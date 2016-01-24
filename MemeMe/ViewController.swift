//
//  ViewController.swift
//  MemeMe
//
//  Created by Andrew Tantomo on 2016/01/23.
//  Copyright © 2016年 Andrew Tantomo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    let defaultTopText = "TOP"
    let defaultBottomText = "BOTTOM"
    let saveConfMsg = "Your meme has been saved!"
    
    @IBOutlet weak var topTextField: MemeTextField!
    @IBOutlet weak var bottomTextField: MemeTextField!
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var pickerToolbar: UIToolbar!
    
    var activeField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         // Do any additional setup after loading the view, typically from a nib.
        
        shareButton.enabled = false
        memeImageView.contentMode = .ScaleAspectFill
        
        let textAttr = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -4.0,
        ]
        
        for memeTextField in [topTextField, bottomTextField] {
            memeTextField.delegate = self
            memeTextField.defaultTextAttributes = textAttr
            memeTextField.textAlignment = .Center
            memeTextField.autocapitalizationType = .AllCharacters
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func shareButtonTapped(sender: UIBarButtonItem) {
        
        let memedImage = generateMemedImage()
        
        let activityViewCtrl = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewCtrl.completionWithItemsHandler = {(activityType: String?, completed: Bool, returnedItems: [AnyObject]?, activityError: NSError?) -> () in
            
            if (activityType == UIActivityTypeSaveToCameraRoll) {
                
                self.save(memedImage)
                self.showConfirmationMessage()
            }
        }
        presentViewController(activityViewCtrl, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        
        let imagePickerCtrl = UIImagePickerController()
        imagePickerCtrl.delegate = self
        imagePickerCtrl.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePickerCtrl, animated: true, completion: nil)
    }

    @IBAction func pickAnImageFromAlbum(sender: UIBarButtonItem) {
        
        let imagePickerCtrl = UIImagePickerController()
        imagePickerCtrl.delegate = self
        imagePickerCtrl.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePickerCtrl, animated: true, completion: nil)
    }
    
    @IBAction func textFieldChanged(sender: MemeTextField) {
        sender.hasBeenEdited = true
    }
    
    func subscribeToKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        let keyboardHeight = getKeyboardHeight(notification)
        let textFieldBase = view.frame.size.height - (activeField.frame.origin.y + activeField.frame.size.height)

        if (keyboardHeight > textFieldBase) {
            view.frame.origin.y -= keyboardHeight
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImageView.image = image
            shareButton.enabled = true
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        activeField = textField
        
        if let memeTextField = textField as? MemeTextField {
            if (!memeTextField.hasBeenEdited) {
                memeTextField.text = ""
            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if (textField.text == "") {
            
            switch (textField) {
                
            case topTextField:
                textField.text = defaultTopText
            case bottomTextField:
                textField.text = defaultBottomText
            default:
                break
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
        
    }
    
    private func generateMemedImage() -> UIImage {
        
        navigationController?.navigationBar.hidden = true
        pickerToolbar.hidden = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        pickerToolbar.hidden = false
        navigationController?.navigationBar.hidden = false
        
        return memedImage
    }
    
    private func save(memedImage: UIImage) -> Meme {
        
        // TODO: Do something with the image (add to collection view, etc.)
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!,
            image: memeImageView.image!, memedImage: memedImage)
        return meme
    }
    
    private func showConfirmationMessage() {
        let alertCtrl = UIAlertController(title: nil, message: saveConfMsg, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertCtrl.addAction(okAction)
        presentViewController(alertCtrl, animated: true, completion: nil)
    }
}

