//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Andrew Tantomo on 2016/01/23.
//  Copyright © 2016年 Andrew Tantomo. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {

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
    
    var prevKeyboardHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
         // Do any additional setup after loading the view, typically from a nib.
        
        shareButton.enabled = false
        memeImageView.contentMode = .ScaleAspectFit
        
        setupMemeTextField(topTextField)
        setupMemeTextField(bottomTextField)
        
        memeImageView.image?.size
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
            
            if (completed) {
                self.save(memedImage)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        presentViewController(activityViewCtrl, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
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
        sender.edited = true
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

        if (bottomTextField.isFirstResponder()) {
            view.frame.origin.y = view.frame.origin.y - (keyboardHeight  - prevKeyboardHeight)
            prevKeyboardHeight = keyboardHeight
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
        prevKeyboardHeight = 0.0
    }
    
    private func setupMemeTextField(textField: UITextField) {
        
        let textAttr = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -4.0,
        ]
        
        textField.delegate = self
        textField.defaultTextAttributes = textAttr
        textField.textAlignment = .Center
        textField.autocapitalizationType = .AllCharacters
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
    
    private func save(memedImage: UIImage) -> () {
        
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!,
            image: memeImageView.image!, memedImage: memedImage)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
}

extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
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
        
        if let memeTextField = textField as? MemeTextField {
            // Only clear default text (texts created by user should not be removed)
            if (!memeTextField.edited) {
                memeTextField.text = ""
            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if let memeTextField = textField as? MemeTextField {
            
            // Trim excess whitespaces
            var newText = memeTextField.text! as NSString
            newText = newText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            memeTextField.text = newText as String
            
            // Restore default text when text field is empty after editing
            if (memeTextField.text == "") {
                
                switch (memeTextField) {
                    
                case topTextField:
                    memeTextField.text = defaultTopText
                case bottomTextField:
                    memeTextField.text = defaultBottomText
                default:
                    break
                }
                memeTextField.edited = false
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
