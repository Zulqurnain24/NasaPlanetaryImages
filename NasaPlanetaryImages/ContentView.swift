//
//  ContentView.swift
//  NasaImagesApp
//
//  Created by Mohammad Zulqurnain on 04/03/2023.
//

import RealTimeRegression
import SwiftUI

struct DataDetailView: View {
    let data: PlanetModel
    var onReturn: () -> Void
    var body: some View {
        VStack() {
            Image(data.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 500)
                .clipped()
            
            Text(data.title)
                .font(.headline)
            
            Text(data.description)
                .padding()
            Text(data.date)
        }
        .padding()
        .navigationBarTitle(Text(data.title), displayMode: .inline)
        .onDisappear {
            onReturn()
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel: PlanetViewModel
    @State var selectedItem: PlanetModel?
    
    init() {
        _viewModel = StateObject(wrappedValue: PlanetViewModel())
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Recommendations")
                    .font(.headline)
                RecommendationsView(data: viewModel.recommendations)
                .frame(height: 100)
                .font(.headline)
                .navigationTitle("Planets")
                List(viewModel.planets) { item in
                    VStack(alignment: .leading) {
                        Image(item.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                        
                        Text(item.title)
                            .font(.title3)
                    }
                    .onTapGesture {
                        viewModel.didView(item)
                        selectedItem = item
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadAllplanets()
            }
        }
        .onDisappear {
            viewModel.resetUserChoices()
        }
        .sheet(item: $selectedItem) { selectedItem in
            DataDetailView(data: selectedItem,
                           onReturn: {
           viewModel.didViewLast(selectedItem)
       })
        }
    }
    
}
