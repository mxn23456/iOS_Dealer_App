//
//  Inv.swift
//  Dealer_App
//
//  Created by minh nguyen on 12/24/15.
//  Copyright © 2015 minh nguyen. All rights reserved.
//

import UIKit

class Inv{
    //MARK: Properties
    var invDesc: String
    var image: UIImage?
   // var InvTrans[]
    
    init(invDesc: String, image: UIImage?){
        self.invDesc = invDesc
        self.image = image
    }
}
