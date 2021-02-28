//
//  ChatVC.swift
//  lancerhacks
//
//  Created by Sid on 2/27/21.
//

import UIKit
import FirebaseDatabase
class ChatVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var messageTF: UITextField!
    var timer = Timer()

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatTV: UITableView!
    var currentPerson = "person1"
    var otherPerson = "person2"
    var num_messages = 0
    var key = ""
    var texts: [TextObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chatTV.delegate = self
        self.chatTV.dataSource = self
        if(currentPerson < otherPerson){
            key = "\(currentPerson)_and_\(otherPerson)"
        } else {
            key = "\(otherPerson)_and_\(currentPerson)"
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)

        fetch_data()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func fetch_data(){
        read_db{ (success) in
            if(success){
                self.chatTV.reloadData()
            
            }
        }
    }
    
    @objc func updateCounting(){
        texts.removeAll()
        fetch_data()
    }
    func read_db(success:@escaping (Bool) -> Void){
        print("hello")
        let ref = Database.database().reference()
        ref.child("chats").observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: Any] {
                let values = Array(data.values)
                print(data)
                
                
                if(data[self.key] != nil){
                    var secondary_data = data[self.key]! as! NSDictionary
                    print(type(of: secondary_data))
                    var num_messages = secondary_data["num_messages"] as! Int
                    self.num_messages = num_messages
                    for i in 1...num_messages{
                        print(i)
                        var current_message = "message\(i)"
                        var messages = (secondary_data[current_message]!) as! NSDictionary
                        self.texts.append(TextObject(message: messages["text"]! as! String, uID: messages["sender"]! as! String == self.currentPerson))
                    }
                } else {
                    print("nothing")
                }

            }
        success(true)
            
        })
    }
    
    func sendMessageToDatabase(success:@escaping (Bool) -> Void){

        var ref: DatabaseReference! = Database.database().reference()
        var dataDictionary: [String: Any] = [:]
        var second_dictionary: [String: Any] = [:]
        second_dictionary["text"] = messageTF.text
        second_dictionary["sender"] = currentPerson
        dataDictionary["num_messages"] = num_messages + 1
//            dataDictionary["message\(num_messages)"
        ref.child("chats").child((key)).child("message\(num_messages + 1)").setValue(second_dictionary)
        ref.child("chats").child((key)).child("num_messages").setValue(num_messages + 1)
            success(true)
        }
        
    

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
//                self.chatTV.frame.origin.y -= keyboardSize.height - 100
                self.messageTF.frame.origin.y -= keyboardSize.height - 100
                self.sendButton.frame.origin.y -= keyboardSize.height - 100

            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.chatTV.frame.origin.y != 0 {
            self.chatTV.frame.origin.y = 0
            self.messageTF.frame.origin.y = 0
            self.sendButton.frame.origin.y = 0

        }
    }
    
    @IBAction func SendTypedMessage(_ sender: Any) {
        var message = messageTF.text!
//        messageTF.text = ""
        if(message.count == 0){return}
        else{
            texts.append(TextObject(message: message, uID: true))
            chatTV.reloadData()
        }
        
        sendMessageToDatabase{ (success) in
            if(success){
                self.messageTF.text = ""
                self.num_messages = self.num_messages + 1
                self.chatTV.reloadData()
            }
        }
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        
        //if(currentMode == 0){
        var current_text = texts[indexPath.row]
        //else if(currentMode == 1){ event = eventNames[indexPath.row].eventName! }
        //else{ event = historyEvents[indexPath.row].eventName! }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! ChatCell
        cell.set_text(text: current_text.getMessage(), me: current_text.getSender())
        return cell
    }
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

public class TextObject{
    var textMessage: String!
    var sender: Bool!
    
    init(message: String, uID: Bool) {
        textMessage = message
        sender = uID
//        if(uID == "adkfjadf"){
//            sender = true
//        } else{
//            sender = false
//        }
    }
    
    func getMessage() -> String{
        return textMessage!
    }
    
    func getSender() -> Bool{
        return sender!
    }
}
