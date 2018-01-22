# RelayoutView
Masonry 布局的使用

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
