//
//  Model.swift
//  weather-swiftui
//
//  Created by Martin Stojcev on 2023-02-05.
//

import Foundation

struct WeatherModel: Codable {
    let timezone: Int
    let weather: [WeatherInfo]
    let main: CurrentWeather
    let name: String
}

struct CurrentWeather: Codable {
    let temp: Float
}

struct WeatherInfo: Codable {
    let main: String
    let description: String 
}
