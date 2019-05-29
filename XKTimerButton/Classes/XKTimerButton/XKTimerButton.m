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
    self.countingTextColor       = [[UIColor colorWithRed:49/255.0 green:49/255.0 blue:49/255.0 alpha:1.0] colorWithAlphaComponent:0.5];
    self.countingBackgroundColor = [self colorWithHexString:@"dedede"];
    self.normalTextColor         = self.titleLabel.textColor;
    self.normalBackgroundColor   = self.backgroundColor;
    self.timerInterval           = 60;
    self.countingPrefix          = @"重新获取 ";
    self.countingSuffix          = @"";
    
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
        [self setTitleColor:self.countingTextColor forState:UIControlStateNormal];
        self.backgroundColor = self.countingBackgroundColor;
        self.userInteractionEnabled = NO;
    }
}

- (void)setTimerInterval:(NSInteger)timerInterval {
    
    _timerInterval = timerInterval;
    
    _settingInterval = timerInterval;
}

- (void)timerMethod {
    
    if (--_settingInterval <= 0) {
        !self.xkTimerCounting ?: self.xkTimerCounting(0, self);
        _settingInterval = self.timerInterval;
        [self.timer invalidate];
        self.timer = nil;
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self setTitleColor:self.normalColor  forState:UIControlStateNormal];
        self.userInteractionEnabled = YES;
        [self setTitleColor:self.normalTextColor forState:UIControlStateNormal];
        self.backgroundColor = self.normalBackgroundColor;
        return;
    }
    !self.xkTimerCounting ?: self.xkTimerCounting(_settingInterval, self);
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
        [self setTitleColor:self.countingTextColor  forState:UIControlStateNormal];
    });
    self.userInteractionEnabled = NO;
}

- (UIColor *)colorWithHexString:(NSString *)color {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

- (void)xk_setTimerWithQueue:(dispatch_queue_t)queue seconds:(double)seconds interval:(NSTimeInterval)interval leeway:(NSTimeInterval)leeway countingHandler:(void (^ _Nullable)(CGFloat))countingHandler cancelHandler:(void (^ _Nullable)(void))cancelHandler {
    
    __block double countingSeconds = seconds;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, interval * NSEC_PER_SEC, leeway * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (--countingSeconds > 0) {
            !countingHandler ?: countingHandler(countingSeconds);
        }
        else {
            dispatch_cancel(timer);
        }
    });
    dispatch_source_set_cancel_handler(timer, ^{
        !cancelHandler ?: cancelHandler();
    });
    dispatch_resume(timer);
    
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
