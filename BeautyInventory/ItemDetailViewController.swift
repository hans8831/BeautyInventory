//
//  ItemDetailViewController.swift
//  BeautyInventory
//
//  Created by Ling Ouyang on 12/6/16.
//  Copyright © 2016 Ling Ouyang. All rights reserved.
//

import Foundation
import UIKit
import CoreData
protocol AddItemViewControllerDelegate: class {
    func addItemViewControllerDidCancel(_ controller: ItemDetailViewController)
    func ItemDetailViewController(_ controller: ItemDetailViewController,
                               didFinishAdding item: BeautyInventoryItem)
    func ItemDetailViewController(_ controller: ItemDetailViewController,
                               didFinishEditing item: BeautyInventoryItem)
}



class ItemDetailViewController: UITableViewController,
                             UITextFieldDelegate {
   
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField_OpenDate: UITextField!
    @IBOutlet weak var textField_ExpireDate: UITextField!
    @IBOutlet weak var lOpenDate: UILabel!
    @IBOutlet weak var lExpireDate: UILabel!
    
    @IBOutlet weak var textField_Quantity: UILabel!
    @IBOutlet weak var textField_Price: UITextField!
    @IBOutlet weak var ItemOpenDateView: UITableViewCell!
    
    @IBOutlet weak var ItemExpireDateView: UITableViewCell!
    @IBOutlet weak var ItemPriceView: UITableViewCell!
    @IBOutlet weak var ItemQuantityView: UITableViewCell!
    
    
    @IBOutlet weak var itemNo: UILabel!
    
    @IBOutlet weak var itemStepper: UIStepper!
    
    
    @IBAction func setItemQuantity(_ sender: Any) {
        itemNo.text = "\(Int(itemStepper.value))"
    }
    
    
    @IBAction func textField_OpenDate(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(ItemDetailViewController.datePickerValueOpenDateChanged),
                                 for: UIControlEvents.valueChanged)
    }
    
    
    @IBAction func textField_ExpireDate(sender: UITextField) {
        // 6
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(ItemDetailViewController.datePickerValueExpireDateChanged),
                                 for: UIControlEvents.valueChanged)
        
    }
    
    func datePickerValueOpenDateChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateFormatter.dateFormat="MM/dd/yyyy"
        
        
        textField_OpenDate.text = dateFormatter.string(from: sender.date)
        
        print(dateFormatter.string(from: sender.date))
        
    }
    
    func datePickerValueExpireDateChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateFormatter.dateFormat="MM/dd/yyyy"
        
        
        textField_ExpireDate.text = dateFormatter.string(from: sender.date)
        
        print(dateFormatter.string(from: sender.date))
        
    }
    
    weak var delegate: AddItemViewControllerDelegate?
    var itemToEdit: BeautyInventoryItem?
    var itemToShop: BeautyInventoryItem?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
              title = "Edit Item"
              lOpenDate.isEnabled = true
              lExpireDate.isEnabled = true
              textField_OpenDate.textColor = UIColor.black
              textField_ExpireDate.textColor = UIColor.black
              textField_OpenDate.isEnabled = true
              textField_ExpireDate.isEnabled = true
            
             textField.text = item.text
             textField_OpenDate.text = item.openDate
             textField_ExpireDate.text = item.expireDate
              doneBarButton.isEnabled = true
             ItemPriceView.isHidden=true
             ItemQuantityView.isHidden=true
        }
        else if let item = itemToShop{
             title = "Shop Item"
             textField.text = item.text
             ItemExpireDateView.isHidden=true
             ItemOpenDateView.isHidden=true
             textField_OpenDate.text = item.openDate
             textField_ExpireDate.text = item.expireDate
             textField_Price.text = item.price
             textField_Quantity.text = item.quantity

             lOpenDate.isEnabled = false
             lExpireDate.isEnabled = false
             textField_OpenDate.textColor = UIColor.lightGray
             textField_ExpireDate.textColor = UIColor.lightGray
             textField_OpenDate.isEnabled = false
             textField_ExpireDate.isEnabled = false
            
             doneBarButton.isEnabled = true
          
        }
        
        else {
        
            ItemPriceView.isHidden=true
            ItemQuantityView.isHidden=true        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        if newText.length > 0 {
            doneBarButton.isEnabled = true }
        else {
            doneBarButton.isEnabled = false
        }
        return true
    }
    
    func setItemPrice(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let oldText = textField_Price.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        if newText.length > 0 {
            doneBarButton.isEnabled = true }
        else {
            doneBarButton.isEnabled = false
        }
        return true
    }
    
    
    func setItemQuantity(_ textField: UITextField,
                      shouldChangeCharactersIn range: NSRange,
                      replacementString string: String) -> Bool {
        let oldText = textField_Quantity.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        if newText.length > 0 {
            doneBarButton.isEnabled = true }
        else {
            doneBarButton.isEnabled = false
        }
        return true
    }
    
    
    
    
    
    @IBAction func cancel() {
        delegate?.addItemViewControllerDidCancel(self)
    }
    @IBAction func done() {
        if let item = itemToEdit{
            item.text = textField.text!
            item.openDate=textField_OpenDate.text!
            item.expireDate=textField_ExpireDate.text!
            delegate?.ItemDetailViewController(self, didFinishEditing: item)
        }
        else if let item = itemToShop{
            
            item.text = textField.text!
            item.openDate=textField_OpenDate.text!
            item.expireDate=textField_ExpireDate.text!
            item.price=textField_Price.text!
            item.quantity=textField_Quantity.text!
            delegate?.ItemDetailViewController(self, didFinishEditing: item)
        }
        else{
        let item = BeautyInventoryItem()
            item.text = textField.text!
            item.openDate = textField_OpenDate.text!
            item.expireDate = textField_ExpireDate.text!
            item.checked = false
            delegate?.ItemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView,
                        willSelectRowAt indexPath: IndexPath) -> IndexPath? {
       return nil
    }

    
}
