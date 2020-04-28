//  Copyright © 2020 Erica Sadun. All rights reserved.

import Cocoa

// Impersonate Finder from the command line

extension Bundle {
    /// The posed identifier.
    @objc
    public var __bundleIdentifier: NSString {
        return "com.apple.finder"
    }
    
    /// Exchanges bundle identifiers to impersonate an app
    static func swizzle() {
        // This method is sufficiently evil that I won't apologize for the force-unwraps. Sue me.
        method_exchangeImplementations(
            class_getInstanceMethod(Bundle.classForCoder(),
                                    #selector(getter:bundleIdentifier))!,
            class_getInstanceMethod(Bundle.classForCoder(),
                                    #selector(getter:__bundleIdentifier))!
        )
    }
}
