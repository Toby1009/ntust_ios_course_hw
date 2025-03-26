//
//  UserAvatarView.swift
//  hw2
//
//  Created by 楊鈞安 on 2025/3/26.
//

import Foundation
import SwiftUI

struct UserAvatarView: View {
    let imageUrl: String
    let isOnline: Bool
    let username: String
    let showUsername: Bool
    
    var body: some View {
        HStack {
            ZStack(alignment: .bottomTrailing) {
                // 頭像圖片
                AsyncImage(url: URL(string: imageUrl)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                    } else {
                        Color.gray.opacity(0.3) // 頭像載入中 or 加載失敗
                    }
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())

                // 在線狀態指示器
                if isOnline {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 10, height: 10)
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                        .offset(x: -30, y: 3)
                }
            }
            if showUsername{
                Text(username)
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .padding(10)
        .background(Color.black.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onTapGesture {
            print("\(username) profile tapped") // 這裡可以導航到用戶頁面
        }
    }
}

struct UserAvatarView_Previews: PreviewProvider {
    static var previews: some View {
        UserAvatarView(
            imageUrl: "https://www.redditstatic.com/avatars/avatar_default_02_46D160.png",
            isOnline: true,
            username: "u/RedditUser",
            showUsername: false
        )
        .preferredColorScheme(.dark)
    }
}
