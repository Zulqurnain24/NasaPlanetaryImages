//
//  RecommendationsView.swift
//  NasaPlanetaryImages
//
//  Created by Mohammad Zulqurnain on 04/03/2023.
//

import SwiftUI

struct RecommendationsView: View {
    let data: [PlanetModel]
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(data) { item in
                        VStack(alignment: .leading) {
                            Image(item.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width - 300, height: 100)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            
                            Text(item.title)
                                .font(.headline)
                                .lineLimit(1)
                                .padding(.top, 5)
                            
                            Text(item.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                                .padding(.top, 5)
                        }
                        .frame(height: 100)
                        .frame(width: geometry.size.width - 300)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
        }
    }
}
