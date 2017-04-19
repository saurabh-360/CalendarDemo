//
//  MonthDateModel.swift
//  CalendarMonthWeek
//
//  Created by Saurabh Yadav on 19/04/17.
//  Copyright © 2017 Adglobal360 India Pvt Ltd. All rights reserved.
//

import UIKit

struct DateStruct {
    var date = 0
    var weekDay = -1
    var previous_next = false
    var current = false
}

class MonthDateModel: NSObject {

    var dates = [DateStruct]()
    var totalWeeks = 0
    convenience init(startDay : Int, endDate : Int, previousMonthLastDate : Int?) {
        self.init()

        // add previous month dates
        
        var previousMonthDate = previousMonthLastDate!
        var previousLastWeekDay = startDay-1
        while previousLastWeekDay >= 1 {
            var dateStruct = DateStruct()
            dateStruct.date = previousMonthDate
            dateStruct.weekDay = previousLastWeekDay
            dateStruct.previous_next = true
            previousLastWeekDay = previousLastWeekDay - 1
            previousMonthDate-=1
            dates.insert(dateStruct, at: 0)
        }
        var start = startDay
        // add current month
        for i in 1...endDate {
            var dateStruct = DateStruct()
            dateStruct.date = i
            dateStruct.weekDay = start
            dateStruct.current = true
            start = start + 1
            dates.append(dateStruct)
            if start > 7{
                start = start % 7
                totalWeeks+=1
            }
        }
        
        // add next month
        var nextMonthDate = 1
        var nextWeekDay = start
        while nextWeekDay <= 7 {
            var dateStruct = DateStruct()
            dateStruct.date = nextMonthDate
            dateStruct.weekDay = nextWeekDay
            dateStruct.previous_next = true
            nextWeekDay = nextWeekDay + 1
            nextMonthDate+=1
            dates.append(dateStruct)
        }
    }
}


extension Date {
    
    func startOfMonth() -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MM yyyy HH:mm:ss ZZZ"
        dateFormatter.timeZone = NSTimeZone.local
        //        (abbreviation: "GMT-5:00") as TimeZone!
        let string = dateFormatter.string(from: self)
        
        let presentDate = dateFormatter.date(from: string)
        
        let calendar = Calendar.current
        let currentDateComponents = calendar.dateComponents([.year, .month, .weekday], from: presentDate!)
        let startOfMonth = calendar.date(from: currentDateComponents)
        
        return startOfMonth
    }
    
    func firstWeekDay() -> Int? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MM yyyy HH:mm:ss ZZZ"
        dateFormatter.timeZone = NSTimeZone.local
        //        (abbreviation: "GMT-5:00") as TimeZone!
        let string = dateFormatter.string(from: self)
        
        let presentDate = dateFormatter.date(from: string)
        
        let calendar = Calendar.current
        let currentDateComponents = calendar.dateComponents([.year, .month, .weekday], from: presentDate!)
        let startOfMonth = calendar.date(from: currentDateComponents)
        let weekday = Calendar.current.component(.weekday, from: startOfMonth!)
        
        return weekday
    }
    
    
    func dateByAddingMonths(_ monthsToAdd: Int) -> Date? {
        
        let calendar = Calendar.current
        var months = DateComponents()
        months.month = monthsToAdd
        
        return calendar.date(byAdding: months, to: self)
    }
    
    func endOfMonth() -> Int? {
        
        guard let plusOneMonthDate = dateByAddingMonths(1) else { return nil }
        let calendar = Calendar.current
        let plusOneMonthDateComponents = calendar.dateComponents([.year, .month], from: plusOneMonthDate)
        let endOfMonth = calendar.date(from: plusOneMonthDateComponents)?.addingTimeInterval(-1)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        dateFormatter.timeZone = NSTimeZone.local
        
        let dayString = dateFormatter.string(from: endOfMonth!)
        return Int(dayString)
    }
    
    func current_previousEndOfMonth() -> (Int?, Int?)? {
        
        
        guard let plusOneMonthDate = dateByAddingMonths(1) else { return nil }
        let calendar = Calendar.current
        let plusOneMonthDateComponents = calendar.dateComponents([.year, .month], from: plusOneMonthDate)
        let endOfMonth = calendar.date(from: plusOneMonthDateComponents)?.addingTimeInterval(-1)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        dateFormatter.timeZone = NSTimeZone.local
        
        let dayString = dateFormatter.string(from: endOfMonth!)
        
        guard let previousplusOneMonthDate = dateByAddingMonths(0) else { return nil }
        let previousPlusOneMonthDateComponents = calendar.dateComponents([.year, .month], from: previousplusOneMonthDate)
        let previousEndOfMonth = calendar.date(from: previousPlusOneMonthDateComponents)?.addingTimeInterval(-1)
        
        let previousDayString = dateFormatter.string(from: previousEndOfMonth!)
        return (Int(dayString), Int(previousDayString))
    }
    
    struct Gregorian {
        static let calendar = Calendar(identifier: .gregorian)
    }
    
    var startOfWeek: Date? {
        return Gregorian.calendar.date(from: Gregorian.calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
    }
    
}
