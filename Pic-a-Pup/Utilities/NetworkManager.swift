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
    let picapupAPIUrl = "18.219.234.168:5000/breedSearch"
    
    func sendPostToServer(parameters: Dictionary<String, Any>) {
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
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
