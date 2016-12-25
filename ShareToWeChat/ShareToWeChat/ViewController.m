/**********************************************************
 
 代码版权归原作者所有，请尊重源码版本
 *********************************************************** */
//
//  ViewController.m
//  ShareToWeChat
//
//  Created by 一波 on 2016/12/25.
//  Copyright © 2016年 一波. All rights reserved.
//

#import "ViewController.h"
#import "WXApi.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *shareTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *shareDesciptionTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)clickedToTimeLine:(id)sender {
    
    [self shareToWeChat:WXSceneTimeline isText:YES];
}

- (IBAction)clickedToSession:(id)sender {
    
    [self shareToWeChat:WXSceneSession isText:YES];
    
}

- (IBAction)shareUrlToTimeLine:(id)sender {
    [self shareToWeChat:WXSceneTimeline isText:NO];
}


- (IBAction)shareUrlToSession:(id)sender {
    [self shareToWeChat:WXSceneSession isText:NO];
}


- (void)shareToWeChat:(int)scene isText:(BOOL)isText{
    
    if ([WXApi isWXAppInstalled]) {
        if ([WXApi isWXAppSupportApi]) {
            if (isText) {
                if ([self judgeTextLength]){
                    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                    req.text = [NSString stringWithFormat:@"标题：%@\n描述：%@",self.shareTitleTextField.text,self.shareDesciptionTextField.text];
                    req.bText = YES;
                    req.scene = scene;
                    [WXApi sendReq:req];
                } else {
                    [self showAlertWithMessage:@"分享的东西是啥啊，没填完吧" buttonTitle:@"是的"];
                }
            } else {
                if ([self judgeTextLength]){
                    WXMediaMessage *message = [WXMediaMessage message];
                    // 这里这个title 和description 好像很好玩的，
                    // 在分享到朋友圈的时候是没有description的，只有title
                    // 但是分享到盆友的时候又是有description的
                    message.title = self.shareTitleTextField.text;
                    message.description = self.shareDesciptionTextField.text;
                    
                    WXWebpageObject *webpageObject = [WXWebpageObject object];
                    webpageObject.webpageUrl = @"www.baidu.com";
                    message.mediaObject = webpageObject;
                    [message setThumbImage:[UIImage imageNamed:@"share_icon"]];
                    
                    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                    req.bText = NO;
                    req.message = message;
                    req.scene = scene;
                    [WXApi sendReq:req];
                } else {
                    [self showAlertWithMessage:@"分享的东西是啥啊，没填完吧" buttonTitle:@"是的"];
                }
            }
         } else {
            
            [self showAlertWithMessage:@"当前微信版本不支持分享，请升级您的微信" buttonTitle:@"去AppStore升级"];
        }
    } else {
        
        [self showAlertWithMessage:@"您还没有安装微信" buttonTitle:@"去AppStore下载"];
    }
}

- (BOOL)judgeTextLength{
    if (self.shareTitleTextField.text.length ||
        self.shareDesciptionTextField.text.length) {
        return YES;
    } else {
        return NO;
    }
}

- (void)showAlertWithMessage:(NSString *)message buttonTitle:(NSString *)buttonTitle{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![buttonTitle isEqualToString:@"是的"]) {
            NSString *weChatUrl = [WXApi getWXAppInstallUrl];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:weChatUrl]];
        }
    }];
    [alert addAction:cancleAction];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.shareTitleTextField resignFirstResponder];
    [self.shareDesciptionTextField resignFirstResponder];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
