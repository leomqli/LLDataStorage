//
//  LLKeychainProtocol.swift
//  LLDataStorage
//
//  Created by Leo on 2020/3/13.
//  Copyright © 2020 LmqLeo. All rights reserved.
//

/// LLUserDefaultsProtocol 协议
public protocol LLKeychainProtocol  {
    var uniqueKey: String { get }
}

///限定 为String类型 赋值uniqueKey为命名空间 + value 防止key值重复
public extension LLKeychainProtocol where Self: RawRepresentable, Self.RawValue == String {
    var uniqueKey: String {
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        return namespace + "." + "\(rawValue)"
    }
}
