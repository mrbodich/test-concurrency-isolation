//
//  ComputerImplementations.swift
//  
//
//  Created by Bogdan Chornobryvets on 9/8/24.
//

import Foundation

actor AsyncIsolatedComputer: Computer {
    private(set) var events: [Event] = []
    
    func testComputing(id: Int, complexity: Int) async {
        events.append(.init(.in, id: id))
        await compute(complexity: complexity)
        events.append(.init(.out, id: id))
    }
    
    private func compute(complexity: Int) async {
        Self.computingJob(complexity: complexity)
    }
}

actor AsyncNonIsolatedComputer: Computer {
    private(set) var events: [Event] = []
    
    func testComputing(id: Int, complexity: Int) async {
        events.append(.init(.in, id: id))
        await compute(complexity: complexity)
        events.append(.init(.out, id: id))
    }
    
    nonisolated
    private func compute(complexity: Int) async {
        Self.computingJob(complexity: complexity)
    }
}

actor AsyncNonIsolatedWrappedComputer: Computer {
    private(set) var events: [Event] = []
    
    func testComputing(id: Int, complexity: Int) async {
        events.append(.init(.in, id: id))
        await computeWrapper(complexity: complexity)
        events.append(.init(.out, id: id))
    }
    
    private func computeWrapper(complexity: Int) async {
        await compute(complexity: complexity)
    }
    
    nonisolated
    private func compute(complexity: Int) async {
        Self.computingJob(complexity: complexity)
    }
}

actor AsyncAnotherActorComputer: Computer {
    private(set) var events: [Event] = []
    
    func testComputing(id: Int, complexity: Int) async {
        events.append(.init(.in, id: id))
        await StandaloneComputingActor.shared.compute(complexity: complexity)
        events.append(.init(.out, id: id))
    }
}

actor AsyncIsolatedWrapperAnotherActorComputer: Computer {
    private(set) var events: [Event] = []
    
    func testComputing(id: Int, complexity: Int) async {
        events.append(.init(.in, id: id))
        await compute(complexity: complexity)
        events.append(.init(.out, id: id))
    }
    
    private func compute(complexity: Int) async {
        await StandaloneComputingActor.shared.compute(complexity: complexity)
    }
}

actor DirectComputer: Computer {
    private(set) var events: [Event] = []
    
    func testComputing(id: Int, complexity: Int) async {
        events.append(.init(.in, id: id))
        Self.computingJob(complexity: complexity)
        events.append(.init(.out, id: id))
    }
}

actor StandaloneComputingActor {
    init() {}
    static let shared: StandaloneComputingActor = .init()
    
    func compute(complexity: Int) async {
        for _ in 0..<(100_000 * complexity) {
            let _ = sqrt(0.5)
        }
    }
}
