//
//  Task.swift
//  ToDoApp
//
//  Created by 山崎浩毅 on 2018/12/26.
//  Copyright © 2018年 山崎浩毅. All rights reserved.
//

import Foundation

class Task {
    let text: String // タスクの内容
    let deadline: Date // タスクの締め切り時間
    
    // 引数からtextとdeadlineを受け取りTaskを生成するイニシャライザ
    init (text: String, deadline: Date) {
        self.text = text
        self.deadline = deadline
    }
    
    // 引数のdictionaryからTask
}
