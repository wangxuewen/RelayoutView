//
//  SHConfigNetworkingView.m
//  ZhuJiaYiApplication
//
//  Created by 王学文 on 2017/12/29.
//  Copyright © 2017年 zhujiayi. All rights reserved.
//

#import "SHConfigNetworkingView.h"
#import "Masonry.h"

@interface SHConfigNetworkingView ()

@property (strong, nonatomic) UIView *backGroundView;
@property (strong, nonatomic) UIView *promptInfoView;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UIImageView *animationImageView;
@property (strong, nonatomic) UILabel *promptInfoLabel;
@property (strong, nonatomic) UIView *separatorLineView;
@property (strong, nonatomic) UIButton *nextButton; 
@property (strong, nonatomic) UIView *nextWifiSeparatorView;
@property (strong, nonatomic) UIButton *wifiConfigButton;
@property (strong, nonatomic) UIView *wifiOpeartionSeparatorView;
@property (strong, nonatomic) UIButton *operationButton;


@property (copy, nonatomic)ConfigStatus operationBlock;

@end

@implementation SHConfigNetworkingView

+ (SHConfigNetworkingView*)sharedView {
    static dispatch_once_t once;
    
    static SHConfigNetworkingView *sharedView;
#if !defined(SV_APP_EXTENSIONS)
    dispatch_once(&once, ^{ sharedView = [[self alloc] initWithFrame:[[[UIApplication sharedApplication] delegate] window].bounds]; });
#else
    dispatch_once(&once, ^{ sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; });
#endif
   
    return sharedView;
}

+ (void)settingConfigStatus:(SHConfigurationStatus)configStatus {
    switch (configStatus) {
        case SHConfigurationStatusCancel: {
            [self sharedView].animationImageView.hidden = NO;
            [self sharedView].iconImageView.hidden = YES;
            [self sharedView].animationImageView.animationDuration = 1.0;
            //设置重复次数,0表示不重复
            [self sharedView].animationImageView.animationRepeatCount = 0;
            [[self sharedView].animationImageView setAnimationImages:[NSArray arrayWithObjects:
                                                                 [UIImage imageNamed:@"smartV1.2_配置中1"],
                                                                 [UIImage imageNamed:@"smartV1.2_配置中2"],
                                                                 [UIImage imageNamed:@"smartV1.2_配置中3"],
                                                                 [UIImage imageNamed:@"smartV1.2_配置中4"],
                                                                 nil ]];
            [[self sharedView].animationImageView startAnimating];
            [self sharedView].promptInfoLabel.text = @" "; // 空格防止label高度为0
            [self sharedView].promptInfoLabel.textColor = [UIColor grayColor];
            [[self sharedView].operationButton setTitle:@"取消配置" forState:UIControlStateNormal];
        }
            break;
        case SHConfigurationStatusSuccess: {
            [self sharedView].animationImageView.hidden = YES;
            [self sharedView].iconImageView.hidden = NO;
            [[self sharedView].iconImageView setImage:[UIImage imageNamed:@"smartV1.2_配置成功"]];
            [self sharedView].promptInfoLabel.text = @"配置成功";
            [self sharedView].promptInfoLabel.textColor = [UIColor blackColor];
            [[self sharedView].operationButton setTitle:[[self sharedView].leftButtonTitle isEqualToString:@"确定"] ? @"确定" :  @"继续" forState:UIControlStateNormal];
            [self sharedView].leftButtonTitle = @"";

        }
            
            break;
        case SHConfigurationStatusFailure: {
            [self sharedView].animationImageView.hidden = YES;
            [self sharedView].iconImageView.hidden = NO;
            [[self sharedView].iconImageView setImage:[UIImage imageNamed:@"smartV1.2_连接超时"]];
            [self sharedView].promptInfoLabel.text = @"配置失败，请重试";
            [self sharedView].promptInfoLabel.textColor = [UIColor blackColor];
            [[self sharedView].nextButton setTitle:[[self sharedView].leftButtonTitle isEqualToString:@"取消"] ? @"取消" : @"下一个" forState:UIControlStateNormal];
            [[self sharedView].wifiConfigButton setTitle:@"wifi配置" forState:UIControlStateNormal];
            [[self sharedView].operationButton setTitle:@"重试" forState:UIControlStateNormal];
            [self sharedView].leftButtonTitle = @"";
        }
            
            break;
        case SHConfigurationStatusComplete: {
            [self sharedView].animationImageView.hidden = YES;
            [self sharedView].iconImageView.hidden = NO;
            [[self sharedView].iconImageView setImage:[UIImage imageNamed:@"smartV1.2_完成所有配置"]];
            [self sharedView].promptInfoLabel.text = @"已经完成所有配置";
            [self sharedView].promptInfoLabel.textColor = [UIColor blackColor];
            [[self sharedView].operationButton setTitle:@"立即体验" forState:UIControlStateNormal];
        }
            
            break;
        default:
            break;
    }
}


