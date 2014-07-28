//
//  GRViewController.m
//  _22_Touches
//
//  Created by Exo-terminal on 4/19/14.
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}
#pragma mark - Distance -

-(CGPoint)distanceFromPoint: (CGPoint) center{
    
    CGPoint point1 = CGPointMake(INT16_MAX, INT16_MAX);
    CGPoint point = self.centerView;
    
    if (!(self.possibleNearRect == nil)) {
        for (NSValue* value in self.possibleNearRect) {
            CGPoint pointFromArray  = [value CGPointValue];
            
            
            int a = abs(center.x - point1.x);
            int b = abs(center.x - pointFromArray.x);
            
            if (b < a) {
                
                point1 = pointFromArray;
                point = pointFromArray;
                
            }else if(a == b){

                int c = abs((center.y - point1.y));
                int d = abs(( center.y - pointFromArray.y));
                
                if (c > d) {
                    point = pointFromArray;
                }else{
                    point = point1;
                }
            }
            
        }
    }else{
        point = center;
    }
    
  
    
    return point;
}

#pragma mark - Ner Cell -

-(void) createCenterWithRect:(CGRect) rect {
    
    self.possibleNearRect = [[NSMutableArray alloc]init];
    
    NSInteger midX = CGRectGetMidX(rect);
    NSInteger midY = CGRectGetMidY(rect);
    
    UIView* view = [self.blackView objectAtIndex:0];
    NSInteger a = CGRectGetWidth(view.frame);
    
    CGPoint topLeft     = CGPointMake(midX - a, midY + a);
    CGPoint buttonLeft  = CGPointMake(midX - a, midY - a);
    CGPoint topRight    = CGPointMake(midX + a, midY + a);
    CGPoint buttonRight = CGPointMake(midX + a, midY - a);
    
    [self addObjectInArray:self.possibleNearRect point:topLeft];
    [self addObjectInArray:self.possibleNearRect point:buttonLeft];
    [self addObjectInArray:self.possibleNearRect point:topRight];
    [self addObjectInArray:self.possibleNearRect point:buttonRight];

}

-(void)addObjectInArray:(NSMutableArray*) array point: (CGPoint)point  {
    
    BOOL check = [self pointInsideView:self.mainView point:point];

      if (check) {
        [array addObject:[NSValue valueWithCGPoint:point]];
    }
}

- (BOOL) pointInsideView: (UIView*) view point:(CGPoint) point{
    
    BOOL areYes = NO;
    
    if (point.x > 0 && point.x < view.frame.size.width &&
        
        point.y > 0 && point.y < view.frame.size.width) {
        areYes = YES;
    }
    
    return areYes;
}

-(void) editArray: (NSArray*) array{
    
    NSMutableArray* arrayForDel = [[NSMutableArray alloc]init];
    
    for (NSValue * value in self.possibleNearRect) {
        
        
        CGPoint p=[value CGPointValue];
        
        for (UIImageView * iView in array) {
            
            CGPoint centerView = iView.center;
            
            if (CGPointEqualToPoint(p, centerView)) {
                
                [arrayForDel addObject:[NSNumber numberWithInt:[self.possibleNearRect indexOfObject:value]]];
            }
            
            }
        }
    [self deleteObjectAtIndex:arrayForDel];
}

-(void)deleteObjectAtIndex: (NSMutableArray*) array{
    
    for (int i = ([array count]-1); i >= 0; i--) {
        
        int del =  [[array objectAtIndex:i]intValue];
        [self.possibleNearRect removeObjectAtIndex:del];
    }
}

#pragma mark - Animation Rect -

-(void) animationViewWithImageName: (NSString*) string{
    
    for (NSValue * value in self.possibleNearRect) {
        
        CGPoint p=[value CGPointValue];
   
        for (UIView * iView in self.blackView) {
      
            CGPoint centerView = CGPointMake(CGRectGetMidX(iView.frame), CGRectGetMidY(iView.frame));
           
             if (CGPointEqualToPoint(p, centerView)) {
                 
                 UIImageView* customView = [self createViewWithCenter:centerView imageName:string];
                 [self animationWithView:customView];
            }
        }
    }
}

-(UIImageView*) createViewWithCenter: (CGPoint) center imageName: (NSString*) string{
    
    UIImageView* view = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 30, 30)];
    
    view.image = [UIImage imageNamed:string];
    view.center = center;
    view.tag = 4;
    [self.mainView addSubview:view];
    [view bringSubviewToFront:self.mainView];

    return view;
}

-(void)animationWithView: (UIImageView*) view{
    
    UIImageView* newView = view;
    
    [UIView animateWithDuration:0.8f
                          delay:0
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                     animations:^{
                         newView.alpha = 0.2;
                     }
                    completion:^(BOOL finished) {
                    }];
   }

#pragma mark - TOUCHES -

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

   CGPoint pointInMainView = [[touches anyObject] locationInView:self.mainView];
    
    for (UIImageView *iView in self.mainView.subviews) {
        
        if (([iView isKindOfClass:[UIImageView class]] && iView.tag == 3) ||
            ([iView isKindOfClass:[UIImageView class]] && iView.tag == 2)
            ) {
            
            NSString* string = [[NSMutableString alloc]init];
            string =  @"redSide.png";
            
            if (iView.tag == 3) {
                string = @"whiteSide.png";
            }
            
            
            if  (pointInMainView.x > iView.frame.origin.x &&
                 pointInMainView.x < iView.frame.origin.x + iView.frame.size.width &&
                 
                 pointInMainView.y > iView.frame.origin.y &&
                 pointInMainView.y < iView.frame.origin.y + iView.frame.size.height){
                
                self.draggingView = iView;
                self.centerView = iView.center;
                
                [self.mainView bringSubviewToFront:self.draggingView];
                
                CGPoint touchPoint = [[touches anyObject] locationInView:self.draggingView];
                
                self.touchOffset = CGPointMake(CGRectGetMidX(self.draggingView.bounds) - touchPoint.x,
                                               CGRectGetMidY(self.draggingView.bounds) - touchPoint.y);
                
                [UIView animateWithDuration:0.3
                                 animations:^{
                                     self.draggingView.transform = CGAffineTransformIdentity;
                                     iView.alpha = 0.5;
                }];
                
                [self createCenterWithRect:iView.frame];
                
                if (!(self.possibleNearRect == nil)) {
                    [self editArray:self.redImageView];
                    
                    if (!(self.possibleNearRect == nil)) {

                        [self editArray:self.whiteImageView];
                        
                        [self animationViewWithImageName:string];
                    }
                }
  
            }
       }
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    if (self.draggingView) {
        
        UITouch* touch = [touches anyObject];
        CGPoint pointInMainView = [touch locationInView:self.mainView];
        
        CGPoint correct = CGPointMake(pointInMainView.x + self.touchOffset.x,
                                      pointInMainView.y + self.touchOffset.y);
        
        self.draggingView.center = correct;
    }
}

-(void) onTouchesEnded{
    
     if (!(self.possibleNearRect == nil)) {
         CGPoint newCenter = [self distanceFromPoint:self.draggingView.center];
         self.draggingView.center = newCenter;
     }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.draggingView.transform = CGAffineTransformIdentity;
                         self.draggingView.alpha = 1.f;
                     }];
    self.draggingView = nil;
    
    for (UIView *iView in [self.mainView subviews]) {
        [iView.layer removeAllAnimations];
        if (iView.tag == 4) {
            [iView removeFromSuperview];
        }
    }
    
 }
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self onTouchesEnded];
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
     [self onTouchesEnded];
}


@end
