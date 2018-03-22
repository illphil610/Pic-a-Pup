//
//  CameraViewController.swift
//  Pic-a-Pup
//
//  Created by Philip on 3/16/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import Foundation
import UIKit
import CameraManager
import Firebase
import Alamofire
import CoreLocation
import SwiftyJSON

class CameraViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
                                               NetworkProtocolDelegate, UtilityDelegate {
    //CLLocationManagerDelegate,
    @IBOutlet weak var pictureFromCamera: UIImageView!
    @IBOutlet weak var breedTypeLabel: UILabel!
    @IBOutlet weak var breedInfoTextField: UITextView!
    
    let locationManager = CLLocationManager()
    
    let picker = UIImagePickerController()
    let fbManager = FirebaseManager()
    let networkManager = NetworkManager()
    let cameraManager = CameraManager()
    let utility = Utility()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        utility.delegate = self
        networkManager.delegate = self
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.delegate = utility
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func launchPhotoGallery(_ sender: UIBarButtonItem) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
        picker.popoverPresentationController?.barButtonItem = sender
        //cameraManager.launchPhotoLibrary(picker: picker)
        //present(picker, animated: true, completion: nil)
        //picker.popoverPresentationController?.barButtonItem = sender
    }
    
    @IBAction func launchCamera(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            let alertVC = cameraManager.noCameraAvailable()
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get { return .lightContent }
    }
    
    //MARK: - Delegates
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pictureFromCamera.contentMode = .scaleAspectFill
            pictureFromCamera.clipsToBounds = true
            pictureFromCamera.image = chosenImage
            breedTypeLabel.text = "Weiner Dog"
            breedInfoTextField.text = "best dog around"
            
            // This needs to be implemented when the user clicks a button
            fbManager.uploadImageToFirebase(chosenImage, completionBlock: { (fileUrl, errorMessage) in
                if let url = fileUrl {
                    let modelSearchRequest = ModelSearchRequest(breed: "Beagle", location: "19426", url: "\(url)")
                    let dick = try? modelSearchRequest.asDictionary()
                    if let dicktionary = dick {
                        self.networkManager.sendPostToServer(parameters: dicktionary)
                    }
                } else if let error = errorMessage {
                    print("\(error)")
                }
            })
        }
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func sendPlacemarkData(_ placemark: CLPlacemark) {
        print(placemark.postalCode ?? "default jawn")
    }
    
    func sendLocationCoorData(_ locationCoords: CLLocation) {
        print(locationCoords.coordinate)
    }
    
    func sendResponseJSONData(_ response: Any) {
        let json = JSON(response)
        print("\(json)")
        //breedTypeLabel.text = json["name"].string
        //breedInfoTextField.text = json["info"].string
        breedTypeLabel.text = "Weiner Dog"
        breedInfoTextField.text = "best dog around"
    }
}


