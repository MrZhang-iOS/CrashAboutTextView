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
        //不可变数组的方法交换
        Class instanceClass = objc_getClass("__NSArrayI");
        
        SEL originalInstanceSelector = @selector(objectAtIndex:);
        SEL swizzledInstanceSelector = @selector(zw_objectAtIndex:);
        
        Method originalInstanceMethod = class_getInstanceMethod(instanceClass, originalInstanceSelector);
        Method swizzledInstanceMethod = class_getInstanceMethod(instanceClass, swizzledInstanceSelector);
        
        if (originalInstanceMethod && swizzledInstanceMethod)
        {
            BOOL isMethodAdd = class_addMethod(instanceClass, originalInstanceSelector, method_getImplementation(swizzledInstanceMethod), method_getTypeEncoding(swizzledInstanceMethod));
            if (isMethodAdd)
            {
                class_replaceMethod(instanceClass, swizzledInstanceSelector, method_getImplementation(originalInstanceMethod), method_getTypeEncoding(originalInstanceMethod));
            }
            else
            {
                method_exchangeImplementations(originalInstanceMethod, swizzledInstanceMethod);
            }
        }
        else
        {
            NSLog(@"__NSArrayI的objectAtIndex交换方法失败");
        }
        
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

- (id)zw_objectAtIndex:(NSUInteger)index {
    id obj = nil;
    if (index >= 0 && index < self.count) {
        obj = [self zw_objectAtIndex:index];
        if (obj && [obj isKindOfClass:[NSNull class]])
        {
            obj = nil;
        }
    } else {
        NSLog(@"exception: array out of bounds");
    }
    return obj;
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
