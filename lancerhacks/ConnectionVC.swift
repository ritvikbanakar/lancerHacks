//
//  ConnectionVC.swift
//  lancerhacks
//
//  Created by Sid on 2/27/21.
//

import UIKit
import FirebaseDatabase
import FirebaseUI
class ConnectionVC: UIViewController, UIGestureRecognizerDelegate {

    
    @IBOutlet weak var profileImage1: UIImageView!
    @IBOutlet weak var profileImage2: UIImageView!
    
    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var name2: UILabel!
    
    @IBOutlet weak var about1: UILabel!
    @IBOutlet weak var about2: UILabel!
    
    
    @IBOutlet weak var interest1: UILabel!
    @IBOutlet weak var interest2: UILabel!
    
    @IBOutlet weak var creatorName1: UILabel!
    @IBOutlet weak var creatorName2: UILabel!
    
    @IBOutlet weak var projectImage1: UIImageView!
    @IBOutlet weak var projectImage2: UIImageView!
    
    
    let height = UIScreen.main.bounds.height
    var positionTop: CGAffineTransform!
    var positionCenter: CGAffineTransform!
    var positionBottom: CGAffineTransform!
    var positionTop2: CGAffineTransform!
    var positionBottom2: CGAffineTransform!
    var para: [String] = []
    var keyArray: [String] = []
    var profileArray: [String] = []
    static var titles: [String] = []
    static var authors: [String] = []
    static var dates: [String] = []
    static var text: [[String]] = [[]]
    static var text2: [String] = []
    static var sub: [String] = []
    static var url: [String] = []
    static var currentIndex = 0
    static var savedIndex: [Int]!
    static var interests: [String] = []
    var names = ["Vidit Agrawal", "Ritvik Banakar"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        read()
        
        
        
        positionTop = CGAffineTransform(translationX: 0, y: -height)
        positionBottom = CGAffineTransform(translationX: 0, y: height)
        positionCenter = CGAffineTransform.identity
        positionTop2 = CGAffineTransform(translationX: 0, y: -height)
        positionBottom2 = CGAffineTransform(translationX: 0, y: height)
        
        profileImage1.contentMode = .scaleAspectFill
        profileImage2.contentMode = .scaleAspectFill
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(respondToTap))
        tapImage.delegate = self
//        self.profileImage2.addGestureRecognizer(tapImage)
        self.profileImage1.addGestureRecognizer(tapImage)
        self.profileImage1.isUserInteractionEnabled = true
        self.profileImage2.isUserInteractionEnabled = true
        
