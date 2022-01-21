//
//  ViewController.swift
//  task_Eternals_iOS
//
//  Created by Sravan Sriramoju on 2022-01-12.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    
    //var categories = ["Books", "Groceries", "Shopping-List", "Movies"]
    var categories:[String] = []
    var details:[NSManagedObject] = []
    
    @IBOutlet weak var categoryTv: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTv.delegate=self
        categoryTv.dataSource=self
        showCategories()
        categoryTv.reloadData()
    }
    
    @IBAction func addCategory() {
        showAlert()
    }
    
   
    func showAlert(){
        let alert = UIAlertController(title: "Alert!", message: "Please enter the Category Name", preferredStyle: .alert)
        
        //adding text field
        alert.addTextField { field in
            field.placeholder = "Category name"
            field.returnKeyType = .continue
            field.keyboardType = .emailAddress
        }
        
        //adding two buttons to alert
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { [self] _ in
            // read the textfields from alert box
            guard let fields = alert.textFields, fields.count == 1 else{
                return
            }
            let catName = fields[0]
            guard let name = catName.text, !name.isEmpty else{
                return
            }
            //self.categories.append(name)
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{ return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName:"Categories", in:managedContext)!
            let record = NSManagedObject(entity:entity, insertInto:managedContext)
            record.setValue(name, forKey:"categoryName")
            
            do {
                try managedContext.save()
                details.append(record)
                print("Category Added!")
                //To display an alert box
                let alertController = UIAlertController(title: "Message", message: "New Category Added!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) {
                    (action: UIAlertAction!) in
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            } catch
            let error as NSError {
                print("Could not save. \(error),\(error.userInfo)")
            }
            
            categoryTv.reloadData()
        }))
        present(alert, animated: true)
    }
    
    func showCategories(){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
        return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest < NSManagedObject > (entityName: "Categories")
        do {
            details =
            try managedContext.fetch(fetchRequest)
        } catch
        let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
}
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "taskslist" {
//            if let indexPath = sender as? IndexPath {
//                let destVC = segue.destination as! TasksListViewController
//                let new = String(details[indexPath.row].value(forKey: "categoryName"))
//                destVC.categoryName = new
//            }
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "taskslist"{
            let destination = segue.destination as! TasksListViewController
            let selectedRow = categoryTv.indexPathForSelectedRow!.row
            let cat = details[selectedRow]
            destination.categoryName = String(describing: cat.value(forKey: "categoryName") ?? "-")
        }
    }
    }
    
  

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let cat = details[indexPath.row]
//       if let vc=storyboard?.instantiateViewController(withIdentifier: "taskslist") as? TasksListViewController{
//            vc.categoryName = String(describing: cat.value(forKey: "categoryName"))
//            self.navigationController?.pushViewController(vc, animated: true)
//       }
        self.performSegue(withIdentifier: "taskslist", sender: self)
    }
}

extension ViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cat = details[indexPath.row]
        let cell = categoryTv.dequeueReusableCell(withIdentifier: "categories", for: indexPath)
        //cell.textLabel?.text = categories[indexPath.row]
        cell.textLabel?.text = String(describing: cat.value(forKey: "categoryName") ?? "-")
        return cell
    }
    
}

