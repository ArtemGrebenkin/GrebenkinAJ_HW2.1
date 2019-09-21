//
//  ViewController.swift
//  GrebenkinAJ_HW2.1
//
//  Created by Artem Grebenkin on 9/18/19.
//  Copyright © 2019 Artem Grebenkin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var outputView: UIView!
    
    @IBOutlet weak var sliderRed: UISlider!
    @IBOutlet weak var sliderGreen: UISlider!
    @IBOutlet weak var sliderBlue: UISlider!
    
    @IBOutlet weak var txtFieldRed: UITextField!
    @IBOutlet weak var txtFieldGreen: UITextField!
    @IBOutlet weak var txtFieldBlue: UITextField!
    
    @IBOutlet weak var labelRed: UILabel!
    @IBOutlet weak var labelGreen: UILabel!
    @IBOutlet weak var labelBlue: UILabel!
    
    
    var floatValueRed : CGFloat = 0
    var floatValueGreen : CGFloat = 0
    var floatValueBlue : CGFloat = 0
    var floatValueAlpha: CGFloat = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFieldRed.delegate = self
        txtFieldGreen.delegate = self
        txtFieldBlue.delegate = self
        
        setupElements()
        setupKeyboard()
    }



    @IBAction func sliderChanging(_ sender: UISlider) {
        
        let value = Int(sender.value)
        
        switch sender.tag {
        case 1: floatValueRed = CGFloat(sender.value)
                setText(red: value, green: nil, blue: nil)
        case 2: floatValueGreen = CGFloat(sender.value)
                setText(red: nil, green: value, blue: nil)
        case 3: floatValueBlue = CGFloat(sender.value)
                setText(red: nil, green: nil, blue: value)
        default: break
        }
        paintView()
    }
    

    //тап мимо клавиатуры должен завершить ввод
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
        getValueFromTxtField()
        paintView()
    }
    
    
    //the Done button
    @objc func donePressed() {
        view.endEditing(true)
        getValueFromTxtField()
        paintView()
        
        sliderRed.setValue(Float(floatValueRed), animated: true)
        sliderGreen.setValue(Float(floatValueGreen), animated: true)
        sliderBlue.setValue(Float(floatValueBlue), animated: true)
        
        setText(red: Int(floatValueRed), green: Int(floatValueGreen), blue: Int(floatValueBlue))
    }
    
    
    
    func getValueFromTxtField() {
        
        if let strRed = txtFieldRed.text {
            if let red = Float(strRed) {
                floatValueRed = CGFloat(red)
            }
        }
        if let strGreen = txtFieldGreen.text {
            if let green = Float(strGreen) {
                floatValueGreen = CGFloat(green)
            }
        }
        if let strBlue = txtFieldBlue.text {
            if let blue = Float(strBlue) {
                floatValueBlue = CGFloat(blue)
            }
        }
    }
    
    
    
    func paintView() {
        outputView.backgroundColor = UIColor(red: floatValueRed/255, green: floatValueGreen/255, blue: floatValueBlue/255, alpha: floatValueAlpha)
    }
    
    
    func setText(red: Int?, green: Int?, blue: Int?) {
        //for labels
        if let red = red {labelRed.text = "R: " + String(red)}
        if let green = green {labelGreen.text = "G: " + String(green)}
        if let blue = blue {labelBlue.text = "B: " + String(blue)}
        
        //for text fields
        if let red = red {txtFieldRed.text = String(red)}
        if let green = green {txtFieldGreen.text = String(green)}
        if let blue = blue {txtFieldBlue.text = String(blue)}
        
    }
}



extension ViewController {
    private func setupElements() {
        outputView.layer.cornerRadius = outputView.frame.height / 10
        
        //получим начальные значения для слайдеров от вью
        if let colorRGB = outputView.backgroundColor {
            if colorRGB.getRed(&floatValueRed, green: &floatValueGreen, blue: &floatValueBlue, alpha: &floatValueAlpha) {
                
                setText(red: Int(floatValueRed * 255.0), green: Int(floatValueGreen * 255.0), blue: Int(floatValueBlue * 255.0))
                
                sliderRed.value = Float(floatValueRed * 255.0)
                sliderGreen.value = Float(floatValueGreen * 255.0)
                sliderBlue.value = Float(floatValueBlue * 255.0)
                
            }
        }
    }
    
    
    private func setupKeyboard() {
        
        //кнопка Done на всплывающей клав.
        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        //тап по экрану
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.viewTapped(gestureRecognizer:)))

        toolBar.sizeToFit()
        toolBar.setItems([doneButton], animated: false)

        view.addGestureRecognizer(tapGesture)
        
        txtFieldRed.inputAccessoryView = toolBar
        txtFieldGreen.inputAccessoryView = toolBar
        txtFieldBlue.inputAccessoryView = toolBar
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        //проверим ввод дб в диапазоне 0...255
        if let strValue = textField.text {
            if let value = Int(strValue) {
                if value > 255 {textField.text = "255"}
            }
        }
    }
}
