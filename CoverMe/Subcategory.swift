//
//  Subcategory.swift
//  CoverMe
//
//  Created by Jeffrey Jones on 4/17/15.
//  Copyright (c) 2015 Electric City Studios. All rights reserved.
//

import UIKit

class Subcategory: NSObject {
    var name: String?
    var image: String?
    var category: Category?
    
    init(name: String? = nil, image: String? = nil, category: Category? = nil) {
        self.name = name
        self.category = category
        self.image = image
        super.init()
    }
}
