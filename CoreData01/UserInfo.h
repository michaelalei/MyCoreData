//
//  UserInfo.h
//  CoreData01
//
//  Created by qianfeng on 14-10-8.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserInfo : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pass;

@end
