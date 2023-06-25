//
//  WeatherManager.swift
//  Weather
//
//  Created by Mohamed Hany on 15/06/2023.
//

import Foundation
import CoreLocation

protocol weatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatheManager {
    private let apiKey = "dae24ce4d77bc8efc4a21f2d5f4d5d62"
    private let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric"
    
    var delegate: weatherManagerDelegate?
    
    func fetchWeather (cityName: String){
        let url = "\(weatherURL)&appid=\(apiKey)&q=\(cityName)"
        performRequest(urlString: url)
    }
    
    func fetchWeather (latitiude: CLLocationDegrees, longitude: CLLocationDegrees){
        let url = "\(weatherURL)&appid=\(apiKey)&lat=\(latitiude)&lon=\(longitude)"
        performRequest(urlString: url)
    }
    
    func performRequest(urlString: String){
        //create url
        if let url = URL(string: urlString){
            //create URLSession
            let session = URLSession(configuration: .default)
            
            //Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = parseJSON(weatherData: safeData){
                        delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            //start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        do{
            let dataString = try JSONDecoder().decode(WeatherData.self, from: weatherData)
            let name = dataString.name
            let temp = dataString.main.temp
            let id = dataString.weather[0].id
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        }
        catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
