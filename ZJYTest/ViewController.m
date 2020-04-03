//
//  ViewController.m
//  ZJYTest
//
//  Created by 王学文 on 2018/1/17.
//  Copyright © 2018年 王学文. All rights reserved.
//

#import "ViewController.h"
#import "SHConfigNetworkingView.h"
#import "Masonry.h"

@interface ViewController ()

@property (strong, nonatomic) UIButton *testButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 测试git 回滚问题哈哈哈哈
    [self.view setNeedsUpdateConstraints];
    
    [self.view addSubview:self.testButton];
    
    [self.testButton addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark -Layout
- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    [self.testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
        
    }];
}

#pragma mark -testAction
-(void)testAction:(UIButton *)sender {
    
    if ([sender.currentTitle isEqualToString:@"取消配置"]) {
        [sender setTitle:@"配置成功" forState:UIControlStateNormal];
        [SHConfigNetworkingView showConfigurationNetworkWithStatus:^(SHConfigurationStatus configStatus) {
            NSLog(@"执行类型：%ld", configStatus);
        }];
    } else if ([sender.currentTitle isEqualToString:@"配置成功"]) {
        [sender setTitle:@"配置失败" forState:UIControlStateNormal];
        [SHConfigNetworkingView showConfigurationNetworkWithStatus:^(SHConfigurationStatus configStatus) {
            NSLog(@"执行类型：%ld", configStatus);

        }];
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [SHConfigNetworkingView successConfigurationNetworkingStatus:^(SHConfigurationStatus configStatus) {
                NSLog(@"执行类型：%ld", configStatus);

            }];
        });
        
    } else if ([sender.currentTitle isEqualToString:@"配置失败"]) {
        [sender setTitle:@"配置wifi" forState:UIControlStateNormal];
        [SHConfigNetworkingView showConfigurationNetworkWithStatus:^(SHConfigurationStatus configStatus) {
            NSLog(@"执行类型：%ld", configStatus);

        }];
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [SHConfigNetworkingView failureConfigurationNetworkingStatusIndependentDevice:NO operation:^(SHConfigurationStatus configStatus) {
                
            }];
        });
        
    } else if ([sender.currentTitle isEqualToString:@"配置wifi"]) {
        [sender setTitle:@"取消配置" forState:UIControlStateNormal];
        [SHConfigNetworkingView sharedView].leftButtonTitle = @"左标题";
        [SHConfigNetworkingView showConfigurationNetworkWithStatus:^(SHConfigurationStatus configStatus) {
            NSLog(@"执行类型：%ld", configStatus);

        }];
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [SHConfigNetworkingView failureConfigurationNetworkingStatusIndependentDevice:YES operation:^(SHConfigurationStatus configStatus) {
                NSLog(@"执行类型：%ld", configStatus);

            }];
        });
        
    }
}


#pragma mark -Getter
-(UIButton *)testButton {
    if (!_testButton) {
        _testButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_testButton setTitle:@"取消配置" forState:UIControlStateNormal];
        [_testButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    return _testButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
