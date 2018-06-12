//
//  ProfileViewController.swift
//  PR3
//
//  Copyright © 2018 UOC. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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
    @IBAction func takePicture(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        profileImage.image = image
        
        saveProfileImage(image)
        
        dismiss(animated: true, completion: nil)
    }
    // END-UOC-5
    
    // BEGIN-UOC-6
    func imageURL(forKey key: String) -> URL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectoty = documentsDirectories.first!
        
        return documentDirectoty.appendingPathComponent(key)
    }
    
    func loadProfileImage() -> UIImage? {
        let url = imageURL(forKey: "profile_image")
        
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return UIImage(named: "EmptyProfile.png")
        }
        
        return imageFromDisk
    }
    
    func saveProfileImage(_ image: UIImage) {
        let url = imageURL(forKey: "profile_image")
        
        if let data = UIImageJPEGRepresentation(image, 1) {
            let _ = try? data.write(to: url, options: [.atomic])
        }
    }
    // END-UOC-6
    
    // BEGIN-UOC-7
    func saveProfileData(_ currentProfile: Profile) {
        let url = imageURL(forKey: "profile_data")
        NSKeyedArchiver.archiveRootObject(currentProfile, toFile: url.path)
    }
    
    func loadProfileData() -> Profile {
        let url = imageURL(forKey: "profile_data")
        if let profile = NSKeyedUnarchiver.unarchiveObject(withFile: url.path) as? Profile {
            return profile
        }
        
        return Profile()
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        let currentProfile = Profile(name: nameField.text!, surname: surnameField.text!, streetAddress: streetAddressField.text!, city: cityField.text!, occupation: occupationField.text!, company: companyField.text!, income: Int(incomeField.text!)!)
        saveProfileData(currentProfile)
    }
    // END-UOC-7
}
