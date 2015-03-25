//
//  Category.swift
//  CoverMe
//
//  Created by Jeffrey Jones on 3/14/15.
//  Copyright (c) 2015 Electric City Studios. All rights reserved.
//

import UIKit

class Category: NSObject {
    var name: String?
    
    init(name: String? = nil) {
        self.name = name
        super.init()  // JAJ - Do I need to call super.init here? Anytime class is NSObject call parent class init
    }
   
}
