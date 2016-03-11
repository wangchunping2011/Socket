//
//  ClientViewController.m
//  SocketDemo
//
//  Created by 王春平 on 16/3/11.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "ClientViewController.h"
#import <GCDAsyncSocket.h>

@interface ClientViewController ()<GCDAsyncSocketDelegate>

@property (weak, nonatomic) IBOutlet UITextField *hostTf;
@property (weak, nonatomic) IBOutlet UITextField *portTf;
@property (weak, nonatomic) IBOutlet UITextField *messageTf;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) GCDAsyncSocket *clientSocket;

@end

@implementation ClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - handle action

- (IBAction)connectAction:(UIButton *)sender {
    self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    BOOL result = [self.clientSocket connectToHost:self.hostTf.text onPort:[self.portTf.text intValue] error:&error];
    if (result) {
        self.textView.text = [self.textView.text stringByAppendingString:@"\n链接成功"];
    } else {
        self.textView.text = [self.textView.text stringByAppendingString:@"\n连接失败"];
    }
}

- (IBAction)sendMessageAction:(UIButton *)sender {
    NSData *data = [self.messageTf.text dataUsingEncoding:NSUTF8StringEncoding];
    [self.clientSocket writeData:data withTimeout:-1 tag:0];
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    self.textView.text = [self.textView.text stringByAppendingFormat:@"\n成功连接服务器：%@", host];
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    self.textView.text = [self.textView.text stringByAppendingString:@"\n消息发送成功"];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.textView.text = [self.textView.text stringByAppendingFormat:@"\n接收消息成功：%@", message];
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