- (instancetype)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        [self addSubview:self.backGroundView];
        [self addSubview:self.promptInfoView];
        [self.promptInfoView addSubview:self.animationImageView];
        [self addSubview:self.iconImageView];
        [self.promptInfoView addSubview:self.promptInfoLabel];
        [self.promptInfoView addSubview:self.separatorLineView];
        [self.promptInfoView addSubview:self.nextButton];
        [self.nextButton addSubview:self.nextWifiSeparatorView];
        [self.promptInfoView addSubview:self.wifiConfigButton];
        [self.wifiConfigButton addSubview:self.wifiOpeartionSeparatorView];
        [self.promptInfoView addSubview:self.operationButton];
        [self setNeedsUpdateConstraints];
    }
    return self;
}



+ (void)showConfigurationNetworkWithStatus:(ConfigStatus)cancelConfig {
//    [SHConfigNetworkingView sharedView].alpha = 0;
//    [SHConfigNetworkingView sharedView].iconImageView.alpha = 0;
//
//    [UIView animateWithDuration:1.5 animations:^{
//        [SHConfigNetworkingView sharedView].alpha = 1;
//        [SHConfigNetworkingView sharedView].iconImageView.alpha = 1;
//
//    } completion:^(BOOL finished) {
        [self settingConfigStatus:SHConfigurationStatusCancel];
        [self sharedView].operationBlock = cancelConfig;
        [[self sharedView] hiddenNextButton];
        [[self sharedView] hiddenCompleteIconImageView];
//    }];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    [window addSubview:[SHConfigNetworkingView sharedView]];
    [window bringSubviewToFront:[SHConfigNetworkingView sharedView]];
}

+ (void)successConfigurationNetworkingStatus:(ConfigStatus)configSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedView].animationImageView stopAnimating];
        [self settingConfigStatus:SHConfigurationStatusSuccess];
        [self sharedView].operationBlock = configSuccess;
    });
    
}

+ (void)completeConfigurationNetworkingStatus:(ConfigStatus)configComplete {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedView].animationImageView stopAnimating];
        [self settingConfigStatus:SHConfigurationStatusComplete];
        [self sharedView].operationBlock = configComplete;
        [[self sharedView] showCompleteIconImageView];
        
    });
    
}

+ (void)failureConfigurationNetworkingStatusIndependentDevice:(BOOL)flag operation:(ConfigStatus)failureOperation {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedView].animationImageView stopAnimating];
        [self settingConfigStatus:SHConfigurationStatusFailure];
        [self sharedView].operationBlock = failureOperation;
        
        [[self sharedView] showNextButton:flag];
    });

}




