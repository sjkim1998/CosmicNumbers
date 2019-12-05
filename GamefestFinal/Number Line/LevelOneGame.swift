//
//  LevelOneGame.swift
//  Number Line
//
//  Created by Tian Liu on 9/12/19.
//  Copyright © 2019 Tian Liu. All rights reserved.
//

import UIKit
import AVFoundation

//class ViewController: UIViewController {
class LevelOneGame: UIViewController {

    @IBOutlet weak var lineRef: Line!
    @IBOutlet weak var astronaut: UIImageView!
    @IBOutlet weak var zero: UIButton!
    @IBOutlet weak var one: UIButton!
    @IBOutlet weak var two: UIButton!
    @IBOutlet weak var three: UIButton!
    @IBOutlet weak var four: UIButton!
    @IBOutlet weak var five: UIButton!

    var desiredNumber=Int.random(in: 0...5)
    var answerClicked = false
    var player: AVAudioPlayer?
    var accessibleNumbers:[UIView]=[]
    var selectedAnswer = 0
    var howManyLevelsAreDone:Int=0
    var previousVC:UIViewController?=nil
    var answerArray: [UIButton]=[]
    var answerSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // save answer buttons into an array
        answerArray = [zero, one, two, three, four, five]
        
        // Make the screen accessible, and specify the question with a randomly chosen number from 0-5
        isAccessibilityElement = true

        // If the voiceover accessible function isn't enabled, read out the question using audio kit
//        if(!UIAccessibility.isVoiceOverRunning){
//            let utterance = AVSpeechUtterance(string: "Where is the astronaut at?")
//            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//            utterance.rate = 0.5
//            utterance.volume=5
//
//            let synthesizer = AVSpeechSynthesizer()
//            synthesizer.speak(utterance)
//        }
        
        let linerefbounds:CGRect=lineRef.bounds
        var minXOfLine = lineRef.center.x-(linerefbounds.width/2) - 30
        astronaut.frame = CGRect(x: minXOfLine + ((linerefbounds.width-40) / 5 * CGFloat(desiredNumber)),  y: lineRef.center.y, width: astronaut.frame.size.width, height: astronaut.frame.size.height)
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        if(UIAccessibility.isVoiceOverRunning){
            
        }
       // button.isSelected = true
        for answer in answerArray {
            if (answer == button) {
                answerSelected = true
                button.backgroundColor = UIColor(red:0.43, green:0.17, blue:0.56, alpha:1.0)
                button.setTitleColor(UIColor.white, for: .normal)
                button.accessibilityValue = "Selected"
                //playSound()
                if let text = button.titleLabel?.text {
                    selectedAnswer = Int(text) ?? 0
                }
            }
            else {
                answerSelected = false
                answer.backgroundColor = UIColor(red:0.90, green:0.73, blue:0.17, alpha:1.0)
                answer.setTitleColor(UIColor.black, for: .normal)
                answer.accessibilityValue = ""
            }
        }
        
//        for answer in answerArray {
//            if answerSelected && answer !== button {
//                answerSelected = false
//                answer.backgroundColor = UIColor(red:0.90, green:0.73, blue:0.17, alpha:1.0)
//                answer.setTitleColor(UIColor.black, for: .normal)
//            }
//            if answer.isSelected && answer !== button {
//                answer.isSelected = false
//                answer.backgroundColor = UIColor(red:0.90, green:0.73, blue:0.17, alpha:1.0)
//                answer.setTitleColor(UIColor.black, for: .normal)
//            }
        //}
        
        print(selectedAnswer)
        
//        for answer in answerArray {
//            if (answer.isSelected) {
//                answer.isSelected = false
//                button.backgroundColor = UIColor(red:0.90, green:0.73, blue:0.17, alpha:1.0)
//                button.setTitleColor(UIColor.black, for: .normal)
//            }
//            else if (!answer.isSelected && answer == button) {
//                answer.isSelected = true
//                button.backgroundColor = UIColor(red:0.43, green:0.17, blue:0.56, alpha:1.0)
//                button.setTitleColor(UIColor.white, for: .normal)
//                if let text = button.titleLabel?.text {
//                    selectedAnswer = Int(text) ?? 0
//                }
//            }
//        }
        
//        if (answerClicked == true) {
//            answerClicked = false
//            button.backgroundColor = UIColor(red:0.90, green:0.73, blue:0.17, alpha:1.0)
//            button.setTitleColor(UIColor.black, for: .normal)
//            playSound()
//        }
//        else {
//            answerClicked = true
//            button.backgroundColor = UIColor(red:0.43, green:0.17, blue:0.56, alpha:1.0)
//            button.setTitleColor(UIColor.white, for: .normal)
//            if let text = button.titleLabel?.text {
//                selectedAnswer = Int(text) ?? 0
//            }
//            playSound()
//        }
    }
    
    func deselectAllButtons(){
        
    }
    // Play sound when the player clicks an answer button
    func playSound() {
        guard let url = Bundle.main.url(forResource: "selected", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = player else { return }

            player.setVolume(20, fadeDuration: 0)
            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // Create number labels for the number line
    func initializeNumberTexts(){
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let distance = lineRef.distance
        let textHeight=100
        let textWidth=40
        var linerefbounds:CGRect=lineRef.bounds
        let spaceBetweenLineAndText:CGFloat=10.0
        var i = 0
        
        // Create 5 labels and make them accessible
        while (i < lineRef.numberOfPoints+1) {
            let xdist = (distance*CGFloat(i))
            var minXOfLine = lineRef.center.x-(linerefbounds.width/2)
            var maxYOfLine = lineRef.center.y+(linerefbounds.height/2)
            let label = UILabel(frame: CGRect(x: xdist+lineRef.offSetFromEdges + minXOfLine, y: maxYOfLine+spaceBetweenLineAndText, width: CGFloat(textWidth), height: CGFloat(textHeight)))

            label.isAccessibilityElement = true
            label.text = String(i)
            label.font = UIFont(name: "Arial-BoldMT", size: 50)
            label.textColor = UIColor.white;
            self.view.addSubview(label)
            label.accessibilityTraits = UIAccessibilityTraits.playsSound
            label.isUserInteractionEnabled = true
            label.accessibilityLabel = String(i)
            accessibleNumbers.append(label)
            i = i+1
        }
    }
    
    
    @IBAction func Submit(_ sender: Any) {
        if  (selectedAnswer == desiredNumber) {
            performSegue(withIdentifier: "toCongrats", sender: self)
        }
        else {
            performSegue(withIdentifier: "toTryAgain", sender: self)
        }
    }
    
    // May need for future reference
    func removePopOverView(){
    }
    
    // Based on whether the player answered the question correctly, this function will direct the player to either incorrect/correct popup window
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var tryAgainVC=segue.destination as? IncorrectPopUpViewController
        
        //If the player answered the question incorrectly, he/she needs to try the same round again
        if(tryAgainVC != nil){
            tryAgainVC?.previousOneVCNum=desiredNumber
            tryAgainVC?.previousOneSelectedNum=selectedAnswer
            tryAgainVC?.previousOne=true
            if (desiredNumber > selectedAnswer) {
                tryAgainVC?.previousGreater = true
            }
            else {
                tryAgainVC?.previousSmaller = true
            }
        }
        else{
            // If the player answered the question correctly, he/she will play the next round
            var rightVC = segue.destination as? CorrectPopUpViewController
            if (rightVC != nil){
                rightVC!.parentOneVC=self
                rightVC!.numLevelsComplete=self.howManyLevelsAreDone
            }
            else{
                print("other vc")
            }
        }
    }
}

