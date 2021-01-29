//
//  VerificationViewController.swift
//  FastCash
//
//  Created by Trevor Carpenter on 1/18/21.
//  Copyright © 2021 Trevor Carpenter. All rights reserved.
//

import UIKit

class VerificationViewController: UIViewController, PinTexFieldDelegate {

    @IBOutlet weak var OTP1: PinTextField!
    @IBOutlet weak var OTP2: PinTextField!
    @IBOutlet weak var OTP3: PinTextField!
    @IBOutlet weak var OTP4: PinTextField!
    @IBOutlet weak var OTP5: PinTextField!
    @IBOutlet weak var OTP6: PinTextField!
    @IBOutlet weak var ErrorLabel: UILabel!
    
    @IBOutlet weak var sentToNumber: UILabel!
    
    var fields: [UITextField] = []
    var phoneNum: String = ""
    var currentField = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fields.append(OTP1)
        self.fields.append(OTP2)
        self.fields.append(OTP3)
        self.fields.append(OTP4)
        self.fields.append(OTP5)
        self.fields.append(OTP6)
        
        self.fields = self.fields.map({$0.delegate = self; return $0})
        

        self.currentField = 0
        OTP1.becomeFirstResponder()
        sentToNumber.text = "Code was sent to \(self.phoneNum)"
    }
    
    func clearCodes() {
        self.fields = self.fields.map({ $0.text = ""; return $0})
        self.fields[0].becomeFirstResponder()
        self.currentField = 0
    }
    
    func didPressBackspace(textField: PinTextField) {
        if (self.currentField > 0 && self.currentField < 5)  || (self.currentField == 5 && textField.text == ""){
            self.currentField -= 1
            self.fields[currentField].becomeFirstResponder()
            self.fields[currentField].text = ""
        }
    }
    
    @IBAction func editedField(_ sender: Any) {
        let text = self.fields[self.currentField].text ?? ""
        print(text)
        
        // solve for autofill
        if text.count == 0 {
            print("breaking")
            return
        }
        
        // solve for pasting code into the first field
        if text.count > 1 && self.currentField == 0 {
            for (field, index) in zip(self.fields, 1...6) {
                if index > text.count {
                    self.fields[self.currentField+1].becomeFirstResponder()
                    return
                }
                field.text = String(text[text.index(text.startIndex, offsetBy: index-1)])
                self.currentField = index-1
            }
        }
        
        if self.currentField == 5 {
            Api.verifyCode(phoneNumber: self.phoneNum,
                           code: self.fields.compactMap({$0.text}).reduce("", {$0 + $1}),
                           completion: { response, error in
                if let resp = response {
                    
                    Storage.phoneNumberInE164 = self.phoneNum
                    Storage.authToken = resp["auth_token"] as? String
                    
                    let wallet = Wallet.init(data: resp, ifGenerateAccounts: false)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "home")
                    
                    guard let homeVC = vc as? HomeViewController else {
                        assertionFailure("couldn't find vc")
                        return
                    }
                    
                    homeVC.name = wallet.userName ?? ""
                    homeVC.accounts = wallet.accounts
                    homeVC.phoneNumber = wallet.phoneNumber
                    self.navigationController?.present(homeVC, animated: true)
                }
                else {
                    self.ErrorLabel.text = error?.message
                    self.ErrorLabel.textColor = .systemRed
                }
            })
        }
        else {
            // go to next
            self.currentField += 1
            self.fields[currentField].becomeFirstResponder()
        }
    }
    
    @IBAction func resendCode(_ sender: Any) {
        Api.sendVerificationCode(phoneNumber: self.phoneNum, completion: { response, error in
            if let _ = response {
                self.ErrorLabel.text = ""
                self.ErrorLabel.textColor = .black
            }
            if let err = error {
                self.ErrorLabel.text = err.message
                self.ErrorLabel.textColor = .systemRed
            }
        })
    }

}
