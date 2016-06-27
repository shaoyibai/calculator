//
//  calculatorBrain.swift
//  calculator
//
//  Created by jason yang on 16/5/23.
//  Copyright © 2016年 hanzheng yang. All rights reserved.
//

import Foundation

class calculaterBrain
{
    
    private var accumlator = 0.0
    private var internalProgram = [AnyObject]()
    
    func setOperation(operand : Double) {
        accumlator = operand
        internalProgram.append(operand)
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E) ,
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "=" : Operation.Equals,
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "−" : Operation.BinaryOperation({ $0 - $1 })
        
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        
    }
    
    func performaOperation(symbol :String) {
        internalProgram.append(symbol)
        if let operation = operations[symbol] {
            switch operation{
            case .Constant (let value):
                accumlator = value
            case .UnaryOperation (let function):
                accumlator = function(accumlator)
            case .BinaryOperation (let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumlator)
            case .Equals :
                executePendingBinaryOperation()
        
            }
        }
        
    }
    
    private func executePendingBinaryOperation ()
    {
        if pending != nil {
            accumlator = pending!.binaryFunction(pending!.firstOperand, accumlator)
            pending = nil
        }
    }
    
    private var pending : PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction : (Double, Double) -> Double
        var firstOperand : Double
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return internalProgram
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject]{
                for op in arrayOfOps {
                    if let operand = op as? Double {
                       setOperation(operand)
                    } else if let operation = op as? String {
                        performaOperation(operation)
                    }
                }
            }
        }
    }
    
    
    func clear() {
        accumlator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    var result: Double {
        get {
            return accumlator
        }
    }
}