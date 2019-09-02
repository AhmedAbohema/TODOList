//
//  Category.swift
//  TODOList
//
//  Created by AHMED on 8/24/19.
//  Copyright © 2019 AHMED. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
