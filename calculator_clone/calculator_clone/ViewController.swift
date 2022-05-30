//
//  ViewController.swift
//  calculator_clone
//
//  Created by sanghyo on 2022/05/27.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var valueDisplay: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var divideButton: UIButton!
    @IBOutlet weak var multiplyButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    var prevValue: String = "0"
    var nextValue: String = ""
    var commaValue: String = "0"
    var labelTextSize: CGFloat = 90
    var isPositive: Bool = true
    var operationSymbol: OperationSymbol?
    var rightBeforeSymbpl: OperationSymbol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //코드 지저분함 개선 필요(toggleSign에서부터 지저분해짐)
    @IBAction func tapNumber(_ sender: UIButton) {
        let buttonText = sender.titleLabel?.text
        //연산(=, +, - ..) 이후 입력하면 새로운 값 입력되도록
        if prevValue == "0" || prevValue == "-0"{
            prevValue = buttonText!
            if !isPositive{ prevValue.insert("-", at: prevValue.startIndex)}
            setComma()
            valueDisplay.text = commaValue
            resetButton.titleLabel?.text = "C"
        }
        else if prevValue.getIntDigit() <= 8{
            prevValue += buttonText!
            setComma()
            valueDisplay.text = commaValue
            resizeLabelText()
            valueDisplay.font = valueDisplay.font.withSize(labelTextSize)
        }
    }
    
    @IBAction func resetValue(_ sender: UIButton) {
        prevValue = "0"
        commaValue = "0"
        isPositive = true
        labelTextSize = 90
        valueDisplay.font = valueDisplay.font.withSize(labelTextSize)
        valueDisplay.text = "0"
        resetButton.titleLabel?.text = "AC"
    }
    
    @IBAction func setDot(_ sender: UIButton) {
        //사칙연산 부호 이후 . 눌렀을 대 0.으로 뜨는 처리
        if prevValue.getIntDigit() < 9  && prevValue.firstIndex(of:".") == nil{
            prevValue += "."
            setComma()
            valueDisplay.text = commaValue
        }
    }
    
    @IBAction func toggleSign(_ sender: UIButton) {
        let firstIndex = prevValue.startIndex

        if isPositive{
            isPositive = false
            labelTextSize = prevValue.getIntDigit() >= 6 ? labelTextSize - 12 : labelTextSize
            prevValue.insert("-", at: firstIndex)
        }else{
            isPositive = true
            prevValue.remove(at: firstIndex)
            labelTextSize = prevValue.getIntDigit() >= 6 ? labelTextSize + 12 : labelTextSize
        }
        setComma()
        valueDisplay.text = commaValue
        valueDisplay.font = valueDisplay.font.withSize(labelTextSize)
    }
    
    @IBAction func setOperationSymbol(_ sender: UIButton) {
        switch sender{
        case divideButton:
            operationSymbol = OperationSymbol.divide
        case multiplyButton:
            operationSymbol = OperationSymbol.multiply
        case minusButton:
            operationSymbol = OperationSymbol.minus
        case plusButton:
            operationSymbol = OperationSymbol.plus
        default:
            break
        }
    }
    
    @IBAction func percentFunction(_ sender: UIButton) {
        prevValue = prevValue != "0" ? String(Double(prevValue)! / 100) : prevValue
        setComma()
        valueDisplay.text = commaValue
    }
    
    @IBAction func equalFunction(_ sender: UIButton) {
        
    }
    
    //minus, comma, dot을 숫자로 인지하지 않도록 하는 코드가 다소 복잡해보임, 간결화 필요
    func setComma(){
        commaValue = prevValue
        var intCount = commaValue.getIntDigit()
        var lastIndex = commaValue.endIndex
        
        if let tmpIndex = commaValue.firstIndex(of:"."){
            lastIndex = tmpIndex
            intCount = String(commaValue[commaValue.startIndex..<lastIndex]).getIntDigit()
        }
        switch intCount{
        case 4...6:
            let firstComma = commaValue.index(lastIndex, offsetBy: -3)
            commaValue.insert(",", at: firstComma)
        case 7...9:
            let firstComma = commaValue.index(lastIndex, offsetBy: -3)
            let secondComma = commaValue.index(lastIndex, offsetBy: -6)
            commaValue.insert(",", at: firstComma)
            commaValue.insert(",", at: secondComma)
        default:
            break
        }
    }
    
    //자연스러운 크기 감소 반영 필요
    func resizeLabelText(){
        switch prevValue.getIntDigit(){
        case 7:
            labelTextSize -= 12
        case 8:
            labelTextSize -= 12
        case 9:
            labelTextSize -= 12
        case 10:
            labelTextSize -= 12
        default:
            break
        }
    }
    
    func roundValue(_ targetValue: Double) -> String{
        let digit: Double = pow(10, 8)
        let res = round(targetValue * digit) / digit
        
        return String(res)
    }
}

extension String{
    func getIntDigit() -> Int{
        var intDigitNum: Int = self.count
        intDigitNum = self.firstIndex(of:".") != nil ? intDigitNum - 1 : intDigitNum
        intDigitNum = self.firstIndex(of:"-") != nil ? intDigitNum - 1 : intDigitNum
        
        return intDigitNum
    }
}

enum OperationSymbol{
    case divide
    case multiply
    case minus
    case plus
    case percent
    case equal
}

