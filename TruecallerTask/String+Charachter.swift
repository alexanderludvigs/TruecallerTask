//
//  String+Charachter.swift
//  TruecallerTask
//
//  Created by Alexander on 11/12/2018.
//  Copyright © 2018 alexanderludvigs. All rights reserved.
//

import Foundation

extension String {
    
    /// Pass index where the first charachter
    /// is 0, so if you want 10th you need
    /// to pass the number 9, if index is
    /// out of range nil is returned
    func charachterAt(index: Int) -> Character? {
        guard (0 ..< self.count).contains(index) else { return nil }
        return self[self.index(self.startIndex, offsetBy: index)]
    }
    
    func tenthCharachter() -> Character? {
        return self.charachterAt(index: 9)
    }
    
    /// Returns a tuple with a list of charachters
    /// and a string representing containing 10th,
    /// 20th, etc.. charachter in the string
    func every10thCharachter() -> ([Character], String) {
        // Start at 10th index
        var indexCounter = 9
        var arrayToReturn: [Character] = []
        var stringToReturn: String = ""
        // Loop through the string until the bounds is reached
        while indexCounter <= self.count {
            if let char = self.charachterAt(index: indexCounter) {
                arrayToReturn.append(char)
                stringToReturn.append("\(indexCounter+1)th:\(char) ")
            }
            indexCounter += 10
        }
        return (arrayToReturn, stringToReturn)
    }
    
    /// Separates the string by whitespaces and
    /// ";" and count occurence of every word.
    /// Returns a dictionary where each
    /// entry is a word and a count
    func wordCount() -> Dictionary<String, Int> {
        let words: [String] = self.components(separatedBy: [" ", ";"])
        var wordDictionary: Dictionary<String, Int> = [:]
        for word in words {
            if let count = wordDictionary[word] {
                wordDictionary[word] = count + 1
            } else {
                wordDictionary[word] = 1
            }
        }
        return wordDictionary
    }
}
