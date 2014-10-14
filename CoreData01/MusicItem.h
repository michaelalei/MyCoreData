//
//  MusicItem.h
//  CoreData01
//
//  Created by qianfeng on 14-10-8.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MusicItem : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * mID;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSDate * year;
@property (nonatomic, retain) NSString * linker;

@end
