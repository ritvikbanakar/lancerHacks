//
//  InitialVC.swift
//  lancerhacks
//
//  Created by Vidit Agrawal on 2/27/21.
//

import UIKit

class InitialVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        vc.modalPresentationStyle = .overFullScreen
    }

    @IBAction func initialtosignup(_ sender: Any) {
        performSegue(withIdentifier: "initialtosignup", sender: nil)
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
