//
//  ViewController.swift
//  COMP585Number
//
//

import UIKit
import AVFoundation

//class ViewController: UIViewController {
class LevelTwoGame: UIViewController {

    // Reference to go back to previous page
    @IBAction func ExitToStart(_ sender: Any) {
         performSegue(withIdentifier: "Submit", sender: self)
    }
    
    // Reference to the astronaut image
    @IBOutlet weak var astronaut: UIImageView!
    
    // Reference to the question label
    @IBOutlet weak var astronautPlaceLabel: UILabel!
    
    // Reference to the line
    @IBOutlet weak var lineRef: Line!
    
    var previousVC:UIViewController?=nil
    var previousVCSuccess:UIViewController?=nil
    var popOverVC:CorrectPopUpViewController?=nil
    var i = 0
    var ranges=[(CGFloat(0.0),CGFloat(0.0))]
    var desiredNumber=Int.random(in: 0...5)
    var threshold=10
    var exampleVar:Int=0
    var player: AVAudioPlayer?
    var howManyLevelsAreDone:Int=0
    var holdingAstronaut:Bool=false
    var maxWaitingTime:Int=5
    var waitingTime:Int = 5
    var mostrecentTick:UIView?=nil
    var accessibleNumbers:[UIView]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the screen accessible, and specify the question with a randomly chosen number from 0-5
        isAccessibilityElement = true 
        astronautPlaceLabel.text="Drag the astronaut to tick \(desiredNumber)" + " and click submit"
        
