//
//  ViewController.swift
//  TestDatePicker
//
//  Created by 无类 on 2018/7/23.
//  Copyright © 2018年 wulei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var datePicker: DDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        datePicker.setDate(pickerMode: DDatePicker.PickerMode.yearMonthDay, minimumDate: Date(), maximumDate: Date().addingTimeInterval(365 * 24 * 3600 * 10), currentDate: nil)
        datePicker.selectedClourse = {date in
            print(date)
        }
    }


}