#pragma mark - Layout
- (void)updateConstraints{
    [super updateConstraints];
   
    [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.promptInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).with.offset(-50);
        make.width.equalTo(@(235));
        make.height.equalTo(@(190));
    }];
    
    [self.animationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.promptInfoView.mas_centerX);
        make.top.equalTo(self.promptInfoView.mas_top).with.offset(20);
        make.bottom.equalTo(self.promptInfoLabel.mas_bottom).with.offset(-10);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.promptInfoView.mas_centerX);
        make.top.equalTo(self.promptInfoView.mas_top).with.offset(20);
        make.bottom.equalTo(self.promptInfoLabel.mas_top).with.offset(-10);
    }];
    
    [self.promptInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.promptInfoView.mas_left);
        make.right.equalTo(self.promptInfoView.mas_right);
        make.bottom.equalTo(self.separatorLineView.mas_top).with.offset(-10);
        make.height.equalTo(@(25));
    }];

    [self.separatorLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.promptInfoView).with.offset(20);
        make.right.equalTo(self.promptInfoView).with.offset(-20);
        make.bottom.equalTo(self.operationButton.mas_top);
        make.height.equalTo(@(0.5));
            
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.promptInfoView.mas_left);
        make.bottom.equalTo(self.promptInfoView);
        make.width.equalTo(@(0.));
        make.height.equalTo(@(50));
    }];
    
    [self.nextWifiSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nextButton.mas_right);
        make.centerY.equalTo(self.nextButton.mas_centerY);
        make.width.equalTo(@(0.5));
        make.height.equalTo(@(20));
    }];
    
    [self.wifiConfigButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nextButton.mas_right);
        make.bottom.equalTo(self.promptInfoView);
        make.width.equalTo(@(0.));
        make.height.equalTo(@(50));
    }];
    
    [self.wifiOpeartionSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.wifiConfigButton.mas_right);
        make.centerY.equalTo(self.operationButton.mas_centerY);
        make.width.equalTo(@(0.5));
        make.height.equalTo(@(20));
    }];
    
    [self.operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wifiConfigButton.mas_right);
        make.right.equalTo(self.promptInfoView.mas_right);
        make.bottom.equalTo(self.promptInfoView);
        make.height.equalTo(@(50));
    }];
    
}

- (void)hiddenNextButton {
    [self.nextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.promptInfoView.mas_left);
        make.bottom.equalTo(self.promptInfoView);
        make.width.equalTo(@(0.));
        make.height.equalTo(@(50));
        
    }];
    
    [self.wifiConfigButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nextButton.mas_right);
        make.bottom.equalTo(self.promptInfoView);
        make.width.equalTo(@(0.));
        make.height.equalTo(@(50));
    }];
}

- (void)showNextButton:(BOOL)flag {
    if (flag) { //独立设备
        [self.nextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.promptInfoView.mas_left);
            make.bottom.equalTo(self.promptInfoView);
            make.width.equalTo(self.promptInfoView.mas_width).multipliedBy(1/3.);
            make.height.equalTo(@(50));
        }];
        [self.wifiConfigButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nextButton.mas_right);
            make.bottom.equalTo(self.promptInfoView);
            make.width.equalTo(self.promptInfoView.mas_width).multipliedBy(1/3.);
            make.height.equalTo(@(50));
        }];
        
    } else {
        [self.nextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.promptInfoView.mas_left);
            make.bottom.equalTo(self.promptInfoView);
            make.width.equalTo(self.promptInfoView.mas_width).multipliedBy(0.5);
            make.height.equalTo(@(50));
        }];
        [self.wifiConfigButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nextButton.mas_right);
            make.bottom.equalTo(self.promptInfoView);
            make.width.equalTo(@(0.));
            make.height.equalTo(@(50));
        }];
    }
}

- (void)hiddenCompleteIconImageView {
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.promptInfoView.mas_centerX);
        make.top.equalTo(self.promptInfoView.mas_top).with.offset(20);
        make.bottom.equalTo(self.promptInfoLabel.mas_top).with.offset(-10);
    }];
}

- (void)showCompleteIconImageView {
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.promptInfoView.mas_centerX);
        make.top.equalTo(self.promptInfoView.mas_top).with.offset(-50);
        make.bottom.equalTo(self.promptInfoLabel.mas_top).with.offset(-10);
    }];
}


#pragma mark -Getter
-(UIView *)promptInfoView {
    if (!_promptInfoView) {
        _promptInfoView = [[UIView alloc] init];
        _promptInfoView.backgroundColor = [UIColor whiteColor];
        _promptInfoView.layer.cornerRadius = 5.;
        _promptInfoView.layer.masksToBounds = YES;
    }
    return _promptInfoView;
}

