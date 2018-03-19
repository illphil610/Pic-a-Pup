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

class CameraViewController : UIViewController, UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate {
    
    @IBOutlet weak var pictureFromCamera: UIImageView!
    
    
    let picker = UIImagePickerController()
    let fbManager = FirebaseManager()
    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
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
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    
    func noCamera() {
        let alertVC = UIAlertController(title: "No Camera",
                                        message: "Sorry, this device has no camera",
                                        preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style:.default,
                                     handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    
    //MARK: - Delegates
    @objc func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pictureFromCamera.contentMode = .scaleAspectFill
            pictureFromCamera.clipsToBounds = true
            pictureFromCamera.image = chosenImage
            fbManager.uploadImageToFirebase(chosenImage, completionBlock: { (fileUrl, errorMessage) in
                if let error = errorMessage {
                    print("\(error)")
                }
                if let url = fileUrl {
                    print(url)
                    let urlString = "http://httpbin.org/post"
                    Alamofire.request(urlString, method: .post, parameters: ["foo": "bar"],encoding: JSONEncoding.default, headers: nil).responseJSON {
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
            })
        }
        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


