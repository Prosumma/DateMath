//
//  Date.swift
//  DateMath
//
//  Created by Gregory Higley on 5/2/18.
//  Copyright © 2018 Gregory Higley. All rights reserved.
//

import Foundation

private func add(to date: Date, expression: Expression) -> (Date, TimeZone) {
    switch expression {
    case .unit:
        return add(to: date, expression: .tz(.current) + expression)
    case let .add(.tz(timeZone), .unit(component, value)):
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        return (calendar.date(byAdding: component, value: value, to: date)!, timeZone)
    case let .add(.tz(timeZone), .add(e1, e2)):
        let tz = Expression.tz(timeZone)
        return add(to: date, expression: (tz + e1) + (tz + e2))
    case let .add(.tz, .tz(timeZone)):
        return (date, timeZone)
    case let .add(e1, e2):
        let (date, timeZone) = add(to: date, expression: e1)
        return add(to: date, expression: .tz(timeZone) + e2)
    case let .tz(timeZone):
        return (date, timeZone)
    }
}

public func +(lhs: Date, rhs: Expression) -> Date {
    let (date, _) = add(to: lhs, expression: rhs)
    return date
}

public func +(lhs: Expression, rhs: Date) -> Date {
    return rhs + lhs
}

public func +=(lhs: inout Date, rhs: Expression) {
    let (date, _) = add(to: lhs, expression: rhs)
    lhs = date
}

public func -(lhs: Date, rhs: Expression) -> Date {
    return lhs + -rhs
}

public func -=(lhs: inout Date, rhs: Expression) {
    lhs = lhs - rhs
}

