//
//  TaskDataSource.swift
//  ToDoApp
//
//  Created by 山崎浩毅 on 2018/12/26.
//  Copyright © 2018年 山崎浩毅. All rights reserved.
//

import Foundation

class TaskDataSource: NSObject {
    // Task一覧を保持するArray。UITableViewに表示させるためのデータ
    private var tasks = [Task]()
    
    // UserDefaultから保存したTask一覧を取得している
    func loadData() {
        let userDefaults = UserDefaults.standard
        let taskDictionaries = userDefaults.object(forKey: "tasks") as? [[String: Any]]
        guard let t = taskDictionaries else { return }
        
        for dic in t {
            let task = Task(from: dic)
            tasks.append(task)
        }
        
        //TaskをUserDefaultsに保存
        func save(task: Task) {
            tasks.append(task)
            
            var taskDictionaries = [[String: Any]]()
            for t in tasks {
                let taskDictionary: [String: Any] = ["text": t.text, "deadline": t.deadline]
                taskDictionaries.append(taskDictionary)
            }
            
            let userDefaults = UserDefaults.standard
            userDefaults.set(taskDictionaries, forKey: "tasks")
            userDefaults.synchronize()
        }
        
        //Taskの総数を返している。UITableViewのcellのカウントに使用
        func count() ->Int{
            return tasks.count
        }
        
        //指定したindexに対応するTaskを返す。indexにはUITableViewのIndexPath.rowが来ることを想定
        func data(at index: Int) ->Task? {
            if tasks.count > index {
                return tasks[index]
            }
            return nil
        }
    }
}
