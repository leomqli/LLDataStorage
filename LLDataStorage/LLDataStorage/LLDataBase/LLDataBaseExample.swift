//
//  LLDataBaseExample.swift
//  LLDataStorage
//
//  Created by Leo on 2020/3/13.
//  Copyright © 2020 LmqLeo. All rights reserved.
//

/// 数据库
enum LLDataBaseExample: String, LLDataBaseExampleProtocol {
    
    /// 学习
    case study = "Study.db"
    /// 课表
    case courseList = "CourseList.db"
    /// 课程页
    case courseDetail = "CourseDetail.db"

    /// 沙盒document路径
    static let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                  .userDomainMask, true).first!

    /// 数据库文件路径
    var path: String {
        return LLDataBaseExample.documentPath + "/" + rawValue
    }

    /// 数据库标签
    var tag: Int {
        switch self {
        case .study:
            return 2020 + 1
        case .courseList:
            return 2020 + 2
        case .courseDetail:
            return 2020 + 3
        }
    }

    /// 真实数据库
    var db: Database {
        let db = Database(withPath: path)
        db.tag = tag
        return db
    }
}

/// 表
enum LLTableName: String, LLTableProtocol {

    /// 学习首页
    case study = "Study"
    /// 课表
    case courseList = "CourseList"
    /// 课程页
    case courseDetail = "CourseDetail"
    
    /// 具体的表名
    var name: String {
        return rawValue
    }

    /// 查询，提前做好查询对象创建
    var select: Select? {
        var select: Select?
//        switch self {
//        case .study:
//            select = try? dataBase.prepareSelect(of: User.self, fromTable: name, isDistinct: true)
//        case .courseList:
//            select = try? dataBase.prepareSelect(of: Gesture.self, fromTable: name, isDistinct: false)
//        case .courseDetail:
//            select = try? dataBase.prepareSelect(of: UserAccount.self, fromTable: name, isDistinct: true)
//        }
        return select
    }
    
    /// 表对应的数据库
    var dataBase: Database {
        switch self {
        case .study:
            return LLDataBaseExample.study.db
        case .courseList:
            return LLDataBaseExample.courseList.db
        case .courseDetail:
            return LLDataBaseExample.courseDetail.db
        }
    }
}

