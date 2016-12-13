//
//  BeautyInventoryItem.swift
//  BeautyInventory
//
//  Created by Ling Ouyang on 12/6/16.
//  Copyright © 2016 Ling Ouyang. All rights reserved.
//

import Foundation
class BeautyInventoryItem:NSObject, NSCoding {
    var text = ""
    var openDate = ""
    var expireDate = ""
    var price = "9.99"
    var quantity = "1"
    var checked = false
    override init(){
       super.init()
    }
    
    required init?(coder aDecoder : NSCoder){
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        openDate = aDecoder.decodeObject(forKey: "OpenDate")as! String
        expireDate = aDecoder.decodeObject(forKey: "ExpireDate") as! String
        price = aDecoder.decodeObject(forKey: "price")as! String
        quantity = aDecoder.decodeObject(forKey: "quantity") as! String
        super.init()
    }
    
    
    func toggleChecked() {
        checked = !checked
    }
    
    func setPrice(iprice : String)
    {
       price = iprice
    }
    
    func setquantity(iquantity : String)
    {
        quantity = iquantity
    }
    
    func setname(iname : String)
    {
        text = iname
    }
    
    func setopenDate(iopenDate : String)
    {
        openDate = iopenDate
    }
    
    func setexpireDate(iexDate : String)
    {
        expireDate = iexDate
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
        aCoder.encode(openDate, forKey: "OpenDate")
        aCoder.encode(expireDate, forKey: "ExpireDate")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(quantity, forKey: "quantity")
    }
}
