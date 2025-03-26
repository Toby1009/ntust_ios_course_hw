//
//  Create.swift
//  hw2
//
//  Created by 楊鈞安 on 2025/3/21.
//

import SwiftUI

struct CreateView: View {
    @Environment(\.dismiss) var dismiss // 取得 dismiss 環境變數
    @State private var inputTitleText = ""
    @State private var inputBodyText = ""
        var body: some View {
            VStack {
                HStack {
                    Button(action: {
                        dismiss() // 關閉視圖
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30 )
                            .foregroundColor(.gray)
                    }
                    .frame(alignment: .leading)
                    Spacer()
                    Button(action:{}){
                        Text("Post")
                    }
                    .frame(alignment:.trailing)
                }
                ScrollView {
                    VStack(spacing: 20) {
                        TextField("", text: $inputTitleText)
                            .overlay(
                                Text(inputTitleText.isEmpty ? "Title" : "")
                                    .foregroundColor(.gray)
                                    .font(.system(size:40))
                                    .padding(.leading, 5),
                                alignment: .leading
                            )
                            .foregroundColor(.white)
                            .font(.system(size:40))
                        TextField("", text: $inputBodyText)
                            .overlay(
                                Text(inputBodyText.isEmpty ? "body text(optional)" : "")
                                    .foregroundColor(.gray)
                                    .font(.system(size:25))
                                    .padding(.leading, 5),
                                alignment: .leading
                            )
                            .foregroundColor(.white)
                            .font(.system(size:25))
                        
                    }
                    .padding(.bottom, 50) // 防止內容太靠近底部
                }
            }
            .safeAreaInset(edge: .bottom) { // 讓輸入框貼齊鍵盤
                HStack(spacing:30) {
                    Spacer()
                    Button("URL") {
                    }
                    Button("Image") {
                    }
                    Button("Video"){
                    }
                    Button("Poll"){
                    }
                    Button("AMA"){
                    }
                    .frame(maxWidth:.infinity,alignment: .leading)
                    Spacer()
                }
                .background(.black)
            }
            .background(Color.black)
        }
}
