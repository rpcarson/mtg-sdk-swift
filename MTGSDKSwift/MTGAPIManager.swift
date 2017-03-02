//
//  MTGAPIManager.swift
//  mtg-sdk-swift
//
//  Created by Reed Carson on 2/24/17.
//  Copyright © 2017 Reed Carson. All rights reserved.
//

import Foundation

typealias JSONResults = [String:Any]
typealias JSONCompletionWithError = ([String:Any]?, NetworkError?) -> Void


public enum NetworkError: Error {
    case requestError(Error)
    case unexpectedHTTPResponse(HTTPURLResponse)
    case fetchCardImageError(String)
    case miscError(String)
}








final class URLManager {
    
    var pageSize = "6"
    var pageTotal = "1"
    
    func buildURL(parameters: [SearchParameter]) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.magicthegathering.io"
        urlComponents.path = {
            if parameters is [CardSearchParameter] {
                return "/v1/cards"
            } else {
                return "/v1/sets"
            }
        }()
        
        urlComponents.queryItems = buildQueryItemsFromParameters(parameters)
        
        if Magic.enableLogging == true {
            if let url = urlComponents.url {
                print("URL: \(url)")
            }
        }
        
        return urlComponents.url
        
    }
    
    private func buildQueryItemsFromParameters(_ parameters: [SearchParameter]) -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        
        let pageSizeQuery = URLQueryItem(name: "pageSize", value: pageSize)
        let pageQuery = URLQueryItem(name: "page", value: pageTotal)
        queryItems.append(pageQuery)
        queryItems.append(pageSizeQuery)
        
        for parameter in parameters {
            let name = parameter.name
            let value = parameter.value
            let item = URLQueryItem(name: name, value: value)
            queryItems.append(item)
        }
        
        return queryItems
    }
    
}



final class MTGAPIService {
    
    func mtgAPIQuery(url: URL, completion: @escaping JSONCompletionWithError) {
        
        var networkError: NetworkError? {
            didSet {
                completion(nil, networkError)
            }
        }
        
        if Magic.enableLogging {
            print("MTGAPIService - beginning mtgAPIQuery... \n")
        }
        
        let networkOperation = NetworkOperation(url: url)
        
        networkOperation.queryURL {
            json, error in
            
            if error != nil {
                networkError = error
                return
            }
            completion(json, nil)
        }
        
    }
    
}



final class NetworkOperation {
    
    let session: URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default)
    }()
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func queryURL(completion: @escaping JSONCompletionWithError) {
        
        if Magic.enableLogging {
            print("NetworkOperation - beginning queryURL... \n")
        }
        
        var networkError: NetworkError? {
            didSet {
                completion(nil, networkError)
            }
        }
        
        let request = URLRequest(url: url)
        let dataTask = session.dataTask(with: request) {
            data, response, error in
            
            guard error == nil else {
                networkError = NetworkError.requestError(error!)
                return
            }
            
            if let httpResponse = (response as? HTTPURLResponse) {
                switch httpResponse.statusCode {
                case 200..<300:
                    if Magic.enableLogging {
                        print("HTTPResponse success - status code: \(httpResponse.statusCode)")
                    }
                    break
                default:
                    networkError = NetworkError.unexpectedHTTPResponse(httpResponse)
                    return
                }
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: []) as? JSONResults
                
                completion(jsonResponse, nil)
                
            } catch {
                networkError = NetworkError.miscError("json serialization error")
                return
            }
        }
        
        dataTask.resume()
        
    }
    
    
}













//
