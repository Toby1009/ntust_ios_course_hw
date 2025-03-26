//
//  ContentView.swift
//  hw2
//
//  Created by 楊鈞安 on 2025/3/20.
//

import SwiftUI


import SwiftUI

enum TabbedItems: Int, CaseIterable{
    case home = 0
    case communities
    case create
    case chat
    case inbox
    
    var title: String{
        switch self {
        case .home:
            return "Home"
        case .communities:
            return "Communities"
        case .create:
            return "Create"
        case .chat:
            return "Chat"
        case .inbox:
            return "Inbox"
        }
    }
    
    var iconName: String{
        switch self {
        case .home:
            return "home-icon"
        case .communities:
            return "communities-icon"
        case .create:
            return "create-icon"
        case .chat:
            return "chat-icon"
        case .inbox:
            return "inbox-icon"
        }
    }
}

struct MainTabbedView: View {
    @State var selectedTab = 0
    @State var showTab: Bool = true
    @State private var lastScrollY: CGFloat = 0
    @State var showSlideMenu : Bool = false
    @State var showCreateView: Bool = false
    init(){
        UITabBar.appearance().isHidden = true
        showSlideMenu = false
    }
    var body: some View {
        HStack(spacing: 0){
            SlideMenuView(showSlideMenu: $showSlideMenu)
            ZStack(alignment: .bottom) {
                // Content
                VStack {
                    switch selectedTab {
                    case 0: HomeView(showTab: $showTab, showSlideMenu: $showSlideMenu)
                    case 1: CommunitiesView()
                    case 2: CreateView()
                    case 3: ChatView()
                    case 4: InboxView(showSlideMenu: $showSlideMenu)
                    default: HomeView(showTab: $showTab , showSlideMenu: $showSlideMenu)
                    }
                }
                .contentShape(Rectangle()) // Make entire area tappable
                // Tab Bar
                if showTab {
                    HStack(spacing: 20) {
                        ForEach((TabbedItems.allCases), id: \.self) { item in
                            Button {
                                if item == .create {
                                                                    showCreateView = true // 觸發全屏顯示 CreateView
                                } else {
                                    selectedTab = item.rawValue
                                }
                            } label: {
                                CustomTabItem(imageName: item.iconName, title: item.title, isActive: (selectedTab == item.rawValue))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 65)
                    .background(Color.black)
                    .transition(.move(edge: .bottom))
                    .padding(.bottom)
                }
            }
            .frame(width:UIScreen.main.bounds.width)
            .edgesIgnoringSafeArea(.bottom)
        }
        .frame(width:UIScreen.main.bounds.width)
        .fullScreenCover(isPresented: $showCreateView) {
            CreateView()
        }
    }
}

extension MainTabbedView{
    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View{
        VStack{
            Spacer()
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .frame(width: 30, height: 30)
                .foregroundColor(Color.white)
            Text(title)
                .font(.system(size: 9))
                .foregroundColor(Color.white)
        }
        .frame(maxWidth:60,maxHeight:50)
    }
}

#Preview {
    MainTabbedView()
}
