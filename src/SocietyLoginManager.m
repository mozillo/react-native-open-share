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

-(void)_callWeiboLogin {
  [OpenShare WeiboAuth:@"all" redirectURI:@"http://openshare.gfzj.us/" Success:^(NSDictionary *message) {
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"managerCallback"
                                                    body:@{
                                                           @"title": @"微博登录成功",
                                                           @"res": message,
                                                           }
     ];
  } Fail:^(NSDictionary *message, NSError *error) {
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"managerCallback"
                                                    body:@{
                                                           @"title": @"微博登录失败",
                                                           @"res": message,
                                                           @"error": error
                                                           }
     ];
  }];
}

@end
