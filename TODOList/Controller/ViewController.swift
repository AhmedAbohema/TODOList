//
//  ViewController.swift
//  TODOList
//
//  Created by AHMED on 7/21/19.
//  Copyright © 2019 AHMED. All rights reserved.
//

import UIKit
import RealmSwift
class ViewController: UITableViewController  {
    var Todoitems : Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet {
            loaddata()
        }
    }
    
   
   let datafilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       // loaddata()
        // Do any additional setup after loading the view.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return Todoitems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = Todoitems?[indexPath.row]{
        cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else
        {
            cell.textLabel?.text = "no item add yet"
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(Todoitems?[indexPath.row])
        
        if let item = Todoitems?[indexPath.row] {
            do {
             try   realm.write {
                    item.done = !item.done
                }
                
            }catch
            {
                print("error did select done \(error)")
            }
        }
       
      
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }


@IBAction func Addbuttonpressed(_ sender: UIBarButtonItem) {
    var textfieldalert = UITextField()
    let alert = UIAlertController(title: "Add New Todeoy item", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
        if let currentCategory = self.selectedCategory {
            do {
                try self.realm.write {
                    let newitem = Item()
                    newitem.dateCreated = Date()
                    newitem.title = textfieldalert.text!
                    currentCategory.items.append(newitem)
                }
            
            }catch{
                print("Error in adding new item \(error)")
            }
        }
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
    
    
    // MARK:- LoadData Methods
    func loaddata()
    {
        Todoitems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    
    
}
    
extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         Todoitems = Todoitems?.filter("title CONTAINS[cd] %@ ", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
       tableView.reloadData()
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
