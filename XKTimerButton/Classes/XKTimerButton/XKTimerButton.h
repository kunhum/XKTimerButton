//
//  XKTimerButton.h
//  YTPedigree
//
//  Created by Nicholas on 2018/6/4.
//  Copyright © 2018年 Nicholas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKTimerButton : UIButton

///开始倒计时
- (void)xk_startCounting;

@property (nonatomic, copy) void(^xkTimerCounting)(NSInteger leftInterval);
@property (nonatomic, copy) BOOL(^xkStartCounting)(XKTimerButton *button);

///默认60s
@property (nonatomic, assign) NSInteger timerInterval;

///倒数时的前缀,默认为 重新获取
@property (nonatomic, copy) NSString *countingPrefix;
///倒数时的后缀,默认为 @""
@property (nonatomic, copy) NSString *countingSuffix;
///倒计时状态下的颜色 默认为313131 50%
@property (nonatomic, strong) UIColor *countingColor;

@end
