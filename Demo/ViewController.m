//
//  ViewController.m
//  CJFImageDrawingCache
//
//  Created by Chris on 15/12/2012.
//  Copyright (c) 2012 Chris Fothergill. All rights reserved.
//

#import "ViewController.h"
#import "MyImageDrawingCache.h"

@interface ViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect bounds = self.view.bounds;
    
    CGRect frame = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
    frame.origin.x = floorf((bounds.size.width - frame.size.width) / 2.0f);
    frame.origin.y = floorf((bounds.size.height - frame.size.height) / 2.0f);
    
    self.imageView = [[UIImageView alloc] initWithFrame:frame];
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.imageView.image = [[MyImageDrawingCache defaultCache] imageForKey:MySquareKey controlState:UIControlStateNormal];
    self.imageView.highlightedImage = [[MyImageDrawingCache defaultCache] imageForKey:MySquareKey controlState:UIControlStateHighlighted];
    
    [self.view addSubview:self.imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
