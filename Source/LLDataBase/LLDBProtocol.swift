//
//  LLDBProtocol.swift
//  LLDataStorage
//
//  Created by Leo on 2020/3/13.
//  Copyright © 2020 LmqLeo. All rights reserved.
//

/// 数据表协议
protocol LLTableProtocol {
    /// 表名
    var name: String {get}
    /// 查找子表
    var select: Select? {get}
    /// 表对应的数据库
    var dataBase: Database {get}
}

/// 数据库协议
protocol LLDataBaseExampleProtocol {
    /// 数据库存放路径
    var path: String {get}
    /// 数据库tag 对应唯一数据库
    var tag: Int {get}
    /// 真实数据库
    var db: Database {get}
}

/// 数据库管理协议
protocol LLDBManagerProtocol {
    // 插入操作
    ///
    /// - Parameters:
    ///   - object: 要插入的对象
    ///   - propertyConvertibleList: 部分插入? 例如 Sample.Properties.identifier
    ///   - databaseName: 用来获取或创建 database
    /// - Returns: 是否成功
    func insert<Object: TableCodable>(
        with objects: [Object],
        on propertyConvertibleList: [PropertyConvertible]?,
        with databaseName: String) -> Bool
    
    /// 插入操作(如果已经存在那么替换)
    ///
    /// - Parameters:
    ///   - object: 要插入的对象
    ///   - propertyConvertibleList: 部分插入? 例如 Sample.Properties.identifier
    ///   - databaseName: 用来获取或创建 database
    /// - Returns: 是否成功
    func insertOrReplace<Object: TableCodable>(
        with objects: [Object],
        on propertyConvertibleList: [PropertyConvertible]?,
        with databaseName: String) -> Bool
    
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
        where condition: Condition?,
        orderBy orderList: [OrderBy]?,
        limit: Limit?,
        offset: Offset?) -> Bool
    
    /// 删除表
    ///
    /// - Parameters:
    ///   - databaseName: 用来获取或创建 database
    ///   - tableName: 要删除的表名
    /// - Returns: 是否成功
    static func deleteTable(
        with databaseName: String,
        from tableName: String) -> Bool
    
    /// 删除数据库
    ///
    /// - Parameter databaseName: 数据库名称
    /// - Returns: 是否删除成功
    static func deleteDatabase(with databaseName: String) -> Bool
    
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
        where condition: Condition?,
        orderBy orderList: [OrderBy]?,
        limit: Limit?,
        offset: Offset?) -> Bool
    
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
        on propertyConvertibleList: [PropertyConvertible],
        where condition: Condition?,
        orderBy orderList: [OrderBy]?,
        limit: Limit?,
        offset: Offset?) -> [Object]?
    
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
                  where condition: Condition?,
                  orderBy orderList: [OrderBy]?,
                  limit: Limit?,
                  offset: Offset?) -> FundamentalValue?
    
    /// 开启事务
    ///
    /// - Parameters:
    ///   - databaseName: 数据库名称
    ///   - transaction: 事务执行模块
    static func run(with databaseName: String,
                    transaction: () -> Void)
    
    /// 数据库设置密码
    ///
    /// - Parameters:
    ///   - databaseName: 数据库名称
    ///   - optionalKey: 密码
    static func setCipher(with databaseName: String,
                          key optionalKey: Data?)
}