-(UIView *)backGroundView {
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc] init];
        _backGroundView.backgroundColor = [UIColor blackColor];
        _backGroundView.alpha = 0.6;
    }
    return _backGroundView;
}

- (UIImageView *)animationImageView {
    if (!_animationImageView) {
        _animationImageView = [[UIImageView alloc] init];
        _animationImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _animationImageView;
}

-(UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smartV1.2_连接超时"]];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

-(UILabel *)promptInfoLabel {
    if (!_promptInfoLabel) {
        _promptInfoLabel = [[UILabel alloc] init];
        _promptInfoLabel.font = [UIFont systemFontOfSize:15];
        _promptInfoLabel.textAlignment = NSTextAlignmentCenter;
        _promptInfoLabel.textColor = [UIColor grayColor];
    }
    return _promptInfoLabel;
}

-(UIView *)separatorLineView {
    if (!_separatorLineView) {
        _separatorLineView = [[UIView alloc] init];
        _separatorLineView.backgroundColor = [UIColor grayColor];
    }
    return _separatorLineView;
}


-(UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_nextButton addTarget:self action:@selector(nextStepAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

-(UIView *)nextWifiSeparatorView {
    if (!_nextWifiSeparatorView) {
        _nextWifiSeparatorView = [[UIView alloc] init];
        _nextWifiSeparatorView.backgroundColor = [UIColor grayColor];
    }
    return _nextWifiSeparatorView;
}

-(UIButton *)wifiConfigButton {
    if (!_wifiConfigButton) {
        _wifiConfigButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wifiConfigButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _wifiConfigButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_wifiConfigButton addTarget:self action:@selector(wifiConfigAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wifiConfigButton;
}

-(UIView *)wifiOpeartionSeparatorView {
    if (!_wifiOpeartionSeparatorView) {
        _wifiOpeartionSeparatorView = [[UIView alloc] init];
        _wifiOpeartionSeparatorView.backgroundColor = [UIColor grayColor];
    }
    return _wifiOpeartionSeparatorView;
}

-(UIButton *)operationButton {
    if (!_operationButton) {
        _operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_operationButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _operationButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_operationButton addTarget:self action:@selector(operationAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _operationButton;
}

-(void)setLeftButtonTitle:(NSString *)leftButtonTitle {
    if (![leftButtonTitle isEqualToString:@""]) {
        _leftButtonTitle = leftButtonTitle;
    }
}

#pragma mark -privagte
- (void)operationAction:(UIButton *)sender {
    [self disMiss];
    
    if ([[sender currentTitle] isEqualToString:@"取消配置"]) { //取消配置
        if (self.operationBlock) {
            self.operationBlock(SHConfigurationStatusCancel);
        }
    } else if ([[sender currentTitle] isEqualToString:@"继续"] || [[sender currentTitle] isEqualToString:@"确定"]) { //配置成功
        if (self.operationBlock) {
            self.operationBlock(SHConfigurationStatusSuccess);
        }
    } else if ([[sender currentTitle] isEqualToString:@"立即体验"]) { //配置完成
        if (self.operationBlock) {
            self.operationBlock(SHConfigurationStatusComplete);
        }
    } else if ([[sender currentTitle] isEqualToString:@"重试"]) { //配置失败
        if (self.operationBlock) {
            self.operationBlock(SHConfigurationStatusFailureAndRetry);
        }
    }
}

- (void)nextStepAction:(UIButton *)sender {
    if (self.operationBlock) {
        self.operationBlock(SHConfigurationStatusFailureAndNext);
    }
    [self disMiss];
}

- (void)wifiConfigAction:(UIButton *)sender {
    [self disMiss];
    if (self.operationBlock) {
        self.operationBlock(SHConfigurationStatusFailureAndWifiConfig);
    }
}

-(void)disMiss {
    self.alpha = 1;
    [UIView animateWithDuration:1.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.alpha = 1;
        [self removeFromSuperview];
    }];
}

@end
