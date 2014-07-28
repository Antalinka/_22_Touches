//
//  GRViewController.m
//  _22_TouchesTest
//
//  Created by Exo-terminal on 4/18/14.
//  Copyright (c) 2014 Evgenia. All rights reserved.
//

#import "GRViewController.h"

@interface GRViewController ()
@property (weak, nonatomic)UIView* draggingView;
@property (assign, nonatomic) CGPoint touchOffset;

@end

@implementation GRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (int i = 0; i < 8; i++) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(10 + 110 * i, 100, 100, 100)];
        view.backgroundColor = [self randomColor];
        [self.view addSubview:view];
    }
    
   
    
    
//    self.testView = view;
//    [self.view addSubview:self.testView];
    
}

-(void) logTouches: (NSSet *) touches andMethod: (NSString *) methodName{
    
    NSMutableString* string = [NSMutableString stringWithString:methodName];
    
    for (UITouch * touch in touches) {
        CGPoint point = [touch locationInView:self.view];
        [string appendFormat:@"%@", NSStringFromCGPoint(point)];
    }
//    NSLog(@"%@", string);
    
//    self.view.multipleTouchEnabled = YES;
    
}

-(UIColor*) randomColor{
    
    CGFloat r = (CGFloat)(arc4random() %256)/255;
    CGFloat g = (CGFloat)(arc4random() %256)/255;
    CGFloat b = (CGFloat)(arc4random() %256)/255;
    NSLog(@"%f, %f, %f",r,g,b);
    return [UIColor colorWithRed:r green:g blue:b alpha:1.f];
}


#pragma mark - Touches


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self logTouches:touches andMethod:@"touchesBegan"];
    UITouch* touch = [touches anyObject];
    CGPoint pointInMainView = [touch locationInView:self.view];
    
    UIView* view = [self.view hitTest:pointInMainView withEvent:event];
    
    if (![view isEqual:self.view]) {
        
        
        
        self.draggingView = view;
        [self.view bringSubviewToFront:self.draggingView];
        
        CGPoint touchPoint = [touch locationInView:self.draggingView];
        self.touchOffset = CGPointMake(CGRectGetMidX(self.draggingView.bounds) - touchPoint.x,
                                       CGRectGetMidY(self.draggingView.bounds) - touchPoint.y);
        
       /* UIView* customView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.draggingView.bounds) - touchPoint.x,
                                                                     CGRectGetMidY(self.draggingView.bounds) - touchPoint.y,
                                                                     50, 50)];
        customView.backgroundColor = [UIColor blackColor];
         customView.alpha = 0.5f;
        
        [self.view addSubview:customView];*/
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.draggingView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
                             self.draggingView.alpha = 0.3f;
                         }];
        
    }else{
        self.draggingView = nil;
    }
//    NSLog(@"inside = %d", [self.view  pointInside:point withEvent:event]);
    
}

-(void) onTouchesEnded{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.draggingView.transform = CGAffineTransformIdentity;
                         self.draggingView.alpha = 1.f;
                     }];
    self.draggingView = nil;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self logTouches:touches andMethod:@"touchesMoved"];
    
    if (self.draggingView) {
        
        UITouch* touch = [touches anyObject];
        CGPoint pointInMainView = [touch locationInView:self.view];
        
        CGPoint correct = CGPointMake(pointInMainView.x + self.touchOffset.x,
                                      pointInMainView.y + self.touchOffset.y);
        
        self.draggingView.center = correct;
    }
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self logTouches:touches andMethod:@"touchesEnded"];
    [self onTouchesEnded];
    
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self logTouches:touches andMethod:@"touchesCancelled"];
    [self onTouchesEnded];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
