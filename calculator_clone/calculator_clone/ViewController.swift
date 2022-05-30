//
//  ViewController.swift
//  calculator_clone
//
//  Created by sanghyo on 2022/05/27.
//

import UIKit

final class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var valueDisplay: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var divideButton: UIButton!
    @IBOutlet weak var multiplyButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    private var nowValue: String = "0"
    private var nowTemp: String = ""
    private var prevValue: Double = 0.0
    private var commaValue: String = "0"
    private var labelTextSize: CGFloat = 90
    private var isPositive: Bool = true
    private var onTapping: Bool = false // 숫자 1자리 이상 입력했는지
    private var operationSymbol: OperationSymbol?
    private var rightBeforeSymbol: OperationSymbol?
    private var clickedButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //코드 지저분함 개선 필요(toggleSign에서부터 지저분해짐)
    @IBAction func tapNumber(_ sender: UIButton) {
        let buttonText = sender.titleLabel?.text
        //연산(=, +, - ..) 이후 입력하면 새로운 값 입력되도록
        if rightBeforeSymbol != nil && rightBeforeSymbol != .percent && !onTapping{
            makeNowValueZero()
        }
        if nowValue == "0" || nowValue == "-0"{
            nowValue = buttonText!
            if !isPositive{ nowValue.insert("-", at: nowValue.startIndex)}
            setComma(nowValue)
            valueDisplay.text = commaValue
            if commaValue != "0" {resetButton.titleLabel?.text = "C"}
            onTapping.toggle()
        }
        else if nowValue.getIntDigit() <= 8{
            nowValue += buttonText!
            setComma(nowValue)
            valueDisplay.text = commaValue
            resizeLabelText()
            valueDisplay.font = valueDisplay.font.withSize(labelTextSize)
        }
    }
    
    @IBAction func resetValue(_ sender: UIButton) {
        nowValue = "0"
        prevValue = 0.0
        commaValue = "0"
        isPositive = true
        labelTextSize = 90
        valueDisplay.font = valueDisplay.font.withSize(labelTextSize)
        valueDisplay.text = "0"
        resetButton.titleLabel?.text = "AC"
        onTapping = false
    }
    
    @IBAction func setDot(_ sender: UIButton) {
        //사칙연산 부호 이후 . 눌렀을 때 0.으로 뜨는 처리
        if rightBeforeSymbol != nil && !onTapping{
            nowValue = "0."
            setComma(nowValue)
            valueDisplay.text = commaValue
            onTapping = true
        }
        else if nowValue.getIntDigit() < 9  && nowValue.firstIndex(of:".") == nil{
            nowValue += "."
            setComma(nowValue)
            valueDisplay.text = commaValue
        }
        resizeLabelText()
        valueDisplay.font = valueDisplay.font.withSize(labelTextSize)
    }
    
    @IBAction func toggleSign(_ sender: UIButton) {
        let firstIndex = nowValue.startIndex
        
        if isPositive{
            isPositive = false
            //labelTextSize = nowValue.getIntDigit() >= 6 ? labelTextSize - 12 : labelTextSize
            nowValue.insert("-", at: firstIndex)
            resizeLabelText()
        }else{
            isPositive = true
            nowValue.remove(at: firstIndex)
            //labelTextSize = nowValue.getIntDigit() >= 6 ? labelTextSize + 12 : labelTextSize
            resizeLabelText()
        }
        setComma(nowValue)
        valueDisplay.text = commaValue
        valueDisplay.font = valueDisplay.font.withSize(labelTextSize)
    }
    
    @IBAction func setOperationSymbol(_ sender: UIButton) {
        prevValue = Double(nowValue)!
        switch sender{
        case divideButton:
            operationSymbol = .divide
            rightBeforeSymbol = .divide
        case multiplyButton:
            operationSymbol = .multiply
            rightBeforeSymbol = .multiply
        case minusButton:
            operationSymbol = .minus
            rightBeforeSymbol = .minus
        case plusButton:
            operationSymbol = .plus
            rightBeforeSymbol = .plus
        default:
            break
        }
        onTapping = false
            
    }
    
    @IBAction func percentFunction(_ sender: UIButton) {
        nowValue = nowValue != "0" ? String(Double(nowValue)! / 100) : nowValue
        setComma(nowValue)
        valueDisplay.text = commaValue
        resizeLabelText()
        valueDisplay.font = valueDisplay.font.withSize(labelTextSize)
        onTapping = false
        operationSymbol = .percent
        rightBeforeSymbol = .percent
    }
    
    @IBAction func equalFunction(_ sender: UIButton){
        if rightBeforeSymbol == .equal{
            //prevValue에 지금 입력한 값 혹은 임시 저장되어 있던 결과 값 대입, nowValue에 이전에 입력했던 뒤에 값 대입
            prevValue = Double(nowValue)!
            nowValue = nowTemp
        }
        if operationSymbol != nil && operationSymbol != OperationSymbol.percent{
            switch operationSymbol{
            case .divide:
                calculateDivide()
            case .multiply:
                calculateMultiply()
            case .minus:
                calculateMinus()
            case .plus:
                calculatePlus()
            default:
                break
            }
            setComma(String(prevValue))
            valueDisplay.text = commaValue == "inf" ? "오류" : commaValue
            nowTemp = nowValue // 뒤에 값을 임시 저장
            nowValue = String(prevValue) //결과값을 nowValue에 임시 저장
            resizeLabelText()
            valueDisplay.font = valueDisplay.font.withSize(labelTextSize)
            rightBeforeSymbol = .equal
            onTapping = false
            clickedButton = nil
        }
    }
    
    func calculateDivide(){
        prevValue /= Double(nowValue)!
    }
    
    func calculateMultiply(){
        prevValue *= Double(nowValue)!
    }
    
    func calculateMinus(){
        prevValue -= Double(nowValue)!
    }
    
    func calculatePlus(){
        prevValue += Double(nowValue)!
    }
    
    func makeNowValueZero(){
        nowValue = "0"
        commaValue = "0"
        isPositive = true
        labelTextSize = 90
        valueDisplay.font = valueDisplay.font.withSize(labelTextSize)
    }
    
    //minus, comma, dot을 숫자로 인지하지 않도록 하는 코드가 다소 복잡해보임, 간결화 필요
    func setComma(_ beforeSetComma: String){
        commaValue = beforeSetComma
        var intCount = commaValue.getIntDigit()
        var lastCountIndex = commaValue.endIndex
        
        if let tmpIndex = commaValue.firstIndex(of:"."){
            lastCountIndex = tmpIndex
            intCount = String(commaValue[commaValue.startIndex..<lastCountIndex]).getIntDigit()
            let strLastIndex = commaValue.index(commaValue.endIndex, offsetBy: -1)
            if tmpIndex == commaValue.index(before: strLastIndex) && commaValue[strLastIndex] == "0"{
                commaValue = String(commaValue[commaValue.startIndex..<lastCountIndex])
            }
        }
        switch intCount{
        case 4...6:
            let firstComma = commaValue.index(lastCountIndex, offsetBy: -3)
            commaValue.insert(",", at: firstComma)
        case 7...9:
            let firstComma = commaValue.index(lastCountIndex, offsetBy: -3)
            let secondComma = commaValue.index(lastCountIndex, offsetBy: -6)
            commaValue.insert(",", at: firstComma)
            commaValue.insert(",", at: secondComma)
        default:
            break
        }
    }
    
    func resizeLabelText(){
        let count = nowValue.firstIndex(of:"-") != nil ? nowValue.getIntDigit() + 1 : nowValue.getIntDigit()
        switch count{
        case 6:
            labelTextSize = 90
        case 7:
            labelTextSize = 77
        case 8:
            labelTextSize = 70
        case 9:
            labelTextSize = 63
        case 10:
            labelTextSize = 56
        default:
            break
        }
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


