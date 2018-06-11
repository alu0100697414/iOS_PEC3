//
//  ProfileViewController.swift
//  PR3
//
//  Copyright © 2018 UOC. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController, UITextFieldDelegate {
    var currentProfile: Profile?
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var streetAddressField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var occupationField: UITextField!
    @IBOutlet weak var companyField: UITextField!
    @IBOutlet weak var incomeField: UITextField!
    
    override func viewDidLoad() {
        profileImage.image = loadProfileImage()
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        currentProfile = loadProfileData()
        
        self.nameField.text = currentProfile?.name
        self.surnameField.text = currentProfile?.surname
        self.streetAddressField.text = currentProfile?.streetAddress
        self.cityField.text = currentProfile?.city
        self.occupationField.text = currentProfile?.occupation
        self.companyField.text = currentProfile?.company
        self.incomeField.text = currentProfile?.income.description
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    
    // BEGIN-UOC-4
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case nameField:
                surnameField.becomeFirstResponder()
            case surnameField:
                streetAddressField.becomeFirstResponder()
            case streetAddressField:
                cityField.becomeFirstResponder()
            case cityField:
                occupationField.becomeFirstResponder()
            case occupationField:
                companyField.becomeFirstResponder()
            case companyField:
                incomeField.becomeFirstResponder()
            case incomeField:
                incomeField.resignFirstResponder()
            default:
                textField.resignFirstResponder()
        }
        
        return false;
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    // END-UOC-4
    
    
    // BEGIN-UOC-5
    //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    //        saveProfileImage(image)
    //    }
    // END-UOC-5
    
    // BEGIN-UOC-6
    func loadProfileImage() -> UIImage? {
        return UIImage(named: "EmptyProfile.png")
    }
    
    func saveProfileImage(_ image: UIImage) {
        
    }
    // END-UOC-6
    
    // BEGIN-UOC-7
    func saveProfileData(_ currentProfile: Profile) {
        
    }
    
    func loadProfileData() -> Profile {
        let profile = Profile(name: "Sherlock", surname: "Holmes", streetAddress: "221B Baker Street", city: "London", occupation: "Detective", company: "Self-employed", income: 500)
        return profile
    }
    // END-UOC-7
}
