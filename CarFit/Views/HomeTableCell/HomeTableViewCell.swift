//
//  HomeTableViewCell.swift
//  Calendar
//
//  Test Project
//

import UIKit
import CoreLocation

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var customer: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var tasks: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var timeRequired: UILabel!
    @IBOutlet weak var distance: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 10.0
        self.statusView.layer.cornerRadius = self.status.frame.height / 2.0
        self.statusView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    func setup(owner:Owner){
        
        var tasks = [String]()
        for i in owner.tasks {
            tasks.append(i.title)
        }
        
        self.tasks.text = tasks.joined(separator: ", ")
        
        self.customer.text = owner.houseOwnerFirstName + " " + owner.houseOwnerLastName
        
        self.status.text = owner.visitState
        
        switch owner.visitState {
        case "ToDo":
            self.statusView.backgroundColor = UIColor.todoOption
        case "InProgress":
            self.statusView.backgroundColor = UIColor.inProgressOption
        case "Done":
            self.statusView.backgroundColor = UIColor.doneOption
        case "Rejected":
            self.statusView.backgroundColor = UIColor.rejectedOption
        default:
            print("def")
        }
        
        if let e = owner.expectedTime {
            self.arrivalTime.text = owner.startTimeUTC.fromUTCToLocalTime() + " / " + e
        } else {
            self.arrivalTime.text = owner.startTimeUTC.fromUTCToLocalTime()
        }
        
        self.destination.text = owner.houseOwnerAddress + ", " + owner.houseOwnerZip + ", " + owner.houseOwnerCity
        
        var t = 0
        for i in owner.tasks {
            t += i.timesInMinutes
        }
        
        self.timeRequired.text = t.description + "min"
        
        // Here v need to add destination Latittude and longitude
//        typealias destinationCoordinate = (lat:Double, long:Double)
        let dlat = 55.778860
        let dLong = 12.521280
        
        let d = calculateDistance(mobileLocationX: owner.houseOwnerLatitude, mobileLocationY: owner.houseOwnerLongitude, DestinationX: dlat, DestinationY: dLong)
        
        self.distance.text = d.description + "Km"
        
        
    }
    
    func calculateDistance(mobileLocationX:Double,mobileLocationY:Double,DestinationX:Double,DestinationY:Double) -> Double {

        //My Source
        let coordinate₀ = CLLocation(latitude: mobileLocationX, longitude: mobileLocationY)
        
        //My Destination
        let coordinate₁ = CLLocation(latitude: DestinationX, longitude:  DestinationY)

        //Finding my distance to my next destination (in km)
        let distanceInMeters = coordinate₀.distance(from: coordinate₁) / 1000

        return distanceInMeters.rounded()
    }

}
