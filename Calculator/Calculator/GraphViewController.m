//
//  GraphViewController.m
//  Calculator
//
//  Created by Douglas Jones on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrain.h"


@interface GraphViewController () <GraphViewDatasource>
@property (nonatomic, weak) IBOutlet GraphView *graphView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation GraphViewController
@synthesize equationDisplay = _equationDisplay;

@synthesize graphView = _graphView;
@synthesize program = _program;
@synthesize toolbar = _toolbar;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;

- (void)setProgram:(id)program
{
    _program = program;
    [self.graphView setNeedsDisplay]; // any time our Model changes, redraw our View
}

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tap:)];
    tapGesture.numberOfTapsRequired = 3;
    [self.graphView addGestureRecognizer:tapGesture];
    self.graphView.dataSource = self;
}

-(double)pointY:(float)xVal inview:(GraphView *)sender
{
  //  for(int x = self.graphView.bounds.origin.x; x < self.graphView.bounds.size.width; x++)
    //{
    NSDictionary *xValDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:xVal] forKey:@"x"];
    //NSLog(@"prog count %@", self.program );
        double yVal = [CalculatorBrain runProgram:self.program usingVariableValues:xValDict];
    self.equationDisplay.text = [CalculatorBrain descriptionOfProgram:self.program];
  //  NSLog(@"this is yval %f", yVal);
//    }
    return yVal;
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (splitViewBarButtonItem != _splitViewBarButtonItem) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}


- (void)awakeFromNib  // always try to be the split view's delegate
{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if (![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) {
        detailVC = nil;
    }
    return detailVC;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
   // return YES;
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    NSLog(@"aviewcontroller %@", self.title);
    NSLog(@"viewcontrol title %@", aViewController.title);
    barButtonItem.title = aViewController.title;
    
    //UIViewController * cont = [self.splitViewController.viewControllers objectAtIndex:0].title;
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}



- (void)viewDidUnload {
    [self setEquationDisplay:nil];
    [self setToolbar:nil];
    [super viewDidUnload];
}
@end
