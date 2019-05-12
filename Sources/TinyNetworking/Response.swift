//
//  Response.swift
//  TinyNetworking
//
//  Created by Joan Disho on 30.03.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation

public class Response {
    
    public let statusCode: Int
    
    public let data: Data
    
    public let request: URLRequest?
    
    public let response: HTTPURLResponse?
    
    public init(statusCode: Int, data: Data, request: URLRequest? = nil, response: HTTPURLResponse? = nil) {
        self.statusCode = statusCode
        self.data = data
        self.request = request
        self.response = response
    }
    
    public var description: String {
        return "Status Code: \(statusCode), Data Length: \(data.count)"
    }
    
    public var debugDescription: String {
        return description
    }
    
    public static func == (lhs: Response, rhs: Response) -> Bool {
        return lhs.statusCode == rhs.statusCode
            && lhs.data == rhs.data
            && lhs.response == rhs.response
    }

    public func map<D>(to type: D.Type) throws -> D where D : Decodable {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch(let error) {
            throw TinyNetworkingError.decodingFailed(error)
        }
    }
}

