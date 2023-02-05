//
//  ViewModel.swift
//  weather-swiftui
//
//  Created by Martin Stojcev on 2023-02-05.
//

import SwiftUI

class WeatherViewModel: ObservableObject {
   @Published var title: String = "-"
   @Published var descriptionText: String = "-"
   @Published var temp: String = "-"
   @Published var timezone: String = "-"
   @Published var cityName: String = "-"
    
    
    init() {
        fetchWeather()
    }
    
    func fetchWeather() {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=41.7165&lon=21.7723&appid=df365c37bf9a2670c766e7b77c51712a&units=metric") else { return }
        
        url.asyncDownload { data, response, error in
            guard let data = data else {
                print("URL session data task error: \(error)")
                return
            }
            
            do {
                let weatherModel = try JSONDecoder().decode(WeatherModel.self, from: data)
                
                DispatchQueue.main.async {
                    self.timezone = "\(weatherModel.timezone)"
                    self.title = weatherModel.weather.first?.main ?? "No title"
                    self.descriptionText = weatherModel.weather.first?.description ?? "No description"
                    self.temp = "\(weatherModel.main.temp)"
                    self.cityName = weatherModel.name
                }
            }
            catch {
                print("JSON serialization error: \(error)")
            }

        }
    }
}

extension URL {
    func asyncDownload(completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()) {
        URLSession.shared
            .dataTask(with: self, completionHandler: completion)
            .resume()
    }
}
