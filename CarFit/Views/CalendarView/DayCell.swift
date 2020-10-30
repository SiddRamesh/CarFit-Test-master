//
//  DayCell.swift
//  Calendar
//
//  Test Project
//

import UIKit

class DayCell: UICollectionViewCell {

    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var weekday: UILabel!
    
    var date: Date?
    
    var strDate = Date()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dayView.layer.cornerRadius = self.dayView.frame.width / 2.0
        self.dayView.backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        // invoke superclass implementation
        super.prepareForReuse()
        self.dayView.backgroundColor = .clear
    }
    
    func configureCell(date: Date){
        self.strDate = date
        let cal = Calendar.current
        let components = (cal as NSCalendar).components([.day], from: date)
        let day = components.day!

        self.day.text = "\(String(describing: day))"
        self.weekday.text = loadDayName(forDate: date)
    }
    
    func loadDayName(forDate: Date) -> String {
        let calendar = Calendar.current
        let myComponents = (calendar as NSCalendar).components([.weekday], from: forDate)
        let weekDay = myComponents.weekday
        switch weekDay {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tues"
        case 4:
            return "Wed"
        case 5:
            return "Thur"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default:
            return "Holiday"
        }
    }
    
    func isSelected(isTapped:Bool){
        
        self.dayView.backgroundColor = isTapped == true ? UIColor.init(white: 0.5, alpha: 0.5) : .clear
    }
    
}
