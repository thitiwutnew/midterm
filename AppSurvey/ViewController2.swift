//
//  ViewController2.swift
//  AppSurvey
//
//  Created by Admin on 5/3/2562 BE.
//  Copyright © 2562 Admin. All rights reserved.
//

import UIKit
import SQLite3
class ViewController2: UIViewController {
var db: OpaquePointer?
    
    @IBOutlet weak var viewdata: UITextView!
    
    
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
        
        readValues()
    }
    func readValues(){
        viewdata.text=""
        //first empty the list of heroes
        
        
        //this is our select query
        let queryString = "SELECT * FROM Surveydatas"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            
            let datesss = String(cString: sqlite3_column_text(stmt, 1))
            viewdata.text?.append("วันที่ : \(datesss)\n")
            
            let local = String(cString: sqlite3_column_text(stmt, 2))
            viewdata.text?.append("สถานที่ : \(local)\n")
            
            let product = String(cString: sqlite3_column_text(stmt, 3))
            viewdata.text?.append("สินค้า : \(product)\n")
            
            let likesss = String(cString: sqlite3_column_text(stmt, 4))
            if(likesss=="3"){
                        viewdata.text?.append("ความพึ่งพอใจ : ชอบมาก \n")
            }
            if(likesss=="2"){
                viewdata.text?.append("ความพึ่งพอใจ : เฉยๆ \n")
            }
            if(likesss=="1"){
                viewdata.text?.append("ความพึ่งพอใจ : ไม่ชอบ \n")
            }
    
            viewdata.text?.append("=================================\n")
            //adding values to list
        }
        
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
