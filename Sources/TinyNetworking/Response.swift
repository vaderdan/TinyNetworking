//
//  Response.swift
//  TinyNetworking
//
//  Created by Joan Disho on 30.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

public class Response {
    public let urlRequest: URLRequest
    public let data: Data
    public let headers: [AnyHashable:Any]

    public init(urlRequest: URLRequest, data: Data, headers: [AnyHashable: Any]) {
        self.urlRequest = urlRequest
        self.data = data
        self.headers = headers
    }

    public func map<D>(to type: D.Type) throws -> D where D : Decodable {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch(let error) {
            throw TinyNetworkingError.decodingFailed(error)
        }
    }
}

