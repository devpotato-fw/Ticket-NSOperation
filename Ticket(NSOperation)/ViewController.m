//
//  ViewController.m
//  Ticket(NSOperation)
//
//  Created by wangfang on 2017/3/2.
//  Copyright © 2017年 onefboy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (assign, nonatomic) NSUInteger ticketCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 先监听线程退出的通知，以便知道线程什么时候退出
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(threadExitNotice)
                                                 name:NSThreadWillExitNotification
                                               object:nil];
    
    _ticketCount = 50;
    
    //1.创建NSInvocationOperation对象
    NSInvocationOperation *operation1 = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:@selector(saleTicket)
                                                                              object:nil];
    operation1.name = @"西安售票中心";
    
    NSInvocationOperation *operation2 = [[NSInvocationOperation alloc] initWithTarget:self
                                                                             selector:@selector(saleTicket)
                                                                               object:nil];
    operation1.name = @"北京售票中心";
    
    // 用NSInvocationOperation建了一个后台线程,并且放到NSOperationQueue中
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 加入队列后，线程自动执行
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    
    
    operation1.completionBlock = ^() {
        NSLog(@"执行完毕%@", [NSThread currentThread]);
    };
    
    operation2.completionBlock = ^() {
        NSLog(@"执行完毕%@", [NSThread currentThread]);
    };
}

- (void)threadExitNotice {
    
    NSLog(@"%@", [NSThread currentThread]);
}

- (void)saleTicket {
    while (1) {
        // 添加同步锁
        @synchronized(self) {
            //如果还有票，继续售卖
            if (_ticketCount > 0) {
                _ticketCount --;
                NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", _ticketCount, [NSThread currentThread].name]);
                [NSThread sleepForTimeInterval:0.2];
            }
            //如果已卖完，关闭售票窗口
            else {
                break;
            }
        }
    }
}

@end
