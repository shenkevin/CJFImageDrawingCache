//
//  CJFImageDrawingCache.h
//  CJFImageDrawingCache
//
//  Created by Chris on 15/12/2012.
//  Copyright (c) 2012 Chris Fothergill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^CJFImageDrawingCacheBlock)(CGRect rect, UIControlState controlState);

@interface CJFImageDrawingCache : NSObject

+ (instancetype)defaultCache;

- (UIImage *)imageForKey:(id <NSCopying>)key controlState:(UIControlState)controlState;

- (void)cacheDrawingBlock:(CJFImageDrawingCacheBlock)drawingBlock size:(CGSize)size forKey:(id <NSCopying>)key;
- (void)cacheDrawingBlock:(CJFImageDrawingCacheBlock)drawingBlock size:(CGSize)size insets:(UIEdgeInsets)insets forKey:(id <NSCopying>)key;

@end
