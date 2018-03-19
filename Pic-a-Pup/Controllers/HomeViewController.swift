//
//  HomeViewController.swift
//  Pic-a-Pup
//
//  Created by Philip on 3/16/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleLogOut(_ sender: UIButton) {
            try! Auth.auth().signOut()
            self.dismiss(animated: false, completion: nil)
    }
}
