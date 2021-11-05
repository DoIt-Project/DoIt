//
//  Strings.swift
//  DoIt
//
//  Created by Yulia on 28.10.2021.
//

import Foundation

enum AuthStrings: String {
    case username = "auth.username"
    case email = "auth.email"
    case password = "auth.password"
    case retypePassword = "auth.retypePassword"
    case signUp = "auth.signUp"
    case signIn = "auth.signIn"
    case alreadySignedUp = "auth.alreadySignedUp"
    case notSignedUp = "auth.notSignedUp"
    // screen headers
    case headerSignIn = "auth.headerSignIn"
    case headerSignUp = "auth.headerSignUp"
}

enum FindFriendsString: String {
    case header = "findFriends.header"
    case followButton = "findFriends.followButton"
    case unfollowButton = "findFriends.unfollowButton"
    case searchPlaceholder = "findFriends.searchPlaceholder"
}
