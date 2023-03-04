//
//  MainViewModel.swift
//  NasaPlanetaryImages
//
//  Created by Mohammad Zulqurnain on 04/03/2023.
//

import RealTimeRegression
import UIKit

@MainActor
final class PlanetViewModel: ObservableObject {
    private var allPlanets: [FavoriteWrapper<PlanetModel>] = []
    @Published private(set) var planets: [PlanetModel] = []
    @Published private(set) var recommendations: [PlanetModel] = []
    
    private var recommendationsTask: Task<Void, Never>?
    
    func loadAllplanets() async {
        guard let url = Bundle.main.url(forResource: "planetsContent", withExtension: "json") else {
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            allPlanets = (try JSONDecoder().decode([PlanetModel].self, from: data)).shuffled().map {
                if  let image = UIImage(named: $0.image) {
                    let histogram = image.imageHistogram()
                    return FavoriteWrapper(model: $0, title: $0.title, imageHistogram: histogram)
                }
                return FavoriteWrapper(model: $0, title: $0.title, imageHistogram: [])
            }
            planets = allPlanets.map(\.model)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func didViewLast(_ item: PlanetModel) {
        recommendationsTask = Task {
            do {
                RealTimeRegression.shared.set(recommendations: 4) // Set number of recommendations
                let result = try await RealTimeRegression.shared.computeRecommendations(basedOn: allPlanets)
                if !Task.isCancelled {
                    recommendations = result
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func didView(_ item: PlanetModel) {
        if let index = allPlanets.firstIndex(where: { $0.model.id == item.id }) {
            allPlanets[index] = FavoriteWrapper(model: item, title: item.title, imageHistogram: UIImage(imageLiteralResourceName: item.image).imageHistogram())
            allPlanets[index].hasOpened = true
            allPlanets[index].isFavorite = true
        }
    }
    
    func resetUserChoices() {
        planets = allPlanets.map(\.model)
        recommendations = []
    }
}
