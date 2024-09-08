//
//  Computer.swift
//  
//
//  Created by Bogdan Chornobryvets on 9/8/24.
//

import Foundation

protocol Computer: Actor {
    var events: [Event] { get }
    func testComputing(id: Int, complexity: Int) async
}

extension Computer {
    static func computingJob(complexity: Int) {
        for _ in 0..<(100_000 * complexity) {
            let _ = sqrt(0.5)
        }
    }
}
