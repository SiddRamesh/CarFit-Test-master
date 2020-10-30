//
//  ViewController.swift
//  Calendar
//
//  Test Project
//

import UIKit

class HomeViewController: UIViewController, AlertDisplayer {

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var calendarView: UIView!
    @IBOutlet weak var calendar: UIView!
    @IBOutlet weak var calendarButton: UIBarButtonItem!
    @IBOutlet weak var workOrderTableView: UITableView!
    
    @IBOutlet var tableHeightConstraint :NSLayoutConstraint!
    
    private let cellID = "HomeTableViewCell"
    
    var response : Response?
    var owners : [Owner]? = [Owner]()
    var filterOwner : [Owner]? = [Owner]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCalendar()
    }
    
    var zeroHeightConstraint: NSLayoutConstraint?
    var animationRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData(file: "carfit")
        self.setupUI()
        
        self.zeroHeightConstraint = calendarView.heightAnchor.constraint(equalToConstant: 0)
        
        self.workOrderTableView.addTapGesture {
            if self.animationRunning { return }
            self.animateView(isCollapse: true)
        }
    }
    
    func animateView(isCollapse: Bool) {
        self.zeroHeightConstraint?.isActive = isCollapse

        self.animationRunning = true
        self.tableHeightConstraint.constant =  isCollapse == true ? 0 : 112

        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.animationRunning = false
        })
    }
    
    @objc func refreshData(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.filterOwner?.removeAll()
            self.workOrderTableView.endRefreshing()
        }
        
    }
    
    func loadData(file:String){
        
        guard let url = Bundle.main.path(forResource: file, ofType: "json") else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: URL(fileURLWithPath: url)) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode(Response.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        
        print("Resp:",loaded.code)
        self.response = loaded
        self.owners = loaded.data
        self.workOrderTableView.reloadData()
        
    }
    
    //MARK:- Add calender to view
    private func addCalendar() {
        if let calendar = CalendarView.addCalendar(self.calendar) {
            calendar.delegate = self
        }
    }
    
    //MARK:- UI setups
    private func setupUI() {
        self.navBar.transparentNavigationBar()
        let nib = UINib(nibName: self.cellID, bundle: nil)
        self.workOrderTableView.register(nib, forCellReuseIdentifier: self.cellID)
        self.workOrderTableView.rowHeight = UITableView.automaticDimension
        self.workOrderTableView.estimatedRowHeight = 170
        self.workOrderTableView.addRefreshControll(actionTarget: self, action: #selector(refreshData))
        self.navBar.topItem?.title = "Today"
    }
    
    //MARK:- Show calendar when tapped, Hide the calendar when tapped outside the calendar view
    @IBAction func calendarTapped(_ sender: UIBarButtonItem) {
        if self.animationRunning { return }
        self.animateView(isCollapse: false)
    }
    
}


//MARK:- Tableview delegate and datasource methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let f = self.filterOwner, f.isEmpty == false {
            return f.count
        } else {
            return self.owners?.count ?? 0
        }
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! HomeTableViewCell
        
        if let f = self.filterOwner, f.isEmpty == false {
            let fo = f[indexPath.row]
            cell.setup(owner: fo)
            
        } else {
            if let o = self.owners?[indexPath.row] {
                cell.setup(owner: o)
            }
        }
    
        return cell
    }
    
}

//MARK:- Get selected calendar date
extension HomeViewController: CalendarDelegate {
    
    func getSelectedDate(_ date: String) {
        
        if let l : String = getDate(str: date) {
//        print(l as Any)
        
        if let o = self.owners {
            self.filterOwner = o.filter({$0.startTimeUTC.contains(l)})
        }
        
        self.navBar.topItem?.title = Date().description.contains(l) ? "Today" : l
        self.workOrderTableView.reloadData()
            
        }
    }
    
    func getDate(str: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd hh:mm:ss Z"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        dateFormatter.timeZone = TimeZone.current
        
        if let date = dateFormatter.date(from: str) {
        dateFormatter.dateFormat =  "yyyy-MM-dd"
                        
        let l = dateFormatter.string(from: date)
            return l
        }
        return nil
    }
    
}