        setUp()
        // Do any additional setup after loading the view.
        
        
    }
    
    @IBAction func performSegueToNew(_ sender: Any) {
        performSegue(withIdentifier: "hometonew", sender: nil)
    }
    @objc func respondToTap(){
        let newvc = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
//        newvc.delegate = self
        newvc.modalPresentationStyle = .fullScreen

        self.present(newvc, animated: true, completion: nil)
    }
    
    
    
    func read(){
        var dataString = ""
        let ref = Database.database().reference()
        ref.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: Any] {
                print(data)
                var new_data = data as! NSDictionary
                self.keyArray = new_data.allKeys as! [String]
                
            
                for value in self.keyArray{
                    var dict = data[value] as! NSDictionary
                    self.profileArray.append(dict["author"] as! String)
                    ConnectionVC.sub.append(dict["description"] as! String)
                    ConnectionVC.titles.append(dict["title"] as! String)
                    var interests = dict["interests"] as! NSArray
                    print(interests[0])
                    
                    ConnectionVC.interests.append("Master: \(dict["master"]!)\nInterests: \(interests[0])")
                    
                    
                }
                
                
               
                self.setTitles(title1Index: ConnectionVC.currentIndex, title2Index: ConnectionVC.currentIndex+1)
//                for web in ConnectionVC.url {
//                    //print(URL(string: web)!)
//
//                    //print(ConnectionVC.authors)
//                    //print("\n\n\n")
//                    let html = try! String(contentsOf: URL(string: web)!, encoding: .utf8)
//                    do {
//                       let doc: Document = try SwiftSoup.parseBodyFragment(html)
//                        let body: Elements = try doc.getElementsByTag("p")
//                         let authorStuff: [Element] = try doc.select("meta").array()
//                        for name in authorStuff {
//                            if(try name.attr("name") == "byl") {
//                                ConnectionVC.authors.append(try name.attr("content"))
//                            }
//                        }
//                        for p in body {
//                            var check = try p.text()
//
//
//                            if(check != "Advertisement" && check != "Supported by"
//                                && !check.hasPrefix("By")) {
//
//                                dataString += try p.text() + "\n\n\n\t"
//                            }
//                        }
//                        ConnectionVC.text2.append(dataString)
//                        dataString = ""
//                    } catch Exception.Error(let type, let message) {
//                        print(message)
//                    } catch {
//                        print("error")
//                    }
//
//                }

            }
        }) { (error) in  print(error.localizedDescription) }
    }
    func setUp(){
        name2.transform = positionBottom
        about2.transform = positionBottom
        interest2.transform = positionBottom
        profileImage2.transform = positionBottom2
        projectImage2.transform = positionBottom
        creatorName2.transform = positionBottom
        profileImage1.layer.cornerRadius = 25
        profileImage1.layer.masksToBounds = true
        profileImage2.layer.cornerRadius = 25
        profileImage2.layer.masksToBounds = true

    }
    
    func setTitles(title1Index: Int, title2Index: Int){
        print(title1Index)
        print(title2Index)
        name1.text = ConnectionVC.titles[title1Index]
        creatorName1.text = names[title1Index]
        creatorName2.text = names[title2Index]

        about1.text = ConnectionVC.sub[title1Index]
        profileImage1.image = UIImage(named: "\(title1Index)")
        projectImage1.image = UIImage(named: "\(title1Index)")
        interest1.text = ConnectionVC.interests[title1Index]
        interest2.text = ConnectionVC.interests[title2Index]

//        if(title1Index + 1 > ConnectionVC.titles.count){
            name2.text = ConnectionVC.titles[title2Index]
            about2.text = ConnectionVC.sub[title2Index]

            profileImage2.image = UIImage(named: "\(title2Index)")
            projectImage2.image = UIImage(named: "\(title2Index)")

//        }
        

    }
    
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case .down:
                if(ConnectionVC.currentIndex == 0){ break }
                setTitles(title1Index: ConnectionVC.currentIndex-1, title2Index: ConnectionVC.currentIndex)
                ConnectionVC.currentIndex -= 1
                name1.transform = positionTop
                about1.transform = positionTop
                interest1.transform = positionTop
                creatorName1.transform = positionTop
                profileImage1.transform = positionTop2
                projectImage1.transform = positionTop
                
                name2.transform = positionCenter
                about2.transform = positionCenter
                interest2.transform = positionCenter
                creatorName2.transform = positionCenter
                profileImage2.transform = positionCenter
                projectImage2.transform = positionCenter

