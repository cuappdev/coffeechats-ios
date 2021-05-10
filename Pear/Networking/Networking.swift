//
//  Networking2.swift
//  Pear
//
//  Created by Lucy Xu on 5/8/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import Foundation
import Alamofire

class Networking2 {

    static let shared: Networking2 = Networking2()

    static var headers: HTTPHeaders {
        let accessToken = UserDefaults.standard.string(forKey: Constants.UserDefaults.accessToken) ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Token \(accessToken)",
            "Accept": "application/json"
        ]
        return headers
    }

    private static let hostEndpoint = "http://\(Keys.pearServerURLV2)"

    private static func getUrlWithQuery(baseUrl: String, items: [String: String]) -> String? {
        guard let baseUrl = URL(string: baseUrl) else { return nil }
        var urlComp = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        var queryItems: [URLQueryItem] = []
        items.forEach { (key, value) in
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComp?.queryItems = queryItems
        return urlComp?.url?.absoluteString
    }

    static func authenticateUser(idToken: String, completion: @escaping (UserSession) -> Void) {
        let parameters: [String: Any] = [
            "id_token": idToken
        ]

        AF.request(
            "\(hostEndpoint)/api/authenticate/",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let authorizationData = try? jsonDecoder.decode(Response<UserSession>.self, from: data) {
                    let userSession = authorizationData.data
                    completion(userSession)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }


}


