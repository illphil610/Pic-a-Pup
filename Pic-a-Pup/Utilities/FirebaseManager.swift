//
//  FirebaseManager.swift
//  Pic-a-Pup
//
//  Created by Philip on 3/16/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import Foundation
import FirebaseStorage
import Firebase

struct Constants {
    struct Pups {
        static let imagesFolder: String = "PupImages"
    }
}

class FirebaseManager: NSObject {
    func uploadImageToFirebase(_ image: UIImage, completionBlock: @escaping (_ url: URL?, _ errorMessage: String?) -> Void) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let imageName = "\(Date().timeIntervalSince1970).jpg"
        let imagesReference = storageReference.child(Constants.Pups.imagesFolder).child(imageName)
        
        if let imageData = UIImageJPEGRepresentation(image, 0.1) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let _ = imagesReference.putData(imageData, metadata: metadata, completion: { metadata, error in
                if let metadata = metadata {
                    completionBlock(metadata.downloadURL(), nil)
                } else {
                    completionBlock(nil, error?.localizedDescription)
                }
            })
        } else {
            completionBlock(nil, "image could not be converted to Data.")
        }
    }
}
