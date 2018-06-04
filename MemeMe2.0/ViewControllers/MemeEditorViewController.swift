//
//  MemeEditorViewController.swift
//  MemeMe2.0
//
//  Created by Kim Lyndon on 5/16/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//  MemeMe version 1 was recycled into this project. 

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
//Set outlets for imageView and text fields
        @IBOutlet weak var imagePickerView: UIImageView!
        @IBOutlet weak var topTextField: UITextField!
        @IBOutlet weak var bottomTextField: UITextField!
        @IBOutlet weak var cameraButton: UIBarButtonItem!
        @IBOutlet weak var shareButton: UIBarButtonItem!
        @IBOutlet weak var toolbar: UIToolbar!
        @IBOutlet weak var navigationBar: UINavigationBar!
        @IBOutlet weak var cancelButton: UIBarButtonItem!
        
        
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            subscribeToKeyboardNotifications()
//Enable buttons
            cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
          
        
            
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            unsubscribeFromKeyboardNotifications()
            
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            setTextFields(textField: topTextField, defaultText: "TOP")
            setTextFields(textField: bottomTextField, defaultText: "BOTTOM")
            shareButton.isEnabled = false
        }
        
        func setTextFields(textField: UITextField, defaultText: String) {
//Setting the text fields' styles and fonts
            let memeTextAttributes:[String: Any] = [
                NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
                NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
                NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                NSAttributedStringKey.strokeWidth.rawValue: -3]
            
//Set default attributes
            textField.defaultTextAttributes = memeTextAttributes
            textField.delegate = self
            textField.textAlignment = .center
            textField.text = defaultText
            
        }
        
//Connect action for the ALBUM button and set delegate
        @IBAction func pickAnImageFromAlbum(_ sender: Any) {
            pick(sourceType: .photoLibrary)
        }
        
        //MARK: Meme Editor
//imagePickerControllerDelegate Methods
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                imagePickerView.image = image
        }
            
//Dismiss picker after choice is made
            self.dismiss(animated: true, completion: nil)
            
        }
        
//Connect action for camera option
        @IBAction func pickAnImageFromCamera(_ sender: Any) {
            pick(sourceType: .camera)
        }
//Former code to hide nav and toolbar refactored
    func navBarStatus(status: Bool) {
        navigationBar.isHidden = status
        toolbar.isHidden = status
    }
    
        func generateMemedImage() -> UIImage {
//HIDE NAV AND TOOL BAR
            navBarStatus(status: true)
// Render view to an image
            UIGraphicsBeginImageContext(self.view.frame.size)
            view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
            let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
//SHOW NAV AND TOOL BAR
            navBarStatus(status: false)
            
            return memedImage
        }
    
//Initialize meme model object
        func save() {
            let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.append(meme)
        
    }
        
        func pick(sourceType: UIImagePickerControllerSourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
        
        @IBAction func shareButtonPressed(_ sender: Any) {
            let memedImage = generateMemedImage()
            let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
//This area of code was giving me trouble and I asked for outside help from a friend.
            activityViewController.completionWithItemsHandler = {activity, didComplete, item, error in if didComplete {
                self.save()
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
        }
            }
            present(activityViewController, animated: true, completion: nil)
            
            
        }
     
        @IBAction func cancelButtonPressed(_ sender: Any) {
            imagePickerView.image = nil
            dismiss(animated: true, completion: nil)
            
        }
        func textFieldDidBeginEditing(_ textField: UITextField) {
            if textField.text == "TOP" || textField.text == "BOTTOM" {
                textField.text = ""
        }
    
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
        
            
            if textField.isEqual(bottomTextField) {
                self.unsubscribeFromKeyboardNotifications()
        }
            return true;
        }
        
        func subscribeToKeyboardNotifications() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWllShow(_notification:)), name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_notification:)), name: .UIKeyboardDidHide, object: nil)
        }
        
        func unsubscribeFromKeyboardNotifications() {
            NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        }
        
        @objc func keyboardWllShow(_notification: Notification) {
            if bottomTextField.isEditing {
            view.frame.origin.y = -getKeyboardHeight(_notification: _notification)
        }
        }
        
        func getKeyboardHeight(_notification: Notification) -> CGFloat {
            let userInfo = _notification.userInfo
            let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
            return keyboardSize.cgRectValue.height
        }
        
        @objc func keyboardWillHide(_notification: Notification) {
            view.frame.origin.y = 0
        }
}

