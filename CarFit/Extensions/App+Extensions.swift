//
//  App+Extensions.swift
//  Calendar
//
//Test Project

import UIKit

//MARK:- Navigation bar clear
extension UINavigationBar {
    
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
    
}

extension UIView {

    func addTapGesture(action : @escaping ()->Void ){
        let tap = MyTapGestureRecognizer(target: self , action: #selector(self.handleTap(_:)))
        tap.action = action
        tap.numberOfTapsRequired = 1

        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true

    }
    @objc func handleTap(_ sender: MyTapGestureRecognizer) {
        sender.action!()
    }
}

class MyTapGestureRecognizer: UITapGestureRecognizer {
    var action : (()->Void)? = nil
}

extension String {
    
    func fromUTCToLocalTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        var formattedString = self.replacingOccurrences(of: "Z", with: "")
        if let lowerBound = formattedString.range(of: ".")?.lowerBound {
            formattedString = "\(formattedString[..<lowerBound])"
        }
        
//        dateFormatter.timeZone = TimeZone.current
        guard let date = dateFormatter.date(from: formattedString) else {
            return self
        }
        
        dateFormatter.dateFormat = "h:mm a" //imp
//        print("UTC Time:",date.description)
        let localTime = dateFormatter.string(from: date)
//        print("Local Time:",localTime)
        
        return localTime.description //localTime
    }
    
    func strToDate() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat =  "yyyy-MM-dd hh:mm:ss Z"
        dateFormatter.timeZone = TimeZone.current
        guard let date = dateFormatter.date(from: self) else {
            return self
        }
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        let l = dateFormatter.string(from: date)
        
        return l
    }
    
    func fromUTCToLocalDate() -> String {
            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd" //imp
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" //"yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            var formattedString = self.replacingOccurrences(of: "Z", with: "")
            if let lowerBound = formattedString.range(of: ".")?.lowerBound {
                formattedString = "\(formattedString[..<lowerBound])"
            }
            
            guard let date = dateFormatter.date(from: self) else {
                return self
            }
            
//            let date = dateFormatter.date(from: self)
//            let d = dateFormatter.string(from: date)
//            let d = dateFormatter.date(from: formattedString)
    //        print("Local Time:",localTime)
        
            
        return date.description
        }
    
}
