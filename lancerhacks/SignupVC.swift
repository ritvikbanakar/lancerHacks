//
//  SignupVC.swift
//  lancerhacks
//
//  Created by Vidit Agrawal on 2/27/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SignupVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var goalsTV: UITextView!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    var selectedRows = NSMutableIndexSet()

    var data = ["Photography", "E-commerce", "Entrepreneurship", "Finance", "Life coach", "Law", "Medicine", "Business", "Management", "Leadership", "Mental Health", "Philosophy", "Education"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        vc.modalPresentationStyle = .overFullScreen
    }

    @IBAction func signuptologin(_ sender: Any) {
        performSegue(withIdentifier: "signuptologin", sender: nil)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func validateFields() -> String? {
        if nameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || goalsTV.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            descriptionTV.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || ageTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all of the fields."
        }
                    
        
        let cleanedPassword = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        
        return ""
    }
    func alert(msg: String)
    {
        let alertController = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                       
         alertController.addAction(defaultAction)
         self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func signUpButtonPressed(_ sender: Any) {
        //validate fields and create user
        let error = validateFields()
        print("Error \(error)")
        if error != "" {
            alert(msg: error!)
        }
        else {
            let name = nameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let age = ageTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let goals = goalsTV.text!
            let description = descriptionTV.text!
            var interests:[String] = []
            for index in selectedRows
            {
                interests.append(data[index])
            }
            let db = Database.database().reference()
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil {
                    self.alert(msg: err!.localizedDescription)
                }
                else{
                    
                    db.child("users").child(result!.user.uid).setValue(["name": name, "goals":goals, "age":age, "description": description, "master": interests])
                    
                    self.performSegue(withIdentifier: "signuptoprof", sender: nil)
                }
            }
        }
        
    }

}

extension SignupVC: UITableViewDataSource, UITableViewDelegate {
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

