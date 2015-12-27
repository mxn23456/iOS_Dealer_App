//
//  InvTran.swift
//  Dealer_App
//
//  Created by minh nguyen on 12/24/15.
//  Copyright © 2015 minh nguyen. All rights reserved.
//

import Foundation

class InvTran{
    //Mark: Properties
    var amount: Int
    var transDesc: String
    var dateCreated: NSDate
    
    init(amount: Int, transDesc: String){
        self.amount = amount
        self.transDesc = transDesc
        self.dateCreated = NSDate()
        
    }
        
    
    func getDate() -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        let convertedDate = dateFormatter.stringFromDate(dateCreated)
        return convertedDate
    }
    
}