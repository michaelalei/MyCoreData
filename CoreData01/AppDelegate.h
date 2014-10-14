//
//  AppDelegate.h
//  CoreData01
//
//  Created by qianfeng on 14-10-8.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//数据映射对象类,将OC中的类对象,映射为Sqlite中的一个字段内容
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//数据模型管理对象
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//存储对象,负责将数据存储到文件中
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//存盘操作
- (void)saveContext;
//获得本地数据库路径
- (NSURL *)applicationDocumentsDirectory;

@end
