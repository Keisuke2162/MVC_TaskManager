//
//  Modal.swift
//  MVC_TaskManager
//
//  Created by 植田圭祐 on 2020/05/10.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

/*
 1.タスクを生成
let task = Task(text: "買い物", deadline: Date())
 
 2.データ操作用クラスをインスタンス化
let dataSource = TaskDataSource()
 
 3.生成したタスクをUserDefaultsに保存
dataSource.save(task: task)
 
 4.UserDefaultsからデータを取得（取得したデータがTableViewに表示される）
dataSource.load()
 
*/

import Foundation


//Modalの役割① データ構造の表現
class Task {
    
    let text: String    //タスク内容
    let deadline: Date  //締め切り時間
    
    //テキストと締め切りを受け取り、タスクを生成するメソッド（イニシャライザメソッド）
    init(text: String, deadline: Date) {
        self.text = text
        self.deadline = deadline
    }
    
    //UserDefaultsに保存されたdictionaryからTaskを生成するイニシャライザ
    init(from dictionary: [String: Any]) {
        self.text = dictionary["text"] as! String
        self.deadline = dictionary["deadline"] as! Date
    }
    
    
}

//Modalの役割② データの振る舞い、ロジックを保持
class TaskDataSource: NSObject {
    
    //タスクの一覧を保持する配列(TableViewに表示するデータ)
    private var tasks = [Task]()
    
    //UserDefaultsから保存したタスクの一覧を取得する
    func load() {
        let userDefaluts = UserDefaults.standard
        let taskDictionaries = userDefaluts.object(forKey: "tasks") as? [[String: Any]]
        
        //データが有ることを確認
        guard let t = taskDictionaries else { return }
        
        //dictionaryの内容でひとつずつタスク生成する
        for dic in t {
            let task = Task(from: dic)
            tasks.append(task)
        }
    }
    
    //タスクをUserDefaultsに保存する処理
    func save(task: Task) {
        
        tasks.append(task)
        
        var taskDictionaries = [[String: Any]]()
        
        //タスクの内容をそれぞれ key:value 形式で保存
        for t in tasks {
            let taskDictionary: [String: Any] = ["text": t.text, "deadline": t.deadline]
            
            taskDictionaries.append(taskDictionary)
        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(taskDictionaries, forKey: "tasks")
        userDefaults.synchronize()
        
    }
    
    //タスクの総数
    func count() ->Int {
        return tasks.count
    }
    
    //TableViewのIndexPath.rowに対応するデータを返却
    func data(at index: Int) ->Task? {
        if tasks.count > index {
            return tasks[index]
        }
        return nil
    }
}
