

//
//  ViewController.swift
//  VocabulairesItaliens
//
//  Created by Normand Martin on 16-03-16.
//  Copyright © 2016 Normand Martin. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var numberOfCharacter: UILabel!
    @IBOutlet weak var frenchVocabulary: UILabel!
    
    @IBOutlet weak var successIndex: UILabel!
    @IBOutlet weak var hint: UILabel!
    @IBOutlet weak var goodAnswer: UILabel!
    @IBOutlet weak var italianResponse: UITextField!
  

    var truncItalianItem2: String = ""
    var frenchRandomItem: Int = 0
    var italianItem: String = ""
    var arr: NSMutableArray = []
    var newArr: NSArray = []
    var hintWords: [String] = []
    var n: Int = 0
    var diffGoodBad: Int = 0
    var indexFirstBad: Int = 0
    var indexAppend: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        chooseQuestion()
        hint.text = ""
        goodAnswer.text = ""

    }
    func chooseQuestion() {
        var indexArr: Int = 0
        indexFirstBad = 0
        
        if let plist = Plist(name: "VocabulaireItalien") {
            arr = plist.getMutablePlistFile()!
            for arrs in arr {
                let itemDetail = arrs as! [String]
                diffGoodBad = Int.init(itemDetail[2])! - Int.init(itemDetail[3])!
                let dateFormatter = NSDateFormatter()
                dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +SSSS"
                successIndex.text = String(diffGoodBad)
                if let lastDate = dateFormatter.dateFromString(itemDetail[4]){
                    let timeLaps: Double = NSDate().timeIntervalSinceDate(lastDate)
                    if diffGoodBad < 0 && timeLaps > 10800.00 && indexFirstBad == 0 {
                    
                    indexFirstBad = indexFirstBad + 1
                    indexAppend = indexArr
                    }
                }
                indexArr = indexArr + 1
            }
            if indexFirstBad == 1 {
                let itemFrench = arr[indexAppend] as! [String]
                frenchVocabulary.text = itemFrench[0]
                italianItem = itemFrench[1]
                if let italianIndex = italianItem.characters.indexOf("(") {
                    let truncItalianItem = italianItem.substringToIndex(italianIndex)
                    truncItalianItem2 = String(truncItalianItem.characters.dropLast())
                }else{
                    truncItalianItem2 = italianItem
                }

            }else{
            let nbItem = arr.count
            frenchRandomItem = Int(arc4random_uniform(UInt32(nbItem)))
            let itemFrench = arr[frenchRandomItem] as! [String]
            frenchVocabulary.text = itemFrench[0]
            italianItem = itemFrench[1]
            if let italianIndex = italianItem.characters.indexOf("(") {
                let truncItalianItem = italianItem.substringToIndex(italianIndex)
                truncItalianItem2 = String(truncItalianItem.characters.dropLast())
            }else{
                truncItalianItem2 = italianItem
            }
            }
            numberOfCharacter.text = String(truncItalianItem2.characters.count)
            italianResponse.text = ""
        } else {
            print ("Unable to get Plist")
        }
        hintWords = truncItalianItem2.componentsSeparatedByString(" ")
        hint.text = ""
    }

    
    func textFieldShouldReturn(italianResponse: UITextField) -> Bool {
        var selectedItem: [String]
        if truncItalianItem2 == italianResponse.text {
            if indexFirstBad == 1 {
                selectedItem = arr[indexAppend] as! [String]
            }else{
                selectedItem = arr[frenchRandomItem] as! [String]
            }
            let goodScore = Int.init(selectedItem[2])! + 1
            let goodScoreString = String.init(goodScore)
            selectedItem[2] = goodScoreString
            selectedItem[4] = String.init(NSDate())
            goodAnswer.text = "Buona Risposta!"
            if indexFirstBad == 1 {
                arr[indexAppend] = selectedItem
            }else{
                arr[frenchRandomItem] = selectedItem
            }
        }else{
            if indexFirstBad == 1 {
                selectedItem = arr[indexAppend] as! [String]
            }else{
                selectedItem = arr[frenchRandomItem] as! [String]
            }
            let badScore = Int.init(selectedItem[3])! + 1
            let badScoreString = String.init(badScore)
            selectedItem[3] = badScoreString
            goodAnswer.text = truncItalianItem2
            selectedItem[4] = String.init(NSDate())
            if indexFirstBad == 1 {
                arr[indexAppend] = selectedItem
            }else{
                arr[frenchRandomItem] = selectedItem
            }
        }
        
        if let plist = Plist(name: "VocabulaireItalien"){
            do {
                try plist.addValuesToPlistFile(arr)
            } catch {
                print(error)
            }
           newArr = plist.getValuesInPlistFile()!
        }else{
            print("unable to get plist")
        }

    return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func detectEditingChange(sender: UITextField) {
        let nbCharacter = italianResponse.text?.characters.count
        let nbCharacterTotal = truncItalianItem2.characters.count
        numberOfCharacter.text = String(nbCharacterTotal - nbCharacter!)
    }

    @IBAction func anotherQuestion(sender: AnyObject) {
        chooseQuestion()
        n = 0
        hint.text = ""
        goodAnswer.text = ""

    }
    
    @IBAction func hintButton() {
        let numberWords = hintWords.count
        if numberWords > 6 && n < 3 {
            let indexWord = Int(arc4random_uniform(UInt32(numberWords)))
            hint.text = hint.text! + " " + hintWords[indexWord]
            n += 1
        }
    }

    @IBAction func showResultsButton(sender: UIButton) {
        
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showResultSegue" {
            let controller = segue.destinationViewController as! ListeResultsTableViewController
            controller.newArr = newArr
            
        }
    }
}


