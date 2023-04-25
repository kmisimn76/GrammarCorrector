//
//  MainView.swift
//  TestStoryboard
//
//  Created by 김수민 on 2023/04/23.
//

import Cocoa

class MainView: NSView, LoadableView {
    @IBOutlet weak var inputTextField: NSTextField!
    @IBOutlet weak var outputTextView: NSTextField!
   
    
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        _ = load(fromNIBNamed: "MainView")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    @IBAction func A(_ sender: NSButton) {
        correctGrammar(sender)
    }
    
    @IBAction func correctGrammar(_ sender: Any) {
        // Get input sentence from the text field
        let inputSentence =
        """
        Below is an instruction that describes a task, paired with an input that provides further context. Write a response that appropriately completes the request.
        
        ### Instruction:
        Correct the given sentence grammatically without modifying the content
        
        ### Input:
        """
        + "\n" + inputTextField.stringValue + "\n\n### Response:\n"
        
        // Run Dalai as a subprocess
        let task = Process()
        task.launchPath = "/Users/sumin/dalai/alpaca/main"
        task.arguments = ["--seed", "-1", "--threads", "4", "--n_predict", "200" ,"--model", "/Users/sumin/dalai/alpaca/models/7B/ggml-model-q4_0.bin", "--top_k", "40" ,"--top_p", "0.9" ,"--temp", "0.8" ,"--repeat_last_n", "64" ,"--repeat_penalty", "1.3", "-p", inputSentence]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        
        task.launch()
        task.waitUntilExit()
        
        // Read output from Dalai
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let outputString = String(data: data, encoding: .utf8)
        // Display corrected sentence in the output text view
        let output = outputString ?? "### Response:\nError: No output from Dalai"
        let answer = output.split(separator: "### Response:\n")[1]
        outputTextView.stringValue = String(answer)
    }
}
