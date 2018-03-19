//
//  NetworkManager.swift
//  Pic-a-Pup
//
//  Created by Philip on 3/18/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    let url = "http://httpbin.org/post"
    
    func sendPostToServer() {
        Alamofire.request(url, method: .post, parameters: ["foo": "bar"], encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                print(response)
                break
            case .failure(let error):
                print(error)
            }
        }
    }
}
