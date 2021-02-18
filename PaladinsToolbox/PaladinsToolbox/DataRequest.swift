//
//  DataRequest.swift
//  PaladinsToolbox
//
//  Created by John Stanford on 2/17/21.
//

import Foundation

public class DataRequest {
    static let shared = DataRequest()
    private init() {}
    func getData<Model: Decodable>(_ string: String,
                                   type: Model.Type,
                                   completion: @escaping (Result<Model, Error>) -> Void) {
        guard let url = URL(string: string) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error ==  nil else {
                _ = response
                print("Error fetching data")
                return
            }
            do {
                let result = Result {
                    try JSONDecoder().decode(Model.self, from: data)
                }
                completion(result)
            }
        }
        task.resume()
    }
    func getData<Model: Decodable>(_ string: String,
                                   type: [Model].Type,
                                   completion: @escaping (Result<[Model], Error>) -> Void) {
        guard let url = URL(string: string) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error ==  nil else {
                _ = response
                print("Error fetching data")
                return
            }
            do {
                let result = Result {
                    try JSONDecoder().decode([Model].self, from: data)
                }
                completion(result)
            }
        }
        task.resume()
    }
}
