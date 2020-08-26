//
//  UserData.swift
//  ToDoList
//
//  Created by Steve Lau on 2020/8/25.
//

import Foundation

var encoder = JSONEncoder()
var decoder = JSONDecoder()

//operate on date, make the inititalizer
class ToDo: ObservableObject {
    @Published var ToDoList: [SingleToDo]
    var count = 0
    
    init() {
        self.ToDoList = []
    }
    
    init(data: [SingleToDo]) {
        self.ToDoList = []
        for item in data{
            self.ToDoList.append(SingleToDo(title: item.title, dueDate: item.dueDate,isChecked: item.isChecked, id: self.count))
            count+=1
        }
    }
    
    func check(id: Int) {
        self.ToDoList[id].isChecked.toggle()
        self.dataStore()
    }
    
    func add(data: SingleToDo){
        self.ToDoList.append(SingleToDo(title: data.title, dueDate: data.dueDate, id: self.count))
        self.count += 1
        
        self.sort()
        self.dataStore()
    }
    
    func edit(data: SingleToDo, id: Int){
        self.ToDoList[id].title = data.title
        self.ToDoList[id].dueDate = data.dueDate
        self.ToDoList[id].isChecked = false
        self.dataStore()
        self.sort()
    }
    
    func sort(){
        self.ToDoList.sort(by: {(data1, data2) in
                            return data1.dueDate.timeIntervalSince1970 < data2.dueDate.timeIntervalSince1970 })
        
        for i in 0 ..< self.ToDoList.count{
            ToDoList[i].id = i
        }
    }
    
    func delete(id: Int){
        self.ToDoList[id].deleted = true
        self.sort()
        self.dataStore()
    }
    
    func dataStore() {
        let dataStore = try! encoder.encode(self.ToDoList)
        UserDefaults.standard.set(dataStore, forKey: "ToDoList")
        
    }
    
}


//This is only a template
struct SingleToDo: Identifiable, Codable {
    var title: String = ""
    var dueDate: Date = Date()
    var isChecked: Bool = false
    
    var deleted = false
    var id = 0
}
