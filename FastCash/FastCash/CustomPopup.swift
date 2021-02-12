//
//  CustomPopup.swift
//  FastCash
//
//  Created by arfullight on 2/12/21.
//  Copyright © 2021 Trevor Carpenter. All rights reserved.
//

import Foundation
import UIKit

protocol PopupEnded {
    func popupDidEnd(input: String)
}

class CustomPopup: UIView {
    var delegate: PopupEnded? = Optional.none
    var titleLabel: UILabel? = Optional.none
    var textField: UITextField? = Optional.none
    
    //initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    @objc private func onTap() {
        self.endEditing(true)
    }
    
    func setTitle(title: String) {
        self.titleLabel?.text = title
    }

    //common func to init our view
    private func setupView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.addGestureRecognizer(tapGesture)
        
        self.backgroundColor = UIColor(white: 1, alpha: 0.7)
        
        // create main window
        let windowWidth = Int(self.bounds.width) - 32 * 2
        let windowHeight = 250
        let frame = CGRect(x: Int(self.bounds.width) / 2 - windowWidth / 2, y: Int(self.bounds.height) / 2 - windowHeight / 2, width: windowWidth, height: windowHeight)
        let window = UIView(frame: frame)
        window.backgroundColor = .white
        window.layer.cornerRadius = 10
        window.layer.shadowColor = UIColor.black.cgColor
        window.layer.shadowOpacity = 0.6
        window.layer.shadowOffset = .zero
        window.layer.shadowRadius = 10
        
        // add title label
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 16, width: windowWidth, height: 40))
        headerLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        headerLabel.text = ""
        headerLabel.textAlignment = .center
        headerLabel.textColor = .black
        window.addSubview(headerLabel)
        self.titleLabel = headerLabel
        
        // add textfield
        // TODO: set default value somehow
        let textField = UITextField(frame: CGRect(x: 16, y: Int(headerLabel.bounds.height) + 32, width: windowWidth - 32, height: 40))
        let textFieldMaxY = Int(headerLabel.bounds.height) + 32 + 40
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        window.addSubview(textField)
        self.textField = textField
        
        // add "Done" button
        let button = UIButton(frame: CGRect(x: windowWidth / 2 - 150 / 2, y: textFieldMaxY + 16, width: 125, height: 50))
        button.setTitle("Done", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = button.bounds.height / 2
        button.addTarget(self, action: #selector(self.onClick), for: .touchUpInside)
        window.addSubview(button)
        
        self.addSubview(window)
    }
    
    @objc func onClick(sender: UIButton) {
        self.endEditing(true)
        self.isHidden = true
        
        if let delegate = self.delegate {
            guard let input = self.textField?.text else { return }
            delegate.popupDidEnd(input: input)
        }
    }
}
