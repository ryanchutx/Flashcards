//
//  ViewController.swift
//  Flashcards
//
//  Created by Ryan Chu on 2/20/21.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
}

class firstScreenViewController: UIViewController {

    // IBOutlets for various components and objects used within the storyboard
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var btnOptionOne: UIButton!
    @IBOutlet weak var btnOptionTwo: UIButton!
    @IBOutlet weak var btnOptionThree: UIButton!
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var flashcards = [Flashcard]()
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        card.layer.cornerRadius = 20.0;
        card.layer.shadowRadius = 15.0;
        card.layer.shadowOpacity = 0.15;
        frontLabel.layer.cornerRadius = 20.0;
        backLabel.layer.cornerRadius = 20.0;
        frontLabel.clipsToBounds = true;
        backLabel.clipsToBounds = true;
        btnOptionOne.layer.cornerRadius = 10;
        btnOptionOne.layer.borderWidth = 3;
        btnOptionOne.layer.borderColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        btnOptionTwo.layer.cornerRadius = 10;
        btnOptionTwo.layer.borderWidth = 3;
        btnOptionTwo.layer.borderColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        btnOptionThree.layer.cornerRadius = 10;
        btnOptionThree.layer.borderWidth = 3;
        btnOptionThree.layer.borderColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        
        readSavedFlashcards()
        
        if flashcards.count == 0 {
            updateFlashcard(question: "Where is the U.S. Capitol Located?", answer: "Washington D.C")
        } else {
            updateLabels()
            updateNextPrevButtons()
        }
        
    }

    @IBAction func didTapOptionOne(_ sender: Any) {
        btnOptionOne.isHidden = true;
    }
    
    @IBAction func didTapOptionTwo(_ sender: Any) {
        frontLabel.isHidden = true;
    }
    
    @IBAction func didTapOptionThree(_ sender: Any) {
        btnOptionThree.isHidden = true;
    }
    
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        flipFlashcard()
    }
    
    func flipFlashcard() {
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {
            if self.frontLabel.isHidden == true {
                self.frontLabel.isHidden = false;
            } else {
                self.frontLabel.isHidden = true;
            }
        })
    }
    
    func animateCardOut() {
        UIView.animate(withDuration: 0.3, animations: {self.card.transform = CGAffineTransform.identity.translatedBy(x: -300, y: 0)}, completion: {finished in
                self.updateLabels()
                self.animateCardIn()
        })
    }
    
    func animateCardIn() {
        card.transform = CGAffineTransform.identity.translatedBy(x: 300, y: 0)
        
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    func animateCardOut2() {
        UIView.animate(withDuration: 0.3, animations: {self.card.transform = CGAffineTransform.identity.translatedBy(x: 300, y: 0)}, completion: {finished in
                self.updateLabels()
                self.animateCardIn2()
        })
    }
    
    func animateCardIn2() {
        card.transform = CGAffineTransform.identity.translatedBy(x: -300, y: 0)
        
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        currentIndex = currentIndex - 1
        updateNextPrevButtons()
        animateCardOut2()
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        currentIndex = currentIndex + 1
        updateNextPrevButtons()
        animateCardOut()
    }
    
    func updateLabels() {
        let currentFlashcard = flashcards[currentIndex]
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
    }
    
    func updateFlashcard(question: String, answer: String) {
        let flashcard = Flashcard(question:question, answer:answer)
        frontLabel.text = flashcard.question
        backLabel.text = flashcard.answer
        flashcards.append(flashcard)
        print("😼 added new flashcard")
        print("😎 we now have \(flashcards.count) flashcards")
        currentIndex = flashcards.count - 1
        print("😱 our current index is \(currentIndex)")
        updateNextPrevButtons()
        updateLabels()
        saveAllFlashcardsToDisk()
    }
    
    func updateNextPrevButtons() {
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        if currentIndex == 0 {
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController = segue.destination as! UINavigationController
        
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashcardsController = self
        
    }
    
    func saveAllFlashcardsToDisk() {
        let dictionaryArray = flashcards.map{(card) -> [String: String] in return ["question": card.question, "answer": card.answer]}
        
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        print("🎉 flashcards saved to UserDefaults")
    }
    
    func readSavedFlashcards() {
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
        
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            
            flashcards.append(contentsOf: savedCards)
        }
    }
    
}

