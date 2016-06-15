//
//  ViewController.swift
//  calculator
//
//  Created by jason yang on 16/5/22.
//  Copyright © 2016年 hanzheng yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    
    private var userInTheMiddleOfInput = false
    
    @IBAction private func typekey(sender: UIButton) {
        let digit = sender.currentTitle!
        print("this is \(digit)")
        if userInTheMiddleOfInput
        {
            display.text = display.text! + digit
        }
        else
        {
            display.text = digit
        }
        userInTheMiddleOfInput = true
    }
    
    private var displayValue : Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }

    private var brain = calculaterBrain()
    
    @IBAction private func pieButton(sender: UIButton) {
        brain.setOperation(displayValue)
        userInTheMiddleOfInput = false
        if let math = sender.currentTitle {
            brain.performaOperation(math)
            displayValue = brain.result
        }
        
        
    }
}

