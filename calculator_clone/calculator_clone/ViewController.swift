//
//  ViewController.swift
//  calculator_clone
//
//  Created by sanghyo on 2022/05/27.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var valueDisplay: UILabel!
    var prevValue: String = ""
    var commaValue: String = ""
    var labelTextSize: CGFloat = 90
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapNumber(_ sender: UIButton) {
        let buttonText = sender.titleLabel?.text
        if valueDisplay.text == "0"{
            valueDisplay.text = buttonText
            prevValue += buttonText!
        }else if prevValue.getIntDigit() <= 8{
            prevValue += buttonText!
            setComma(tappedInt: buttonText!)
            valueDisplay.text = commaValue
            resizeLabelText(prevValue.count)
            valueDisplay.font = valueDisplay.font.withSize(labelTextSize)
        }
        
    }
    
    @IBAction func resetValue(_ sender: UIButton) {
        prevValue = ""
        commaValue = ""
        labelTextSize = 90
        valueDisplay.font = valueDisplay.font.withSize(labelTextSize)
        valueDisplay.text = "0"
    }
    
    @IBAction func setDot(_ sender: UIButton) {
        if prevValue.getIntDigit() < 9  && commaValue.firstIndex(of:".") == nil{
            prevValue += "."
            commaValue += "."
            valueDisplay.text = commaValue
        }
    }
    
    func setComma(tappedInt: String){
        if prevValue.firstIndex(of:".") == nil{
            commaValue = prevValue
            switch prevValue.getIntDigit(){
            case 4...6:
                let firstComma = commaValue.index(commaValue.endIndex, offsetBy: -3)
                commaValue.insert(",", at: firstComma)
            case 7...9:
                let firstComma = commaValue.index(commaValue.endIndex, offsetBy: -3)
                let secondComma = commaValue.index(commaValue.endIndex, offsetBy: -6)
                commaValue.insert(",", at: firstComma)
                commaValue.insert(",", at: secondComma)
            default:
                break
            }

        }else{
            commaValue += tappedInt
        }
    }
    
    //dot 추가, - 추가와 숫자 개수에 따른 크기 감소 반영 필요
    func resizeLabelText(_ intDigitLen: Int){
        switch intDigitLen{
        case 7:
            labelTextSize -= 13
        case 8:
            labelTextSize -= 10
        case 9:
            labelTextSize -= 10
        default:
            break
        }
    }
}

extension String{
    func getIntDigit() -> Int{
        return self.firstIndex(of:".") != nil ? self.count - 1 : self.count
    }
}


