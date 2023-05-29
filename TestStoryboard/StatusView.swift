//
//  MainView.swift
//  TestStoryboard
//

import Cocoa
import SwiftUI

import Foundation

class StatusView: NSView, LoadableView {
    @IBOutlet weak var inputTextField: NSTextField!
    @IBOutlet weak var outputTextView: NSTextField!
    @IBOutlet weak var button: NSButton!
    @IBOutlet weak var selectedCB: NSComboBox!
    
    
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        _ = load(fromNIBNamed: "StatusView")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    @IBAction func A(_ sender: NSButton) {
        correctGrammar(sender)
    }
    
    @IBAction func correctGrammar(_ sender: Any) {
        // Get input sentence from the text field
        outputTextView.stringValue = "Now in Processing..."
        let selected_method = selectedCB.selectedCell()?.stringValue ?? "invalid"
        if selected_method.contains("Correct(on-device)") {
            print("on-device inference")
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
        else if selected_method.contains("Correct(on-premise)") {
            print("linux server inference")
            let inputSentence =
            """
            A given sentence that is wrong in grammarly. A correct sentence is the corrected version of a given sentence in grammarly.
            Given sentence:
            """
            + inputTextField.stringValue
            + "Correct sentence:"
            var answer = ""
            
            struct TextCompletionResponse: Decodable {
                let choices: [Choice]
            }
            struct Choice: Decodable {
                let text: String
            }
            // Create the URL and request
            if let url = URL(string: "http://172.16.165.2:8000/v1/completions") {
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                // Set the request headers if needed
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                // Add any other headers as required
                
                // Set the request body data
                let parameters = [
                    "prompt": inputSentence,
                    "stop": "\n"
                ]
                
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                } catch {
                    print("Error serializing JSON: \(error)")
                    return
                }
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print("Error: \(error)")
                        return
                    }
                    
                    if let data = data {
                        let responseString = String(data: data, encoding: .utf8)
                        print("Response: \(responseString ?? "")")
                        do {
                            let decoder = JSONDecoder()
                            let response = try decoder.decode(TextCompletionResponse.self, from: data)
                            
                            if let choice = response.choices.first {
                                let text = choice.text
                                print("Text: \(text)")
                                DispatchQueue.main.async {
                                    self.outputTextView.stringValue = text
                                }
                            }
                        } catch {
                            print("Error decoding JSON: \(error)")
                            answer = "Parsing err"
                            DispatchQueue.main.async {
                                self.outputTextView.stringValue = answer
                            }
                        }
                    }
                }
                
                task.resume()
            }
        }
        else if selected_method.contains("Chat(on-premise)") {
            print("linux server inference, Chatting bot")
            let inputSentence =
            """
            A dialog, where User interacts with AI. AI is helpful, kind, obedient, honest, and knows its own limits. User: Hello, AI. AI: Hello! How can I assist you today?
            User:
            """
            + inputTextField.stringValue
            + "AI:"
            var answer = ""
            
            struct TextCompletionResponse: Decodable {
                let choices: [Choice]
            }
            struct Choice: Decodable {
                let text: String
            }
            // Create the URL and request
            if let url = URL(string: "http://172.16.165.2:8000/v1/completions") {
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                // Set the request headers if needed
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                // Add any other headers as required
                
                // Set the request body data
                let parameters = [
                    "prompt": inputSentence,
                    "stop": "\n"
                ]
                
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                } catch {
                    print("Error serializing JSON: \(error)")
                    return
                }
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print("Error: \(error)")
                        return
                    }
                    
                    if let data = data {
                        let responseString = String(data: data, encoding: .utf8)
                        print("Response: \(responseString ?? "")")
                        do {
                            let decoder = JSONDecoder()
                            let response = try decoder.decode(TextCompletionResponse.self, from: data)
                            
                            if let choice = response.choices.first {
                                let text = choice.text
                                print("Text: \(text)")
                                DispatchQueue.main.async {
                                    self.outputTextView.stringValue = text
                                }
                            }
                        } catch {
                            print("Error decoding JSON: \(error)")
                            answer = "Parsing err"
                            DispatchQueue.main.async {
                                self.outputTextView.stringValue = answer
                            }
                        }
                    }
                }
                
                task.resume()
            }
        }
        else if selected_method.contains("Correct(OpenAI-API)") {
            print("chargpt inference")
            let answer = ""
            outputTextView.stringValue = String(answer)
        }
        else {
            print("invalid running target")
            outputTextView.stringValue = "!! Invalid running target !!"
        }
    }
    
    @IBAction func exitation(_ sender: Any) {
        NSApplication.shared.terminate(nil) // Quiting this app
    }
}


struct StatusViewWrap: NSViewRepresentable {
    func makeNSView(context: Context) -> StatusView {
        StatusView(frame: NSRect(x: 0.0, y: 0.0, width: 480.0, height: 270.0))
    }
    
    func updateNSView(_ nsView: StatusView, context: Context) {
        
    }
    
    typealias NSViewType = StatusView
    
    
}
