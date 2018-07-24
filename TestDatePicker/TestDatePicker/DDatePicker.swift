//
//  DDatePicker.swift
//  WuLeiEdu
//
//  Created by 无类 on 2018/7/12.
//  Copyright © 2018年 wulei. All rights reserved.
//

import UIKit

class DDatePicker: UIView {

    enum PickerMode {
        case yearMonthDay
        case yearMonth
    }

    // var private
    
    fileprivate var pickerView: UIPickerView!
    fileprivate var dataSource_yearmonth_year: [String] = []
    fileprivate var dataSource_yearmonth_month: [[String]] = []
    
    fileprivate var dataSource_yearmonthDay_year: [String] = []
    fileprivate var dataSource_yearmonthDay_month: [[String]] = []
    fileprivate var dataSource_yearmonthDay_day: [[[String]]] = []
    
    // public
    // tip: Date最小是公元0年
    
    var pickerMode: PickerMode = PickerMode.yearMonth
    var minimumDate: Date?
    var maximumDate: Date?
    var currentDate: Date?
    
    // 回调选择的时间（本地时区）
    var selectedClourse:((Date)->())?
    
    func setDate(pickerMode: PickerMode, minimumDate: Date, maximumDate: Date, currentDate: Date?) {
        
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.currentDate = currentDate
        self.pickerMode = pickerMode
        
        setupDate()
        pickerView.reloadAllComponents()
    }
    
    init(minimumDate: Date, maximumDate: Date, currentDate: Date?) {
        super.init(frame: CGRect.zero)
        
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.currentDate = currentDate
        
        setupDate()
        pickerView.reloadAllComponents()
    }
    
    /// 计算数据源
    fileprivate func setupDate() {
        switch pickerMode {
        case .yearMonth:
            
            let calendar = NSCalendar.current
            let year_min = calendar.component(Calendar.Component.year, from: minimumDate!)
            let year_max = calendar.component(Calendar.Component.year, from: maximumDate!)
            
            var index = 0
            // 遍历年份
            for year in year_min...year_max {
                
                dataSource_yearmonth_year.append(year.description)
                
                // 该年对应的时间
                let format = DateFormatter()
                format.dateFormat = "yyyy"
                let year_date = format.date(from: year.description)!
                // 该年有多少个月
                let year_months = calendar.range(of: .month, in: .year, for: year_date)!
                
                var monthLowerBound = year_months.lowerBound
                var monthUpperBound = year_months.upperBound
                if year == year_min {
                    monthLowerBound = calendar.component(Calendar.Component.month, from: minimumDate!)
                }else if year == year_max {
                    monthUpperBound = calendar.component(Calendar.Component.month, from: maximumDate!)
                }
                
                // 遍历月份
                var monthData: [String] = []
                for monthsIndex in monthLowerBound..<monthUpperBound {
                    
                    monthData.append(monthsIndex.description)
                }
                dataSource_yearmonth_month.append(monthData)
                
                index += 1
            }
        case .yearMonthDay:
            
            let calendar = NSCalendar.current
            let year_min = calendar.component(Calendar.Component.year, from: minimumDate!)
            let year_max = calendar.component(Calendar.Component.year, from: maximumDate!)
            
            var index = 0
            // 遍历年份
            for year in year_min...year_max {
                
                dataSource_yearmonthDay_year.append(year.description)
                
                // 该年对应的时间
                let format = DateFormatter()
                format.dateFormat = "yyyy"
                let year_date = format.date(from: year.description)!
                // 该年有多少个月
                let year_months = calendar.range(of: .month, in: .year, for: year_date)!
                
                var monthLowerBound = year_months.lowerBound
                var monthUpperBound = year_months.upperBound
                if year == year_min {
                    monthLowerBound = calendar.component(Calendar.Component.month, from: minimumDate!)
                }else if year == year_max {
                    monthUpperBound = calendar.component(Calendar.Component.month, from: maximumDate!)
                }
                
                // 遍历月份
                var monthData: [String] = []
                var monthDayData: [[String]] = []
                for monthsIndex in monthLowerBound..<monthUpperBound {
                    
                    monthData.append(monthsIndex.description)
                    
                    // 该月对应的时间
                    let format = DateFormatter()
                    format.dateFormat = "yyyy-MM"
                    let month_date = format.date(from: "\(year)-\(monthsIndex)")!
                    // 该月有多少个日
                    let year_month_days = calendar.range(of: .day, in: .month, for: month_date)!
                    
                    var dayLowerBound = year_month_days.lowerBound
                    var dayUpperBound = year_month_days.upperBound
                    let month_min = calendar.component(Calendar.Component.month, from: minimumDate!)
                    let month_max = calendar.component(Calendar.Component.month, from: maximumDate!)
                    if year == year_min, monthsIndex == month_min {
                        dayLowerBound = calendar.component(Calendar.Component.day, from: minimumDate!)
                    }else if year == year_max, monthsIndex == month_max {
                        dayUpperBound = calendar.component(Calendar.Component.day, from: maximumDate!)
                    }
                    
                    /// 遍历日份
                    var dayData: [String] = []
                    for dayIndex in dayLowerBound..<dayUpperBound {
                    
                        dayData.append(dayIndex.description)
                    }
                    
                    monthDayData.append(dayData)
                }
                dataSource_yearmonthDay_month.append(monthData)
                dataSource_yearmonthDay_day.append(monthDayData)
                
                index += 1
            }
        }
    }
    
