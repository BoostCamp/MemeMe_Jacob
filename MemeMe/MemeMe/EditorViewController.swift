//
//  EditorViewController.swift
//  MemeMe
//
//  Created by Dongyoon Kang on 2017. 1. 19..
//  Copyright © 2017년 Dongyoon Kang. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    // MARK : Properties
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var tvTop: UITextField!
    @IBOutlet weak var tvBottom: UITextField!
    @IBOutlet weak var shareMemedImageButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    let memeTextAttributes = [
        
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3.0
        
    ] as [String : Any]
    
    
    // hide statusbar
    override var prefersStatusBarHidden: Bool {
        return true;
    }
    
    // MARK : Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tvTop.defaultTextAttributes = memeTextAttributes
        tvBottom.defaultTextAttributes = memeTextAttributes
        tvTop.textAlignment = .center
        tvBottom.textAlignment = .center
        
        // Set placeholder text for text fields
        tvTop.attributedPlaceholder = NSAttributedString(string: "TOP", attributes: memeTextAttributes)
        tvBottom.attributedPlaceholder = NSAttributedString(string: "BOTTOM", attributes: memeTextAttributes)
        
        tvTop.delegate = self
        tvBottom.delegate = self
        
        shareMemedImageButton.isEnabled = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK : IBAction
    @IBAction func pickAnImageFromCamera(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        
    }

    @IBAction func pickAnImageFromAlbum(_ sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonClicked(_ sender: AnyObject) {
        
        let controller = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        controller.completionWithItemsHandler = {(activity, success, items, error) in
            if success && error == nil{
                //Do Work
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
            else if error != nil{
                print("fail")
                //log the error
            }
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonClicked(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    
    // after image picked
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            shareMemedImageButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK : TextFeild Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.placeholder?.removeAll()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    // MARK : calculate over rapping keyboard and hide & show keyboard
    func getKeyboardRect(_ notification:Notification) -> CGRect {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue
    }
    
    func keyboardWillShow(_ notification:Notification) {
        
        let keyboardRect = getKeyboardRect(notification);
        let textField = findFirstResponder() as! UITextField

        if keyboardRect.contains(textField.frame.origin) { // bottom text field
            view.frame.origin.y = 0 - getKeyboardRect(notification).height
        }
    }
    
    func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)

    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)

    }
    
    func findFirstResponder() -> UIResponder? {
        for v in self.view.subviews {
            if v.isFirstResponder {
                return (v as UIResponder)
            }
        }
        return nil
    }
    
    // MARK : Save Model
    func save() {
        // Create the meme
        let meme = Meme(topText: tvTop.text!, bottomText: tvBottom.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate

        appDelegate.memes.append(meme)
        
    }
    
    func generateMemedImage() -> UIImage {
        // TODO: Hide toolbar and navbar
        topToolbar.isHidden = true
        bottomToolbar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)

        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        topToolbar.isHidden = false
        bottomToolbar.isHidden = false


        return memedImage
    }

   }

