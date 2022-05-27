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
            valueDisplay.text! = prevValue
            resizeLabelText(prevValue.count, &labelTextSize)
            valueDisplay.font = valueDisplay.font.withSize(labelTextSize)
        }
        
    }
    func resizeLabelText(_ labelLen: Int, _ labelSize: inout CGFloat){
        switch labelLen{
        case 7:
            labelSize -= 10
        case 8:
            labelSize -= 10
        case 9:
            labelSize -= 10
        default:
            break
        }
    }
    
}

