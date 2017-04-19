//
//  ViewController.swift
//  CalendarMonthWeek
//
//  Created by Saurabh Yadav on 19/04/17.
//  Copyright © 2017 Adglobal360 India Pvt Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var monthCollectionView: UICollectionView!
    @IBOutlet weak var calendarContainerView: UIView!
    
    @IBOutlet weak var presentedMonthLabel: UILabel!
    
    var dates = [DateStruct]()
    var globalDate = Date()
    var totalWeeks = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.monthCollectionView.delegate = self
        self.monthCollectionView.dataSource = self
        self.monthCollectionView.layer.borderWidth = 0.5
        self.monthCollectionView.layer.borderColor = UIColor.darkGray.cgColor

        self.getCurrentMonthCalendar(monthToAdd: 0)
    }
    
    func getCurrentMonthCalendar(monthToAdd : Int){
        globalDate = globalDate.dateByAddingMonths(monthToAdd)!
        print(globalDate.startOfMonth()?.startOfWeek ?? "no date")

        let firstWeekDay = globalDate.firstWeekDay()
        let (currentLastDate, previousLastDate) = globalDate.current_previousEndOfMonth()!
        
        let datesModel = MonthDateModel.init(startDay: firstWeekDay!, endDate: currentLastDate!, previousMonthLastDate : previousLastDate!)
        self.dates = datesModel.dates
        self.totalWeeks = datesModel.totalWeeks
        for i in self.dates{
            print(i.date, i.weekDay, i.current, i.previous_next)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        dateFormatter.timeZone = NSTimeZone.local
        
        let monthYearString = dateFormatter.string(from: globalDate)
        self.presentedMonthLabel.text = monthYearString

        let range = Range(uncheckedBounds: (0, monthCollectionView.numberOfSections))
        let indexSet = IndexSet(integersIn: range)
        monthCollectionView.reloadSections(indexSet)

        
//        self.monthCollectionView.reloadData()
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCell", for: indexPath) as? MonthCell
        cell?.layer.borderColor = UIColor.darkGray.cgColor
        cell?.layer.borderWidth = 0.5
        let object = self.dates[indexPath.row]
        
        cell?.dateLabel.text = "\(object.date)"
        if object.current == false {
            cell?.dateLabel.textColor = UIColor.gray
            cell?.leftCountLabel.isHidden = true
            cell?.rightCountLabel.isHidden = true
        } else{
            cell?.dateLabel.textColor = UIColor.black
            cell?.leftCountLabel.isHidden = false
            cell?.rightCountLabel.isHidden = false
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dates.count
    }
    
    @IBAction func showPreviousMonth(_ sender: Any) {
        getCurrentMonthCalendar(monthToAdd : -1)
    }
    
    @IBAction func showNextMonth(_ sender: Any) {
        getCurrentMonthCalendar(monthToAdd : 1)
    }
    

}

extension ViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.calendarContainerView.frame.size.width/7, height: ((self.calendarContainerView.frame.size.height - 65) / CGFloat(self.totalWeeks + 1)))
    }

}
