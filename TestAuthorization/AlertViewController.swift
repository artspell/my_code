//
//  AlertViewController.swift
//  TestAuthorization
//
//  Copyright © 2017 ArtSpell. All rights reserved.
//

import UIKit

extension UIAlertController{
    
    //show alert in app
    func presentAlertWithText(_ view:UIViewController, text: String){
        let alertController = UIAlertController(title: "Message for you", message: text, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        view.present(alertController, animated: true, completion: nil)
    }
}
