//
//  AppDelegate.m
//  CoreData01
//
//  Created by qianfeng on 14-10-8.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import "AppDelegate.h"
#import "UserInfo.h"

//12121
@implementation AppDelegate



@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self addUser] ;
    //查找数据
    [self gainDatas] ;
    return YES;
}

//添加
-(void)addUser
{
    for (int i  = 0 ; i < 10; i++)
    {
        //NSEntityDescription 实体描述对象
        UserInfo * userInfo  = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo"
                                                              inManagedObjectContext:self.managedObjectContext];
        userInfo.name = [NSString stringWithFormat:@"baobao_%d",i];
        NSLog(@"name = %@",userInfo.name);
        userInfo.pass = @"password3";
        
        NSError *error = nil;
        //会将类对象的内容转换为数据库中的数据存储到数据库中
        if (![self.managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        NSLog(@"add success");
    }
}
//查询
-(void)gainDatas
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:self.managedObjectContext]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd]'baobao_1'"];//查询条件
    // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"password='password3'"];//查询条件
    
    NSMutableArray *sortDescriptors = [NSMutableArray array];    //排序用
    [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] ];  //排序用
    
    [fetchRequest setPredicate:predicate];  //查询条件
    [fetchRequest setFetchBatchSize:5];     //分页
    [fetchRequest setSortDescriptors:sortDescriptors];  //排序
    [fetchRequest setReturnsObjectsAsFaults:NO];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:@"name", @"pass", nil]];  //查询的字段，一般不需要
    NSError *error = nil;
    NSArray *fetchedItems = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedItems == nil) {
        NSLog(@"fetch request resulted in an error %@, %@", error, [error userInfo]);
    }
    else
    {
        NSLog(@"fetchedItems=%d",fetchedItems.count);
        for (UserInfo *user in fetchedItems)
        {
            NSLog(@"user.authour=%@",user.name);
             [self deleteUser:user];  //删除
            // [self updateUser:user];  //更新
        }
    }
}
//删除：NSManagedObject对象必须先取出来，用managedObjectContext删除，保存就好
-(void)deleteUser:(id)user
{
    [self.managedObjectContext deleteObject:user];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    NSLog(@"delete success");
}
//更新：直接修改对象，保存managedObjectContext就好
-(void)updateUser:(UserInfo*)user{
    user.name = @"baobao";   //修改后，直接保存managedObjectContext就可以了
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    NSLog(@"update success");
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreData01" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreData01.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
