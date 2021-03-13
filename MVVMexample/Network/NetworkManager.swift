//
//  NetworkManager.swift
//  MVVMexample
//
//  Created by Pyo Cho on 2021/03/13.
//

import Foundation

class NetworkManager {
    static let shared: NetworkManager = NetworkManager()
    private init() {}
    
    func requestPerson(handler: @escaping (Result<[Model.MVVM.Person], APIError>) -> ()) {
        DispatchQueue.global().async {
            sleep(2)
            let person = Model.MVVM.Person(name: "개굴", age: 27)
            handler(.failure(.none))
//            handler(.success([person]))
        }
    }
}
