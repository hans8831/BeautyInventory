//
//  ViewController.swift
//  BeautyInventory
//
//  Created by Ling Ouyang on 12/5/16.
//  Copyright © 2016 Ling Ouyang. All rights reserved.
//

import UIKit
//import Google
import Firebase
import GoogleSignIn

class BeautyInventoryViewController: UITableViewController , AddItemViewControllerDelegate, GIDSignInUIDelegate {

    var items: [BeautyInventoryItem]
  
    
    
    
    required init?(coder aDecoder: NSCoder) {
        items = [BeautyInventoryItem]()
        super.init(coder: aDecoder)
        loadBeautyInventoryItems()
        print("Documents folder is \(documentsDirectory())")
        print("Data file path is \(dataFilePath())")
            }
    
    
    //var beautyInventory: Beautyinventory!
    
    func documentsDirectory()-> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in:  .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("BeautyInventory.plist")
    }
    
    func loadBeautyInventoryItems() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            items = unarchiver.decodeObject(forKey: "BeautyInventoryItems") as![BeautyInventoryItem]
            unarchiver.finishDecoding()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleButtons()
    }

   fileprivate func setupGoogleButtons() {
        //add google sign in button
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 16, y: view.frame.height - 500 , width: 200, height: 50)
        view.addSubview(googleButton)
       GIDSignIn.sharedInstance().uiDelegate = self    }
    
    func handleCustomGoogleSign() {
       
        GIDSignIn.sharedInstance().signIn()
    
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureExpireDate(for cell: UITableViewCell, with item: BeautyInventoryItem)
    {
        let label = cell.viewWithTag(1002) as! UILabel
        label.text = item.expireDate
        
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat="MM/dd/yyyy"
        
 
        
        //let openDateObj = dateFormatter.date(from: item.openDate)
        //if openDateObj == nil
       let openDateObj=Date()
        //let  openDateObj = Date()
                
        let  expireDateObj = dateFormatter.date(from: item.expireDate)
        //if expireDateObj == nil
        //{expireDateObj=Date()}
        
        let cal = NSCalendar.current

       let components = cal.dateComponents([Calendar.Component.day], from: openDateObj, to: expireDateObj!)
        if components.day! < 30 {
           label.textColor = UIColor.red
           label.font = UIFont.boldSystemFont(ofSize: 16.0)
        }
        else
        {
            label.textColor = UIColor.black
            label.font = UIFont.systemFont(ofSize: 16.0)
        }
        
    }
    
    
    
    func configureText(for cell: UITableViewCell, with item: BeautyInventoryItem)
    {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    
    /*func configureCheckmark(for cell: UITableViewCell, with item: BeautyInventoryItem) {
        
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked{
            label.text = "√"
        } else{
            label.text = ""
        }
    }*/
    
    // find out how many rows there are
    // find out how many rows there are
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return items.count// right now we have only one row of data
    }
    
    // handle it when user select a row
   /* override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        saveBeautyInventoryItems()
    }*/
    
  
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "BeautyInventoryItem",for: indexPath)
            let item = items[indexPath.row]
            let label = cell.viewWithTag(1000) as! UILabel
            let expireDatelabel = cell.viewWithTag(1002) as! UILabel
            label.text=item.text
            expireDatelabel.text = item.expireDate
        
            //configureCheckmark(for: cell, with: item)
            configureExpireDate(for: cell, with:item)
        return cell
    }
    //var shopbuttonRow : Int
    
    //func buttonClicked(sender:UIButton) {
        
     //    shopbuttonRow = sender.tag
    //}
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
           forRowAt indexPath: IndexPath) {
           items.remove(at: indexPath.row)
           let indexPaths = [indexPath]
           tableView.deleteRows(at: indexPaths, with: .automatic)
           saveBeautyInventoryItems()
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
        }
        else if segue.identifier == "EditItem"{
             let navigationController = segue.destination as! UINavigationController
             let controller = navigationController.topViewController
                              as! ItemDetailViewController
             controller.delegate = self
             if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
               controller.itemToEdit = items[indexPath.row]
            }
            
        }
        
        else if segue.identifier == "ShopItem"{
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController
                as! ItemDetailViewController
            controller.delegate = self
            
           
            let button = sender as! UIButton
            let view = button.superview!
            let pcell = view.superview
            
            if let indexPath = tableView.indexPath(for: pcell as! UITableViewCell){
                controller.itemToShop = items[indexPath.row]
            }
            
            
        }
    }
    
    
    
    
    func addItemViewControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }

   func ItemDetailViewController(_ controller: ItemDetailViewController,
                           didFinishAdding item: BeautyInventoryItem) {
    let newRowIndex = items.count
    items.append(item)
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
    dismiss(animated: true, completion: nil)
    saveBeautyInventoryItems()
    
    }
    
    
    func ItemDetailViewController(_ controller:
        ItemDetailViewController,
                               didFinishEditing item: BeautyInventoryItem) {
        if let index = items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
                configureExpireDate(for: cell, with: item)
            }
        }
           dismiss(animated: true, completion: nil)
        saveBeautyInventoryItems()
    }
    
    func saveBeautyInventoryItems() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(items, forKey: "BeautyInventoryItems")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
  
    @IBAction func cartSummary(_ sender: Any) {
        
    }
   
        
    @IBAction func addItem() {
        let newRowIndex = items.count
        let item = BeautyInventoryItem()
        //item.text = "I am a new guy here"
        //item.checked = false
        //item.openDate = "Dec 8, 2016"
        item.expireDate = "Dec 8, 2017"
        items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
}
