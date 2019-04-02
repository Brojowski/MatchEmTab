//
//  ViewController.swift
//  MatchEmScene
//
//  Created by Alex Gajowski on 2/21/19.
//  Copyright © 2019 alex. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    static let GAME_TIME = 15.0
    static let MIN_WH = 50
    static let MAX_WH = 150
    static let MAX_X_POS = 300
    static let MAX_Y_POS = 600
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var possiblePointsLabel: UILabel!
    
    private var possibleScore = 0
    private var score = 0
    private var highlightedRect: PairButton? = nil
    private var timerVal = 0.0
    private weak var gameTimer: Timer?
    private weak var rectCreator: Timer?
    private var gameInProgress = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startGame()
    }
    
    // MARK - Game Logic
    
    func startGame() {
        rectCreator = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in
            self.addPair()
        })
        
        Timer.scheduledTimer(withTimeInterval: GameViewController.GAME_TIME, repeats: false, block: { _ in
            self.endGame()
        })
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.timerVal -= 1
            self.updateTimer()
        })
        
        timerVal = GameViewController.GAME_TIME
        updateTimer()
        gameInProgress = true
    }
    
    func endGame() {
        gameInProgress = false
        timerLabel.text = "Timer: 0"
        gameTimer?.invalidate()
        rectCreator?.invalidate()
    }
    
    func updateTimer() {
        timerLabel.text = "Time: \(timerVal)"
    }
    
    func updateScore() {
        scoreLabel.text = "Score: \(score)"
    }
    
    func addPair() {
        let rects = self.randRects()
        
        view.addSubview(rects.0)
        view.addSubview(rects.1)
        possibleScore += 1
        
        possiblePointsLabel.text = "Pairs: \(possibleScore)"
    }
    
    // MARK - Random Rects
    
    func rand(min: Int, max: Int) -> CGFloat {
        return CGFloat.random(in: CGFloat(integerLiteral: min)...CGFloat(integerLiteral:max))
    }
    
    func randColor() -> UIColor {
        let r = rand(min: 0, max: 1)
        let g = rand(min: 0, max: 1)
        let b = rand(min: 0, max: 1)
        let a = CGFloat(integerLiteral: 1)
        
        return UIColor.init(displayP3Red: r, green: g, blue: b, alpha: a)
    }
    
    // returns: [(x1, y1), (x2, y2)]
    func randPositions() -> [(CGFloat, CGFloat)] {
        var dims = [(CGFloat, CGFloat)]()
        
        dims.append((rand(min: 0, max: GameViewController.MAX_X_POS), rand(min: 0, max: GameViewController.MAX_Y_POS)))
        dims.append((rand(min: 0, max: GameViewController.MAX_X_POS), rand(min: 0, max: GameViewController.MAX_Y_POS)))
        
        return dims
    }
    
    func randRects() -> (PairButton, PairButton) {
        let width = rand(min: GameViewController.MIN_WH, max: GameViewController.MAX_WH)
        let height = rand(min: GameViewController.MIN_WH, max: GameViewController.MAX_WH)
        
        let p = randPositions()
        
        let frame1 = CGRect(x: p[0].0, y: p[0].1, width: width, height: height)
        let frame2 = CGRect(x: p[1].0, y: p[1].1, width: width, height: height)
        
        let button1 = PairButton(frame: frame1)
        let button2 = PairButton(frame: frame2)
        button1.paired = button2
        button2.paired = button1
        
        let color = randColor()
        button1.backgroundColor = color
        button2.backgroundColor = color
        
        button1.addTarget(self,
                          action: #selector(self.onRectanglePress(sender:)),
                          for: .touchUpInside)
        button2.addTarget(self,
                          action: #selector(self.onRectanglePress(sender:)),
                          for: .touchUpInside)
        
        return (button1, button2)
    }
    
    func unhighlight(rect: UIButton?) {
        if let toUnhighlight = rect {
            toUnhighlight.setTitle("", for: .normal)
        }
    }
    
    func highlightRect(rect: UIButton){
        rect.setTitle("😳", for: .normal)
        //rect.
    }
    
    func scoreRects(first: PairButton, second: PairButton) {
        score += 1
        first.removeFromSuperview()
        second.removeFromSuperview()
        updateScore()
    }
    
    class PairButton: UIButton {
        var paired: PairButton? = nil
    }
    
    // MARK - Click Events
    
    @objc func onRectanglePress(sender: PairButton) {
        // Prevent input if the game is over
        if !gameInProgress {
            return
        }
        
        // If this rect is pair of last one pressed,
        // then score it.
        let pairedRect = highlightedRect?.paired
        if pairedRect != nil && pairedRect == sender {
            scoreRects(first: sender, second: sender.paired!    )
        }
        else {
            unhighlight(rect: highlightedRect)
        }
        pairedRect?.setTitle("", for: .normal)
        highlightedRect = sender
        highlightRect(rect: highlightedRect!)
    }
    
    
    @IBAction func onRestartGame(_ sender: UIButton) {
        startGame()
    }
}

