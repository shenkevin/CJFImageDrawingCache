//
//  CJFImageDrawingCache.m
//  CJFImageDrawingCache
//
//  Created by Chris on 15/12/2012.
//  Copyright (c) 2012 Chris Fothergill. All rights reserved.
//

#import <objc/runtime.h>

#import "CJFImageDrawingCache.h"

static NSString * const CJFImageDrawingCacheBlockKey = @"CJFImageDrawingCacheBlockKey";
static NSString * const CJFImageDrawingCacheSizeKey = @"CJFImageDrawingCacheSizeKey";
static NSString * const CJFImageDrawingCacheInsetsKey = @"CJFImageDrawingCacheInsetsKey";

static inline NSString * CJFImageCacheKey(id <NSCopying> key, UIControlState controlState) {
    return [NSString stringWithFormat:@"%@-%d", key, controlState];
}

@implementation CJFImageDrawingCache {
    NSCache *_imageCache;
    NSMutableDictionary *_drawingCache;
}

+ (instancetype)defaultCache
{
    static id __defaultCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __defaultCache = [[self alloc] init];
    });
    return __defaultCache;
}

- (id)init
{
    self = [super init];
    if (self) {
        _imageCache = [[NSCache alloc] init];
        _drawingCache = [[NSMutableDictionary alloc] init];
        
        Method *methods = NULL;
        unsigned int count;
        methods = class_copyMethodList([self class], &count);
        if (methods != NULL) {
            NSLog(@"count = %d", count);
            for (int i = 0; i < count; i++) {
                SEL selector = method_getName(methods[i]);
                if ([NSStringFromSelector(selector) hasPrefix:@"draw"]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [self performSelector:selector];
#pragma clang diagnostic pop
                }
            }
            free(methods);
        }
        
    }
    return self;
}

- (UIImage *)imageForKey:(id <NSCopying>)key controlState:(UIControlState)controlState
{
    UIImage *image = [_imageCache objectForKey:CJFImageCacheKey(key, controlState)];
    if (image == nil) {
        CJFImageDrawingCacheBlock drawingBlock = _drawingCache[key][CJFImageDrawingCacheBlockKey];
        CGSize size = [_drawingCache[key][CJFImageDrawingCacheSizeKey] CGSizeValue];
        UIEdgeInsets insets = [_drawingCache[key][CJFImageDrawingCacheInsetsKey] UIEdgeInsetsValue];
        
        if (drawingBlock != nil) {
            UIGraphicsBeginImageContextWithOptions(size, NO, 0);
            drawingBlock(CGRectMake(0.0f, 0.0f, size.width, size.height), controlState);
            image = [UIGraphicsGetImageFromCurrentImageContext() resizableImageWithCapInsets:insets];
            UIGraphicsEndImageContext();
            [_imageCache setObject:image forKey:CJFImageCacheKey(key, controlState)];
        }
    }
    
    return image;
}

- (void)cacheDrawingBlock:(CJFImageDrawingCacheBlock)drawingBlock size:(CGSize)size forKey:(id <NSCopying>)key
{
    [self cacheDrawingBlock:drawingBlock size:size insets:UIEdgeInsetsZero forKey:key];
}

- (void)cacheDrawingBlock:(CJFImageDrawingCacheBlock)drawingBlock size:(CGSize)size insets:(UIEdgeInsets)insets forKey:(id <NSCopying>)key
{
    NSDictionary *drawing = @{
        CJFImageDrawingCacheBlockKey: drawingBlock,
        CJFImageDrawingCacheSizeKey: [NSValue valueWithCGSize:size],
        CJFImageDrawingCacheInsetsKey: [NSValue valueWithUIEdgeInsets:insets]
    };
    [_drawingCache setObject:drawing forKey:key];
}

@end

