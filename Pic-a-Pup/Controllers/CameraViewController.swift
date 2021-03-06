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
    @IBOutlet weak var pictureFromCamera: UIImageView!
    @IBOutlet weak var breedTypeLabel: UILabel!
    @IBOutlet weak var breedInfoTextField: UITextView!
    
    // Looking into dependency injection for this...
    let locationManager = CLLocationManager()
    let picker = UIImagePickerController()
    let fbManager = FirebaseManager()
    let networkManager = NetworkManager()
    let cameraManager = CameraManager()
    let utility = Utility()
    
    // Location info to be updated by utility delegate **should maybe change utility to LocationUtility haha
    var currentUserCoordinateLocation: CLLocation?
    var currentUserPlacemark: CLPlacemark?
    var downloableUrlFromFirebase: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        utility.delegate = self
        networkManager.delegate = self
        view.addVerticalGradientLayer(topColor: primaryColor,
                                      bottomColor: secondaryColor)
        // Launch camera when this controller is created
        launchCameraForController()
        
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
    }
    
    @IBAction func launchCamera(_ sender: UIBarButtonItem) {
        launchCameraForController()
    }
    
    func launchCameraForController() {
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
            
            // Send image to firebase and retrieve downloadable url
            fbManager.uploadImageToFirebase(chosenImage, completionBlock: { (fileUrl, errorMessage) in
                if let url = fileUrl {
                    self.downloableUrlFromFirebase = url
                    // Creating a temp ModelSearchRequest object
                    let modelSearchRequest = ModelSearchRequest(location: "19426", url: "\(url)")
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
        currentUserPlacemark = placemark
        print(placemark.postalCode ?? "default jawn")
    }
    
    func sendLocationCoorData(_ locationCoords: CLLocation) {
        currentUserCoordinateLocation = locationCoords
        print(locationCoords.coordinate)
    }
    
    func sendResponseJSONData(_ response: Any) {
        let json = JSON(response)
        
        // parse for data, and send avail data to firebase manager to
        // finish creating DogSearchResult and send to Firebase.
        print("\(json)")
        breedTypeLabel.text = json["breed"].string
        breedInfoTextField.text = json["breed_info"].string
        //let breedType = json["breed"].string
        //let breedInfo = json["breed_info"].string
        
        //if let location = currentUserCoordinateLocation {
          //  if let url = downloableUrlFromFirebase {
            //    fbManager.saveObjectToFirebase(breedType!, breedInfo!, location: String(describing: location.coordinate), url)
            //}
    
        /*
        let breedType = json["breed"].string
        let breedInfo = json["breed_info"].string
        fbManager.saveObjectToFirebase(breedType!, breedInfo!, currentUserCoordinateLocation?.coordinate, downloableUrlFromFirebase)
 */
    }
}


