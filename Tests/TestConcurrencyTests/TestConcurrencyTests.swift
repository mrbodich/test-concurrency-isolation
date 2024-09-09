//
//  TestConcurrencyTests.swift
//
//
//  Created by Bogdan Chornobryvets on 9/8/24.
//

import XCTest
@testable import TestConcurrency

final class TestConcurrencyTests: XCTestCase {
    func testIsolatedConcurrency() async throws {
        //  given
        let computer = AsyncIsolatedComputer()
        let jobs: [Int] = [10, 5, 3, 8, 2]
        
        //  when
        await run(jobs: jobs, on: computer)
        
        // then
        /// We expect the next sequence here: [in(2), out(2), in(0), out(0), in(1), out(1)]
        /// Eg random job can start, but must finish before the next job can enter synchronized context of the `testComputing` method
        let events = await computer.events
        for index in stride(from: 1, to: jobs.count * 2, by: 2) {
            XCTAssertEqual(
                events[index - 1].eventType,
                .in
            )
            XCTAssertEqual(
                events[index].eventType,
                .out
            )
            XCTAssertEqual(
                events[index - 1].id,
                events[index].id
            )
        }
    }
    
    func testNoConcurrency() async throws {
        //  given
        let computer = DirectComputer()
        let jobs: [Int] = [10, 5, 3, 8, 2]
        
        //  when
        await run(jobs: jobs, on: computer)
        
        // then
        /// We expect the next sequence here: [in(2), out(2), in(0), out(0), in(1), out(1)]
        /// Eg random job can start, but must finish before the next job can enter synchronized context of the `testComputing` method
        let events = await computer.events
        for index in stride(from: 1, to: jobs.count * 2, by: 2) {
            XCTAssertEqual(
                events[index - 1].eventType,
                .in
            )
            XCTAssertEqual(
                events[index].eventType,
                .out
            )
            XCTAssertEqual(
                events[index - 1].id,
                events[index].id
            )
        }
    }
    
    func testNonIsolatedConcurrency() async throws {
        //  given
        let computer = AsyncNonIsolatedComputer()
        let jobs: [Int] = [10, 5, 3, 8, 2]
        
        //  when
        await run(jobs: jobs, on: computer)
        
        // then
        /// We expect the next sequence here: [in(2), in(0), in(1), out(1), out(0), out(2)]
        /// Eg all jobs started concurrently, not waiting for each other, and then finished concurrently
        let events = await computer.events
        for index in jobs.indices {
            XCTAssertEqual(
                events[index].eventType,
                .in
            )
            XCTAssertEqual(
                events[index + jobs.count].eventType,
                .out
            )
        }
    }
    
    func testNonIsolatedWrappedConcurrency() async throws {
        //  given
        let computer = AsyncNonIsolatedWrappedComputer()
        let jobs: [Int] = [10, 5, 3, 8, 2]
        
        //  when
        await run(jobs: jobs, on: computer)
        
        // then
        /// We expect the next sequence here: [in(2), in(0), in(1), out(1), out(0), out(2)]
        /// Eg all jobs started concurrently, not waiting for each other, and then finished concurrently
        let events = await computer.events
        for index in jobs.indices {
            XCTAssertEqual(
                events[index].eventType,
                .in
            )
            XCTAssertEqual(
                events[index + jobs.count].eventType,
                .out
            )
        }
    }
    
    func testAnotherActorConcurrency() async throws {
        //  given
        let computer = AsyncAnotherActorComputer()
        let jobs: [Int] = [10, 5, 3, 8, 2]
        
        //  when
        await run(jobs: jobs, on: computer)
        
        // then
        /// We expect the next sequence here: [in(2), in(0), in(1), out(1), out(0), out(2)]
        /// Eg all jobs started concurrently, not waiting for each other, and then finished concurrently
        let events = await computer.events
        for index in jobs.indices {
            XCTAssertEqual(
                events[index].eventType,
                .in
            )
            XCTAssertEqual(
                events[index + jobs.count].eventType,
                .out
            )
        }
    }
}

extension TestConcurrencyTests {
    private func run(jobs: [Int], on computer: Computer) async {
        await withTaskGroup(of: Void.self) { group in
            for (id, job) in jobs.enumerated() {
                group.addTask {
                    await computer.testComputing(id: id, complexity: job)
                }
            }
            return await group.waitForAll()
        }
    }
}