//               self.profileImage1.frame = CGRect(x: 0, y: self.profileImage1.frame.size.height, width: self.profileImage1.frame.size.width, height: self.profileImage1.frame.size.height)
//               self.profileImage2.frame = CGRect(x: 0, y: 0, width: self.profileImage2.frame.size.width, height: self.profileImage2.frame.size.height)
                self.profileImage1.alpha = 1
                self.profileImage2.alpha = 1
                self.name1.alpha = 0
                self.about1.alpha = 0
                self.projectImage1.alpha = 0

                self.creatorName1.alpha = 0
                self.interest1.alpha = 0
                self.name2.alpha = 1
                self.about2.alpha = 1
                self.creatorName2.alpha = 1
                self.projectImage2.alpha = 1
                self.interest2.alpha = 1
                UIView.animate(withDuration: 0.3, animations: {
                    self.name1.transform = self.positionCenter
                    self.name1.alpha = 1
                    self.about1.alpha = 1
                    self.interest1.alpha = 1
                    self.projectImage1.alpha = 1
                    self.creatorName1.alpha = 1
                    self.name2.alpha = 0
                    self.about2.alpha = 0
                    self.interest2.alpha = 0
                    self.creatorName2.alpha = 0
                    self.projectImage2.alpha = 0
                    self.about1.transform = self.positionCenter
                    self.interest1.transform = self.positionCenter
                    self.creatorName1.transform = self.positionCenter
                    self.creatorName2.transform = self.positionBottom
                    self.projectImage1.transform = self.positionCenter
                    self.projectImage2.transform = self.positionBottom
                    self.name2.transform = self.positionBottom
                    self.interest2.transform = self.positionBottom
                    self.about2.transform = self.positionBottom
                    self.profileImage1.transform = self.positionCenter
                    self.profileImage2.transform = self.positionBottom2
                    self.profileImage1.alpha = 1
                    self.profileImage2.alpha = 1
                })
                
            case .up:
                if(ConnectionVC.currentIndex == ConnectionVC.titles.count-1){ break }
                ConnectionVC.currentIndex += 1
                UIView.animate(withDuration: 0.3, animations: {
                    self.name1.transform = self.positionTop
                    self.about1.transform = self.positionTop
                    self.interest1.transform = self.positionTop
                    self.profileImage1.transform = self.positionTop2
                    self.creatorName1.transform = self.positionTop
                    self.projectImage1.transform = self.positionTop
                    self.name2.transform = self.positionCenter
                    self.about2.transform = self.positionCenter
                    self.interest2.transform = self.positionCenter
                    self.creatorName2.transform = self.positionCenter
                    self.profileImage2.transform = self.positionCenter
                    self.projectImage2.transform = self.positionCenter
                    self.name1.alpha = 0
                    self.about1.alpha = 0
                    self.interest1.alpha = 0
                    self.creatorName1.alpha = 0
                    self.projectImage1.alpha = 0
                    self.name2.alpha = 1
                    self.about2.alpha = 1
                    self.creatorName2.alpha = 1
                    self.interest2.alpha = 1
                    self.profileImage1.alpha = 1
                    self.profileImage2.alpha = 1
                    self.projectImage2.alpha = 1
                    
                    
                }, completion: {
                    (value: Bool) in
                    self.name1.transform = self.positionCenter
                    self.about1.transform = self.positionCenter
                    self.interest1.transform = self.positionCenter
                    self.creatorName1.transform = self.positionCenter
                    self.profileImage1.transform = self.positionCenter
                    self.projectImage1.transform = self.positionCenter
                    self.name2.transform = self.positionBottom
                    self.about2.transform = self.positionBottom
                    self.interest2.transform = self.positionBottom
                    self.creatorName2.transform = self.positionBottom
                    self.profileImage2.transform = self.positionBottom2
                    self.projectImage2.transform = self.positionBottom
                    self.name1.alpha = 1
                    self.about1.alpha = 1
                    self.interest1.alpha = 1
                    self.projectImage1.alpha = 1
                    self.creatorName1.alpha = 1
                    self.interest2.alpha = 0
                    self.name2.alpha = 0
                    self.about2.alpha = 0
                    self.creatorName2.alpha = 1
                    self.projectImage2.alpha = 1
                    self.profileImage1.alpha = 1
                    self.profileImage2.alpha = 1
                    if(ConnectionVC.currentIndex < ConnectionVC.titles.count-2){
                        self.setTitles(title1Index: ConnectionVC.currentIndex, title2Index: ConnectionVC.currentIndex+1)
                    } else {
                        self.setTitles(title1Index: ConnectionVC.currentIndex, title2Index: ConnectionVC.currentIndex)
                    }
                })
               
            default:
                break
            }
        }
    }


}

