//
//  CreateTaskView.swift
//  ToDoApp
//
//  Created by 山崎浩毅 on 2018/12/27.
//  Copyright © 2018年 山崎浩毅. All rights reserved.
//

import Foundation
import UIKit

// CreateTaskViewControllerへユーザーインタラクションを伝達するためのProtocolです
protocol CreateTaskViewDelegate: class {
    func createView(taskEditting view: CreateTaskView, text: String)
    func createView(deadlineEditting view: CreateTaskView, deadline: Date)
    func createView(saveButtonDidTap view: CreateTaskView)
}

class CreateTaskView: UIView {
    private var taskTextField: UITextField! // タスク内容を入力するUITextField
    private var datePicker: UIDatePicker! // 締切時間を表示するUIPickerView
    private var deadlineTextField: UITextField! // 締切時間を入力するUITextField
    private var saveButton: UIButton! // 保存ボタン
    
    weak var delegate: CreateTaskViewDelegate? // デリゲート
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        taskTextField = UITextField()
        taskTextField.delegate = self
        taskTextField.tag = ()
        taskTextField.placeholder = "予定を入れてください"
        addSubview(taskTextField)
        
        deadlineTextField = UITextField()
        deadlineTextField.tag = 1
        deadlineTextField.placeholder = "期限を入れてください"
        addSubview(deadlineTextField)
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        // UITextFieldが編集モードになった時に、キーボードではなく、UIDatePickerになるようにしている
        deadlineTextField.inputView = datePicker
        
        saveButton = UIButton()
        saveButton.setTitle("保存する", for: .normal)
        saveButton.setTitleColor(UIColor.black, for: .normal)
        saveButton.layer.borderWidth = 0.5
        saveButton.layer.cornerRadius = 4.0
        saveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        addSubview(saveButton)
    }
    
    @objc func saveButtonTapped(_ sender: UIButton) {
        // saveボタンが押された時に呼ばれるメソッド。押したという情報をCreateTaskViewControllerへ伝達している
        delegate?.createView(saveButtonDidTap: self)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        // UIDatePickerの値が変わった時に呼ばれるメソッド。sender.dateがユーザーが選択した締切日時で、DateFormatterをに用いてStringに変換し、deadlineTextField.textに代入している。また、日時の情報をCreateTaskViewControllerへ伝達している
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        let deadlineText = dateFormatter.string(from: sender.date)
        deadlineTextField.text = deadlineText
        delegate?.createView(deadlineEditting: self, deadline: sender.date)
    }
}

override func layoutSubviews() {
    super.layoutSubviews()
    
    taskTextField.frame = CGRect(x: bounds.origin.x + 30, y: bounds.origin.y + 30, width: bounds.size.width - 60, height: 50)
    deadlineTextField.frame = CGRect(x: taskTextField.frame.origin.x, y: taskTextField.frame.maxY, width: taskTextField.frame.size.width, height: taskTextField.frame.size.height)
    
    let saveButtonSize = CGSize(width: 100, height: 50)
    saveButton.frame = CGRect(x: (bounds.size.width - saveButtonSize.width) / 2, y: deadlineTextField.frame.maxY + 20, width: saveButtonSize.width, height: saveButtonSize.height)
}

extension CreateTaskView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 0 {
            // textField.tagで識別している。もし、tagが０の時、textField.textすなわち、ユーザーが入力したタスク内容の文字をCreateTaskViewControllerに伝達している
            delegate?.createView(taskEditting: self, text: textField.text ?? "")
        }
        return true
    }
}
