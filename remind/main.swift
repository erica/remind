//  Copyright © 2020 Erica Sadun. All rights reserved.

import Cocoa
import ArgumentParser

/// A type responsible for scheduling local notifications by spoofing the Finder
struct Notifier: ParsableCommand {
    
    // MARK: - Configure parsable command
    
    /// The configuration for a command.
    static let configuration = CommandConfiguration(
        commandName: "remind",
        abstract: Notifier.abstract,
        discussion: Notifier.discussion,
        shouldDisplay: true,
        helpNames: [.long]
    )
    
    // MARK: - Message
    
    /// Positional strings that make up the message to be displayed on firing the notification.
    @Argument(
        parsing: .remaining,
        help: "Notification message.")
    var message: [String]
    
    // MARK: - Delay
    
    /// A command-line option to set a delay in integer-increments of minutes.
    @Option(
        name: [.long, .short],
        default: 0,
        help: "Delay in minutes."
    )
    var minutes: Int
    
    /// A command-line option to set a delay in integer-increments of hours.
    @Option(
        name: [.long, .short],
        default: 0,
        help: "Delay in hours."
    )
    var hours: Int
    
    /// A command-line option to set a delay in integer-increments of days.
    @Option(
        name: [.long, .short],
        default: 0,
        help: "Delay in days."
    )
    var days: Int
    
    // MARK: - Time
    
    /// A command-line option to set a delay using `H:m` or `h:ma` formatting.
    @Option(
        name: [.customLong("time"), .customLong("at"), .long, .customShort("t")],
        help: "Sets time for scheduled reminder."
    )
    var when: String?
    
    
    // MARK: - Sounds
    
    /// A command-line option to override the default sound with another system library sound.
    @Option(
        default: "Glass",
        help: .hidden // "Sets notification sound."
    )
    var sound: String
    
    /// A command-line flag for listing the available sounds in /System/Library/Sounds
    @Flag(name: [.customLong("sounds")],
          help: .hidden) // "Lists available sounds then quits."
    var listSounds: Bool
    
    // MARK: - Report
    
    /// A command-line flag for listing any user notifications scheduled for Finder
    @Flag(name: [.long, .short],
        help: "Lists scheduled notifications then quits.")
    var list: Bool
    
    // MARK: - Clean
    
    /// A command-line flag for bulk-removing user notifications scheduled for Finder
    @Flag(
        name: [.customLong("clean"), .customShort("x")],
        help: .hidden) // "Removes utility-scheduled notifications from  center then quits."
    var removeScheduled: Bool

    // MARK: - Main
       
    func run() throws {
        
        // Throw help on calls to `remind` without arguments
        guard
            CommandLine.argc > 1
            else { throw CleanExit.helpRequest() }
     
        // Be evil but effective
        Bundle.swizzle()
        
        // Act and dash
        guard !removeScheduled else { Self.removeNotifications(); return }
        guard !list else { Self.listNotifications(); return }
        let sounds = try FileManager.default
            .contentsOfDirectory(atPath: "/System/Library/Sounds")
            .map({ ($0 as NSString).deletingPathExtension })
        guard !listSounds else { print(sounds.joined(separator: ", ")); return }

        // Sounds can use any capitalization. Glass is default.
        let adjustedSound = sound.capitalized
        if !sounds.contains(adjustedSound) {
            print("Replacing unknown sound with default.")
        }
        
        let note = NSUserNotification()
        note.title = "Reminder"
        note.soundName = sounds.contains(adjustedSound) ? adjustedSound : "Glass"
        note.subtitle = message.joined(separator: " ")

        note.deliveryDate = try Date.dateWith(d: days, h: hours, minutes: minutes, format: when)
        let formatter = DateFormatter()
        (formatter.dateStyle, formatter.timeStyle) = (.short, .short)
        formatter.locale = Locale.current
        if let deliveryDate = note.deliveryDate {
            let dateString = formatter.string(from: deliveryDate)
            print("Scheduling note for \(dateString).")
        }
        
        let center = NSUserNotificationCenter.default
        center.scheduleNotification(note)
        Notifier.waitThenQuit()
    }
}


// MARK: - Main

// Note: see SE-0281 @main: Type-Based Program Entry Points
//   https://github.com/apple/swift-evolution/blob/master/proposals/0281-main-attribute.md
Notifier.main()
