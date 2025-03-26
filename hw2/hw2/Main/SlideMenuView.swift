//
//  SlideMenu.swift
//  hw2
//
//  Created by 楊鈞安 on 2025/3/23.
//

import Foundation
import SwiftUI

struct SlideMenuView: View{
    @State private var slideWidth : CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    @Binding var showSlideMenu : Bool
    let  maxSlideWidth : CGFloat = 600
    var body : some View{
        ScrollView{
            VStack{
                Text("Hell aaa")
                    .foregroundColor(Color.white)
                    .onTapGesture {
                            print("slide tap")
                    }
                Spacer()
            }
            .frame(width:slideWidth)
            .background(Color.black)
            .onChange(of: showSlideMenu){
                if showSlideMenu{
                    slideWidth = maxSlideWidth
                }else{
                    slideWidth = 0
                }
            }
            
        }
        .background(Color.black)
        .simultaneousGesture(
            DragGesture()
                .onChanged{ value in
                    let dragOffset = value.translation.width - lastOffset
                    slideWidth = min(max(slideWidth + dragOffset, 0), maxSlideWidth)
                    lastOffset = value.translation.width  // 記錄最後的偏移量
                }
                .onEnded{ value in
                    if  value.translation.width < 0{
                        slideWidth = 0
                    }else {
                        slideWidth = 500
                    }
                    lastOffset = 0 // 重置
                    
                    if slideWidth <= 0{
                        showSlideMenu = false
                    }else{
                        showSlideMenu = true
                    }
                }
        )
    }
}
