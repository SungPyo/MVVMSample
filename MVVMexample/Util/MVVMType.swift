//
//  MVVMType.swift
//  MVVMexample
//
//  Created by Pyo Cho on 2021/03/14.
//

import Foundation

class Observable<T> {
    typealias Observer = (T) -> ()
    
    private var observers: [Observer] = []
    
    fileprivate var event: T? {
        didSet {
            observers.forEach { observer in
                guard let event = event else { return }
                observer(event)
            }
        }
    }

    fileprivate func subscribe(observer: @escaping Observer) {
        observers.append(observer)
        guard let value = event else { return }
        observer(value)
    }
}

class MVVMType: Observable<Any> {
    typealias ErrorHandler = (APIError) -> ()
    
    var errorEvent: ErrorHandler? = nil
    
    func output<T>(model: Observable<T>) -> T? {
        return model.event
    }
    
    func input<T>(model: Observable<T>, input: T) {
        model.event = input
    }
    
    func subscribe<T>(to: Observable<T>, callBack: @escaping (T) -> ()) {
        to.subscribe(observer: callBack)
    }
}
