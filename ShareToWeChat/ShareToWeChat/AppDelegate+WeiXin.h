/**********************************************************
 
 代码版权归原作者所有，请尊重源码版本
 *********************************************************** */
//
//  AppDelegate+WeiXin.h
//  ShareToWeChat
//
//  Created by 一波 on 2016/12/25.
//  Copyright © 2016年 一波. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"

@interface AppDelegate (WeiXin)<WXApiDelegate>
// 开放一个方法，给AppDelegate 调用，用来注册微信的
- (void)registToWeChat;
@end
