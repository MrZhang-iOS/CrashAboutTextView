//
//  NSArray+Swizzle.m
//  CrashAtTextViewForArray
//
//  Created by zhangwei on 2021/9/4.
//

#import "NSArray+Swizzle.h"
#import <objc/runtime.h>

@implementation NSArray (Swizzle)

//分类的方式重构系统方法时不要直接覆盖系统方法，使用runtime置换掉系统方法，防止与相同分类模块冲突造成异常
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //可变数组的方法交换
        Class instanceClassM = objc_getClass("__NSArrayM");
        
        SEL originalInstanceSelectorM = @selector(objectAtIndex:);
        SEL swizzledInstanceSelectorM = @selector(zw_mutableObjectAtIndex:);
        
        Method originalInstanceMethodM = class_getInstanceMethod(instanceClassM, originalInstanceSelectorM);
        Method swizzledInstanceMethodM = class_getInstanceMethod(instanceClassM, swizzledInstanceSelectorM);
        
        if (originalInstanceMethodM && swizzledInstanceMethodM)
        {
            BOOL isMethodAdd = class_addMethod(instanceClassM, originalInstanceSelectorM, method_getImplementation(swizzledInstanceMethodM), method_getTypeEncoding(swizzledInstanceMethodM));
            if (isMethodAdd)
            {
                class_replaceMethod(instanceClassM, swizzledInstanceSelectorM, method_getImplementation(originalInstanceMethodM), method_getTypeEncoding(originalInstanceMethodM));
            }
            else
            {
                method_exchangeImplementations(originalInstanceMethodM, swizzledInstanceMethodM);
            }
        }
        else
        {
            NSLog(@"__NSArrayM的objectAtIndex交换方法失败");
        }
    });
}

- (id)zw_mutableObjectAtIndex:(NSUInteger)index {
    id obj = nil;
    if (index >= 0 && index < self.count) {
        obj = [self zw_mutableObjectAtIndex:index];
        if (obj && [obj isKindOfClass:[NSNull class]])
        {
            obj = nil;
        }
    } else {
        NSLog(@"exception: mutable array out of bounds");
    }
    return obj;
}

@end
