//
//  AppDelegate.swift
//  TestStoryboard
//
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem: NSStatusItem?
    @IBOutlet weak var menu: NSMenu?
    @IBOutlet weak var MainMenuItem: NSMenuItem?
    //var Viewcont: StatusView?
    var popover: NSPopover!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        //let statusview = StatusView(frame: NSRect(x: 0.0, y: 0.0, width: 480.0, height: 270.0))
        let statusview = StatusViewWrap()
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 480, height: 270)
        popover.behavior = .transient
        //popover.contentViewController = StatusViewController()
        popover.contentViewController = NSHostingController(rootView: statusview)
        //popover.contentViewController?.view = Viewcont!
        self.popover = popover
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        //statusItem?.button?.title = "TestStoryboard"
        statusItem?.button?.image = NSImage(named: "ConvertIcon")!
        statusItem?.button?.action = #selector(togglePopover(_:))
        print("End Finishing launch")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    //@IBOutlet weak var popover: NSPopover?
    @IBAction func showPopover(sender: AnyObject?) {
        print("?")
    }
    @objc func togglePopover(_ sender: AnyObject?) {
        print("Execute popover")
        popover.contentViewController?.view.window?.becomeKey()
        
        //Helper.instance.setStatusString()
        if let button = self.statusItem?.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
    
    /*override func awakeFromNib() {
        super.awakeFromNib()
     
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.title = "TestStoryboard"
        if let menu = menu {
            statusItem?.menu = menu
            menu.setAccessibilityEdited(true)
        }
        if let item = MainMenuItem {
            Viewcont = StatusView(frame: NSRect(x: 0.0, y: 0.0, width: 480.0, height: 270.0))
            item.view = Viewcont
            //print(item.isAccessibilityEdited())
            item.setAccessibilityEdited(true)
        }
    }*/
    
    @IBAction func showPreferences(_ sender: Any) {
    }

    
    /*@objc func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }

    func applicationDidFinishLaunching(_ arg: Any) {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            button.title = "My App"
            button.action = #selector(showPopover(sender:))
        }
        
        let popover = NSPopover()
        let viewController = MenuBarViewController(nibName: nil, bundle: nil)
        popover.contentViewController = viewController
        popover.behavior = .transient
        self.popover = popover
    }*/

}

