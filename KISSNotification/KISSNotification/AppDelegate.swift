//
//  AppDelegate.swift
//  KISSNotification
//
//  Created by Seth on 2015-10-09.
//  Copyright © 2015 DrabWeb. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // The rectangular notification stuff
    // The main window that holds all the notification stuff
    @IBOutlet weak var window: NotificationWindow!
    
    // The image view for the notification
    @IBOutlet weak var notificationImage: NSImageView!
    
    // The text field for the header of the notification
    @IBOutlet weak var notificationHeader: NSTextField!
    
    // The text field for the info text field in the notification
    @IBOutlet weak var notificationInfo: NSTextField!
    
    // The visual effect view for the background of the notification
    @IBOutlet weak var notificationEffectView: NSVisualEffectView!
    
    // The square notification stuff
    // The main window that holds all the notification stuff
    @IBOutlet weak var squareWindow: NotificationWindow!
    
    // The image view for the notification
    @IBOutlet weak var squareNotificationImage: NSImageView!
    
    // The text field for the header of the notification
    @IBOutlet weak var squareNotificationHeader: NSTextField!
    
    // The text field for the info text field in the notification
    @IBOutlet weak var squareNotificationInfo: NSTextField!
    
    // The visual effect view for the background of the notification
    @IBOutlet weak var squareNotificationEffectView: NSVisualEffectView!
    
    // The visual effect view for the background of the text in the square notification window
    @IBOutlet weak var squareNotificationTextEffectView: NSVisualEffectView!
    
    // Is the window square?
    var windowSquare : Bool = false;
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        // Load the text of the /tmp/ file that says what the notification should be
        let location = "/tmp/kissnotification";
        let fileContent = try! String(contentsOfFile: location, encoding: NSUTF8StringEncoding);
        print(fileContent);
        
        // Split the file contents on every new line
        // Line 1 == Image
        // Line 2 == Header
        // Line 3 == Info
        // Line 4 == Duration
        // Line 5 == Sound
        // Line 6 == Corner
        // Line 7 == Square (true/false)
        let notificationSettings : [NSString] = fileContent.characters.split{$0 == "\n"}.map(String.init);
        print(notificationSettings.count);
        
        // Set up the window
        setup();
        
        // Show the notification
        let notifImage : NSImage = NSImage(byReferencingURL: NSURL(fileURLWithPath: notificationSettings[0] as String));
        let notifHeader : NSString = notificationSettings[1];
        let notifInfo : NSString = notificationSettings[2];
        let notifDuration : UInt32 = UInt32(notificationSettings[3].integerValue);
        var notifSound : NSSound = NSSound();
        let notifCorner : UInt32 = UInt32(notificationSettings[5].integerValue);
        var notifSquare : Bool = false;
        
        // See if the dialog should be square
        if(notificationSettings[6] == "false") {
            notifSquare = false;
        }
        else {
            notifSquare = true;
        }
        
        // Load the sound
        if(notificationSettings[4] != "none") {
            notifSound = NSSound(contentsOfURL: NSURL(fileURLWithPath: notificationSettings[4] as String), byReference: false)!;
        }
        
        sendNotification(notifImage, header: notifHeader, infoText: notifInfo, duration: notifDuration, sound: notifSound, corner: notifCorner, square: notifSquare);
    }
    
    func setup() {
        // Set up the rectangular window
        // Set the window opacity to zero
        window.alphaValue = 0;
        
        // Shadow fixing...
        window.orderFrontRegardless();
        
        // Hide the window
        window.close();
        
        // Set the effect material
        notificationEffectView.material = NSVisualEffectMaterial.Dark;
        
        // Set the style mask
        window.styleMask = NSTitledWindowMask | NSFullSizeContentViewWindowMask | NSClosableWindowMask;
        
        // Hide the titlebar
        window.standardWindowButton(NSWindowButton.CloseButton)?.superview?.superview?.removeFromSuperview();
        
        // Ignore mouse events
        window.ignoresMouseEvents = true;
        
        // Set the background color to clear
        window.backgroundColor = NSColor.clearColor();
        
        // Allow the window to be transparent
        window.opaque = false;
        
        // Set the level so it floats above all others
        window.level = 100;
        
        // Hide the window again
        window.close();
        
        // Setup the square window
        // Set the window opacity to zero
        squareWindow.alphaValue = 0;
        
        // Shadow fixing...
        squareWindow.orderFrontRegardless();
        
        // Hide the window
        squareWindow.close();
        
        // Set the effect material
        squareNotificationEffectView.material = NSVisualEffectMaterial.Dark;
        
        // Set the text effect view to do in window and be light
        squareNotificationTextEffectView.wantsLayer = true;
        squareNotificationTextEffectView.material = NSVisualEffectMaterial.Dark;
        
        // Set the style mask
        squareWindow.styleMask = NSTitledWindowMask | NSFullSizeContentViewWindowMask | NSClosableWindowMask;
        
        // Hide the titlebar
        squareWindow.standardWindowButton(NSWindowButton.CloseButton)?.superview?.superview?.removeFromSuperview();
        
        // Ignore mouse events
        squareWindow.ignoresMouseEvents = true;
        
        // Set the background color to clear
        squareWindow.backgroundColor = NSColor.clearColor();
        
        // Allow the window to be transparent
        squareWindow.opaque = false;
        
        // Set the level so it floats above all others
        squareWindow.level = 100;
        
        // Hide the window again
        squareWindow.close();
    }
    
    func sendNotification(image : NSImage, header : NSString, infoText : NSString, duration : UInt32, sound : NSSound, corner : UInt32, square : Bool) {
        // Create the variable for the notification window rect
        var rect : NSRect = NSRect();
        
        // If we are showing the square window...
        if(square) {
            // Say that we are doing a square notification
            windowSquare = true;
            
            // Check what corner it should be in
            // 1 == Top Left
            // 2 == Top Right
            // 3 == Bottom Left
            // 4 == Bottom Right
            if(corner == 1) {
                rect = NSRect(x: 22, y: ((NSScreen.mainScreen()?.frame.height)! - 22) - squareWindow.frame.height, width: squareWindow.frame.width, height: squareWindow.frame.height);
            }
            else if(corner == 2) {
                rect = NSRect(x: ((NSScreen.mainScreen()?.frame.width)! - 22) - squareWindow.frame.width, y: ((NSScreen.mainScreen()?.frame.height)! - 22) - squareWindow.frame.height, width: squareWindow.frame.width, height: squareWindow.frame.height);
            }
            else if(corner == 3) {
                rect = NSRect(x: 22, y: 22, width: squareWindow.frame.width, height: squareWindow.frame.height);
            }
            else if(corner == 4) {
                rect = NSRect(x: ((NSScreen.mainScreen()?.frame.width)! - 22) - squareWindow.frame.width, y: 22, width: squareWindow.frame.width, height: squareWindow.frame.height);
            }
            
            // Set the window frame so it is in the proper corner
            squareWindow.setFrame(rect, display: false);
            
            // Set the image
            squareNotificationImage.image = image;
            
            // Set the header
            squareNotificationHeader.stringValue = String(header);
            
            // Set the info
            squareNotificationInfo.stringValue = String(infoText);
            
            // Bring forward the window
            squareWindow.orderFrontRegardless();
            
            // Play the sound
            sound.play();
            
            // Fade in the window
            squareWindow.animator().alphaValue = 1;
        }
        // If its rectangular...
        else {
            // Say that we are not doing a square notification
            windowSquare = true;
            
            // Check what corner it should be in
            // 1 == Top Left
            // 2 == Top Right
            // 3 == Bottom Left
            // 4 == Bottom Right
            if(corner == 1) {
                rect = NSRect(x: 22, y: ((NSScreen.mainScreen()?.frame.height)! - 22) - window.frame.height, width: window.frame.width, height: window.frame.height);
            }
            else if(corner == 2) {
                rect = NSRect(x: ((NSScreen.mainScreen()?.frame.width)! - 22) - window.frame.width, y: ((NSScreen.mainScreen()?.frame.height)! - 22) - window.frame.height, width: window.frame.width, height: window.frame.height);
            }
            else if(corner == 3) {
                rect = NSRect(x: 22, y: 22, width: window.frame.width, height: window.frame.height);
            }
            else if(corner == 4) {
                rect = NSRect(x: ((NSScreen.mainScreen()?.frame.width)! - 22) - window.frame.width, y: 22, width: window.frame.width, height: window.frame.height);
            }
            
            // Set the window frame so it is in the proper corner
            window.setFrame(rect, display: false);
            
            // Set the image
            notificationImage.image = image;
            
            // Set the header
            notificationHeader.stringValue = String(header);
            
            // Set the info
            notificationInfo.stringValue = String(infoText);
            
            // Bring forward the window
            window.orderFrontRegardless();
            
            // Play the sound
            sound.play();
            
            // Fade in the window
            window.animator().alphaValue = 1;
        }
        
        
        // Set the timer
        var alarm = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(duration), target:self, selector: Selector("closeNotificationWindow"), userInfo: nil, repeats:false);
    }
    
    func closeNotificationWindow() {
        // If we showed a square window...
        if(windowSquare) {
            // Fade out the square window
            squareWindow.animator().alphaValue = 0;
            window.animator().alphaValue = 0;
        }
        // If not...
        else {
            // Fade out the rectangular window
            window.animator().alphaValue = 0;
        }
        
        var alarm = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1), target:self, selector: Selector("quitSelf"), userInfo: nil, repeats:false);
    }
    
    func quitSelf() {
        // Quit the app
        NSApplication.sharedApplication().terminate(self);
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    
}

