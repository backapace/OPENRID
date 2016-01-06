//
//  OPENJLID.h
//  OPENJLID
//
//  Created by gaodun on 15/10/28.
//  Copyright © 2015年 haust. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OPENRID : NSObject
+ (NSString *)uniqueID;
@end

@interface UIApplication(OPENID)
- (NSArray *)scheduledLocalNotificationsOveride;
@end