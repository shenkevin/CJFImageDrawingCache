CJFImageDrawingCache
====================

Usage
-----

You can use CJFImageDrawingCache in two ways. 

The first is to instantiate it and use `cacheDrawingBlock:size:forKey:`, `cacheDrawingBlock:size:insets:forKey:` and `imageForKey:controlState`.

The second way is to subclass it and add methods that begin with `draw`. These will automatically be called when the object is instantiated. 
	
	extern NSString * const MySquareKey;
	
	@interface MyImageDrawingCache : CJFImageDrawingCache
	@end
	
	NSString * const MySquareKey = @"MySquare";
	
	@implementation MyImageDrawingCache
	
	- (void)drawSquare
	{
		[self cacheDrawingBlock:^(CGRect rect, UIControlState controlState) {
			CGContextRef ctx = UIGraphicsGetCurrentContext();
			if (controlState & UIControlStateNormal) {
				[[UIColor blueColor] setFill];
			}
			else if (controlState & UIControlStateHighlighted) {
				[[UIColor redColor] setFill];
			}
			CGContextFillRect(ctx, rect);
		} size:CGSizeMake(100.0f, 100.0f) forKey:MySquareKey];
	}
	
	@end
	
Then else where in your code when you need the image

	self.imageView.image = [[MyImageDrawingCache defaultCache] imageForKey:MySquareKey controlState:UIControlStateNormal];
	self.imageView.highlightedImage = [[MyImageDrawingCache defaultCache] imageForKey:MySquareKey controlState:UIControlStateHighlighted];
	
Requirements
------------

CJFImageDrawingCache requires Xcode 4.5 or greater to compile and uses ARC.