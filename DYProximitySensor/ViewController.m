//
//  ViewController.m
//  DYProximitySensor
//
//  Created by Ethank on 16/7/22.
//  Copyright © 2016年 DY. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Extension.h"

@interface ViewController ()<UIAccelerometerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *ballImageView;
@property (nonatomic, assign)CGPoint velocity;
@property (nonatomic, assign)BOOL isChangeDirectionX;
@property (nonatomic, assign)BOOL isChangeDirectionY;
@property (nonatomic, assign)CGFloat offSetX;
@property (nonatomic, assign)CGFloat offSetY;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    //距离传感器
//    [self proximity];
    //加速器
//    [self accelerator];
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//=====================距离传感器========================
- (void)proximity {
    //1.开启距离传感器
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    //2.监听有物体靠近设备，系统发出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateDidChanange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
}
//检测
- (void)proximityStateDidChanange:(NSNotification *)note {
    UIDevice *currentDevice = [UIDevice currentDevice];
    if (currentDevice.proximityState) {
        NSLog(@"靠近");
    } else {
        NSLog(@"远离");
    }
}
//=====================加速器========================

- (void)accelerator {
    //1.利用单例获取采集对象
    UIAccelerometer *acc = [UIAccelerometer sharedAccelerometer];
    //2.设置代理
    acc.delegate = self;
    //3.设置采样时间
    acc.updateInterval = 1 / 30.0;
    
}
#pragma mark -UIAccelerometerDelegate
//4.实现方法
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
//    NSLog(@"-----x=%f-----y=%f-----z=%f-------", acceleration.x, acceleration.y, acceleration.z);
    if (!self.isChangeDirectionX ) {
        _velocity.x += acceleration.x;
    } else {
        _velocity.x -= acceleration.x;
        if (_velocity.x >= self.offSetX) {
            self.isChangeDirectionX = NO;
        }
    }
    if (!self.isChangeDirectionY) {
        _velocity.y -= acceleration.y;
    } else {
        _velocity.y += acceleration.y;
        if (_velocity.y >= self.offSetY) {
            self.isChangeDirectionY = NO;
        }
    }
    self.ballImageView.x = _velocity.x;
    self.ballImageView.y = _velocity.y;
    //边界回弹
    if (self.ballImageView.x <= 0) {
        self.ballImageView.x = 0;
//        _velocity.x *= -.5;
        self.isChangeDirectionX = NO;
    }
    if (CGRectGetMaxX(self.ballImageView.frame) >= self.view.width) {
        self.ballImageView.x = self.view.width;
//        _velocity.x *= -.5;
        self.offSetX = _velocity.x*0.5;
        self.isChangeDirectionX = YES;
    }
    if (self.ballImageView.y <= 0) {
        self.ballImageView.y = 0;
//        _velocity.y *= -.5;
        self.isChangeDirectionY = NO;
    }
    if (CGRectGetMaxY(self.ballImageView.frame) >= self.view.height) {
        self.ballImageView.y = self.view.height;
//        _velocity.y *= -.5;
        self.offSetY = _velocity.y*0.5;
        self.isChangeDirectionY = YES;
    }
    NSLog(@"-----x=%f-----y=%f------", acceleration.x, acceleration.y);
}


@end
