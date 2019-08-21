//
//  ViewController.swift
//  TODOList
//
//  Created by AHMED on 7/21/19.
//  Copyright © 2019 AHMED. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UITableViewController  {
    var itemarray = [Item]()
    var selectedCategory : Category? {
        didSet {
            loaddata()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   let datafilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       // loaddata()
        // Do any additional setup after loading the view.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return itemarray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemarray[indexPath.row].title
        if itemarray[indexPath.row].done == true {
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemarray[indexPath.row])
        
        if itemarray[indexPath.row].done == true
        {
            itemarray[indexPath.row].done = false
        }else {
            itemarray[indexPath.row].done = true
        }
        
       
        savedata()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }


@IBAction func Addbuttonpressed(_ sender: UIBarButtonItem) {
    var textfieldalert = UITextField()
    let alert = UIAlertController(title: "Add New Todeoy item", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
        
        let newitem = Item(context: self.context)
        newitem.title = textfieldalert.text!
        newitem.done = false
        newitem.parentCategory = self.selectedCategory
        self.itemarray.append(newitem)
        self.savedata()
        self.tableView.reloadData()
        
    }
    alert.addAction(action)
    alert.addTextField { (alertTextfield) in
        alertTextfield.placeholder = " Create new Item"
        textfieldalert = alertTextfield
    }
    present(alert , animated: true , completion: nil)
}
    
    //MARK:- SaveData Methods
    func savedata()
    {
       
        do{
          try  context.save()
        }catch {
            print("error durring Saving \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK:- LoadData Methods
    func loaddata(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil)
    {
        let categorypredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let addtionalpredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate , addtionalpredicate])
        }
        else
        {
            request.predicate = categorypredicate
        }
       // let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
       itemarray = try context.fetch(request)
        }catch{
            print("error \(error)")
        }
        tableView.reloadData()
    }
    
    
    
}
    
extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
       let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
       request.sortDescriptors = [sortDescriptor]
        
       loaddata(with: request, predicate: predicate)
        
      
        }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
           loaddata()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
