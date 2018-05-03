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

public indirect enum Expression {
    case unit(Calendar.Component, Int)
    case add(Expression, Expression)
    case tz(TimeZone)
    
    var negated: Expression {
        switch self {
        case let .unit(component, value): return .unit(component, -value)
        case let .add(e1, e2): return .add(e1.negated, e2.negated)
        case .tz: return self
        }
    }
}

public func *(lhs: Calendar.Component, rhs: Int) -> Expression {
    return .unit(lhs, rhs)
}

public func *(lhs: Int, rhs: Calendar.Component) -> Expression {
    return .unit(rhs, lhs)
}

public func +(lhs: Expression, rhs: Expression) -> Expression {
    return .add(lhs, rhs)
}

public func ⁝(lhs: TimeZone, rhs: Expression) -> Expression {
    return .tz(lhs) + rhs
}

public prefix func -(e: Expression) -> Expression {
    return e.negated
}

public func -(lhs: Expression, rhs: Expression) -> Expression {
    return lhs + -rhs
}

