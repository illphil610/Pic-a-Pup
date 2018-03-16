//
//  MenuViewController.swift
//  Pic-a-Pup
//
//  Created by Philip on 3/13/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import UIKit
import Firebase

class MenuViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let currentUser = Auth.auth().currentUser {
            self.performSegue(withIdentifier: "toHomeScreen", sender: self)
        }
    
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

