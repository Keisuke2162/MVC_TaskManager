//
//  CreateTask.swift
//  MVC_TaskManager
//
//  Created by 植田圭祐 on 2020/05/10.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation
import UIKit


//CreateTaskViewControllerにユーザーインタラクションを通知するプロトコル

protocol CreateTaskViewDelegate: class {
    func createView(taskEditting view: CreateTaskView, text: String)
    func createView(deadlineEditting view: CreateTaskView, deadline: Date)
    func createView(saveButtonDidTap view: CreateTaskView)
}

//タスク作成画面に表示するパーツ群
class CreateTaskView: UIView {
    
    private var taskTextField: UITextField!
    private var datePicker: UIDatePicker!
    private var deadlineTextField: UITextField!
    private var saveButton: UIButton!
    
    weak var delegate: CreateTaskViewDelegate?
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        taskTextField = UITextField()
        taskTextField.delegate = self
        taskTextField.tag = 0
        taskTextField.placeholder = "タスクを入力してください"
        addSubview(taskTextField)
        
        deadlineTextField = UITextField()
        deadlineTextField.tag = 1
        deadlineTextField.placeholder = "締め切りを入力してください"
        addSubview(deadlineTextField)
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        
        //締め切り入力の際はTextField編集時にDatePickerを開く
        deadlineTextField.inputView = datePicker
        
        saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.layer.borderWidth = 0.5
        saveButton.layer.cornerRadius = 4.0
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        addSubview(saveButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func saveButtonTapped(_ sender: UIButton) {
        //「セーブボタンを押した」というアクションをCreateViewControllerに通知する
        delegate?.createView(saveButtonDidTap: self)
    }
    
    /*
     DatePickerの値変更時に呼ばれる
     1. DateFormatterにて変換し、TextFieldに表示する
     2. 入力した日時情報をCreateViewControllerに通知する
    */
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy/mm/dd"
        dateFormatter.dateFormat = "EEE MMM hh:mm"
        
        let deadlineText = dateFormatter.string(from: sender.date)
        deadlineTextField.text = deadlineText
        delegate?.createView(deadlineEditting: self, deadline: sender.date)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        taskTextField.frame = CGRect(x: bounds.origin.x + 30,
                                     y: bounds.origin.y + 30,
                                     width: bounds.size.width - 50,
                                     height: 50)
        
        deadlineTextField.frame = CGRect(x: taskTextField.frame.origin.x,
                                         y: taskTextField.frame.origin.y + 30,
                                         width: taskTextField.frame.size.width,
                                         height: taskTextField.frame.size.height)
        
        
        let saveButtonSize = CGSize(width: 100, height: 50)
        saveButton.frame = CGRect(x: (bounds.size.width - saveButtonSize.width) / 2,
                                  y: deadlineTextField.frame.maxY + 20,
                                  width: saveButtonSize.width,
                                  height: saveButtonSize.height)
    }
}

extension CreateTaskView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //tagが0（タスク入力用Fieldの場合）だとタスク内容をCreateViewControllerに通知
        if textField.tag == 0 {
            delegate?.createView(taskEditting: self, text: textField.text ?? "")
        }
        
        return true
    }
}
