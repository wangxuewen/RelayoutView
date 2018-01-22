//
//  SHConfigNetworkingView.h
//  ZhuJiaYiApplication
//
//  Created by 王学文 on 2017/12/29.
//  Copyright © 2017年 zhujiayi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SHConfigurationStatus) {
    SHConfigurationStatusCancel = 1,
    SHConfigurationStatusSuccess,
    SHConfigurationStatusFailure,
    SHConfigurationStatusComplete,
    SHConfigurationStatusFailureAndNext,
    SHConfigurationStatusFailureAndWifiConfig,
    SHConfigurationStatusFailureAndRetry,
    
    
};

typedef void(^ConfigStatus)(SHConfigurationStatus configStatus);

@interface SHConfigNetworkingView : UIView

+ (SHConfigNetworkingView*)sharedView;

///配置中，block用于取消操作
+ (void)showConfigurationNetworkWithStatus:(ConfigStatus)cancelConfig;
///配置成功，block用于成功操作
+ (void)successConfigurationNetworkingStatus:(ConfigStatus)configSuccess;
///配置失败，block用于失败操作
+ (void)completeConfigurationNetworkingStatus:(ConfigStatus)configComplete;
///配置完成，block用于成功开始体验
+ (void)failureConfigurationNetworkingStatusIndependentDevice:(BOOL)flag operation:(ConfigStatus)failureOperation;
/// 页面消失
-(void)disMiss;

///用于更多设置 取消代替下一个
@property (strong, nonatomic) NSString *leftButtonTitle;

@end
