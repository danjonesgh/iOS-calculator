//
//  GraphViewController.h
//  Calculator
//
//  Created by Douglas Jones on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"

@interface GraphViewController : UIViewController <UISplitViewControllerDelegate, SplitViewBarButtonItemPresenter>

@property (weak, nonatomic) IBOutlet UILabel *equationDisplay;
@property (nonatomic, strong) id program;

@end
