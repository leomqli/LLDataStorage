//
//  LLKeychainManager.swift
//  LLDataStorage
//
//  Created by Leo on 2020/3/13.
//  Copyright © 2020 LmqLeo. All rights reserved.
//

/// 重写subscript方法 为LLKeychainManager添加下标赋值法
public class LLKeychainManager {
    
    private lazy var keychain: KeychainSwift = {
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        return keychain
    }()
    
    /// 只支持存储String Data Bool 其他类型会保存失败
    public static let standard = LLKeychainManager()
    private init() { }
    
    public subscript(key: LLKeychainProtocol) -> Any? {
        set {
            if let newValue = newValue as? String {
                keychain.set(newValue, forKey: key.uniqueKey)
                return
            }
            if let newValue = newValue as? Bool {
                keychain.set(newValue, forKey: key.uniqueKey)
                return
            }
            if let newValue = newValue as? Data {
                keychain.set(newValue, forKey: key.uniqueKey)
                return
            }
            assert(false, "请传入可被保存的类型 类型限定为 String/Bool/Data")
        }
        get {
            if let value = keychain.get(key.uniqueKey), value != "\u{01}", value != "\0", value != "" {
                return value
            }
            if let value = keychain.getBool(key.uniqueKey) {
                return value
            }
            if let value = keychain.getData(key.uniqueKey) {
                return  value
            }
            return nil
        }
    }
}
