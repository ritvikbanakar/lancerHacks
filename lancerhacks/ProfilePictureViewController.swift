//
//  ProfilePictureViewController.swift
//  lancerhacks
//
//  Created by Sid on 2/27/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class ProfilePictureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickPhotoButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
  
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func continueTapped(_ sender: Any) {
        if(imageView.image == nil)
        {
            pickPhotoButton.setTitle("Please choose a picture", for: .normal)

        }
        else
        {
            uploadProfilePic()
            performSegue(withIdentifier: "proftohome", sender: nil)
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        vc.modalPresentationStyle = .overFullScreen
    }

    @IBAction func pickPhotoTapped(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    func uploadProfilePic() {
        let userID = Auth.auth().currentUser?.uid
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let imagesRef = storageRef.child("profiles")
        
        // Data in memory
        let data = imageView.image?.pngData()
        
        // Create a reference to the file you want to upload
        let profilePicRef = imagesRef.child(userID!)

        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = profilePicRef.putData(data!, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            print(error)
            return
          }
          // Metadata contains file metadata such as size, content-type.
            _ = metadata.size
          // You can also access to download URL after upload.
          profilePicRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              return
            }
            print(downloadURL)
          }
        }

    }
}
extension ProfilePictureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage
        {
            imageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
        
        pickPhotoButton.setTitle("Pick a different photo", for: .normal)
        
        print("\(info)")
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

