//
//  TwoFactorAuthenticationViewController.swift
//  PR3
//
//  Copyright © 2018 UOC. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var firstField: UITextField!
    @IBOutlet weak var secondField: UITextField!
    @IBOutlet weak var thirdField: UITextField!
    @IBOutlet weak var fourthField: UITextField!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    
    @IBOutlet weak var pleaseLabel: UILabel!
    
    @IBOutlet weak var pleaseVerticalLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var backHorizontalButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextHorizontalButtonConstraint: NSLayoutConstraint!
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // We first check that the user is only entering numeric characters
        let numericSet = CharacterSet.decimalDigits
        let stringSet = CharacterSet(charactersIn: string)
        let onlyNumeric = numericSet.isSuperset(of: stringSet)
        
        if !onlyNumeric {
            return false
        }
        
        // We then check that the length of resulting text will be smaller or equal to 1
        let currentString = textField.text ?? ""
        
        guard let stringRange = Range(range, in: currentString) else {
            return false
        }
        
        let resultingString = currentString.replacingCharacters(in: stringRange, with: string)
        
        let resultingLength = resultingString.count
        
        if resultingLength <= 1 {
            return true
        } else {
            return false
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        doAuthentication()
    }
    
    // BEGIN-UOC-2
    override func viewDidLoad() {
        firstField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        secondField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        thirdField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        fourthField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        switch textField {
            case firstField:
                secondField.becomeFirstResponder()
            case secondField:
                thirdField.becomeFirstResponder()
            case thirdField:
                fourthField.becomeFirstResponder()
            case fourthField:
                doAuthentication()
            default:
                textField.resignFirstResponder()
        }
    }
    // END-UOC-2
    
    func doAuthentication() {
        var validCode: Bool
        if let firstCode = firstField.text, let secondCode = secondField.text, let thirdCode = thirdField.text, let fourthCode = fourthField.text {
            let fullCode = firstCode + secondCode + thirdCode + fourthCode
            validCode = Services.validate(code: fullCode)
        } else {
            validCode = false
        }
        
        if validCode {
            // BEGIN-UOC-3
            pleaseVerticalLabelConstraint.constant -= 100
            backHorizontalButtonConstraint.constant += 100
            nextHorizontalButtonConstraint.constant -= 100

            UIView.animate(
                withDuration: 1,
                animations: {
                    self.firstLabel.alpha = 0
                    self.firstField.alpha = 0
                    self.secondLabel.alpha = 0
                    self.secondField.alpha = 0
                    self.thirdLabel.alpha = 0
                    self.thirdField.alpha = 0
                    self.fourthLabel.alpha = 0
                    self.fourthField.alpha = 0
                    
                    self.view.layoutIfNeeded()
                },
                completion: { (finished: Bool) in
                    self.pleaseLabel.alpha = 0
                    self.performSegue (withIdentifier: "SegueToMainNavigation", sender: self)
                }
            )
            // END-UOC-3
        } else {
            let errorMessage = "Sorry, the entered code is not valid"
            let errorTitle = "We could not autenticate you"
            Utils.show (Message: errorMessage, WithTitle: errorTitle, InViewController: self)
        }
    }
}
