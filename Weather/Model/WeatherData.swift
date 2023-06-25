//
//  WeatherData.swift
//  Weather
//
//  Created by Mohamed Hany on 17/06/2023.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [weather]
}

struct Main: Codable {
    let temp: Double
}

struct weather: Codable {
    let id: Int
}
