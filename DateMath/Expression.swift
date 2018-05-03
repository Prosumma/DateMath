//
//  CalendarExpression.swift
//  DateMath
//
//  Created by Gregory Higley on 5/2/18.
//  Copyright © 2018 Gregory Higley. All rights reserved.
//

import Foundation

precedencegroup TimeZonePrecedence {
    associativity: right
    lowerThan: MultiplicationPrecedence
    higherThan: AdditionPrecedence
}

infix operator ⁝: TimeZonePrecedence

/**
 A DateMath expression.
 
 The only supported operation in date math is addition.
 (Subtraction is just the addition of a negative number.)
 */
public indirect enum Expression {
    /// Adds `Int` units of `Calendar.Component`. The units may be negative.
    case add(Calendar.Component, Int)
    /// Adds the expression on the right then the one on the left.
    case combine(Expression, Expression)
    /// Changes the time zone.
    case tz(TimeZone)
    
    /// (Recursively) negates the `Expression`.
    var negated: Expression {
        switch self {
        case let .add(component, value): return .add(component, -value)
        case let .combine(e1, e2): return .combine(e1.negated, e2.negated)
        case .tz: return self
        }
    }
}

/**
 Creates an `Expression` specifying the number of units of a
 calendar component, e.g., `.day * 2` means "2 days".
 */
public func *(lhs: Calendar.Component, rhs: Int) -> Expression {
    return .add(lhs, rhs)
}

/**
 Creates an `Expression` specifying the number of units of a
 calendar component, e.g., `2 * .day` means "2 days".
 */
public func *(lhs: Int, rhs: Calendar.Component) -> Expression {
    return .add(rhs, lhs)
}

/**
 Creates an expression which is the result of combining
 the two sub-expressions together.
 */
public func +(lhs: Expression, rhs: Expression) -> Expression {
    return .combine(lhs, rhs)
}

/**
 Sets the time zone.
 
 Setting the time zone applies to all expressions to the
 right of this one:
 
 ```
 .current ⁝ .day * 2
 ```
 
 This says that `.day * 2` should be applied in the current
 time zone. The right-most time zone in a sequence of time zones
 supercedes all others:
 
 ```
 tz1 ⁝ tz2 ⁝ tz3 ⁝ .day * 2 - .second * 1
 ```
 
 In the expression above, only `tz3` will have any force.
 */
public func ⁝(lhs: TimeZone, rhs: Expression) -> Expression {
    return .tz(lhs) + rhs
}

/// (Recursively) negates the expression
public prefix func -(e: Expression) -> Expression {
    return e.negated
}

/// Subtracts the second expression from the first.
public func -(lhs: Expression, rhs: Expression) -> Expression {
    return lhs + -rhs
}

