//
//  StatusViewController.swift
//  TestStoryboard
//
//

import Cocoa

class StatusViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        print("!!!")
    }
    
    override func viewWillAppear() {
        self.view.window?.appearance = NSAppearance()
    }
    
}
