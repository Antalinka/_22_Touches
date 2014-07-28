//
//  GRViewController.h
//  _22_Touches
//
//  Created by Exo-terminal on 4/19/14.
//  Copyright (c) 2014 Evgenia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GRViewController : UIViewController{
}
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *blackView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *redImageView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *whiteImageView;
@property (strong, nonatomic) NSMutableArray* possibleNearRect;

@property (assign, nonatomic) CGPoint centerView;

@end
