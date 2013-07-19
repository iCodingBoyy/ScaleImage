//
//  ViewController.m
//  ScaleImage
//
//  Created by 马远征 on 13-7-19.
//  Copyright (c) 2013年 ChinaSoft. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIImageView *imageView;
    
    CGFloat lastDistance;
    
    CGFloat imgStartWidth;
    CGFloat imgStartHeight;
}
@end

@implementation ViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        lastDistance = 0;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = [[UIScreen mainScreen]applicationFrame];
    CGPoint centerPoint = CGPointMake(rect.size.width/2, rect.size.height/2);
    CGRect bounds = CGRectMake(0, 0, 240, 360);
    
    imageView = [[UIImageView alloc]initWithFrame:bounds];
    imageView.center = centerPoint;
    imageView.image = [UIImage imageNamed:@"030.jpg"];
    [self.view addSubview:imageView];
    
    imgStartWidth = imageView.frame.size.width;
    imgStartHeight = imageView.frame.size.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark 手势

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point1 , point2;
    CGFloat sub_x , sub_y;
    CGRect imageFrame;
    CGFloat currentDistance;
    
    NSArray *touchArray = [[event allTouches]allObjects];
    NSLog(@"手指个数 %d",[touchArray count]);
    
    if ([touchArray count] >= 2)
    {
        point1 = [[touchArray objectAtIndex:0] locationInView:self.view];
        point2 = [[touchArray objectAtIndex:1] locationInView:self.view];
        
        sub_x = point1.x - point2.x;
        sub_y = point1.y - point2.y;
        
        currentDistance = sqrtf(sub_x*sub_x + sub_y*sub_y);
        
        if (lastDistance > 0)
        {
            imageFrame = imageView.frame;
            //＋2包括两个手指触摸点的距离
            if (currentDistance > lastDistance + 2)
            {
                NSLog(@"放大图片");
                // 图像放大，如果放大尺寸大于图像本身的尺寸，图像则放大为本身的尺寸
                imageFrame.size.width += 10;
                if (imageFrame.size.width > 1000)
                {
                    imageFrame.size.width = 1000;
                }
                // 保存最后放大或者缩小的距离
                lastDistance = currentDistance;
            }
            
            if (currentDistance < lastDistance - 2)
            {
                NSLog(@"缩小");
                // 缩小图像，最小尺寸为50x50
                imageFrame.size.width -= 10;
                if (imageFrame.size.width < 50)
                {
                    imageFrame.size.width = 50;
                }
                lastDistance = currentDistance;
            }
            
            // 图像经过放大或者索缩小后返回原来的尺寸
            if (lastDistance == currentDistance)
            {
                imageFrame.size.height = imgStartHeight*imageFrame.size.width/imgStartWidth;
                
                float addwidth = imageFrame.size.width - imageView.frame.size.width;
                float addheight = imageFrame.size.height - imageView.frame.size.height;
                
                imageView.frame = CGRectMake(imageFrame.origin.x-addwidth/2.0f,
                                             imageFrame.origin.y-addheight/2.0f,
                                             imageFrame.size.width,
                                             imageFrame.size.height);
                
            }

        }
        else
        {
            lastDistance = currentDistance;
        }
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    lastDistance = 0;
}
@end
