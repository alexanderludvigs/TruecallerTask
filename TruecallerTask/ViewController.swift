//
//  ViewController.swift
//  TruecallerTask
//
//  Created by Alexander on 10/12/2018.
//  Copyright © 2018 alexanderludvigs. All rights reserved.
//

import UIKit
import Foundation

fileprivate let trucallerURL = URL(string: "http://www.truecaller.com")!
fileprivate let noCharachterText = "No charachter found"

class ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var tenthCharTextView: UITextView!
    @IBOutlet weak var wordCountLabel: UILabel!
    @IBOutlet weak var wordCountTextField: UITextField!
    @IBOutlet weak var every10thCharachterTextView: UITextView!
    
    var enteredWord: String?
    
    /// Truecaller website content
    var content: String? {
        didSet {
            guard let content = content else { return }
            
            // 1)
            var tenthCharText = noCharachterText
            if let tenthChar: Character = content.tenthCharachter() {
                tenthCharText = "\(tenthChar)"
            }
            
            // 2)
            let every10thCharachterText: String = content.every10thCharachter().1
            
            // 3)
            let dictionary: Dictionary<String, Int> = content.wordCount()
            var countText = "Word count: "
            
            // If user entered a word into the textField
            // we present the count of the entered word
            if let enteredWord = enteredWord {
                if let count = dictionary[enteredWord] {
                    countText = "Word count: \(count)"

                } else {
                    countText = "Word count: 0"
                }
            }
            
            DispatchQueue.main.async {
                self.tenthCharTextView.text = tenthCharText
                self.every10thCharachterTextView.text = every10thCharachterText
                self.wordCountLabel.text = countText
            }
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Helpers
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // Store word input if not empty
        if let text = wordCountTextField.text, !text.isEmpty {
            enteredWord = text
        }
        
        // First, we create a group to synchronize our tasks
        let group = DispatchGroup()
        
        // Web as string from each function
        var contentArray = [String?]()
        
        // The 'enter' method increments the group's task count…
        group.enter()
        request1 { content in
            contentArray.append(content)
            group.leave()
        }
        
        group.enter()
        request2 { content in
            contentArray.append(content)
            group.leave()
        }
        
        group.enter()
        request3 { content in
            contentArray.append(content)
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            // Since we only have one datasource
            // truecaller web we just pick the
            // first string in the array
            if let first = contentArray.first {
                self?.content = first
            }
        }
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Failed to fetch content", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
    
}

// MARK: - Network

extension ViewController {
    
    // Note:
    // the function request1(), request2() &
    // request3() call the fetchContentWith()
    
    func request1(_ completion: @escaping (String?) -> Void) {
        fetchContentWith(trucallerURL) { (result) in
            completion(result)
        }
    }
    
    func request2(_ completion: @escaping (String?) -> Void) {
        fetchContentWith(trucallerURL) { (result) in
            completion(result)
        }
    }
    
    func request3(_ completion: @escaping (String?) -> Void) {
        fetchContentWith(trucallerURL) { (result) in
            completion(result)
        }
    }
    
    func fetchContentWith(_ url: URL, completion: @escaping (String?) -> Void) {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.timeoutInterval = 5.0
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // Error
            guard error == nil else {
                debugPrint("got error = \(error!)")
                completion(nil)
                return
            }
            
            // Cast response to HTTPURLResponse to get status code
            guard let response = response as? HTTPURLResponse else {
                completion(nil)
                return
            }
            
            let statusCode = response.statusCode
            if (200 ... 299).contains(statusCode) == false {
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            // Success since we reached here
            
            // Cast data to String
            let stringToReturn = String(decoding: data, as: UTF8.self)

            completion(stringToReturn)
        }
        task.resume()
    }
    
}
