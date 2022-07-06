//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, country: String)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "CDE4DC5E-2534-43D8-AAA1-F6C10D418629"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String) async throws {
        let coinURL = baseURL + "\(currency)/?apikey=\(apiKey)"
        
        guard let url = URL(string: coinURL) else { return }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let priceData = parseJson(data)
        let stringData = String(format: "%.2f", priceData)
        delegate?.didUpdatePrice(price: stringData, country: currency)
    }
    
    func parseJson(_ data: Data) -> Double {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            return decodedData.rate
            
        } catch {
            return 0.00
        }
    }
}
