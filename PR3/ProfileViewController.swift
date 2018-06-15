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
    // This method handles "return key" events.
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
    
    // Hide keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    // END-UOC-4
    
    
    // BEGIN-UOC-5
    @IBAction func takePicture(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        
        // Check if camera is available. If not, get library
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get picked image
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set image in UIImageView
        profileImage.image = image
        
        saveProfileImage(image)
        
        dismiss(animated: true, completion: nil)
    }
    // END-UOC-5
    
    // BEGIN-UOC-6
    func getURL(forKey key: String) -> URL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectoty = documentsDirectories.first!
        
        return documentDirectoty.appendingPathComponent(key)
    }
    
    func loadProfileImage() -> UIImage? {
        let url = getURL(forKey: "profile_image")
        
        // Get profile image
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return UIImage(named: "EmptyProfile.png") // Get empty profile image
        }
        
        return imageFromDisk
    }
    
    func saveProfileImage(_ image: UIImage) {
        let url = getURL(forKey: "profile_image")
        
        // Save image
        if let data = UIImageJPEGRepresentation(image, 1) {
            let _ = try? data.write(to: url, options: [.atomic])
        }
    }
    // END-UOC-6
    
    // BEGIN-UOC-7
    func saveProfileData(_ currentProfile: Profile) {
        let url = getURL(forKey: "profile_data")
        
        // Save profile data
        NSKeyedArchiver.archiveRootObject(currentProfile, toFile: url.path)
    }
    
    func loadProfileData() -> Profile {
        let url = getURL(forKey: "profile_data")
        if let profile = NSKeyedUnarchiver.unarchiveObject(withFile: url.path) as? Profile {
            // Get profile data
            return profile
        }
        
        // Get empty profile
        return Profile()
    }
    
    // Save button action
    @IBAction func saveButton(_ sender: UIButton) {
        let currentProfile = Profile(name: nameField.text!, surname: surnameField.text!, streetAddress: streetAddressField.text!, city: cityField.text!, occupation: occupationField.text!, company: companyField.text!, income: Int(incomeField.text!)!)
        saveProfileData(currentProfile)
    }
    // END-UOC-7
}
