//
//  TimeStamp.swift
//  STimer
//
//  Created by Anna on 29.08.2021.
//

import Foundation
import RealmSwift

class TimeStamp: Object {
    @objc dynamic var time: Int = 0
    @objc dynamic var date: NSDate? = nil
}
