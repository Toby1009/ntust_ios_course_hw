//
//  Inbox.swift
//  hw2
//
//  Created by 楊鈞安 on 2025/3/21.
//

import SwiftUI

struct InboxView: View {
    @Binding var showSlideMenu : Bool
    @State private var   selection: Int = 0
    let tabs = ["Notifications","Messages"]
    /// The font of the tab title
    let font : Font = .body
    /// The selection bar sliding animation type
    let animation: Animation = .easeInOut
    
    /// The accent color when the tab is selected
    let activeAccentColor: Color = .white
    
    /// The accent color when the tab is not selected
    let inactiveAccentColor: Color =  .gray
    
    /// The color of the selection bar
    let selectionBarColor: Color = .blue
    
    /// The tab color when the tab is not selected
    let inactiveTabColor: Color = .clear
    
    /// The tab color when the tab is  selected
    let activeTabColor: Color = .clear
    
    /// The height of the selection bar
    let selectionBarHeight: CGFloat = 2
    
    /// The selection bar background color
    let selectionBarBackgroundColor: Color =  Color.gray.opacity(0.2)
    
    /// The height of the selection bar background
    let selectionBarBackgroundHeight: CGFloat = 1
    
    var body: some View {
        GeometryReader{
            let safeArea = $0.safeAreaInsets
            let headerHeight = safeArea.top
            ZStack{
                Color.black.edgesIgnoringSafeArea(.all)
                NavigationStack{
                    Text("Inbox view")
                        .foregroundColor(Color.white)
                }
                .background(Color.black)
                .safeAreaInset(edge: .top){
                    VStack(spacing:0){
                        HeaderView()
                            .frame(height: headerHeight, alignment: .bottom)
                            .background(Color.black)
                        InboxSlideTabView()
                            .background(Color.black)
                    }
                   
                }
            }
            
        }
        .background(Color.black)
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack{
            Button{
                showSlideMenu.toggle()
            } label: {
                Image(systemName:"slider.horizontal.3")
                    .resizable()
                    .frame(width: 32, height: 32)
            }
            .foregroundColor(Color.white)
            Spacer()
            Text("Inbox")
                .font(.system(size:30))
                .frame(alignment: .center)
                .foregroundColor(Color.white)
            Spacer()
            Button(action: {
                print("Custom button tapped!")
            } ) {
                HStack {
                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
                }
            }
            .foregroundColor(Color.white)
            .frame(alignment: .trailing)
            UserAvatarView(
                imageUrl: "https://www.redditstatic.com/avatars/avatar_default_02_46D160.png",
                isOnline: true,
                username: "u/RedditUser",
                showUsername: false
            )
            .preferredColorScheme(.dark)
        }
        .background(Color.black)
    }
    
    @State private var selectionState: Int = 0 {
            didSet {
                selection = selectionState
            }
        }
    
    func isSelected(tabIdentifier: String) -> Bool {
        return tabs[selectionState] == tabIdentifier
    }
    func selectionBarXOffset(from totalWidth: CGFloat) -> CGFloat {
        return self.tabWidth(from: totalWidth) * CGFloat(selectionState)
    }
    
    func tabWidth(from totalWidth: CGFloat) -> CGFloat {
        return totalWidth / CGFloat(tabs.count)
    }
    
    @ViewBuilder
    func InboxSlideTabView() -> some View{
        VStack{
            HStack{
                ForEach(self.tabs, id:\.self) { tab in
                    Button(action: {
                        let selection = self.tabs.firstIndex(of: tab) ?? 0
                        self.selectionState = selection
                    }) {
                        HStack {
                            Spacer()
                            Text(tab).font(self.font)
                            Spacer()
                        }
                    }
                    .padding(.vertical, 16)
                    .accentColor(
                        self.isSelected(tabIdentifier: tab)
                        ? self.activeAccentColor
                        : self.inactiveAccentColor)
                    .background(
                        self.isSelected(tabIdentifier: tab)
                        ? self.activeTabColor
                        : self.inactiveTabColor)
                }
            }
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(self.selectionBarColor)
                        .frame(width: self.tabWidth(from: geometry.size.width), height: self.selectionBarHeight, alignment: .leading)
                        .offset(x: self.selectionBarXOffset(from: geometry.size.width), y: 0)
                        .animation(self.animation, value: selectionState)
                    Rectangle()
                        .fill(self.selectionBarBackgroundColor)
                        .frame(width: geometry.size.width, height: self.selectionBarBackgroundHeight, alignment: .leading)
                }.fixedSize(horizontal: false, vertical: true)
            }.fixedSize(horizontal: false, vertical: true)
            TabView(selection: $selectionState) {
                InboxNotificationView()
                    .tag(0)
                
                InboxMessageView()
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(self.animation, value: selectionState)
        }
    }
}

