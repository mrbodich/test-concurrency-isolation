//
//  Event.swift
//  
//
//  Created by Bogdan Chornobryvets on 9/8/24.
//

import Foundation

struct Event: Sendable, CustomStringConvertible {
    let eventType: EventType
    let id: Int
    
    init(_ eventType: EventType, id: Int) {
        self.eventType = eventType
        self.id = id
    }
    
    var description: String {
        switch eventType {
        case .in:  ">>in(\(id))"
        case .out: "<<out(\(id))"
        }
    }
}

enum EventType {
    case `in`
    case  out
}
