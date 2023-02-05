//
//  ViewModel.swift
//  weather-swiftui
//
//  Created by Martin Stojcev on 2023-02-05.
//

import SwiftUI
import CoreLocation

enum WeatherMode: String {
    case location, city
}

class WeatherViewModel: ObservableObject {
    @Published var title: String = "-"
    @Published var descriptionText: String = "-"
    @Published var temp: String = "-"
    @Published var timezone: String = "-"
    @Published var cityName: String = "-"
    var searchedCityLat: Double = 0
    var searchedCityLon: Double = 0
    @Published var locationManager = LocationManager()
    @Published var currentLocation: CLLocation!
    var currentLocationLat: Double = 0
    var currentLocationLon: Double = 0
    var weatherMode: WeatherMode = .location
    
    init() {
        locationManager.getCurrentLocation { location in
            self.currentLocation = location
            print("currentLocationLat: \(location.coordinate.latitude)")
            print("currentLocationLon: \(location.coordinate.longitude)")
        }
    }
    
    func fetchWeather(cityName: String = "", lat: Double = 0.0, lon: Double = 0.0) {
        
        switch weatherMode {
        case .location:
            print("location mode")
            guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=df365c37bf9a2670c766e7b77c51712a&units=metric") else { return }
            
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
                        self.temp = "\(floor(weatherModel.main.temp))"
                        self.cityName = weatherModel.name
                    }
                }
                catch {
                    print("JSON serialization error: \(error)")
                }
                
            }
            
            
        case .city:
            print("city mode")
            guard let getCityNameLatLongURL = URL(string: "http://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&limit=10&appid=df365c37bf9a2670c766e7b77c51712a") else { return }
            
            getCityNameLatLongURL.asyncDownload { [self] data, response, error in
                guard let data = data else {
                    print("URL session data task error: \(error)")
                    return
                }
                
                do {
                    let cityLatLongModel = try JSONDecoder().decode([CityNameObject].self, from: data)
                    
                    self.searchedCityLat = cityLatLongModel.first?.lat ?? 0
                    self.searchedCityLon = cityLatLongModel.first?.lon ?? 0
                    
                    print("cityLat: \(searchedCityLat), long: \(searchedCityLon)")
                    
                    guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(self.searchedCityLat)&lon=\(searchedCityLon)&appid=df365c37bf9a2670c766e7b77c51712a&units=metric") else { return }
                    
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
                catch {
                    print("JSON serialization error: \(error)")
                }
                
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
