//
//  NewPostVC.swift
//  lancerhacks
//
//  Created by Vidit Agrawal on 2/27/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class NewPostVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickPhotoButton: UIButton!
    @IBOutlet weak var masterPicker: UIPickerView!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTV: UITextView!
    var selectedRows = NSMutableIndexSet()
    var chosenInterest: String = ""
    var master: [String] = []
    var masterCount: Int = 0
    var data = ["Photography", "E-commerce", "Entrepreneurship", "Art", "Life coach", "Law", "Medicine", "Business", "Management", "Leadership", "Mental Health", "Philosophy", "Education"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getItems{ (success) in
            if(success){
                print("Success")
                
            }
        }
        print("here")
        self.masterPicker.dataSource = self
        self.masterPicker.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        print(self.masterCount)
        self.masterPicker.reloadAllComponents()
        
                // Do any additional setup after loading the view.
    }
    

    @IBAction func createPostTapped(_ sender: Any) {
        uploadProfilePic()
        self.dismiss(animated: true, completion: nil)
    
        
    }
    @IBAction func pickPhotoTapped(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    func uploadProfilePic() {
        
        
        let storage = Storage.storage().reference()
        let storageRef = storage.child("posts")
        
        guard let key = Database.database().reference().child("posts").childByAutoId().key else { return }
        let db = Database.database().reference().child("posts").child(key)
        let title = titleTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let descriptionText = descriptionTV.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        var interests:[String] = []
        for index in selectedRows
        {
            interests.append(data[index])
        }
        
        db.setValue(["title": title, "description": descriptionText, "master": chosenInterest, "interests": interests, "author": Auth.auth().currentUser?.uid])
        
        
        
        // Data in memory
        let data = imageView.image?.pngData()
        
        // Create a reference to the file you want to upload
        
        let postRef = storageRef.child(key)
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = postRef.putData(data!, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            print(error)
            return
          }
          // Metadata contains file metadata such as size, content-type.
            _ = metadata.size
          // You can also access to download URL after upload.
          postRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              return
            }
            print(downloadURL)
          }
        }

    }
}
extension NewPostVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for:indexPath)
        var text:String
        var accessory = UITableViewCell.AccessoryType.none
        
        text = data[indexPath.row]
        if selectedRows.contains(indexPath.row)
        {
            accessory = .checkmark
        }
        cell.textLabel!.text = text
        cell.accessoryType = accessory
        return cell
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.selectedRows.contains(indexPath.row) ? self.selectedRows.remove(indexPath.row) : self.selectedRows.add(indexPath.row)
        tableView.reloadData()
       
        return nil

    }
}
extension NewPostVC: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        print("hello")
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
        return self.masterCount
    }
    func getItems(success:@escaping (Bool) -> Void){
        var db = Database.database().reference()
        var currentUser = Auth.auth().currentUser?.uid
        var currentUserRef = db.child("users").child(currentUser!)
        currentUserRef.observeSingleEvent(of: DataEventType.value, with: {(snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            var master2 = postDict["master"] as! [String]
            
            for element in master2
            {
                print(self.masterCount)
                self.masterCount = self.masterCount + 1
                self.master.append(element)
            }
            DispatchQueue.main.async {
                self.masterPicker.reloadAllComponents()
            }
            print(self.master)
        })
           
        masterPicker.reloadAllComponents()
        success(true)
    }
    
    
    
}
extension NewPostVC: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(master[row])
        return master[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenInterest = master[row]
    }
}

extension NewPostVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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

