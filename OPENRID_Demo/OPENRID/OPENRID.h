//
//  OPENJLID.h
//  OPENJLID
//
//  Created by gaodun on 15/10/28.
//  Copyright © 2015年 haust. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OPENID : NSObject
+ (NSString *)openID;
@end

@interface UIApplication(OPENID)
- (NSArray *)scheduledLocalNotificationsOveride;
@end