    // init
    
    fileprivate func initSet() {
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        addSubview(pickerView)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        initSet()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        initSet()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pickerView.frame = bounds
    }
}

extension DDatePicker: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        switch pickerMode {
        case .yearMonth:
            return 2
        case .yearMonthDay:
            return 3
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerMode {
        case .yearMonth:
            
            if component == 0 {
                return dataSource_yearmonth_year.count
            }else if component == 1 {
                if dataSource_yearmonth_month.count > 0 {
                    return dataSource_yearmonth_month[pickerView.selectedRow(inComponent: 0)].count
                }else {
                    return 0
                }
            }else {
                return 0
            }
        case .yearMonthDay:
            
            if component == 0 {
                return dataSource_yearmonthDay_year.count
            }else if component == 1 {
                if dataSource_yearmonthDay_month.count > 0 {
                    return dataSource_yearmonthDay_month[pickerView.selectedRow(inComponent: 0)].count
                }else {
                    return 0
                }
            } else if component == 2 {
                if dataSource_yearmonthDay_day.count > 0 {
                    if dataSource_yearmonthDay_day[pickerView.selectedRow(inComponent: 0)].count > 0 {
                        return dataSource_yearmonthDay_day[pickerView.selectedRow(inComponent: 0)][pickerView.selectedRow(inComponent: 1)].count
                    }else {
                        return 0
                    }
                }else {
                    return 0
                }
            }else {
                return 0
            }
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerMode {
        case .yearMonth:
            
            if component == 0 {
                return dataSource_yearmonth_year[row].description
            }else if component == 1 {
                return dataSource_yearmonth_month[pickerView.selectedRow(inComponent: 0)][row].description
            }else {
                return nil
            }
        case .yearMonthDay:
            
            if component == 0 {
                return dataSource_yearmonthDay_year[row].description
            }else if component == 1 {
                return dataSource_yearmonthDay_month[pickerView.selectedRow(inComponent: 0)][row].description
            } else if component == 2 {
                return dataSource_yearmonthDay_day[pickerView.selectedRow(inComponent: 0)][pickerView.selectedRow(inComponent: 1)][row].description
            }else {
                return nil
            }
        }
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerMode {
        case .yearMonth:

            if component == 0 {
                pickerView.reloadComponent(1)
                pickerView.selectRow(0, inComponent: 1, animated: true)
            }

            let format = DateFormatter()
            format.dateFormat = "yyyy-MM"
            let year = dataSource_yearmonth_year[pickerView.selectedRow(inComponent: 0)]
            let month = dataSource_yearmonth_month[pickerView.selectedRow(inComponent: 0)][pickerView.selectedRow(inComponent: 1)]
            let date = format.date(from: year + "-" + month)!
            let timeZoneOffset = TimeZone.current.secondsFromGMT(for: date)
            let currentDate = date.addingTimeInterval(TimeInterval(timeZoneOffset))
            selectedClourse?(currentDate)

        case .yearMonthDay:

            if component == 0 {
                pickerView.reloadComponent(1)
                pickerView.selectRow(0, inComponent: 1, animated: true)
                pickerView.reloadComponent(2)
                pickerView.selectRow(0, inComponent: 2, animated: true)
            }else if component == 1 {
                pickerView.reloadComponent(2)
                pickerView.selectRow(0, inComponent: 2, animated: true)
            }
            
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            let year = dataSource_yearmonthDay_year[pickerView.selectedRow(inComponent: 0)]
            let month = dataSource_yearmonthDay_month[pickerView.selectedRow(inComponent: 0)][pickerView.selectedRow(inComponent: 1)]
             let day = dataSource_yearmonthDay_day[pickerView.selectedRow(inComponent: 0)][pickerView.selectedRow(inComponent: 1)][pickerView.selectedRow(inComponent: 2)]
            let date = format.date(from: year + "-" + month + "-" + day)!
            let timeZoneOffset = TimeZone.current.secondsFromGMT(for: date)
            let currentDate = date.addingTimeInterval(TimeInterval(timeZoneOffset))
            selectedClourse?(currentDate)
        }
        
        
    }
}







