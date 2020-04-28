//  Copyright © 2020 Erica Sadun. All rights reserved.

import Foundation

extension Notifier {
    /// A succinct description of the utility
    static let abstract = "Command-line notifier"

    /// An extended discussion of the utility
    static let discussion = """
    Schedule reminders from the command line. "remind -m 20 Stand up and stretch",
    "remind --at 1:30P Call Bob", "remind --at 13:30 Leave for Dr visit". Any
    notifications scheduled earlier in the day (say it is now 2PM and you set a
    reminder for 11:30), are pushed forward one day.
    """
}
