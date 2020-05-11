//
//  CreateViewController.swift
//  MVC_TaskManager
//
//  Created by 植田圭祐 on 2020/05/11.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation
import UIKit

class CreateViewController: UIViewController {
    
    fileprivate var createTaskView: CreateTaskView!
    
    fileprivate var dataSource: TaskDataSource!
    fileprivate var taskText: String?
    fileprivate var taskDeadline: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        //CreateViewを生成、プロトコル受付用にDelegateをselfに設定
        createTaskView = CreateTaskView()
        createTaskView.delegate = self
        view.addSubview(createTaskView)
        
        //データソースを作成
        dataSource = TaskDataSource()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //CreateTaskViewのレイアウト設定
        createTaskView.frame = CGRect(x: view.safeAreaInsets.left,
                                      y: view.safeAreaInsets.top,
                                      width: view.frame.size.width - view.safeAreaInsets.left - view.safeAreaInsets.right,
                                      height: view.frame.size.height - view.safeAreaInsets.bottom)
    }
        
    //保存成功時に発生させるアラート
    fileprivate func showSaveAlert(){
        let alertController = UIAlertController(title: "Save Seccess", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            _ = self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    //タスク内容が未入力時に発生させるアラート
    fileprivate func showMissingTaskTextAlert(){
        let alertController = UIAlertController(title: "タスクを入力してください", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    //締め切り日時が未記入の場合
    fileprivate func showMissingTaskDeadlineAlert(){
        let alertController = UIAlertController(title: "締め切りを入力してください", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}


extension CreateViewController: CreateTaskViewDelegate {
    func createView(taskEditting view: CreateTaskView, text: String) {
        //タスク入力中に呼び出されるメソッド
        //CreateTaskViewからタスク内容を受け取ってtaskTextに代入
        taskText = text
    }
    
    func createView(deadlineEditting view: CreateTaskView, deadline: Date) {
        //締め切り日時入力中に呼び出されるメソッド
        //CreateTaskViewから日時を受け取ってtaskDeadlineに代入
        taskDeadline = deadline
    }
    
    func createView(saveButtonDidTap view: CreateTaskView) {
        //保存ボタン押下時のメソッド
        /*
         taskTextがnil -> アラート呼び出し
         taskDeadlineがnil ->　アラーと呼び出し
         どっちも入力OK -> タスク生成 -> タスクを保存(dataSource) -> showSaveAlertを表示
        */
        
        guard let taskText = taskText else {
            showMissingTaskTextAlert()
            return
        }
        
        guard let taskDeadline = taskDeadline else {
            showMissingTaskDeadlineAlert()
            return
        }
        
        let task = Task(text: taskText, deadline: taskDeadline)
        dataSource.save(task: task)
        
        showSaveAlert()
    }
    
}
