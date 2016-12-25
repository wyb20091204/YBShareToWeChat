/**********************************************************

代码版权归原作者所有，请尊重源码版本
*********************************************************** */

//
//  AppDelegate+WeiXin.m
//  ShareToWeChat
//
//  Created by 一波 on 2016/12/25.
//  Copyright © 2016年 一波. All rights reserved.
//

#import "AppDelegate+WeiXin.h"

// 微信appId
#define kWeiChatAppId  @"wx"

@implementation AppDelegate (WeiXin)

- (void)registToWeChat{
    // 向微信注册
    [WXApi registerApp:kWeiChatAppId];
    
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    return [WXApi handleOpenURL:url delegate:self];
}


#pragma mark WXApiDelegate 微信分享的相关回调

// onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
- (void)onReq:(BaseReq *)req{
    NSLog(@"自己可以测测这个onReq 什么时候调用哦");
}

// 如果第三方应用（你的应用）向微信发送sendReq请求（比如发送分享请求会有调sendReq请求），然后就会有onResp被回调
- (void)onResp:(BaseResp *)resp{
    // 这里的errCode 在WXApiObject.h  里有具体枚举，想要看详情可以自己去看 我这里失败统一处理为失败
    
    // 处理 分享请求 回调
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        switch (resp.errCode) {
            case WXSuccess:
                [self showAlertWithmessage:@"分享成功"];
                break;
            default:
                [self showAlertWithmessage:@"分享失败"];
                break;
        }
    }
    // 处理 登录授权请求 回调
    else if ([resp isKindOfClass:[SendAuthResp class]]) {
        switch (resp.errCode) {
            case WXSuccess:
                [self showAlertWithmessage:@"微信授权成功"];
                break;
            default:
                [self showAlertWithmessage:@"微信授权失败"];
                break;
        }
    }
}

- (void)showAlertWithmessage:(NSString *)message{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}



@end
