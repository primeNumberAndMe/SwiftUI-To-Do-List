//
//  EditingPage.swift
//  ToDoList
//
//  Created by Steve Lau on 2020/8/25.
//

import SwiftUI

struct EditingPage: View {
    @EnvironmentObject var UserData: ToDo
    
    @State var title: String
    @State var dueDate: Date 
    
    var id: Int? = nil
    
    @Environment(\.presentationMode) var presentation 
    
    var body: some View {
        
        NavigationView{
            
            Form{
                Section(header: Text("Task")){
                    TextField("Things to do", text: self.$title)
                    DatePicker(selection: self.$dueDate, label: { Text("Due Date") })
                }
                Section{
                    Button(action: {
                        if self.id == nil{
                            // to add new task
                            self.UserData.add(data: SingleToDo(title: self.title, dueDate: self.dueDate))
                        }else {
                            //to edit an existing task
                            self.UserData.edit(data: SingleToDo(title: self.title, dueDate: self.dueDate), id: self.id!)
                        }
                        self.presentation.wrappedValue.dismiss()
                    }){
                        Text("Done")
                    }
                    Button(action: {
                        self.presentation.wrappedValue.dismiss()
                    }){
                        Text("Cancel")
                    }
                }
            }
            .navigationBarTitle("Detail")
        }
    }
}

struct EditingPage_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditingPage(title: "", dueDate: Date())
            
        }
    }
}
