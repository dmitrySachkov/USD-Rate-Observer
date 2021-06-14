//
//  Notification.swift
//  USD Rate Observer
//
//  Created by Dmitry Sachkov on 15.06.2021.
//

import Foundation
import UserNotifications

class Notification {
    
    static let shared = Notification()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func getNotificationRequestAuthrization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .alert]) { (granted, error) in
            guard granted else { return }
            self.notificationCenter.getNotificationSettings { settings in
                guard settings.authorizationStatus == .authorized else { return }
            }
        }
    }
    
    func notificationRequest() {
        
        let contenc = UNMutableNotificationContent()
        contenc.title = "Have changes"
        contenc.body = "The USD rate have change"
        contenc.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(identifier: "notification", content: contenc, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            print(error.debugDescription)
        }
    }
    
    func checkRate() {
        let checkpoint = "70.005"
        var ratePoint = ""
        for i in DayRateParserXML.shared.currencyRateArray {
            if i.charCode == "USD" {
                ratePoint = i.value
                print(ratePoint)
            }
        }
        if  ratePoint > checkpoint {
            Notification.shared.notificationRequest()
        }
    }
    
}
