//
//  HGMenuBtn.m
//  GaiBan
//
//  Created by Meng Fan on 16/9/9.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "HGMenuBtn.h"

@implementation HGMenuBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(CGRect)imageRectForContentRect:(CGRect)contentRect {
    NSLog(@"image rect x:%f y:%f w:%f h:%f", contentRect.origin.x, contentRect.origin.y, contentRect.size.width, contentRect.size.height);
    
    CGFloat width = contentRect.size.width-10;
    
    
    return CGRectMake(5, 0, width, width);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect {
    NSLog(@"title rect x:%f y:%f w:%f h:%f", contentRect.origin.x, contentRect.origin.y, contentRect.size.width, contentRect.size.height);
    
    return CGRectMake(contentRect.origin.x, contentRect.size.width-5, contentRect.size.width, contentRect.size.height - contentRect.size.width);
}


@end
