//
//  GraphView.h
//  Calculator
//
//  Created by Douglas Jones on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;
@protocol GraphViewDatasource
- (double)pointY:(float)xVal inview:(GraphView *)sender;
@end

@interface GraphView : UIView

@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;
- (void)pan:(UIPanGestureRecognizer *)panGesture;


@property (nonatomic, weak) IBOutlet id <GraphViewDatasource> dataSource;
@end

