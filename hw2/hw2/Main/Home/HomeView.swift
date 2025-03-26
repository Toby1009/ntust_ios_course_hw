//
//  HomeView.swift
//  hw2
//
//  Created by 楊鈞安 on 2025/3/21.
//

import SwiftUI

struct HomeView: View {
    @Binding var showTab : Bool
    @Binding var showSlideMenu : Bool
    @State private var headerOffset: CGFloat = 0
    @State private var posts: [String] = (1...10).map { "Post \($0)" }
    @State private var isLoading = false
    var body: some View {
        GeometryReader{
            let safeArea = $0.safeAreaInsets
            let headerHeight = safeArea.top
            NavigationStack{
                ZStack {
                    Color.black.edgesIgnoringSafeArea(.all)
                    
                    ScrollView{
                        LazyVStack(spacing: 10) {
                            ForEach(posts.indices, id: \.self) { index in
                                PostRowView(postTitle: posts[index])
                                    .onAppear {
                                        if index == posts.count - 1 {
                                            loadMorePosts()
                                        }
                                    }
                            }
                            if isLoading {
                                ProgressView()
                                    .padding()
                            }
                        }
                        .background(Color.black)
                    }
                    .simultaneousGesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation{
                                    if value.translation.height < 0 {
                                        showTab = false
                                    } else if value.translation.height > 0 {
                                        showTab = true
                                    }
                                    headerOffset = min(value.translation.height , 0)
                                }
                            }
                            .onEnded{ value in
                                withAnimation{
                                    if value.translation.height < 0 {
                                        headerOffset = -(headerHeight*2)
                                    }else if value.translation.height > 0{
                                        headerOffset = 0
                                    }
                                }
                            }
                    )
                    .safeAreaInset(edge: .top){
                        HeaderView()
                            .frame(height: headerHeight, alignment: .bottom)
                            .background(Color.black)
                            .offset(y: headerOffset)
                    }
                }
            }
        }
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
            Text("reddit")
                .font(.system(size:30))
                .foregroundColor(Color.red)
                .frame(alignment: .leading)
            Spacer()
            Button(action: {
                print("Custom button tapped!")
            } ) {
                HStack {
                    Image(systemName: "magnifyingglass")
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
    
       private func loadMorePosts() {
           guard !isLoading else { return }
           isLoading = true
           DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
               let newPosts = (posts.count + 1...posts.count + 10).map { "Post \($0)" }
               posts.append(contentsOf: newPosts)
               isLoading = false
           }
       }
       
       private func refreshPosts() {
           DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
               posts = (1...10).map { "Post \($0)" }
           }
       }
    
    struct PostRowView: View {
        let postTitle: String
        
        var body: some View {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 100)
                .overlay(
                    Text(postTitle)
                        .foregroundColor(.white)
                        .font(.headline)
                )
        }
    }
    

    
}
