//
//  ShoppingCartViewController.swift
//  BeautyInventory
//
//  Created by Ling Ouyang on 12/10/16.
//  Copyright © 2016 Ling Ouyang. All rights reserved.
//

import UIKit
import CoreData


class ShoppingCartViewController:  UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    var items: [BeautyInventoryItem]
    var itemnameArr:[String] = []
    var itempriceArr:[String] = []
    var itemquantityArr:[String] = []
    
    @IBOutlet weak var myShoppingTableView: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        items = [BeautyInventoryItem]()
        super.init(coder: aDecoder)
        //loadBeautyInventoryItems()
        print("Documents folder is \(documentsDirectory())")
        print("Data file path is \(dataFilePath())")
    }
    
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
    

    
    
    func configureItemInCart(for cell: UITableViewCell, with item: BeautyInventoryItem)
    {
        let label_name = cell.viewWithTag(1007) as! UILabel
        label_name.text = item.text
        let label_price = cell.viewWithTag(1004) as! UILabel
        label_price.text = item.price
        let label_quantity = cell.viewWithTag(1003) as! UILabel
        label_quantity.text = item.quantity
        
     
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Storing core data for items in shopping cart in core data
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //let newCartItem = NSEntityDescription.insertNewObject(forEntityName: "CartItems", into: context)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItems")
        request.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(request)
            if results.count > 0
             {
             for result in results as! [NSManagedObject]
               {
                let item = BeautyInventoryItem()
                if let itemname = result.value(forKey: "name") as? String
                  {
                    itemnameArr.append(itemname)
                    item.setname(iname: itemname)
                  }
                
                
                 if let itemquanity = result.value(forKey: "quantity") as? String
                  {
                    
                    if itemquanity == "0"{
                        result.setValue("1", forKey: "quantity" )
                        do {
                            try context.save()
                        }
                        
                        catch  {
                            
                        }
                        
                    }
                    
                    itemquantityArr.append(itemquanity)
                    item.setquantity(iquantity: itemquanity)
                  }
                
                if let itemprice = result.value(forKey: "price") as? String
                {
                    
                    if itemprice == "0"{
                        
                        do {
                            let deleteitemname = result.value(forKey: "name") as? String
                            print("Delete an beauty item:" + deleteitemname!);
                            try context.delete(result)
                        }
                            
                        catch  {
                            
                        }
                    }
                    else {
                        
                        itempriceArr.append(itemprice)
                        item.setPrice(iprice: itemprice)
                    }
                }
                
                items.append(item)
                
                }
            
            }
            
            
            
           
               let newCartItem1 = NSEntityDescription.insertNewObject(forEntityName: "CartItems", into: context)
               newCartItem1.setValue("Body Mist", forKey: "name")
               newCartItem1.setValue("23.45", forKey: "price")
               newCartItem1.setValue("1", forKey: "quantity")
                
               let newCartItem2 = NSEntityDescription.insertNewObject(forEntityName: "CartItems", into: context)
                newCartItem2.setValue("Eyeliner", forKey: "name")
                newCartItem2.setValue("8.5", forKey: "price")
                newCartItem2.setValue("2", forKey: "quantity")
                
                let newCartItem3 = NSEntityDescription.insertNewObject(forEntityName: "CartItems", into: context)
                newCartItem3.setValue("Face Powder", forKey: "name")
                newCartItem3.setValue("18.5", forKey: "price")
                newCartItem3.setValue("0", forKey: "quantity")
                
                let newCartItem4 = NSEntityDescription.insertNewObject(forEntityName: "CartItems", into: context)
                newCartItem4.setValue("Baby Cream", forKey: "name")
                newCartItem4.setValue("0", forKey: "price")
                newCartItem4.setValue("0", forKey: "quantity")
                
                
                let newCartItem5 = NSEntityDescription.insertNewObject(forEntityName: "CartItems", into: context)
                newCartItem5.setValue("Nail Polish", forKey: "name")
                newCartItem5.setValue("0", forKey: "price")
                newCartItem5.setValue("2", forKey: "quantity")
            
            
            
            
         }
          catch
            {
                print("Fail to fetch new cart item")
            }
            
        
        myShoppingTableView.delegate = self
        myShoppingTableView.dataSource = self
        let label_totalquantity = view.viewWithTag(1006) as! UILabel
        let label_totalcost = view.viewWithTag(1005) as! UILabel
        var totalsum: Int = 0
        var sq: Int = 1
        var sp: Double = 1
        var totalcost: Double = 0
        for item in items
        {
          sq = Int(item.quantity)!
          sp = Double(item.price)!
          
          totalsum += sq
          totalcost += Double(sq) * sp
        
        }
        
        label_totalquantity.text = String(totalsum)
        label_totalcost.text = String(totalcost)
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeautyInventoryItem",for: indexPath)
        let item = items[indexPath.row]
        
        configureItemInCart(for: cell, with:item)
        return cell
    }

    
    func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return items.count// right now we have only one row of data
    }
    
    func saveBeautyInventoryItems() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(items, forKey: "BeautyInventoryItems")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
