//
//  StatusViewController.swift
//  TestStoryboard
//
//  Created by 김수민 on 2023/04/25.
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
