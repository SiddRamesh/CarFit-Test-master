//
//  CalendarView.swift
//  Calendar
//
//  Test Project
//

import UIKit

protocol CalendarDelegate: class {
    func getSelectedDate(_ date: String)
}

class CalendarView: UIView {

    @IBOutlet weak var monthAndYear: UILabel!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    
    private let cellID = "DayCell"
    weak var delegate: CalendarDelegate?
    
    var weeks = 0
    var totalDaysInMonth = 0
    
    var mnth = 0
    var items = [[Date]]()
    lazy var dateFormatter: DateFormatter = {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()

    //MARK:- Initialize calendar
    private func initialize() {
        let nib = UINib(nibName: self.cellID, bundle: nil)
        self.daysCollectionView.register(nib, forCellWithReuseIdentifier: self.cellID)
        self.daysCollectionView.delegate = self
        self.daysCollectionView.dataSource = self
        
        self.setCalendar(date: Date())
//        self.daysCollectionView.reloadData()
    }
    
    //MARK:- Change month when left and right arrow button tapped
    @IBAction func arrowTapped(_ sender: UIButton) {
        
        if sender == self.leftBtn {
            self.prevMnth()
        } else {
            self.nextMnth()
        }
        self.daysCollectionView.reloadData()
    }
    
    @objc func prevMnth(){
        self.mnth -= 1
        let prevMonth = Calendar.current.date(byAdding: .month, value: self.mnth, to: Date())
        self.setCalendar(date: prevMonth!)
        
    }
    
    @objc func nextMnth(){
        self.mnth += 1
        let nextMonth = Calendar.current.date(byAdding: .month, value: self.mnth, to: Date())
        self.setCalendar(date: nextMonth!)
    }
    
    func setCalendar(date:Date) {
            let cal = Calendar.current
            let components = (cal as NSCalendar).components([.month, .day,.weekday,.year], from: date)
        if let year  =  components.year,
        let month = components.month {
        let months = self.dateFormatter.monthSymbols
            let monthSymbol = (months![month-1])
        self.monthAndYear.text = "\(monthSymbol) \(year)"

            let weekRange = (cal as NSCalendar).range(of: .weekOfMonth, in: .month, for: date)
            let dateRange = (cal as NSCalendar).range(of: .day, in: .month, for: date)
            weeks = weekRange.length
        self.totalDaysInMonth = dateRange.length

            let totalMonthList = weeks * 7
            var dates = [Date]()
        var firstDate = self.dateFormatter.date(from: "\( year)-\(month)-1")
            let componentsFromFirstDate = (cal as NSCalendar).components([.month, .day,.weekday,.year], from: firstDate ?? Date())
            firstDate = (cal as NSCalendar).date(byAdding: [.day], value: -(componentsFromFirstDate.weekday ?? 1-1), to: firstDate ?? Date(), options: [])!

            for _ in 1 ... totalMonthList {
                dates.append(firstDate ?? Date())
                firstDate = (cal as NSCalendar).date(byAdding: [.day], value: +1, to: firstDate ?? Date(), options: [])
            }
            let maxCol = 7
        let maxRow = self.weeks
        self.items.removeAll(keepingCapacity: false)
            var i = 0
    //        print("-----------------------")
            for _ in 0..<maxRow {
                var colItems = [Date]()
                for _ in 0..<maxCol {
                    colItems.append(dates[i])
                    i += 1
                }
                self.items.append(colItems)
            }
    //        print("---------------------------")
            
        }//year
   
    }
}

//MARK:- Calendar collection view delegate and datasource methods
extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.weeks
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! DayCell
        
        let d = self.items[indexPath.section][indexPath.row]
        
        cell.configureCell(date: d)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? DayCell
            cell?.isSelected(isTapped: true)
        
        delegate?.getSelectedDate(self.items[indexPath.section][indexPath.row].description)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? DayCell
        cell?.isSelected(isTapped: false)
    }
    
}

//MARK:- Add calendar to the view
extension CalendarView {
    
    public class func addCalendar(_ superView: UIView) -> CalendarView? {
        var calendarView: CalendarView?
        if calendarView == nil {
            calendarView = UINib(nibName: "CalendarView", bundle: nil).instantiate(withOwner: self, options: nil).last as? CalendarView
            guard let calenderView = calendarView else { return nil }
            calendarView?.frame = CGRect(x: 0, y: 0, width: superView.bounds.size.width, height: superView.bounds.size.height)
            superView.addSubview(calenderView)
            calenderView.initialize()
            return calenderView
        }
        return nil
    }
    
}
