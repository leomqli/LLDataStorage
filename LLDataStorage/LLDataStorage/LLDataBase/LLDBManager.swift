//
//  LLDBManager.swift
//  LLDataStorage
//
//  Created by Leo on 2020/3/13.
//  Copyright © 2020 LmqLeo. All rights reserved.
//

class LLDBManager {
    
    /// database路径
    private static let databasePath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                          .userDomainMask,
                                                                          true).first!
    
    /// 命名空间
    private static let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
    
    ///单例
    static let shared = LLDBManager()
    private init() {}
    
//    static let db = Database(withPath: dbPath)
    
    /// 创建/获取数据库
    ///
    /// - Parameter name: 名称
    /// - Returns: 数据库
    static func creatDatabase(with name: String) -> Database {
        let path = getDBPath(with: name)
        let database = Database(withPath: path)
        return database
    }
    
    static func getDBPath(with name: String) -> String {
        let path = databasePath + "/" + namespace + "/" + name + ".db"
        return path
    }
}

extension LLDBManager: LLDBManagerProtocol {
    
    /// 插入操作
    ///
    /// - Parameters:
    ///   - object: 要插入的对象
    ///   - propertyConvertibleList: 部分插入? 例如 Sample.Properties.identifier
    ///   - databaseName: 用来获取或创建 database
    /// - Returns: 是否成功
    func insert<Object: TableCodable>(
        with objects: [Object],
        on propertyConvertibleList: [PropertyConvertible]? = nil,
        with databaseName: String) -> Bool {
        
        let database = LLDBManager.creatDatabase(with: databaseName)
        
        do {
            try database.create(table: "\(Object.self)",
                of: Object.self)
            try database.insert(objects: objects,
                                on: propertyConvertibleList,
                                intoTable: "\(Object.self)")
            return true
        } catch let error {
            print(error)
            return false
        }
    }
    
    /// 插入操作(如果已经存在那么替换)
    ///
    /// - Parameters:
    ///   - object: 要插入的对象
    ///   - propertyConvertibleList: 部分插入? 例如 Sample.Properties.identifier
    ///   - databaseName: 用来获取或创建 database
    /// - Returns: 是否成功
    func insertOrReplace<Object: TableCodable>(
        with objects: [Object],
        on propertyConvertibleList: [PropertyConvertible]? = nil,
        with databaseName: String) -> Bool {
        
        let database = LLDBManager.creatDatabase(with: databaseName)
        do {
            try database.create(table: "\(Object.self)",
                of: Object.self)
            try database.insertOrReplace(objects: objects,
                                         on: propertyConvertibleList,
                                         intoTable: "\(Object.self)")
            return true
        } catch let error {
            print(error)
            return false
        }
    }
    
    /// 删除操作 如只设置表名 表示需要删除整个表的数据,当时不会删除表本身
    ///
    /// - Parameters:
    ///   - databaseName: 用来获取或创建 database
    ///   - tableName: 表名
    ///   - condition: 符合删除的条件
    ///   - orderList: 排序的方式
    ///   - limit: 删除的个数
    ///   - offset: 从第几个开始删除
    ///   - Returns: 是否删除成功
    func delete(
        with databaseName: String,
        from tableName: String,
        where condition: Condition? = nil,
        orderBy orderList: [OrderBy]? = nil,
        limit: Limit? = nil,
        offset: Offset? = nil) -> Bool {
        
        let database = LLDBManager.creatDatabase(with: databaseName)
        do {
            try database.delete(fromTable: tableName,
                                where: condition,
                                orderBy: orderList,
                                limit: limit,
                                offset: offset)
            return true
        } catch let error {
            print(error)
            return false
        }
    }
    
    /// 删除表
    ///
    /// - Parameters:
    ///   - databaseName: 用来获取或创建 database
    ///   - tableName: 要删除的表名
    /// - Returns: 是否成功
    static func deleteTable(
        with databaseName: String,
        from tableName: String) -> Bool {
        
        let database = creatDatabase(with: databaseName)
        do {
            try database.drop(table: tableName)
            return true
        } catch let error {
            print(error)
            return false
        }
    }
    
