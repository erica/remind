//  Copyright © 2020 Erica Sadun. All rights reserved.

import Foundation
import Darwin

extension Notifier {
    
    /// Waits for a synchronous task to execute before quitting with a success (0) status
    static func waitThenQuit() {
        let dT = DispatchTime(uptimeNanoseconds: DispatchTime.now().rawValue + 1 * NSEC_PER_SEC)
        DispatchQueue.global(qos: .background)
            .asyncAfter(deadline: dT) {
                Darwin.exit(0)
        }
        dispatchMain()
    }

    /// Lists all future "Finder" notifications currently scheduled with the default `NSUserNotificationCenter` to stdout.
    static func listNotifications() {
        let center = NSUserNotificationCenter.default
        let scheduled = center.scheduledNotifications.sorted {
            if let d0 = $0.deliveryDate, let d1 = $1.deliveryDate {
                return d0.compare(d1) == .orderedAscending
            }
            return false // this shouldn't happen
        }
       
        guard scheduled.count > 0 else {
            print("No scheduled notifications.")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.autoupdatingCurrent
        (dateFormatter.dateStyle, dateFormatter.timeStyle) = (.short, .short)

        let dayOfWeekFormatter = DateFormatter()
        dayOfWeekFormatter.locale = Locale.autoupdatingCurrent
        dayOfWeekFormatter.dateFormat = "E"
        
        for notification in scheduled {
            if let date = notification.deliveryDate {
                let dayOfWeekString = dayOfWeekFormatter.string(from: date)
                let dateString = dateFormatter.string(from: date)
                let noteString = notification.subtitle ?? "No message"
                print("\(dayOfWeekString) \(dateString): \(noteString)")
            }
        }
        
        Notifier.waitThenQuit()
    }
    
    
    /// Removes all "Finder" notifications currently scheduled with the default `NSUserNotificationCenter`.
    static func removeNotifications() {
        let center = NSUserNotificationCenter.default
        guard !center.scheduledNotifications.isEmpty else {
            print("No scheduled notifications.")
            return
        }
        for notification in center.scheduledNotifications {
            center.removeScheduledNotification(notification)
        }
        print("Removed all scheduled notifications.")
    }
}
