//
//  WelcomeViewController.swift
//  loginPage
//
//  Created by Aditya Guru on 30/03/21.
//

import UIKit
//import loginPage
//import ProjectConstants

class WelcomeViewController: UIViewController
{
    var username:String = ""
    var password:String = ""
    var userDB:NSDictionary?
    
    @IBOutlet weak var resultDataTxt: UITextView!
    @IBOutlet weak var showSaveDataBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let alertController = UIAlertController(title: "Welcome "+username, message: "Your Data is loaded and will be displayed shortly", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }
}