    /// 删除数据库
    ///
    /// - Parameter databaseName: 数据库名称
    /// - Returns: 是否删除成功
    static func deleteDatabase(with databaseName: String) -> Bool {
        do {
            let path = getDBPath(with: databaseName)
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch  {
            return false
        }
    }
    
    /// 更新操作
    ///
    /// - Parameters:
    ///   - databaseName: 用来获取database
    ///   - tableName: 表名
    ///   - propertyConvertibleList: 要修改的字段
    ///   - object: 根据这个object得内容修改
    ///   - condition: 符合修改的条件
    ///   - orderList: 排序方式
    ///   - limit: 删除的个数
    ///   - offset: 从第几个开始删除
    /// - Returns: 是否更新成功
    func update<Object: TableCodable>(
        with databaseName: String,
        from tableName: String,
        on propertyConvertibleList: [PropertyConvertible],
        with object: Object,
        where condition: Condition? = nil,
        orderBy orderList: [OrderBy]? = nil,
        limit: Limit? = nil,
        offset: Offset? = nil) -> Bool {
        
        let database = LLDBManager.creatDatabase(with: databaseName)
        do {
            let list = propertyConvertibleList.isEmpty ? Object.Properties.all : propertyConvertibleList
            try database.update(table: tableName,
                                on: list,
                                with: object,
                                where: condition,
                                orderBy: orderList,
                                limit: limit,
                                offset: offset)
            return true
        } catch let error {
            print(error)
            return false
        }
    }
    
    /// 获取数据
    ///
    /// - Parameters:
    ///   - databaseName: 用来获取database
    ///   - tableName: 表名
    ///   - propertyConvertibleList: 构成部分获取的方式 要获取的字段
    ///   - condition: 符合获取的条件
    ///   - orderList: 排序方式
    ///   - limit: 获取的个数
    ///   - offset: 从第几个开始获取
    /// - Returns: 结果
    func get<Object: TableCodable>(
        with databaseName: String,
        from tableName: String,
        on propertyConvertibleList: [PropertyConvertible] = [],
        where condition: Condition? = nil,
        orderBy orderList: [OrderBy]? = nil,
        limit: Limit? = nil,
        offset: Offset? = nil) -> [Object]? {
        
        let database = LLDBManager.creatDatabase(with: databaseName)
        let list = propertyConvertibleList.isEmpty ? Object.Properties.all : propertyConvertibleList
        let object: [Object]? = try? database.getObjects(
            on: list,
            fromTable: tableName,
            where: condition,
            orderBy: orderList,
            limit: limit,
            offset: offset)
        return object
    }
    
    /// 获取value
    ///
    /// - Parameters:
    ///   - databaseName: 用来获取database
    ///   - tableName: 表名
    ///   - propertyConvertible: 获取哪个字段?
    ///   - condition: 符合获取的条件
    ///   - orderList: 排序方式
    ///   - limit: 获取的个数
    ///   - offset: 从第几个开始获取
    /// - Returns: 结果
    func getValue(with databaseName: String,
                  from tableName: String,
                  on propertyConvertible: ColumnResultConvertible,
                  where condition: Condition? = nil,
                  orderBy orderList: [OrderBy]? = nil,
                  limit: Limit? = nil,
                  offset: Offset? = nil) -> FundamentalValue? {
        let database = LLDBManager.creatDatabase(with: databaseName)
        let value = try? database.getValue(on: propertyConvertible,
                                           fromTable: tableName,
                                           where: condition,
                                           orderBy: orderList,
                                           limit: limit,
                                           offset: offset)
        return value
    }
    
    /// 开启事务
    ///
    /// - Parameters:
    ///   - databaseName: 数据库名称
    ///   - transaction: 事务执行模块
    static func run(with databaseName: String,
                    transaction: () -> Void) {
        let database = creatDatabase(with: databaseName)
        try? database.run(transaction: transaction)
    }
    
    /// 数据库设置密码
    ///
    /// - Parameters:
    ///   - databaseName: 数据库名称
    ///   - optionalKey: 密码
    static func setCipher(with databaseName: String,
                          key optionalKey: Data?) {
        let database = creatDatabase(with: databaseName)
        database.setCipher(key: optionalKey)
    }
}
