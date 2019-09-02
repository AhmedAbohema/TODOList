//
//  Item.swift
//  TODOList
//
//  Created by AHMED on 8/24/19.
//  Copyright © 2019 AHMED. All rights reserved.
//

import Foundation
import RealmSwift
class Item: Object {
  @objc dynamic var title : String = ""
  @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated :Date?
  var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
