//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Tatina Dzhakypbekova on 17/5/2025.
//

import Foundation

struct WeatherResponse: Decodable {
    let forecast: Forecast
}

struct Forecast: Decodable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Decodable {
    let date: String
    let day: Day
}

struct Day: Decodable {
    let avgtemp_c: Double
    let maxwind_kph: Double
    let avghumidity: Double
    let condition: Condition
}

struct Condition: Decodable {
    let text: String
    let icon: String
}
