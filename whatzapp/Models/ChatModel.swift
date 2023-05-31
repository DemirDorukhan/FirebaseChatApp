//
//  ChatModel.swift
//  whatzapp
//
//  Created by Dorukhan Demir on 13.04.2023.
//
import SwiftUI

struct ChatModel: Identifiable {
    
    var id : Int
    var message : String
    var uidFromFirebase : String
    var messageFrom : String
    var messageTo : String
    var messageDate : Date
    var messageFromMe : Bool
    
}

