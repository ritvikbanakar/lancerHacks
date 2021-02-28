//
//  LoginVC.swift
//  lancerhacks
//
//  Created by Vidit Agrawal on 2/27/21.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {

    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        vc.modalPresentationStyle = .overFullScreen
    }
    func validateFields() -> String? {
        if emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all of the fields."
        }
        return nil
    }
    func alert(msg: String)
    {
        let alertController = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                       
         alertController.addAction(defaultAction)
         self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func loginTapped(_ sender: Any) {
        
        let error = validateFields()
        if error != nil {
            print(error!)
            alert(msg: error!)
        }
        else {
            let email = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
                if err == nil{
                    print("hello")
                }
                  else{
                    self.alert(msg: (err?.localizedDescription)!)
                       
                  
                  
                    print("POG")
                }
            }
        }
        
    }

    @IBAction func logintosignup(_ sender: Any) {
        performSegue(withIdentifier: "logintosignup", sender: nil)
    }
    
    @IBAction func logintohome(_ sender: Any) {
        performSegue(withIdentifier: "logintohome", sender: nil)

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
