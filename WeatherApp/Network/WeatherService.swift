//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Tatina Dzhakypbekova on 17/5/2025.
//

import Foundation

final class WeatherService {
    private let apiKey = "ad1f8446ea1946f68f1104750251705"
    private let baseURL = "https://api.weatherapi.com/v1/forecast.json"

    func fetchForecast(for city: String, completion: @escaping (Result<[ForecastDay], Error>) -> Void) {
        let urlString = "\(baseURL)?q=\(city)&days=5&key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "BadURL", code: 0)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0)))
                return
            }

            do {
                let result = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(result.forecast.forecastday))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
