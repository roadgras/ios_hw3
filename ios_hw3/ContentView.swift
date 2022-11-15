//
//  ContentView.swift
//  ios_hw3
//
//  Created by li on 2022/11/12.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TableView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("個人課表")
            }
            NotebookView()
                .tabItem {
                    Image(systemName: "pencil")
                    Text("課堂備忘錄")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct  TableView: View {
    var body: some View {
        Image("課表")
            .resizable()
    }
}
