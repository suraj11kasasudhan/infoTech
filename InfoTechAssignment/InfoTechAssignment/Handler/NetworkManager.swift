//
//  NetworkManager.swift
//  InfoTechAssignment
//
//  Created by Suraj on 11/02/25.
//

import Foundation

enum CompletionState {
    case success
    case failure
    case noInternet
    case notAuthorized
}

protocol NetworkServiceProtocol {
    func getRequest(path: String, params: [String : String]?, completionHandler: @escaping (_ status:CompletionState,_ data:Data?) -> Void)
    func postRequest(path: String,queryParams:[String:String]?, postParmsData:Data?, completionHandler: @escaping (_ status:CompletionState,_ data:Data?) -> Void)
}

class NetworkManager: NetworkServiceProtocol {
   
    private let urlSession = URLSession(configuration: .default)
    static let shared = NetworkManager()
    
    private init() {}
    
    func getRequest(path: String, params: [String : String]?, completionHandler: @escaping (_ status:CompletionState,_ data:Data?) -> Void) {
        var urlComponent = URLComponents(string: path)
        var queryItem:[URLQueryItem] = []
        if params != nil{
            for (key,value) in params! {
                queryItem.append(URLQueryItem(name: key, value: value))
            }
        }
        urlComponent?.queryItems = queryItem
        if let url = urlComponent?.url {
            let task =  urlSession.dataTask(with: URLRequest(url: url)){data,response,error in
                if error == nil {
                    if let httpResponse = response as? HTTPURLResponse {
                        if let responseData = data{
                            let jsonData = try? JSONSerialization.jsonObject(with: responseData, options: [])
                            if jsonData != nil {
                                completionHandler(.success,responseData)
                            } else {
                                completionHandler(.success,nil)
                            }
                        }
                    }
                    
                } else {
                    if let error = error as? NSError{
                        switch error.code{
                        case NSURLErrorNotConnectedToInternet:
                            completionHandler(.noInternet,nil)
                        
                        default:
                            completionHandler(.failure, nil)
                        }
                        
                    }
                }
            }
            task.resume()
        }
    }
        
    
    
    func postRequest(path: String,queryParams:[String:String]?,postParmsData:Data?, completionHandler: @escaping (_ status:CompletionState,_ data:Data?) -> Void) {
        var urlComponent = URLComponents(string: path)
        var queryItem:[URLQueryItem] = []
        if queryParams != nil{
            for (key,value) in queryParams! {
                queryItem.append(URLQueryItem(name: key, value: value))
            }
        }
        urlComponent?.queryItems = queryItem
        if let url = urlComponent?.url {
            var urlRequest = URLRequest(url: url)
            if let postParamsDataUnwrapped = postParmsData {
                urlRequest.httpBody = postParamsDataUnwrapped
            }
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task =  urlSession.dataTask(with: urlRequest){data,response,error in
                if error == nil {
                    if let httpResponse = response as? HTTPURLResponse {
                        if let responseData = data{
                            let jsonData = try? JSONSerialization.jsonObject(with: responseData, options: [])
                            completionHandler(.success,responseData)
                        }
                    }
                    
                } else {
                    if let error = error as? NSError{
                        switch error.code{
                        case NSURLErrorNotConnectedToInternet:
                            completionHandler(.noInternet,nil)
                        
                        default:
                            completionHandler(.failure, nil)
                        }
                        
                    }
                }
            }
            task.resume()
        }
    }
}
