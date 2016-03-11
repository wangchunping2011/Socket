//
//  ViewController.m
//  SocketDemo
//
//  Created by 王春平 on 16/3/11.
//  Copyright © 2016年 wang. All rights reserved.
//

/**
 *  测试步骤：服务器监听-----客户端链接------ 客户端（或服务器）发送消息------服务器（或客户端）接收消息
     测试IP地址：127.0.0.1或当前网络IP地址（如192.168.1.150）
     测试端口号：8080
 */

#import "ServerViewController.h"
#import <GCDAsyncSocket.h>

@interface ServerViewController ()<GCDAsyncSocketDelegate>

@property (weak, nonatomic) IBOutlet UITextField *portTf;
@property (weak, nonatomic) IBOutlet UITextField *messageTf;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) GCDAsyncSocket *clientSocket;
@property (nonatomic, strong) GCDAsyncSocket *serverSocket;

@end

@implementation ServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - handle action

- (IBAction)listenAction:(UIButton *)sender {
    self.serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    BOOL result = [self.serverSocket acceptOnPort:[self.portTf.text intValue] error:&error];
    if (result) {
        self.textView.text = [self.textView.text stringByAppendingString:@"\n监听成功"];
    } else {
        self.textView.text = [self.textView.text stringByAppendingString:@"\n监听失败"];
    }
}

- (IBAction)sendMessageAction:(UIButton *)sender {
    NSData *data = [self.messageTf.text dataUsingEncoding:NSUTF8StringEncoding];
    [self.clientSocket writeData:data withTimeout:-1 tag:0];
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    self.clientSocket = newSocket;
    [self.clientSocket readDataWithTimeout:-1 tag:0];
    self.textView.text = [self.textView.text stringByAppendingFormat:@"\n成功链接：%@", newSocket.connectedHost];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.textView.text = [self.textView.text stringByAppendingFormat:@"\n成功接收消息：%@", message];
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    self.textView.text = [self.textView.text stringByAppendingString:@"\n消息发送成功"];
}

@end
