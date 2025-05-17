import Foundation

final class WeatherViewModel {
    var forecast: [ForecastDay] = []
    
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private let service = WeatherService()
    
    func fetchWeather(for city: String) {
        service.fetchForecast(for: city) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let days):
                    self?.forecast = days
                    self?.onDataUpdated?()
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
}
