//
//  Utilities.swift
//  lancerhacks
//
//  Created by Vidit Agrawal on 2/27/21.
//


import Foundation
class Utilities
{
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
}
