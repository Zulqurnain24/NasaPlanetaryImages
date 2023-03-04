//
//  DataModel.swift
//  NasaPlanetaryImages
//
//  Created by Mohammad Zulqurnain on 04/03/2023.
//

import Foundation

struct PlanetModel: Identifiable, Codable {
    let id = UUID()
    let image: String
    let title: String
    let description: String
    let date: String
}
