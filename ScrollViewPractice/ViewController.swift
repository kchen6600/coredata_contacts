//
//  ViewController.swift
//  ScrollViewPractice
//
//  Created by Karen Chen on 6/11/20.
//  Copyright © 2020 Karen Chen. All rights reserved.
//

import UIKit
import ContactsUI
import CoreData

class ViewController: UIViewController,CNContactPickerDelegate {

    
    @IBOutlet weak var number1: UILabel!
    
    @IBOutlet weak var number2: UILabel!
    
    @IBOutlet weak var number3: UILabel!
    
    var one = false
    var two = false
    var three = false
    
    @IBAction func oneTapped(_ sender: Any) {
        //these true false statements are to indicate which button has been tapped (which contact you're updating)
        one = true
        two = false
        three = false
        show()
       
    }
    
    @IBAction func twoTapped(_ sender: Any) {
        one = false
        two = true
        three = false
        show()
    }
    
    @IBAction func threeTapped(_ sender: Any) {
        one = false
        two = false
        three = true
        show()
    }
    
    
    func show() {
        let contacVC = CNContactPickerViewController()
        contacVC.delegate = self
        self.present(contacVC, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact)  {
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            
            let numbers = contact.phoneNumbers.first
            print((numbers?.value)?.stringValue ?? "")
            let labelInfo = "Contact No. \((numbers?.value)?.stringValue ?? "")"
            
            
            //if one has been tapped, add a contact 1 entity .. if two, contact 2, else if it is three, contact 3 in the CORE DATA
            if one {
                //creates an entity
                let number = Contact1(entity: Contact1.entity(), insertInto: context)
                //updates the phone number attribute of the entity
                number.phone = labelInfo
                number1.text = labelInfo
            }
                
            else if two {
                let number = Contact2(entity: Contact2.entity(), insertInto: context)
                number.phone = labelInfo
                number2.text = labelInfo
            }
            else {
                let number = Contact3(entity: Contact3.entity(), insertInto: context)
                number.phone = labelInfo
                number3.text = labelInfo
            }
            try? context.save()
        }
        
    }
    
        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
            self.dismiss(animated: true, completion: nil)
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            
            // this gets a list of all the contacts someone as ever chosen for 1,2, or 3
            let contact1 = try? context.fetch(Contact1.fetchRequest()) as? [Contact1]
            let contact2 = try? context.fetch(Contact2.fetchRequest()) as? [Contact2]
            let contact3 = try? context.fetch(Contact3.fetchRequest()) as? [Contact3]
            
            //this checks to make sure that list isn't empty
            if (contact1!.count != 0 && contact2!.count != 0 && contact3!.count != 0) {
            //these get the most recent additions to the lists
            let phone1 = contact1?[(contact1!.count) - 1].phone
            let phone2 = contact2?[(contact2!.count) - 1].phone
            let phone3 = contact2?[(contact3!.count) - 1].phone
                
//            print(phone1)
//            print(phone2)
//            print(phone3)
                
            number1.text = phone1
            number2.text = phone2
            number3.text = phone3
            }
        }
        // Do any additional setup after loading the view.
    }

}

