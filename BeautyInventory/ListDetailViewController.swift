//
//  ListDetailViewController.swift
//  BeautyInventory
//
//  Created by Ling Ouyang on 12/8/16.
//  Copyright © 2016 Ling Ouyang. All rights reserved.
//

import Foundation

import UIKit
protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(_ controller:ListDetailViewController)
    
    func listDetailViewController(_ controller: ListDetailViewController,didFinishAdding beautyinventory:Beautyinventory)
    
    func listDetailViewController(_ controller: ListDetailViewController,
                                  didFinishEditing beautyinventory:Beautyinventory)
}


class ListDetailViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    
    weak var delegate: ListDetailViewControllerDelegate?
    var beautyinventoryToEdit: Beautyinventory?
    // add title and puts the checklist's name into the text field
    override func viewDidLoad() {
        super.viewDidLoad()
        if let beautyinventory = beautyinventoryToEdit {
            title = "Edit Checklist"
            textField.text = beautyinventory.name
            doneBarButton.isEnabled = true
                    }
    }
    
    // pop up the keyboard
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
            }
    
    // add action method for the Cancel button
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }

// add the text field delegate method that enables or disables the Done button // depending on whether the text field is empty or not
    func textField(_ textField: UITextField,
               shouldChangeCharactersIn range: NSRange,
               replacementString string: String) -> Bool {
        
          let oldText = textField.text! as NSString
          let newText = oldText.replacingCharacters(in: range, with: string) as NSString
          doneBarButton.isEnabled = (newText.length > 0)
          return true
    }
    // add action method for the Done button
    @IBAction func done() {
        if  let beautyinventory = beautyinventoryToEdit {
            beautyinventory.name = textField.text!
            delegate?.listDetailViewController(self, didFinishEditing: beautyinventory) }
        else {
            let beautyinventory = Beautyinventory(name: textField.text!)
            delegate?.listDetailViewController(self, didFinishAdding: beautyinventory)
           }
       }

  // make sure the user cannot select the table cell with the text field
      override func tableView(_ tableView: UITableView,
                              willSelectRowAt indexPath: IndexPath) -> IndexPath? {
               return nil
    }
    // add the text field delegate method that enables or disables the Done button // depending on whether the text field is empty or not
    
    
    
}
