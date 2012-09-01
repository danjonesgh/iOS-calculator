//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Douglas Jones on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



//@protocol SplitViewBarButtonItemPresenter
//@//property (nonatomic, strong) UIBarButtonItem *splitViewBarButtonItem;
//@end

@interface CalculatorViewController : UIViewController 



@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *history;
@property (weak, nonatomic) IBOutlet UILabel *variableDisplay;

@end
