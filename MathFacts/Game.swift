//
//  Game.swift
//  MathFacts
//
//  Created by Jeff on 3/30/16.
//  Copyright © 2016 GeoTech. All rights reserved.
//

import Foundation

class mfGame {
    
    var difficulty: Int
    var operation: String
    var mfProblemSet: [mfProblem]
    var activeProblem: Int?
    
    init(d: Int, op: String) {
        
        if d > 0 && d < 100 {
            self.difficulty = d
        }
        else {
            self.difficulty = 10
        }
        
        self.operation = op
        
        self.mfProblemSet = []
        
        for x in 0...difficulty {
            for y in 0...x {
                if arc4random() % 2 == 1 {
                    self.mfProblemSet.append(mfProblem(value1: x, value2: y, op: self.operation))
                }
                else {
                    self.mfProblemSet.append(mfProblem(value1: y, value2: x, op: self.operation))
                }
            }
        }
        
        nextProblem()
    }
    
    
    
    class mfProblem {
        
        var result: Int; var n1: Int; var n2: Int
        var asked: Bool; var right: Bool
        
        init(value1: Int, value2: Int, op: String) {
            
            asked = false
            right = false
            
            if op == "-" {
                result = value1
                n2 = value2
                n1 = result + n2
            }
            else if op == "X" {
                n1 = value1
                n2 = value2
                result = n1 * n2
            }
            else {       // defult to + if invalid value is sent
                n1 = value1
                n2 = value2
                result = n1 + n2
            }
        }
        
        func checkAnswer(answer: Int) -> Bool {
            if(result == answer) {
                self.asked = true
                self.right = true
                return true
            }
            else {
                self.asked = true
                self.right = false
                return false
            }
            
        }
    }
    
    
    func nextProblem() -> Int? {
        if remaining() > 0 {
            let range = mfProblemSet.count
            var value = Int(arc4random_uniform(UInt32(range)))
            
            while (mfProblemSet[value].asked == true) {
                value = Int(arc4random_uniform(UInt32(range)))
            }
            self.activeProblem = value
            return value
        }
        self.activeProblem = nil
        return nil
    }
    
    
    func currentResult() -> Int? {
        if let x = activeProblem {
            return mfProblemSet[x].result
        }
        else {
            return nil
        }
    }
    
    func currentN1() -> Int? {
        if let x = activeProblem {
            return mfProblemSet[x].n1
        }
        else {
            return nil
        }
    }

    func currentN2() -> Int? {
        if let x = activeProblem {
            return mfProblemSet[x].n2
        }
        else {
            return nil
        }
    }

    func currentAsked() -> Bool? {
        if let x = activeProblem {
            return mfProblemSet[x].asked
        }
        else {
            return nil
        }
    }

    func currentRight() -> Bool? {
        if let x = activeProblem {
            return mfProblemSet[x].right
        }
        else {
            return nil
        }
    }

    func currentOperation() -> String {
        return self.operation
    }
    
    
    func remaining() -> Int {
        var counter: Int = 0
        for problem in mfProblemSet {
            if problem.asked == false {
                counter += 1
            }
        }
        return counter
    }
    
    func totalRight() -> Int {
        var counter: Int = 0
        for problem in mfProblemSet {
            if problem.right == true {
                counter += 1
            }
        }
        return counter
    }

    func totalAsked() -> Int {
        var counter: Int = 0
        for problem in mfProblemSet {
            if problem.asked == true {
                counter += 1
            }
        }
        return counter
    }
    
    func checkAnswer(answer: Int) -> Bool? {
        if let p = activeProblem {
            return mfProblemSet[p].checkAnswer(answer)
        }
        else {
            return nil
        }
    }
}

