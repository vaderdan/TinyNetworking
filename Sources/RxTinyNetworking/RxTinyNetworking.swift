//
//  RxTinyNetworking.swift
//  RxTinyNetworking
//
//  Created by Joan Disho on 07.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import TinyNetworking

extension TinyNetworking: ReactiveCompatible {}

public extension Reactive where Base: TinyNetworkingType {
    func request(
        resource: Base.Resource,
        session: TinyNetworkingSession = URLSession.shared,
        queue: DispatchQueue = .main
        ) -> Single<Response> {
        return Single.create { single in
            let task = self.base.request(resource: resource, session: session, queue: queue) { result in
                switch result {
                case let .error(apiError):
                    single(.error(apiError))
                case let .success(response):
                    single(.success(Response(statusCode: response.statusCode, data: response.data, request: response.request, response: response.response)
                        )
                    )
                }
            }

            return Disposables.create {
                task.cancel()
            }
        }
    }
}

// MARK: Single

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {

    public func map<D: Decodable>(to type: D.Type) -> Single<D> {
        return flatMap { response -> Single<D> in
            return .just(try response.map(to: type))
        }
    }

}

// MARK: Observable

extension ObservableType where E == Response {
    public func map<D: Decodable>(to type: D.Type) -> Observable<D> {
        return flatMap { response -> Observable<D> in
            return .just(try response.map(to: type))
        }
    }
}

