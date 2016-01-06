//
//  OPENJLID.m
//  OPENJLID
//
//  Created by gaodun on 15/10/28.
//  Copyright © 2015年 haust. All rights reserved.
//

#define SAVEKEY @"saveidkeyThisjustaKey"


#import "OPENRID.h"
#import <objc/runtime.h>

@implementation OPENRID


+ (NSString *)uniqueID
{
    if ([self getLocalID]) {
        return [self getLocalID];
    } else {
        return [self creatLocalID];
    }
}

+ (NSString*)getLocalID
{
    NSArray *notiArr=[[UIApplication sharedApplication] scheduledLocalNotificationsOveride];
    for (int i=0; i<notiArr.count; i++)
    {
        UILocalNotification *myLocalNotification = [notiArr objectAtIndex:i];
        NSDictionary *userInfo = myLocalNotification.userInfo;
        NSString *codeID = [userInfo objectForKey:SAVEKEY];
        
        if (codeID)
        {
            return codeID;
        }
    }
    return nil;
}
+ (NSString *)creatLocalID
{
    NSString * codeID = [self generateLocalID];
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    notification.fireDate = [NSDate distantFuture];
    notification.applicationIconBadgeNumber= 0;
    notification.timeZone=[NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.repeatInterval = 0;
    NSDictionary* info = [NSDictionary dictionaryWithObject:codeID forKey:SAVEKEY];
    notification.userInfo = info;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    return codeID;
}
+ (NSString *)generateLocalID
{
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSString * code = [NSString stringWithFormat:@"%x%@%x",arc4random(),@(timeStamp),arc4random()];
    return [code stringByReplacingOccurrencesOfString:@"." withString:@"x"];
}

@end
@implementation UIApplication(OPENID)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(scheduledLocalNotifications);
        SEL swizzledSelector = @selector(scheduledLocalNotificationsOveride);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
        
        //2.
        originalSelector = @selector(cancelAllLocalNotifications);
        swizzledSelector = @selector(cancelAllLocalNotificationsOveride);
        
        originalMethod = class_getInstanceMethod(class, originalSelector);
        swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
    });
}
- (NSArray *)scheduledLocalNotificationsOveride
{
    
    NSArray * notiAll = [self scheduledLocalNotificationsOveride];
    NSMutableArray * mArr = [NSMutableArray array];
    for (int i = 0; i < notiAll.count; i ++) {
        UILocalNotification * local = notiAll[i];
        if ([local.userInfo objectForKey:SAVEKEY] == nil || [[local.userInfo objectForKey:SAVEKEY] isKindOfClass:[NSNull class]]) {
            [mArr addObject:local];
        };
    }
    return [NSArray arrayWithArray:mArr];
}
- (void)cancelAllLocalNotificationsOveride
{
    NSArray * notiAll = [self scheduledLocalNotifications];
    for (int i = 0; i < notiAll.count; i ++) {
        [self cancelLocalNotification:notiAll[i]];
    }
}
@end

