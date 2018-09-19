//
//  XKTimerButton.m
//  YTPedigree
//
//  Created by Nicholas on 2018/6/4.
//  Copyright © 2018年 Nicholas. All rights reserved.
//

#import "XKTimerButton.h"

@interface XKTimerButton () {
    
    ///用户设定的
    NSInteger _settingInterval;
}

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIColor *normalColor;

@end

@implementation XKTimerButton

- (instancetype)init {
    if (self = [super init]) {
        [self initMethod];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initMethod];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initMethod];
}

- (void)initMethod {
    
    [self addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    self.countingColor  = [[UIColor colorWithRed:49/255.0 green:49/255.0 blue:49/255.0 alpha:1.0] colorWithAlphaComponent:0.5];
    self.timerInterval  = 60;
    self.countingPrefix = @"重新获取 ";
    self.countingSuffix = @"";
    
    if ([self.currentTitle isEqualToString:@"button"]) {
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    self.normalColor = self.currentTitleColor;
}

- (void)clickButton:(XKTimerButton *)button {
    
    BOOL canStart = NO;
    if (self.xkStartCounting) {
        canStart = self.xkStartCounting(self);
    }
    
    if (canStart) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setTitleColor:self.countingColor  forState:UIControlStateNormal];
        });
        self.userInteractionEnabled = NO;
    }
}

- (void)setTimerInterval:(NSInteger)timerInterval {
    
    _timerInterval = timerInterval;
    
    _settingInterval = timerInterval;
}

- (void)timerMethod {
    
    if (--_settingInterval <= 0) {
        _settingInterval = self.timerInterval;
        [self.timer invalidate];
        self.timer = nil;
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self setTitleColor:self.normalColor  forState:UIControlStateNormal];
        self.userInteractionEnabled = YES;
        return;
    }
    
    [self setTitle:[NSString stringWithFormat:@"%@%02ld%@",self.countingPrefix,_settingInterval,self.countingSuffix] forState:UIControlStateNormal];
    
}

#pragma mark override
- (void)removeFromSuperview {
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [super removeFromSuperview];
}

#pragma mark 接口
- (void)xk_startCounting {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setTitleColor:self.countingColor  forState:UIControlStateNormal];
    });
    self.userInteractionEnabled = NO;
}

- (void)dealloc {
    NSLog(@"timer button dealloc");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
