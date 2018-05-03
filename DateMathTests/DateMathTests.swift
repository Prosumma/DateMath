//
//  DateMathTests.swift
//  DateMathTests
//
//  Created by Gregory Higley on 5/2/18.
//  Copyright © 2018 Gregory Higley. All rights reserved.
//

import XCTest
@testable import DateMath

class DateMathTests: XCTestCase {
    
    func testYesterday() {
        let date = Date()
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/New_York")!
        XCTAssertEqual(date - calendar.timeZone ⁝ .day * 1, calendar.date(byAdding: .day, value: -1, to: date)!)
    }
    
    func testDayAfterTomorrow() {
        let date = Date()
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/Los_Angeles")!
        XCTAssertEqual(date + calendar.timeZone ⁝ .day * 2, calendar.date(byAdding: .day, value: 2, to: date)!)
    }
    
    func testOneHourAndTwoSecondsAgo() {
        let date = Date()
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/New_York")!
        XCTAssertEqual(date - calendar.timeZone ⁝ (.hour * 1 + .second * 2), calendar.date(byAdding: .hour, value: -1, to: calendar.date(byAdding: .second, value: -2, to: date)!)!)
    }
    
    func testNextYear() {
        let date = Date()
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "GMT")!
        XCTAssertEqual(date + calendar.timeZone ⁝ .year * 1, calendar.date(byAdding: .year, value: 1, to: date)!)
    }
    
}
