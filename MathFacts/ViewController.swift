//
//  ViewController.swift
//  MathFacts
//
//  Created by Jeff on 12/19/15.
//  Copyright © 2015 GeoTech. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    class LogItem: NSManagedObject {
        @NSManaged var score: Double
    }
    
    
    var highScore = [NSManagedObject]()
    var timer = NSTimer()
    var time: Int = 0
    var totalTime: Float = 10.0
    var timeRemaining: Float = 0
    var game = mfGame(d: 1, op: "+")
    
    //Display Problem
    @IBOutlet weak var value1: UILabel!
    @IBOutlet weak var value2: UILabel!
    @IBOutlet weak var displayOperation: UILabel!

    //Game Setup
    @IBOutlet weak var operationSegment: UISegmentedControl!
    @IBOutlet weak var diffSlider: UISlider!
    @IBOutlet weak var labelDifficulty: UILabel!
   
    @IBAction func changeSlider(sender: UISlider) {
        labelDifficulty.text = String(Int(sender.value))
    }
    
    //keyboard Press
    @IBAction func key1(sender: AnyObject) {pressNumber(1)}
    @IBAction func key2(sender: AnyObject) {pressNumber(2)}
    @IBAction func key3(sender: AnyObject) {pressNumber(3)}
    @IBAction func key4(sender: AnyObject) {pressNumber(4)}
    @IBAction func key5(sender: AnyObject) {pressNumber(5)}
    @IBAction func key6(sender: AnyObject) {pressNumber(6)}
    @IBAction func key7(sender: AnyObject) {pressNumber(7)}
    @IBAction func key8(sender: AnyObject) {pressNumber(8)}
    @IBAction func key9(sender: AnyObject) {pressNumber(9)}
    @IBAction func key0(sender: AnyObject) {pressNumber(0)}
    @IBAction func keyC(sender: AnyObject) {pressClear()}
    
    func pressNumber(number: Int) {
        if let currentValue = answerText.text {
            answerText.text = currentValue + String(number)
        }
        else {
            answerText.text = String(number)
        }
    }
    
    func pressClear() {
        answerText.text = ""
    }
    
    //Display time and score
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    //Get Answers
    @IBOutlet weak var answerText: UILabel!
    @IBOutlet weak var btnAnswer: UIButton!
    
   //Start Game
    @IBAction func btnStart(sender: AnyObject) {
        btnAnswer.enabled = true
        scoreLabel.text = "0"
        timerLabel.text = "0:00"
        pressClear()
        
        if let op = operationSegment.titleForSegmentAtIndex(operationSegment.selectedSegmentIndex) {
            if let difficulty = Int(labelDifficulty.text!) {
            game = mfGame(d: difficulty, op: op)
            }
            else {
                game = mfGame(d: 10, op: "+")
                print("error:  could not get difficulty")
            }
        }
        else {
            game = mfGame(d: 10, op: "+")
            print("error:  could not get operation")
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        time = 0
        
        newProblem()
    }
    
    // Create and display new problem
    func newProblem() {
        
        if game.nextProblem() != nil {
            value1.text = String(game.currentN1()!)
            value2.text = String(game.currentN2()!)
            displayOperation.text = game.currentOperation()
        }
        else {
            endGame()
        }
    }
    
    
    @IBAction func btnAnswer(sender: AnyObject) {
        if let answer = Int(answerText.text!) {
            game.checkAnswer(answer)
        }
        scoreLabel.text = String(game.totalRight()) + " right out of " + String(game.totalAsked()) + ". "
        
        if game.remaining() != 0 {
                scoreLabel.text = scoreLabel.text! + String(game.remaining()) + " to go."
        }
        else {
                scoreLabel.text = scoreLabel.text! + String(Int(100.0 * Double(game.totalRight()) / Double(game.totalAsked()))) + "% Correct."
        }
        newProblem()
        pressClear()
    }

    // called every second to update time and timer bar
    func updateTimer() {
        time += 1
        let minutes = Int(time / 60)
        let seconds = time % 60
        timerLabel.text = String(format: "%d:%02d", minutes, seconds)
    }
    
    //called when timer = 0 to freeze game
    func endGame(){
        timer.invalidate()
        btnAnswer.enabled = false
        let score = Float(Float(time) / Float(game.totalRight()))
        timerLabel.text = timerLabel.text! + String(format: ".   %.02f seconds per answer.", score)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnAnswer.enabled = false
        diffSlider.enabled = true
        
        // Print it to the console
        print("context:")
        print(managedObjectContext)
        
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