        // If the voiceover accessible function isn't enabled, read out the question using audio kit
        if(!UIAccessibility.isVoiceOverRunning){
            let utterance = AVSpeechUtterance(string: "Drag the astronaut to tick \(desiredNumber)" + " and click submit")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.5
            utterance.volume=5
    
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
        }
    }
    
    // Based on whether the player answered the question correctly, this function will direct the player to either incorrect/correct popup window
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var tryAgainVC=segue.destination as? IncorrectPopUpViewController
        var selectednumber = 0
        var notonNumberline = true
        let astronaut_positionX = astronaut.center.x
        let astronaut_positionY = astronaut.center.y
        var linerefbounds:CGRect=lineRef.bounds
        var minXOfLine = lineRef.center.x-(linerefbounds.width/2)
        var maxYOfLine = lineRef.center.y
        var index = 0
        // Check which number the user is on, and to notify(hint) the user that number
        while (index < 6) {
            if (astronaut_positionX >= lineRef.points[index].bounds.minX+minXOfLine-40 && astronaut_positionX < lineRef.points[index].bounds.maxX+minXOfLine+40
                && astronaut_positionY >= maxYOfLine-70 &&
                astronaut_positionY < maxYOfLine+100) {
                selectednumber = index
                notonNumberline = false
            }
            index += 1
        }
        
        // If the player answered the question incorrectly, he/she needs to try the same round again
        if(tryAgainVC != nil){
            tryAgainVC?.previousTwoVCNum=desiredNumber
            tryAgainVC?.previousTwoSelectedNum=selectednumber
            tryAgainVC?.previousTwoOnNumberLine=notonNumberline
            tryAgainVC?.previousTwo=true
        }
        else{
            // If the player answered the question correctly, he/she will play the next round
            var rightVC = segue.destination as? CorrectPopUpViewController
            if (rightVC != nil){
                rightVC!.parentTwoVC=self
                rightVC!.numLevelsComplete=self.howManyLevelsAreDone
            }
            else{
                print("other vc")
            }
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
    
    // Handle pan gesture - identify where the player drag the astronaut to
    @IBAction func handlepan(recognizer:UIPanGestureRecognizer) {
        var focusedView=UIAccessibility.focusedElement(using:
            UIAccessibility.AssistiveTechnologyIdentifier.notificationVoiceOver)
        
        let translation = recognizer.translation(in:self.view)

        if let view = recognizer.view {
            let astronaut_position = astronaut.center.x
        
            // The followings are to find intersection (while the player drag the astronaut over other objects on the screen)
            var possibleViewsToIntersect:[UIView] = []
            
            for numlabel in accessibleNumbers{
                possibleViewsToIntersect.append(numlabel)
            }
            
            let intersectingTicks:[UIView]=lineRef!.accessibleTicks.filter{$0 != view && view.frame.intersects(CGRect(x: $0.frame.minX+lineRef.frame.minX, y: $0.frame.minY+lineRef.frame.minY, width: $0.frame.width, height: $0.frame.height))}
            let intersectingNums:[UIView]=possibleViewsToIntersect.filter{$0 != view && view.frame.intersects($0.frame)}
            var intersectingViews=intersectingTicks
            
            for nums in intersectingNums{
                intersectingViews.append(nums)
            }
            
            for iView in intersectingViews{
                //print("Intersect="+(iView.accessibilityLabel ?? "NO ACCESS"))
            }
            
            if (intersectingViews.count==0){
                mostrecentTick=nil
            }
            // Make sounds when the player drag the astronaut over objects
            else if (intersectingViews.count==1){
                if (intersectingViews[0] != mostrecentTick) {
                    mostrecentTick=intersectingViews[0]
                    
                    let utterance = AVSpeechUtterance(string: intersectingViews[0].accessibilityLabel ?? "")
                    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                    utterance.rate = 0.5
                    utterance.volume=5
                    
                    let synthesizer = AVSpeechSynthesizer()
                    synthesizer.speak(utterance)
                }
                else{
                    //do nothing b/c it's the same read item
                }
            }else if (intersectingViews.count==2){
                if (intersectingViews[1] != mostrecentTick) {
                    mostrecentTick=intersectingViews[1]
                    
                    let utterance = AVSpeechUtterance(string: intersectingViews[1].accessibilityLabel ?? "")
                    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                    utterance.rate = 0.5
                    utterance.volume=5
                    
                    let synthesizer = AVSpeechSynthesizer()
                    synthesizer.speak(utterance)
                }
                else{
                    //do nothing b/c it's the same read item
                }
            }else{
                print("more than 2 intersecting items")
            }
            
            if(translation.x >= -0.1 && translation.x <= 0.1 && translation.y >= -0.1 && translation.y <= 0.1 && holdingAstronaut){
              //  print("splat")
                playSound()
                holdingAstronaut=false
                waitingTime=maxWaitingTime
            }
            else{
                if(waitingTime<0){
                    holdingAstronaut=true
                  //  print("holding")
                }
                else{
                    waitingTime-=1
                    holdingAstronaut=false
                   // print("decrement")
                }
            }
            view.center = CGPoint(x:view.center.x + translation.x, y:view.center.y + translation.y)
            
        }
        self.view.bringSubviewToFront(view)
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    // Play drop sound when the player drops the astronaut
    func playSound() {
        guard let url = Bundle.main.url(forResource: "splat", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // When the user clicks submit, the game will check where the astronaut is on. Based on that, the game will determine
    // whether the player answered the question correctly or not. There are some tolerance allowed so the player can be a
    // little bit off on the number line
    @IBAction func Submit(_ sender: Any) {
        let astronaut_positionX = astronaut.center.x
        let astronaut_positionY = astronaut.center.y
        var linerefbounds:CGRect=lineRef.bounds
        var minXOfLine = lineRef.center.x-(linerefbounds.width/2)
        var maxYOfLine = lineRef.center.y
    
        if (astronaut_positionX >= lineRef.points[desiredNumber].bounds.minX+minXOfLine-40 && astronaut_positionX < lineRef.points[desiredNumber].bounds.maxX+minXOfLine+40
            && astronaut_positionY >= maxYOfLine-70 &&
            astronaut_positionY < maxYOfLine+100) {
            performSegue(withIdentifier: "toCongrats", sender: self)
            
        }
        
        else {
            //print("astronaut is in the wrong place!")
            performSegue(withIdentifier: "toTryAgain", sender: self)
        }
        
    }
    
    // May need for future reference
    func removePopOverView(){
        //popOverVC!.view.removeFromSuperview()
        //popOverVC?.removeFromParent()
        //popOverVC?.dismiss(animated: false, completion: nil)
        
        //let vc=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "levelVC")
        //let levelvc=vc as! ViewController
        
        //initialize stuff
        //TODO
        //if we have done a certain amount of levels go back to level select
        //levelvc.howManyLevelsAreDone=self.howManyLevelsAreDone+1
        //levelvc.previousVC=self
        //levelvc.previousVCSuccess=self
        
        //self.present(levelvc, animated: true, completion: nil)
        //self.view.removeFromSuperview()
        //self.parent?.dismiss(animated: true, completion: nil)
    }
    
    // This is to check if an accessible element is focused
    override func accessibilityElementDidBecomeFocused()
    {
        print("focused")
        var focusedElement:UIView
        var accessibleTicksRef:[UIView]=lineRef.accessibleTicks
        var touchedATick:Bool=false
        for i in 0...lineRef.accessibleTicks.count{
            //check if they are focused
            if(accessibleTicksRef[i].accessibilityElementIsFocused()){
                //this is the focused element
                focusedElement=accessibleTicksRef[i]
                //MAKE LINEREF NOT ACCESSIBLE
                touchedATick=true
                focusedElement.isAccessibilityElement=false
                break
            }
        }
    }
}
