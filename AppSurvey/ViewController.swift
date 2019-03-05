//
//  ViewController.swift
//  AppSurvey
//
//  Created by Admin on 5/3/2562 BE.
//  Copyright © 2562 Admin. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    var db: OpaquePointer?
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var product: UITextField!
    @IBOutlet weak var datetimes: UITextField!
     var datePickerView:UIDatePicker!
    var name: String = "0";
    
    @IBAction func likebtn(_ sender: UIButton) {
        name = "3";
    }
    @IBAction func nomalbtn(_ sender: UIButton) {
        name = "2";
    }
    
    @IBAction func badbtn(_ sender: UIButton) {
        name = "1";
    }
    
    @IBAction func additem(_ sender: UIButton) {
        let locations = location.text! as NSString
        let products = product.text! as NSString
        let datetimess = datetimes.text! as NSString
        
        //validating that values are not empty
        //        if(name?.isEmpty)!{
        //            nametext.layer.borderColor = UIColor.red.cgColor
        //            return
        //        }
        
        //        if(lastname?.isEmpty)!{
        //            lasttext.layer.borderColor = UIColor.red.cgColor
        //            return
        //        }
        //
        //creating a statement
        var stmt: OpaquePointer?
        
        //the insert query
        let queryString = "INSERT INTO Surveydatas (dates, location,product,likes) VALUES (?,?,?,?)"
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, datetimess.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        
        if sqlite3_bind_text(stmt, 2, locations.utf8String, -2, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 3, products.utf8String, -3, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 4, name, -4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }
        
        //emptying the textfields
        location.text=""
        product.text=""
        datetimes.text=""
        
        print("Herro saved successfully")
        

        
    }
    @IBAction func showDatePicker(_ sender: UITextField) {
        
        datePickerView = UIDatePicker()
        sender.inputView = datePickerView
        let toolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        toolBar.barStyle = UIBarStyle.default
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // ใช้เป็น space ตรงกลางเพื่อผลักให้ปุ่ม Done ไปชิดด้านขวา
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        
        toolBar.items = [cancelButton, flexibleSpace, doneButton]
        sender.inputAccessoryView = toolBar
    }
    @objc func cancelTapped(sender:UIBarButtonItem!) {
        datetimes.resignFirstResponder()
    }
    
    @objc func doneTapped(sender:UIBarButtonItem!) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "th")
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd")
        datetimes.text = dateFormatter.string(from: datePickerView.date) //หยิบค่าวันที่ไปใส่ใน UITextField
        datetimes.resignFirstResponder() //สุดท้ายแล้วเราจะหุบ UIDatePicker ลงไปนะ
        //โคตรจ๊าบ
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("appdata.sqlite")
        
        //opening the database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        //creating table
if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Surveydatas (id INTEGER PRIMARY KEY AUTOINCREMENT, dates TEXT, location TEXT, product TEXT, likes TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
       
    }

    


}

