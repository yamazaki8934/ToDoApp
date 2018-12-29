//
//  CreateTaskViewController.swift
//  ToDoApp
//
//  Created by 山崎浩毅 on 2018/12/27.
//  Copyright © 2018年 山崎浩毅. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController {
    fileprivate var createTaskView: CreateTaskView!
    fileprivate var dataSource: TaskDataSource!
    fileprivate var taskText: String?
    fileprivate var taskDeadline: Date?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        // createTaskViewを生成し、デリゲートにselfをセット
        createTaskView = CreateTaskView()
        createTaskView.delegate = self
        view.addSubview(createTaskView)
        
        // TaskDataSourceを生成
        dataSource = TaskDataSource()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // CreateTaskViewのレイアウトを決めている
        createTaskView.frame = CGRect(x: view.safeAreaInsets.left, y: view.safeAreaInsets.top, width: view.frame.size.width - view.safeAreaInsets.left - view.safeAreaInsets.right, height: view.frame.size.height - view.safeAreaInsets.bottom)
    }
    
    // 保存が成功した時のアラート。保存が成功したらアラートを出し、前の画面に戻る
    fileprivate func showSaveAlert() {
        let alertController = UIAlertController(title: "保存しました", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) {
            (action) in_ = self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    // タスクが未入力の時のアラート。タスクが未入力の時に保存して欲しくない
    fileprivate func showMissingTaskTextAlert() {
        let alertController = UIAlertController(title: "タスクを入力してください", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}

// CreateTaskViewDelegate メソッド
extension CreateTaskViewController: CreateTaskViewDelegate {
    func createView(taskEditting view: CreateTaskView, text: String) {
        // タスク内容を入力している時に呼ばれるデリゲードメソッド。CreateTaskViewからタスク内容を受け取り、taskTextに代入している
        taskText = text
    }
    
    func createView(deadlineEditting view: CreateTaskView, deadline: Date) {
        // 締切日時を入力している時に呼ばれるデリゲードメソッド。CreateTaskViewから締切日時を受け取り、taskDeadlineに代入している。
        taskDeadline = deadline
    }
    
    func createView(saveButtonDidTap view: CreateTaskView) {
        // 保存ボタンが押された時に呼ばれるデリゲードメソッド。taskTextがnilだった場合showMissingTaskTextAlert()を呼び、taskDeadlineがnilだった場合、showMissingTaskDeadlineAlert()を呼んでいる。どちらもnilでなかった場合に、taskText、taskDeadlineからTaskを生成し、dataSource.save(task: task)を呼んで、taskを保存している。保存完了後showSaveAlert()を呼んでいる。
        guard let taskText = taskText else {
            showMissingTaskTextAlert()
            return
        }
        guard let taskDeadline = taskDeadline else {
            showMissingTaskTextAlert()
            return
        }
        let task = Task(text: taskText, deadline: taskDeadline)
        detaSource.save(task: task)
        
        showSaveAlert()
    }
}
