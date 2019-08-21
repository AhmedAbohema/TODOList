//
//  CategoryViewController.swift
//  TODOList
//
//  Created by AHMED on 8/17/19.
//  Copyright © 2019 AHMED. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {
    
 var CategoryArry = [Category]()
 let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loaddataCategory()
    }

//MARK: - TableView Datasourse methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryArry.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = CategoryArry[indexPath.row].name
        return cell
        
    }
    
    //MARK: - TableView Delegate methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "gotoitems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = CategoryArry[indexpath.row]
        }
    }
    
    
    
    
//MARK: - Data manipulation methods

    // MARK: - Save Data
    func savedata()
    {
        
        do{
            try  context.save()
        }catch {
            print("error durring Saving \(error)")
        }
        tableView.reloadData()
    }
    
    
    //MARK : - LoadData
    func loaddataCategory()
    {
         let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            CategoryArry = try context.fetch(request)
        }catch{
            print("error \(error)")
        }
        tableView.reloadData()
    }
    
    
    
    
    
    //MARK: - ADD new Category
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textfieldalert = UITextField()
        let alert = UIAlertController(title: "Add New Todeoy Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textfieldalert.text!
           
            self.CategoryArry.append(newCategory)
            self.savedata()
            self.tableView.reloadData()
            
        }
        alert.addAction(action)
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = " Create new Category"
            textfieldalert = alertTextfield
        }
        present(alert , animated: true , completion: nil)
    }
    
    
    
    
    
   
    
}
