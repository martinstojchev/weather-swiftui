//
//  ContentView.swift
//  weather-swiftui
//
//  Created by Martin Stojcev on 2023-02-05.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = WeatherViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.cityName)
                .font(.system(size: 50))
            Text(viewModel.timezone)
                .font(.system(size: 32))
            Text(viewModel.temp)
                .font(.system(size: 44))
            Text(viewModel.title)
                .font(.system(size: 24))
            Text(viewModel.descriptionText)
                .font(.system(size: 24))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
