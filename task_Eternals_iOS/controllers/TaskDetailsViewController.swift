//
//  TaskDetailsViewController.swift
//  task_Eternals_iOS
//
//  Created by Sai Snehitha Bhatta on 19/01/22.
//

import CoreData
import UIKit

class TaskDetailsViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var dateTextField: UITextField?
    var datePicker = UIDatePicker()
    let toolBar = UIToolbar()
    let dateFormatter1 = DateFormatter()
    let date = Date()
    var searchController: UISearchController!
    
    var index: Int = 0
    var categoryName3: String!
    var taskName3: String!
    var status3: String!
    var description3: String!
    var currentDate3: String!
    var dueDate3: String!
    var image3: UIImage!
    var details:[NSManagedObject] = []
    /// audio??
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBOutlet weak var categoryNameLb: UILabel!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dueDateLb: UILabel!
    @IBOutlet weak var startDateLb: UILabel!
    @IBOutlet weak var descriptionLb: UILabel!
    @IBOutlet weak var statusLb: UILabel!
    @IBOutlet weak var taskNameLb: UILabel!
    @IBOutlet weak var statusBtnLB: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        audioSlider.isHidden = true
        categoryNameLb.text = categoryName3
        taskNameLb.text = taskName3
        statusLb.text = status3
        descriptionLb.text = description3
        startDateLb.text = currentDate3
        dueDateLb.text = dueDate3
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Task")
          fetchRequest.predicate = NSPredicate(format: "taskName = %@", taskName3)
        do {
            let results = try managedContext.fetch(fetchRequest)
            let objectUpdate = results[0] as! NSManagedObject
            if let imagedata = objectUpdate.value(forKey: "image") as? Data{
            imageView.image = UIImage(data: imagedata)
            }
        }catch {
            print(error.localizedDescription)
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnAudio(_ sender: UIButton) {
        let alert = UIAlertController(title: "select input", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "audio recording", style: .default, handler: { _ in
            self.handleAudioRecording()
            
            
        }))
        alert.addAction(UIAlertAction(title: "audio files", style: .default, handler: { _ in
            self.handleAudioFiles()
        }))
        self.present(alert, animated:  true, completion: nil)
    }
    @IBAction func btnCamera(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select Input", message: "", preferredStyle:  .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera roll", style: .default, handler: { UIAlertAction in
self.handleCameraRoll()}))
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.handleCamera()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func statusClicked(_ sender: UIButton) {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Task")
                  fetchRequest.predicate = NSPredicate(format: "taskName = %@", taskName3)
                do {
                    let results =
                        try managedContext.fetch(fetchRequest)
                    let objectUpdate = results[0] as! NSManagedObject
                    objectUpdate.setValue("Completed", forKey: "status")
                    do {
                        try managedContext.save()
                        
                        statusLb.text = "Completed"
                    
                    } catch
                    let error as NSError {
                        print(error)
                    }
                } catch
                let error as NSError {
                    print(error)
                }
        sender.isEnabled = false
        
    }
    
    
    @IBAction func editTaskBtn(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Task", message: "Edit Task details", preferredStyle: .alert)
                
                //adding text field
                alert.addTextField { field in
                    //field.placeholder = "Category name"
                    field.returnKeyType = .continue
                    field.keyboardType = .emailAddress
                    field.text = self.categoryName3
                }
                alert.addTextField { field in
                    //field.placeholder = "Category name"
                    field.returnKeyType = .continue
                    field.keyboardType = .emailAddress
                    field.text = self.taskName3
                }
                alert.addTextField { field in
                    //field.placeholder = "Category name"
                    field.returnKeyType = .continue
                    field.keyboardType = .emailAddress
                    field.text = self.description3
                }
              alert.addTextField(configurationHandler: dateTextField)

                
                //adding two buttons to alert
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [self] _ in
                    // read the textfields from alert box
                    guard let fields = alert.textFields, fields.count == 4 else{
                        return
                    }
                    let catName = fields[0]
                    guard let cName = catName.text, !cName.isEmpty  else{
                        return
                    }
                    let taskName = fields[1]
                    guard let tName = taskName.text, !tName.isEmpty  else{
                        return
                    }
                    let description = fields[2]
                    guard let desc = description.text, !desc.isEmpty  else{
                        return
                    }
                    let dueDate = fields[3]
                    guard let endDate = dueDate.text else{
                        return
                    }

                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Task")
                      fetchRequest.predicate = NSPredicate(format: "taskName = %@", taskName3)
                    do {
                        let results =
                            try managedContext.fetch(fetchRequest)
                        let objectUpdate = results[0] as! NSManagedObject
                        objectUpdate.setValue(cName, forKey: "categoryName")
                        objectUpdate.setValue(tName, forKey: "taskName")
                        objectUpdate.setValue(desc, forKey: "taskDescription")
                        objectUpdate.setValue(datePicker.date, forKey: "dueDate")
                        do {
                            try managedContext.save()
                            print("Record Updated!")
                            
             //   To display an alert box
                             let alertController = UIAlertController(title: "Message", message: "Task Edited!", preferredStyle: .alert)
        
                             let OKAction = UIAlertAction(title: "OK", style: .default) {
                                 (action: UIAlertAction!) in
                             }
                             alertController.addAction(OKAction)
                             self.present(alertController, animated: true, completion: nil)
                            categoryNameLb.text = cName
                            taskNameLb.text = tName
                            descriptionLb.text = desc
                            dueDateLb.text = dateFormatter1.string(from: datePicker.date)
                        
                        } catch
                            let error as NSError {print(error.localizedDescription)}
                    } catch
                        let error as NSError {print(error.localizedDescription)}
                    
                    
                }))
                self.present(alert, animated: true, completion: nil)
        
    }
    
    func dateTextField(text: UITextField!){
        dateTextField=text
        dateFormatter1.dateFormat = "dd/MM/yyyy"
        dateTextField?.text = dateFormatter1.string(from: date)
        self.createDatePicker()
        dateTextField?.inputView = self.datePicker
        dateTextField?.inputAccessoryView = self.toolBar
    }
    
    func createDatePicker(){
        //designing the datepicker
        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 0, height: 200))
        self.datePicker.backgroundColor = UIColor.lightGray
        datePicker.datePickerMode = .dateAndTime
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(TasksListViewController.doneClick))
        
        print(doneButton)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(TasksListViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.toolBar.isHidden = false

    }

    @objc func doneClick() {
        dateFormatter1.timeStyle = .none
        dateFormatter1.dateFormat = "dd/MM/yyyy"
        dateTextField?.text = dateFormatter1.string(from: datePicker.date)
        datePicker.isHidden = true
        self.toolBar.isHidden = true
    }

    @objc func cancelClick() {
        datePicker.isHidden = true
        self.toolBar.isHidden = true
    }
    

    // -MARK camera code
    func handleCameraRoll(){
        let image = UIImagePickerController()
                 image.delegate=self
             image.sourceType = UIImagePickerController.SourceType.photoLibrary
             //image.sourceType = UIImagePickerController.SourceType.camera
                 image.allowsEditing = true
                 self.present(image, animated: true)
                 {
                     
                 }
                 
             }
             func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                 if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                 {
                     imageView.contentMode = .scaleToFill
                     imageView.image=image
                     if let png = self.imageView.image?.pngData(){
                     let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Task")
                       fetchRequest.predicate = NSPredicate(format: "taskName = %@", taskName3)
                         do {
                             let results =
                                 try managedContext.fetch(fetchRequest)
                             let objectUpdate = results[0] as! NSManagedObject
                             objectUpdate.setValue(png, forKey: "image")
                             do {
                                 try managedContext.save()
                             }catch {
                                 print(error.localizedDescription)
                             }
                         } catch {
                             print(error.localizedDescription)
                         }
                     }
                 }
                 
                 self.dismiss(animated: true, completion:nil)
    }
    func handleCamera(){
        let image = UIImagePickerController()
                 image.delegate=self
             //image.sourceType = UIImagePickerController.SourceType.photoLibrary
             image.sourceType = UIImagePickerController.SourceType.camera
                 image.allowsEditing = false
                 self.present(image, animated: true)
                 {
                     
                 }
                 
             }
             func imagePickerController1(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                 if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                 {
                     imageView.contentMode = .scaleToFill
                     imageView.image=image
                     
                 }
                 
                 self.dismiss(animated: true, completion:nil)
        
    }
    func handleAudioRecording(){
        //todo
        self.performSegue(withIdentifier: "audio", sender: self)
    }
    func handleAudioFiles(){
        //todo
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
