//
//  ContentView.swift
//  ToDoList
//
//  Created by Steve Lau on 2020/8/21.
//

import SwiftUI

func initUserData() -> [SingleToDo]{
    var output: [SingleToDo] = []
    if let dataStored = UserDefaults.standard.object(forKey: "ToDoList") as? Data{
        let data = try! decoder.decode([SingleToDo].self, from: dataStored)
        for item in data{
            if !item.deleted {
                output.append(SingleToDo(title: item.title, dueDate: item.dueDate, isChecked: item.isChecked,  id: output.count))
            }
        }
    }
    return output
}

struct ContentView: View {
    @ObservedObject var UserData: ToDo = ToDo(data: initUserData())
    
    @State var showEditingPage = false
    var body: some View{
        ZStack {
            NavigationView{
                ScrollView(.vertical, showsIndicators: true){
                    VStack {
                        ForEach(self.UserData.ToDoList) {item in
                            if !item.deleted {
                                SingleCardView(index: item.id)
                                    .environmentObject(self.UserData)
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
                .navigationBarTitle("Task List")
            }
            
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Button(action: {
                        self.showEditingPage = true
                    }){
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80)
                            .foregroundColor(.blue)
                            .padding(.trailing)
                    }
                    .sheet(isPresented: self.$showEditingPage, content: {
                        EditingPage(title: "", dueDate: Date())
                            .environmentObject(self.UserData)
                    })
                }
            }
        }
    }
}


struct SingleCardView: View{
    @EnvironmentObject var UserData: ToDo
    var index: Int
    @State var showEditingPage = false

    var body: some View {
        
        HStack{
            Rectangle()
                .frame(width: 6)
                .foregroundColor(.blue)
            
            Button(action: {
                self.UserData.ToDoList[self.index].deleted = true
            }) {
                Image(systemName: "trash")
                    .imageScale(.large)
                    .foregroundColor(.black)
                    .padding(.leading)
            }
            
            
           
            Button(action: {
                self.showEditingPage = true
            }) {
                Group {
                    VStack(alignment: .leading, spacing: 6.0)
                    {
                        Text(self.UserData.ToDoList[index].title)
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundColor(Color.black)
                        Text(self.UserData.ToDoList[index].dueDate.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.leading)
                    Spacer()
                }
            }
            .sheet(isPresented: self.$showEditingPage, content: {
                EditingPage(title: self.UserData.ToDoList[self.index].title,
                            dueDate: self.UserData.ToDoList[self.index].dueDate,
                            id: self.index)
                    .environmentObject(self.UserData)
            })
            
            
            Image(systemName: self.UserData.ToDoList[index].isChecked ? "checkmark.square.fill" : "square")
                .imageScale(.large)
                .padding(.trailing)
                .onTapGesture {
                    self.UserData.check(id: self.index)
                }
            
        }
        .frame(height: 80)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10, x: 0, y: 10)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}


    
