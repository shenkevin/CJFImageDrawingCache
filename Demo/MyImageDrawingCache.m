//
//  MyImageDrawingCache.m
//  CJFImageDrawingCache
//
//  Created by Chris on 15/12/2012.
//  Copyright (c) 2012 Chris Fothergill. All rights reserved.
//

#import "MyImageDrawingCache.h"

NSString * const MySquareKey = @"MySquare";

@implementation MyImageDrawingCache

- (void)drawMySquare
{
    [self cacheDrawingBlock:^(CGRect rect, UIControlState controlState) {
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        if (controlState == UIControlStateNormal) {
            [[UIColor blueColor] setFill];
        }
        else if (controlState & UIControlStateHighlighted) {
            [[UIColor redColor] setFill];
        }
        CGContextFillRect(ctx, rect);
        
    } size:CGSizeMake(100.0f, 100.0f) forKey:MySquareKey];
}

@end
