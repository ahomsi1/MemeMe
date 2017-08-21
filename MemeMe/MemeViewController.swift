//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Amer Homsi on 6/21/17.
//  Copyright © 2017 Amer Homsi. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerToolbar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIButton!
    
    let memeTextFontAttributes: [String:Any] = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSStrokeWidthAttributeName : NSNumber(value: -4.0),
        NSFontAttributeName : UIFont.systemFont(ofSize: 40.0)
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if memeImageView.image == nil {
            shareButton.isEnabled = false
        } else {
            shareButton.isEnabled = true
        }

        configureTextField(textField: topTextField, placeholder: "TOP")
        configureTextField(textField: bottomTextField, placeholder: "BOTTOM")
    }
    
    func configureTextField(textField: UITextField, placeholder: String) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextFontAttributes
        textField.textAlignment = NSTextAlignment.center
        textField.placeholder = placeholder
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        pickImageWithSourceType(.photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        pickImageWithSourceType(.camera)
    }
    
    func pickImageWithSourceType(_ sourceType: UIImagePickerControllerSourceType)  {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImageView.image = image
            shareButton.isEnabled = true
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
        
        activityVC.completionWithItemsHandler = { activity, success, items, cancel in
            if success == true {
                self.save(memedImage)
                self.dismiss(animated: true, completion: nil)
            } else if success == false {
                self.toolBarAndNavBar(isHidden: false)
            }
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        memeImageView.image = nil
        topTextField.text = ""
        bottomTextField.text = ""
        shareButton.isEnabled = false
        
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if topTextField.isEditing {
            unsubscribeFromKeyboardNotifications()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        subscribeToKeyboardNotifications()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //combines the image and text
    func generateMemedImage() -> UIImage {
        
        toolBarAndNavBar(isHidden: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    func toolBarAndNavBar(isHidden: Bool) {
        
        imagePickerToolbar.isHidden = isHidden
        navBar.isHidden = isHidden
    }
    
    func save(_ memedImage : UIImage) {
        // Create the meme to be shared
        let memedImage = generateMemedImage()
        let meme = Meme(originalImage: memeImageView.image!, topText: topTextField.text!, bottomText: bottomTextField.text!, memedImage: memedImage)
        
        //Adding the saved meme to the memes array in the application delegate
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification:Notification) {
        
        view.frame.origin.y = 0 - getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y =  0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
}

