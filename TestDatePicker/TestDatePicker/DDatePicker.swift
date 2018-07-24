//
//  DYearMonthPicker.swift
//  WuLeiEdu
//
//  Created by 无类 on 2018/7/24.
//  Copyright © 2018年 wulei. All rights reserved.
//

import UIKit

class DDatePicker: UIView {
    
    enum PickerMode {
        case yearMonthDay
        case yearMonth
    }
    
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
        
        if let currDate = currentDate {
            selectDate(date: currDate, animation: false)
        }else {
            pickerView.reloadAllComponents()
        }
    }
    
    init(minimumDate: Date, maximumDate: Date, currentDate: Date?) {
        super.init(frame: CGRect.zero)
        
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.currentDate = currentDate
        
        setupDate()
        pickerView.reloadAllComponents()
    }
    
    // pirvate init
    
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
        
        initSet()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pickerView.frame = bounds
    }
}

extension DDatePicker {
    
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
                    // 包含当前月
                    monthUpperBound = calendar.component(Calendar.Component.month, from: maximumDate!) + 1
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
            dataSource_yearmonth_year.removeAll()
            dataSource_yearmonth_month.removeAll()
            
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
                    // 包含当前月
                    monthUpperBound = calendar.component(Calendar.Component.month, from: maximumDate!) + 1
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
                        // 包含当日
                        dayUpperBound = calendar.component(Calendar.Component.day, from: maximumDate!) + 1
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
    
    /// 滚动到某一时间
    fileprivate func selectDate(date: Date, animation: Bool) {
        
        switch pickerMode {
        case .yearMonth:
            let calendar = NSCalendar.current
            let year = calendar.component(Calendar.Component.year, from: date)
            let month = calendar.component(Calendar.Component.month, from: date)
            
            let row_year = dataSource_yearmonth_year.index(of: year.description) ?? 0
            let row_month = dataSource_yearmonth_month[row_year].index(of: month.description) ?? 0
            pickerView.reloadAllComponents()
            pickerView.selectRow(Int(row_year), inComponent: 0, animated: animation)
            pickerView.reloadAllComponents()
            pickerView.selectRow(Int(row_month), inComponent: 1, animated: animation)
        case .yearMonthDay:
            let calendar = NSCalendar.current
            let year = calendar.component(Calendar.Component.year, from: date)
            let month = calendar.component(Calendar.Component.month, from: date)
            let day = calendar.component(Calendar.Component.day, from: date)
            
            let row_year = dataSource_yearmonthDay_year.index(of: year.description) ?? 0
            let row_month = dataSource_yearmonthDay_month[row_year].index(of: month.description) ?? 0
            let row_day = dataSource_yearmonthDay_day[row_year][row_month].index(of: day.description) ?? 0
            pickerView.reloadAllComponents()
            pickerView.selectRow(Int(row_year), inComponent: 0, animated: animation)
            pickerView.reloadAllComponents()
            pickerView.selectRow(Int(row_month), inComponent: 1, animated: animation)
            pickerView.reloadAllComponents()
            pickerView.selectRow(Int(row_day), inComponent: 2, animated: animation)
        }
        
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
                let row_0 = pickerView.selectedRow(inComponent: 0)
                if dataSource_yearmonth_month.count > row_0 {
                    return dataSource_yearmonth_month[row_0].count
                }
            }
        case .yearMonthDay:
            
            if component == 0 {
                return dataSource_yearmonthDay_year.count
            }else if component == 1 {
                let row_0 = pickerView.selectedRow(inComponent: 0)
                if dataSource_yearmonthDay_month.count > row_0 {
                    return dataSource_yearmonthDay_month[row_0].count
                }
            } else if component == 2 {
                let row_0 = pickerView.selectedRow(inComponent: 0)
                let row_1 = pickerView.selectedRow(inComponent: 1)
                if dataSource_yearmonthDay_day.count > row_0 {
                    if dataSource_yearmonthDay_day[row_0].count > row_1 {
                        return dataSource_yearmonthDay_day[row_0][row_1].count
                    }
                }
            }
        }
        return 0
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
                let row_0 = pickerView.selectedRow(inComponent: 0)
                if dataSource_yearmonthDay_month.count > row_0 {
                    let value_1 = dataSource_yearmonthDay_month[row_0]
                    if value_1.count > row {
                        return value_1[row].description
                    }
                }
            } else if component == 2 {
                let row_0 = pickerView.selectedRow(inComponent: 0)
                let row_1 = pickerView.selectedRow(inComponent: 1)
                if dataSource_yearmonthDay_day.count > row_0 {
                    let value_1 = dataSource_yearmonthDay_day[row_0]
                    if value_1.count > row_1 {
                        let value_2 = value_1[row_1]
                        if value_2.count > row {
                            return value_2[row].description
                        }
                    }
                }
            }else {
                return nil
            }
        }
        return nil
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerMode {
        case .yearMonth:
            
            if component == 0 {
                pickerView.reloadComponent(1)
                let row_0 = pickerView.selectedRow(inComponent: 0)
                let row_1 = pickerView.selectedRow(inComponent: 1)
                
                // 没有该行数据了就滚动到最后一个
                if dataSource_yearmonth_month[row_0].count <= row_1 {
                    pickerView.selectRow(row_1 - 1, inComponent: 1, animated: true)
                }
                
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
            let row_0 = pickerView.selectedRow(inComponent: 0)
            let row_1 = pickerView.selectedRow(inComponent: 1)
            let row_2 = pickerView.selectedRow(inComponent: 2)
            
            if component == 0 {
                pickerView.reloadAllComponents()
                
                // 没有该行数据了就滚动到最后一个
                if dataSource_yearmonthDay_month[row_0].count <= row_1 {
                    pickerView.selectRow(row_1 - 1, inComponent: 1, animated: true)
                }
                
                // 没有该行数据了就滚动到最后一个
                if dataSource_yearmonthDay_day[row_0].count > row_1 {
                    if dataSource_yearmonthDay_day[row_0][row_1].count <= row_2 {
                        pickerView.selectRow(row_2 - 1, inComponent: 2, animated: true)
                    }
                }
                
            }else if component == 1 {
                pickerView.reloadAllComponents()
                
                // 没有该行数据了就滚动到最后一个
                if dataSource_yearmonthDay_day[row_0].count > row_1 {
                    if dataSource_yearmonthDay_day[row_0][row_1].count <= row_2 {
                        pickerView.selectRow(row_2 - 1, inComponent: 2, animated: true)
                    }
                }
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

