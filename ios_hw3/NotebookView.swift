//
//  NotebookView.swift
//  ios_hw3
//
//  Created by li on 2022/11/12.
//

import SwiftUI

struct Information: Identifiable {
    let id = UUID()
    var name: String
    var selectDate: Date
    var introduction:String
    var course: String
    var type: String
    var frequency: Int
    var bgColor: Color
    var scale: CGFloat
}

struct NotebookView: View {
    @State private var inf_list:[Information] = []
    @State private var full: Bool = false
    @State private var add: Bool = false
    @State private var random: Bool = false
    @State private var showingAlert: Bool = false
    @State private var showOptions: Bool = false
    @State private var selectDate = Date()
    //@State private var bgColor = Color.red
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()
    var body: some View {
        ZStack{
            NavigationView{
                List{
                    ForEach($inf_list){ $data in
                        Button(action:{
                            self.full = true
                        }){
                            HStack{
                                TextView(text: "名稱:\t"+data.name+"\n截止時間:\t"+dateFormatter.string(from: data.selectDate))
                                    .background(data.bgColor)
                            }.fullScreenCover(isPresented: $full){
                                fullView(inf_list: $inf_list, inf: $data, show: $full)
                            }
                        }
                    }.onDelete(perform: delete)
                }
                .toolbar {
                    EditButton()
                }
                .navigationTitle("課堂備忘錄")
            }
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    
                    
                    Button(action: {
                        self.showOptions = true
                    }, label: {
                        Image(systemName: "ellipsis.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.secondary))
                            .padding(20)
                    })        .actionSheet(isPresented: $showOptions) {
                        ActionSheet(title: Text("Options"),
                            buttons: [
                                .default(Text("新增")) {
                                    self.add = true
                                },
                                .default(Text("抽獎")) {
                                    if(inf_list.count > 0){
                                        self.random = true
                                    }
                                    else{
                                        showingAlert = true
                                    }
                                },
                                .cancel(Text("取消"))
                            ]
                        )
                    }
                }
            }.alert(isPresented: $showingAlert) { Alert(title: Text("沒有選項"))}
            
        }
        .fullScreenCover(isPresented: $random){
            showView(inf: $inf_list.randomElement()!, show: $random)
        }
        .sheet(isPresented: $add){
            addView(inf_list: $inf_list, show: $add)
        }
    }
    func delete(at offsets: IndexSet) {
        inf_list.remove(atOffsets: offsets)
    }
}

struct NotebookView_Previews: PreviewProvider {
    static var previews: some View {
        NotebookView()
    }
}

struct addView: View {
    @Binding var inf_list: [Information]
    @Binding var show: Bool
    @State private var brightnessAmount : Double = 0
    @State private var inf = Information(name: "",selectDate: Date(),introduction: "", course: "", type: "", frequency: 0, bgColor: Color.white, scale: 30)
    @State private var showingAlert: Bool = false
    @State private var isProfile = false
    let today = Date()
    let endDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())!
    let courses = ["計算機系統設計", "圖論演算法", "計算機組織學", "iOS", "專題", "機率論", "其他"]
    let types = ["作業", "報告", "小考", "大考", "其他"]
    var body: some View {
        VStack{
            Form{
                Section(header: HStack{
                    Button("取消") {
                        show = false
                    }
                    Spacer()
                    Button("儲存") {
                        if(inf.name.isEmpty){
                            showingAlert = true
                        }
                        else{
                            self.inf_list.append(inf)
                            show = false
                        }
                    }
                }) {
                    Group{
                        TextField("名稱（必填）", text: $inf.name)
                        DatePicker("時間", selection: $inf.selectDate, in: self.today...self.endDate, displayedComponents: .date)
                    }
                    VStack(alignment: .leading) {
                        Text("科目")
                        Picker("科目", selection: $inf.course) {
                            ForEach(courses, id: \.self) { (course) in
                                Text(course)
                            }
                        }
                        .padding()
                        .labelsHidden()
                        .pickerStyle(WheelPickerStyle())
                    }
                    HStack {
                        Text("事件")
                        Picker("事件", selection: $inf.type) {
                            ForEach(types, id: \.self) { (type)in
                                Text(type)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    HStack {
                        Text("次數：")
                            .font(.custom("jf-openhuninn-1.1", size: 20))
                        Stepper(value: $inf.frequency, in: 0...12)
                        {
                            if inf.frequency == 0
                            {
                                Text("\(inf.frequency) 次")
                                    .font(.custom("jf-openhuninn-1.1", size: 18))
                            }
                            else
                            {
                                Text("\(inf.frequency) 次")
                                    .font(.custom("jf-openhuninn-1.1", size: 18))
                            }
                        }
                        .frame(width:150)
                        .padding()
                    }
                    ColorPicker("設定背景顏色", selection: $inf.bgColor)
                    Text("字型大小:\(inf.scale, specifier: "%.0f")")
                    Slider(value: $inf.scale, in: 1...50)
                    Toggle("是否要備註?", isOn: self.$isProfile)
                    .frame(width:200)
                    if self.isProfile{
                        ZStack{
                            if inf.introduction.isEmpty {
                                VStack{
                                    HStack{
                                        Text("備註(選填)")
                                            .foregroundColor(Color(UIColor.placeholderText))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 12)
                                        Spacer()
                                    }
                                    Spacer()
                                }
                            }
                            TextEditor(text: $inf.introduction)
                                .frame(height: 300)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2))
                        }
                    }
                }
            }
        }.alert(isPresented: $showingAlert) { Alert(title: Text("請輸入名稱"))}
    }
}

struct showView: View {
    @Binding var inf: Information
    @Binding var show: Bool
    var body: some View {
        VStack{
            HStack{
                Button("返回") {
                    show = false
                }
                .padding()
                Spacer()
            }
            Text("無法決定先做什麼事就點下面")
                .font(.system(size:30))
            Spacer()
            DisclosureGroup("抽獎") {
                VStack (alignment: .leading){
                    Text("請先做")
                    Text("名稱 : \(inf.name)")
                }
            }.font(.system(size:30))
            .padding()
            Spacer()
        }
    }
}

struct TextView: View {
    var text:String
    var body: some View {
        Text(text)
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(30)
    }
}

struct fullView: View {
    @Binding var inf_list: [Information]
    @Binding var inf: Information
    @Binding var show: Bool
    @State private var showingAlert: Bool = false
    var body: some View {
        VStack{
            HStack{
                Button("返回") {
                    show = false
                }
                .padding()
                Spacer()
            }
            Spacer()
            VStack (alignment: .leading){
                Text("名稱 : \(inf.name)")
                Text("科目 : \(inf.course)")
                Text("種類 : \(inf.type) \(inf.frequency)")
                Text("時間 : \(inf.selectDate)")
                Text("備註 :")
                Text(inf.introduction)
            }.font(.system(size: inf.scale))
            .padding()
            Spacer()
        }.background(inf.bgColor)
    }
}
