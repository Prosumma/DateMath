//
//  Date.swift
//  DateMath
//
//  Created by Gregory Higley on 5/2/18.
//  Copyright © 2018 Gregory Higley. All rights reserved.
//

import Foundation

/**
 Recursively and immutably performs date math operations.
 
 This function often rewrites the expression tree as it processes
 in order to deal with time zones.
 */
private func add(to date: Date, expression: Expression) -> (Date, TimeZone) {
    switch expression {
    case .add:
        return add(to: date, expression: .tz(.current) + expression)
    case let .combine(.tz(timeZone), .add(component, value)):
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        return (calendar.date(byAdding: component, value: value, to: date)!, timeZone)
    case let .combine(.tz, .combine(.tz(timeZone), e2)):
        return add(to: date, expression: .tz(timeZone) + e2)
    case let .combine(.tz(timeZone), .combine(e1, e2)):
        let tz = Expression.tz(timeZone)
        return add(to: date, expression: (tz + e1) + (tz + e2))
    case let .combine(.tz, .tz(timeZone)):
        return (date, timeZone)
    case let .combine(e1, e2):
        let (date, timeZone) = add(to: date, expression: e1)
        return add(to: date, expression: .tz(timeZone) + e2)
    case let .tz(timeZone):
        return (date, timeZone)
    }
}

/// Returns the result of adding the `Expression` `rhs` to the `Date` `lhs`.
public func +(lhs: Date, rhs: Expression) -> Date {
    let (date, _) = add(to: lhs, expression: rhs)
    return date
}

/// Returns the result of adding the `Expression` `lhs` to the `Date` `rhs`.
public func +(lhs: Expression, rhs: Date) -> Date {
    return rhs + lhs
}

/// Sets the `Date` on the left hand side to itself added to the `Expression` on the right-hand side.
public func +=(lhs: inout Date, rhs: Expression) {
    let (date, _) = add(to: lhs, expression: rhs)
    lhs = date
}

/// Returns the result of substracting the `Expression` on the right-hand side from the `Date` on the left.
public func -(lhs: Date, rhs: Expression) -> Date {
    return lhs + -rhs
}

/// Sets the `Date` on the left hand to itself subtracting the `Expression` on the right hand.
public func -=(lhs: inout Date, rhs: Expression) {
    lhs = lhs - rhs
}

