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
    
    func testExample() {
        let date = Date()
        print(date + TimeZone(identifier: "UTC")! ⁝ .month * 2 + .current ⁝ .day * 4)
    }
    
}
