//
//  CallBackTestManager.m
//  MarryNovo
//
//  Created by Mot on 15/11/4.
//  Copyright © 2015年 Facebook. All rights reserved.
//

#import "SocietyLoginManager.h"
#import "RCTEventDispatcher.h"
#import "OpenShareHeader.h"

@implementation SocietyLoginManager
@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(call) {
  [self _callback];
}

RCT_EXPORT_METHOD(qqLogin) {
  [self _callQQLogin];
}

RCT_EXPORT_METHOD(wechatLogin) {
  [self _callWeichatLogin];
}

RCT_EXPORT_METHOD(weiboLogin) {
  [self _callWeiboLogin];
}


- (void)_callback {
  NSLog(@"Success call native modules");
}

-(void)_callQQLogin {
  
  [OpenShare QQAuth:@"get_user_info" Success:^(NSDictionary *message) {
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"managerCallback"
                                                    body:@{
                                                           @"title": @"QQ登录成功",
                                                           @"res": message
                                                           }
     ];
    
  } Fail:^(NSDictionary *message, NSError *error) {
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"managerCallback"
                                                    body:@{
                                                           @"title": @"QQ登录失败",
                                                           @"res": message,
                                                           @"error": error,
                                                           }
     ];
  }];
}

-(void)_callWeichatLogin {
  [OpenShare WeixinAuth:@"snsapi_userinfo" Success:^(NSDictionary *message) {
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"managerCallback"
                                                    body:@{
                                                           @"title": @"微信登录成功",
                                                           @"res": message
                                                           }
     ];
    
  } Fail:^(NSDictionary *message, NSError *error) {
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"managerCallback"
                                                    body:@{
                                                           @"title": @"微信登录失败",
                                                           @"res": message,
                                                           @"error": error,
                                                           }
     ];
  }];
}

//处理 返回数据中的expirationDate值，因为值的格式有问题，转换成 string 后才能符合 json 的格式要求。 ********开始********
//Commit by Parry at 2016-01-26

- (NSMutableDictionary*)change: (NSDictionary *)message {

  NSMutableDictionary* data = [message mutableCopy];
  if ([message objectForKey:@"expirationDate"]) {
    
    NSDateFormatter *dateToStringFormatter = [[NSDateFormatter alloc] init];
    [dateToStringFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date= [data objectForKey:@"expirationDate"];
    NSString *strDate = [dateToStringFormatter stringFromDate:date];
    
    data = [message mutableCopy];
    
    [data setObject:strDate forKey:@"expirationDate"];
  }
  return data;
  
}

//处理 返回数据中的expirationDate值，因为值的格式有问题，转换成 string 后才能符合 json 的格式要求。 ********结束********

-(void)_callWeiboLogin {
  [OpenShare WeiboAuth:@"all" redirectURI:@"http://sns.whalecloud.com" Success:^(NSDictionary *message) {
    
    NSMutableDictionary* data = [self change:message];
    
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"managerCallback"
                                                    body:@{
                                                           @"title": @"微博登录成功",
                                                           @"res": data,
                                                           }
     ];
  } Fail:^(NSDictionary *message, NSError *error) {
    
    NSMutableDictionary* data = [self change:message];
    
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"managerCallback"
                                                    body:@{
                                                           @"title": @"微博登录失败",
                                                           @"res": data,
                                                           @"error": error
                                                           }
     ];
  }];
}

@end
