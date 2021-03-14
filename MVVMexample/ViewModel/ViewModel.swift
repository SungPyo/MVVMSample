//
//  ViewModel.swift
//  MVVMexample
//
//  Created by Pyo Cho on 2021/03/13.
//

import Foundation

class ViewModel: MVVMType {
    private(set) var jaeeun: Observable<[Model.MVVM.Person]> = Observable()
    
    func requestPerson() {
        NetworkManager.shared.requestPerson { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.input(model: self.jaeeun, input: model)
            case .failure(let error):
                guard let errorEvent = self.errorEvent else { return }
                errorEvent(error)
            }
        }
    }
}

class ViewModel2 {
    private(set) var jaeeun: [Model.MVVM.Person] = []
    
    func requestPerson(handler: @escaping (Result<Bool, APIError>) -> ()) {
        NetworkManager.shared.requestPerson { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.jaeeun = model
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
}
