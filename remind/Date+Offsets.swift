//  Copyright © 2020 Erica Sadun. All rights reserved.

import Foundation

extension Date {
    
    /// Returns a reminder date from a string formatted either hour-24:minute or hour:minute-meridian.
    ///
    /// This method constructs a date from an hour and minute representation.
    /// The date is calculated from "now", moving to midnight and adding the hour and minute components.
    /// If the new date is earlier than "now", it's pushed forward 24 hours, producing the first possible
    /// instance of that hour/minute time in the future.
    ///
    /// - Parameter string: a string formatted either as "h:ma" or "H:m"
    /// - Throws: `RuntimeError`s when unable to parse the input string.
    /// - Returns: A new date, initialized to the offset of the date either today or tomorrow.
    static func date(from string: String) throws -> Date {

        // Establish partial date from string or throw. The string
        // provides hour and minute offsets from midnight.
        let dateFormatter = DateFormatter()
        var date: Date?
        for format in ["h:ma", "ha", "H:m", "HH", "Hm", "HHmm"] {
            dateFormatter.dateFormat = format
            if let parsed = dateFormatter.date(from: string) {
                date = parsed
                break
            }
        }        
        guard let componentDate = date
            else { throw RuntimeError.timeStringError }
                
        // Construct YMD components from now
        let calendar = Calendar.autoupdatingCurrent
        let now = Date()
        let year = calendar.component(.year, from: now)
        let month = calendar.component(.month, from: now)
        let day = calendar.component(.day, from: now)
        
        // Construct HM components from constructed date
        let hour = calendar.component(.hour, from: componentDate)
        let minute = calendar.component(.minute, from: componentDate)
        
        // Combine
        guard let adjustedDate = calendar.date(from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minute))
            else { throw RuntimeError.timeAdjustError }

        // If ascending (the new date is in the future), done. Return the target date
        if Date().compare(adjustedDate) == .orderedAscending {
            return adjustedDate
        }
        
        // Push forward one day to the _next_ instance of this time in a way
        // that will not horrify Dave DeLong
        let components = calendar.dateComponents([.hour, .minute], from: adjustedDate)
        guard let newDateDay = calendar.nextDate(after: Date(), matching: components, matchingPolicy: .strict, direction: .forward)
            else { throw RuntimeError.timeAdjustError }
        return newDateDay
    }

    
    /// Creates a new date for reminder scheduling.
    ///
    /// - Parameters:
    ///   - days: the number of days from now
    ///   - hours: the number of hours from now
    ///   - minutes: the number of minutes from now
    ///   - when: a string describing an hour:minute offset relative to the start of today (when present, overrides d/m/h)
    /// - Throws: `RuntimeError`s when encountering data misconfigurations
    /// - Returns: A new date that represents the time a reminder should be scheduled
    static func dateWith(d days: Int, h hours: Int, minutes: Int, format when: String?) throws -> Date {
        let calendar = NSCalendar.autoupdatingCurrent
        var date = Date()
        date = calendar.date(byAdding: .minute, value: minutes, to: date) ?? date
        date = calendar.date(byAdding: .hour, value: hours, to: date) ?? date
        date = calendar.date(byAdding: .day, value: days, to: date) ?? date

        // Handle "when" formatting, replacing/ignoring date offsets
        if let when = when { date = try self.date(from: when) }
        return date
    }
}
