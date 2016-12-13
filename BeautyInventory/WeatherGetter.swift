//
//  WeatherGetter.swift
//  BeautyInventory
//
//  Created by Ling Ouyang on 12/12/16.
//  Copyright © 2016 Ling Ouyang. All rights reserved.
//

import Foundation
protocol WeatherGetterDelegate {
    func didGetWeather(weather: Weather)
    func didNotGetWeather(error: NSError)
}
class WeatherGetter{
    
let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
let openWeatherMapAPIKey = "998eb5d9103ceaa81787d8535297c0f0"
private var delegate: WeatherGetterDelegate
    
    
init(delegate: WeatherGetterDelegate) {
        self.delegate = delegate
    }
    
func getWeatherByCity(city: String) {
        let weatherRequestURL = NSURL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&q=\(city)")!
        getWeather(weatherRequestURL: weatherRequestURL)
    }
    
func getWeatherByCoordinates(latitude: Double, longitude: Double) {
        let weatherRequestURL = NSURL(string: "\(openWeatherMapBaseURL)?lat=\(latitude)&lon=\(longitude)&APPID=\(openWeatherMapAPIKey)")!
        getWeather(weatherRequestURL: weatherRequestURL)
    }
    
func getWeather(weatherRequestURL: NSURL) {
    
    // This is a pretty simple networking task, so the shared session will do.
    let session = URLSession.shared
    session.configuration.timeoutIntervalForRequest = 3
    print(weatherRequestURL)
    // The data task retrieves the data.
    let dataTask = session.dataTask(with: weatherRequestURL as URL) {
        (data: Data?, response: URLResponse?, error: Error?) in
        if let error = error {
            // Case 1: Error
            // We got some kind of error while trying to get data from the server.
            print("Error:\n\(error)")
        }
        else {
            do {
                // Try to convert that data into a Swift dictionary
                let weatherData = try JSONSerialization.jsonObject(
                    with: data!,
                    options: .mutableContainers) as! [String: Any]
                let weather = Weather(weatherData: weatherData as [String : AnyObject])
                
                // Now that we have the Weather struct, let's notify the view controller,
                // which will use it to display the weather to the user.
                self.delegate.didGetWeather(weather: weather)            }
                 catch let jsonError as NSError {
                // An error occurred while trying to convert the data into a Swift dictionary.
                print("JSON error description: \(jsonError.description)")
            }
        }
    }
    
    // The data task is set up...launch it!
    dataTask.resume()
}
}
