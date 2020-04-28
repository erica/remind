//  Copyright © 2020 Erica Sadun. All rights reserved.

import Foundation

/// Errors encountered while running this command
enum RuntimeError: String, Error {
    // Time string could not be converted to date
    case timeStringError = "Failed to convert time string"
   
    /// Time components cannot be adjusted
    case timeAdjustError = "Failed to adjust time."
    
}

