# RelayoutView
Masonry 布局的使用

（视图第一次布局使用 mas_makeConstraints， 修改该视图的约束使用 mas_remakeConstraints）

//配置中弹框出现
 [SHConfigNetworkingView showConfigurationNetworkWithStatus:^(SHConfigurationStatus configStatus) {
            NSLog(@"执行类型：%ld", configStatus);
        }];
        
配置成功时
[SHConfigNetworkingView successConfigurationNetworkingStatus:^(SHConfigurationStatus configStatus) {
                NSLog(@"执行类型：%ld", configStatus);

            }];
            
            
配置失败有两种操作时，
[SHConfigNetworkingView failureConfigurationNetworkingStatusIndependentDevice:NO operation:^(SHConfigurationStatus configStatus) {
                
            }];

配置失败有三种操作时，       
[SHConfigNetworkingView failureConfigurationNetworkingStatusIndependentDevice:YES operation:^(SHConfigurationStatus configStatus) {
                NSLog(@"执行类型：%ld", configStatus);

            }];
