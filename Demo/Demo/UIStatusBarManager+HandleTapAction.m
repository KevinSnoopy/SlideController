//
//  UIStatusBarManager+HandleTapAction.m
//  Demo
//
//  Created by mac on 2022/1/21.
//

#import "UIStatusBarManager+HandleTapAction.h"
#import <objc/runtime.h>

@implementation UIStatusBarManager (HandleTapAction)

+ (void)load {
    /**
     iOS 13之后
     获取点击状态栏的方法并交换
     */

    if (@available(iOS 13.0, *)) {
        Method oldMethod = class_getInstanceMethod(self, NSSelectorFromString(@"handleTapAction:"));
        Method newMethod = class_getInstanceMethod(self, @selector(new_handleTapAction:));
        method_exchangeImplementations(oldMethod, newMethod);
    }
}

/**
 iOS 13之后
 执行点击状态栏的方法并告诉需要接收的对象
 */
- (void)new_handleTapAction:(id)callback {
    [self new_handleTapAction:callback];
    
    if (@available(iOS 13.0, *)) {
        /**
         模拟点击状态栏
         */
        NSMutableSet *touches = [NSMutableSet set];
        [touches addObject:[UITouch new]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidTapStatusBar" object:@{@"touches": touches, @"event": [UIEvent new]}];
    }
}

@end
