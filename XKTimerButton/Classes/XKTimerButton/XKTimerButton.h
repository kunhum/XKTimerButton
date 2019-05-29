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

@property (nonatomic, copy) void(^xkTimerCounting)(NSInteger leftInterval, XKTimerButton *button);
@property (nonatomic, copy) BOOL(^xkStartCounting)(XKTimerButton *button);

///默认60s
@property (nonatomic, assign) NSInteger timerInterval;

///倒数时的前缀,默认为 重新获取
@property (nonatomic, copy) NSString *countingPrefix;
///倒数时的后缀,默认为 @""
@property (nonatomic, copy) NSString *countingSuffix;
///倒计时状态下文字的颜色 默认为313131 50%
@property (nonatomic, strong) UIColor *countingTextColor;
///倒计时状态下背景的颜色 默认为dedede
@property (nonatomic, strong) UIColor *countingBackgroundColor;
///倒计时状态下文字的颜色 默认为一开始文字
@property (nonatomic, strong) UIColor *normalTextColor;
///倒计时状态下背景的颜色 默认为一开始背景颜色
@property (nonatomic, strong) UIColor *normalBackgroundColor;

@end
