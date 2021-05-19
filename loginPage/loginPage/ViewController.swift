//
//  ViewController.swift
//  loginPage
//
//  Created by Aditya Guru on 25/03/21.
//

import UIKit
//import loginPage
import SQLite3

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var loginPageView: UIView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    var isDatabaseCreated = false
    var databaseLoginHashMap: NSMutableDictionary?
    var loginAttempts = 0
    let mainStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var db : OpaquePointer?
    let dataBaseFileName: String = "UserDB.sqlite"
    let dataBaseName: String = "UserDB"
    
    ///viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        /**
         1. Implement SQLITE steps
         2. Check if database is created, if not, create DB
         3. Load the Database here
         */
        //temporarily assuming database to be created
        databaseLoginHashMap = NSMutableDictionary()
        isDatabaseCreated = createDataBase()
        if(!isDatabaseCreated){
            let alertController = UIAlertController(title: "Error in Database", message: "Error in creating of fetching Database. Please Check the logs for more info. ", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        databaseLoginHashMap?.setValue("password@123", forKey: "aditguru")
        databaseLoginHashMap?.setValue("benditlikebeckham@123", forKey: "beckham")
        username.delegate = self
        password.delegate = self
        
        let tapToDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardTap))
        loginPageView.addGestureRecognizer(tapToDismissKeyboard)
    }
    //Dismiss Keyboard when tapped anywhere on the screen
    @objc func dismissKeyboardTap(_ sender: Any) {
        view.endEditing(true)
    }
    //Create Database
    func createDataBase() -> Bool{
        do{
            let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dataBaseFileName)
            let flags = SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE
            let status = sqlite3_open_v2(fileURL.absoluteString.cString(using: String.Encoding.utf8), &db, flags, nil)
          
            if status == SQLITE_OK {
                let errMsg : UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>? = nil
                let createTableQuerry1 = "CREATE TABLE IF NOT EXISTS "+dataBaseName+" (ID Integer Primary key AutoIncrement, username TEXT, password TEXT);"
                if sqlite3_exec(db, createTableQuerry1, nil, nil, errMsg) == SQLITE_OK{
                    print("Created TABLE")
                }
                else{
                    print ("Error creating table")
                }
            }
        }
        catch{
            print("Unable to create database!\n Error : \(error)")
            return false
        }
        defaultDataInsertion()
        return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    func defaultDataInsertion(){
        var stmt : OpaquePointer?
        let insertQuerry = "INSERT INTO "+dataBaseName+" (username, password) VALUES ('admin', 'password');"
        sqlite3_prepare_v2(db, insertQuerry, -1, &stmt, nil)
        if sqlite3_step(stmt) == SQLITE_DONE{
            print("Insertion complete")
        }
        else{
            print("Failed Insertion")
        }
        sqlite3_finalize(stmt)
        
        var selectStatement : OpaquePointer?
        let selectSql = "select * from "+dataBaseName
        if (sqlite3_prepare_v2(db, selectSql, -1, &selectStatement, nil)) == SQLITE_OK{
            while (sqlite3_step(selectStatement) == SQLITE_ROW){
//                let rowID = sqlite3_column_int(selectStatement, 0)
                let username1 = String(cString: (sqlite3_column_text(selectStatement, 1))!)
                let password1 = String(cString: (sqlite3_column_text(selectStatement, 2))!)
                databaseLoginHashMap?.setValue(password1 as String, forKey: username1 as String)
                if let tempCheck = databaseLoginHashMap?.value(forKey: username1 as String){
                    print("Username Database retrived details \n"+username1+" : "+(tempCheck as! String))
                }
            }
        }
        
        if sqlite3_step(stmt) == SQLITE_DONE{
            print(dataBaseName+" saved successfully!")
        }
    }
    //Load Database
    func loadDatabase(){
        
    }
    @IBAction func loginToBlueSpace (sender : UIButton){
        loginAttempts+=1;
        if(isDatabaseCreated && (!(username.text?.elementsEqual(""))! && !(password.text?.elementsEqual(""))!)){
            let passwordForUser = databaseLoginHashMap?.value(forKey: username.text!)
            if let passwordExistingUser = passwordForUser{
                if(passwordExistingUser as! String == password.text!){
                    //traverse to next viewController
                    let welcomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
                    welcomeViewController.username = username.text!
                    welcomeViewController.password = password.text!
                    self.navigationController?.pushViewController(welcomeViewController, animated: true)
                }
                else{
                    let alertController = UIAlertController(title: "Unable to Login", message: "Password do not match for the username \" "+username.text!+"\"\nPlease Try again!", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? WelcomeViewController{
            vc.username = username.text!
            vc.password = password.text!
            
        }
    }
}

