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
        }else if prevValue.count <= 8{
            prevValue += buttonText!
            setComma()
            valueDisplay.text = commaValue
            resizeLabelText(prevValue.count)
            valueDisplay.font = valueDisplay.font.withSize(labelTextSize)
        }
        
    }
    
    //0으로 변하는 동시에 숫자 크기 초기화 작업 필요
    @IBAction func resetValue(_ sender: UIButton) {
        prevValue = ""
        commaValue = ""
        labelTextSize = 90
        valueDisplay.font = valueDisplay.font.withSize(labelTextSize)
        valueDisplay.text = "0"
    }
    
    func setComma(){
        commaValue = prevValue
        switch prevValue.count{
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
    }
    
    func resizeLabelText(_ labelLen: Int){
        switch labelLen{
        case 7:
            labelTextSize -= 12
        case 8:
            labelTextSize -= 10
        case 9:
            labelTextSize -= 8
        default:
            break
        }
    }
}


