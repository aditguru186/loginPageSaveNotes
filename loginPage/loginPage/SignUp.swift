//
//  SignUp.swift
//  loginPage
//
//  Created by Aditya Guru on 07/04/21.
//

import UIKit

class SignUp: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var nameInfoLabel: UILabel!
    @IBOutlet weak var usernameLabelInfo: UILabel!
    @IBOutlet weak var passwordLabelInfo: UILabel!
    @IBOutlet weak var confirmPasswordLabelInfo: UILabel!
    @IBOutlet weak var phoneNumLabelInfo: UILabel!
    @IBOutlet weak var emailLabelInfo: UILabel!
    
    var dictForDB:NSDictionary?
    var databaseName:String?
    var databaseFileName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainVC = ViewController()
        databaseName = mainVC.dataBaseName
        databaseFileName = mainVC.dataBaseFileName
        nameInfoLabel.isHidden = true
        
//        saveData()
        
        
    }
    func verifyIfValidData(){
        var isDataValidForSaving = true
        let lettersSet = CharacterSet.letters
        let upperLetterSet = CharacterSet.uppercaseLetters
        let lowerLetterSet = CharacterSet.lowercaseLetters
        let numberSet = CharacterSet.decimalDigits
        let symbolSet = CharacterSet.symbols
        if((name.text?.rangeOfCharacter(from: lettersSet) == nil) && name.text == ""){
            isDataValidForSaving = false
            name.tintColor = UIColor(red: 200, green: 0, blue: 0, alpha: 0.5)
            nameInfoLabel.text = "!! Entry of numbers and symbols is discouraged"
            nameInfoLabel.isHidden = false
        }
        let passwordTxt = password.text
        if(passwordTxt?.rangeOfCharacter(from: upperLetterSet) == nil && passwordTxt?.rangeOfCharacter(from: lowerLetterSet) == nil && passwordTxt?.rangeOfCharacter(from: numberSet) == nil && passwordTxt?.rangeOfCharacter(from: symbolSet) == nil && passwordTxt == "" && passwordTxt!.count < 8){
            isDataValidForSaving = false
            passwordLabelInfo.isHidden = false
            passwordLabelInfo.text = "Password must contain at least 1 uppercase, lowercase, digit, symbol, and length should be 8+"
        }
        if(passwordTxt != confirmPassword.text){
            isDataValidForSaving = false
            confirmPasswordLabelInfo.isHidden = false
        }
        if(phoneNumber.text?.rangeOfCharacter(from: numberSet) == nil){
            isDataValidForSaving = false
            phoneNumLabelInfo.isHidden = false
        }
        //validate username by checking its presence in the db, i.e. its uniqueness
        
        
    }
    func saveData(){
        
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
