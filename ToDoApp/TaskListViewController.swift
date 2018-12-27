//
//  TaskListViewController.swift
//  ToDoApp
//
//  Created by 山崎浩毅 on 2018/12/27.
//  Copyright © 2018年 山崎浩毅. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController {
    
    var dataSource: TaskDataSource!
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = TaskDataSource()
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskListCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barButtonTapped(_:)))
        navigationItem.rightBarButtonItem = barButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.loadData() // 画面が表示されるたびに、データをロードする
        tableView.reloadData() // データをロードした後、tableViewを更新する
    }
    
    @objc func barButtonTapped(_ sender: UIBarButtonItem) {
        // タスク作成画面へ画面遷移
        let controller = CreateTaskViewController()
        present(controller, animated: true, completion: nil)
    }
}

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count() // cellの数にdataSourceのカウントを返している
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt IndexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TaskListCell
        
        // indexPath.rowに応じたTaskを取り出す
        let task = dataSource.data(at: indexPath.row)
        
        // taskをcellに受け渡している
        cell.task = task
        return cell
    }
}
