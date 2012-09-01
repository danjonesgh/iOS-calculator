//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Douglas Jones on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"
#import "SplitViewBarButtonItemPresenter.h"

@interface CalculatorViewController () 
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringNumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic) NSDictionary *testVariableValues;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize history = _history;
@synthesize variableDisplay = _variableDisplay;
@synthesize userIsInTheMiddleOfEnteringNumber = _userIsInTheMiddleOfEnteringNumber;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;
//@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;

- (CalculatorBrain *)brain
{
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)variablePressed:(UIButton *)sender {
    
    NSString *var = [sender currentTitle];
    self.display.text = var;
    
    [self.brain pushVariable:sender.currentTitle];
}

- (void)viewDidLoad
{
    self.title = @"Calculator";
}

- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = [sender currentTitle];


    if(self.userIsInTheMiddleOfEnteringNumber)
    {
        // if no decimal found, keep appending digits and decimal point 
        if([self.display.text rangeOfString:@"."].location == NSNotFound  )
        {
            self.display.text = [self.display.text stringByAppendingString:digit]; 
        }
        // else if decimal found only append digits and not another decimal
        else if([self.display.text rangeOfString:@"."].location != NSNotFound && !([digit isEqualToString:@"."]) )
        {
            self.display.text = [self.display.text stringByAppendingString:digit]; 
        }
    }
    else 
    {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringNumber = YES;
        
       // self.history.text = [self.history.text stringByAppendingString:@" "];
       // self.history.text = [self.history.text stringByAppendingString:digit];
    }
}

- (IBAction)operationPressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfEnteringNumber && ([@"+ / -" isEqualToString:sender.currentTitle]))
    {
        if([self.display.text rangeOfString:@"-"].location == NSNotFound)
        {    
            NSString *negative = @"-";
            self.display.text = [negative stringByAppendingString:self.display.text];
         //   self.history.text = [negative stringByAppendingString:self.history.text];
        }
        else 
        {
            self.display.text = [self.display.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
          //  self.history.text = [self.history.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
        
        self.userIsInTheMiddleOfEnteringNumber = YES;
    }
    else
    {
        [self enterPressed];
        double result = [self.brain performOperation:sender.currentTitle];
        if(!([self userIsInTheMiddleOfEnteringNumber]))
        {
           // [self.brain pushVariable:@","];
        }
        NSString *resultString = [NSString stringWithFormat:@"%g", result];
       // NSLog(@"string result %@", resultString);
        self.display.text = resultString;
        self.history.text = [self.history.text stringByAppendingString:@" "];
        
        self.history.text = [self.brain returnDescrip];
      //  self.history.text = [self.history.text stringByAppendingString:sender.currentTitle];
       // self.history.text = [self.history.text stringByAppendingString:@" = "];
      //  self.history.text = [self.history.text stringByAppendingString:resultString];
    }
}

- (IBAction)enterPressed 
{
    
    
    if(!([self.display.text isEqualToString:@"z"]) && !([self.display.text isEqualToString:@"y"]) && !([self.display.text isEqualToString:@"x"]) )
    {
        
        
        [self.brain pushOperand:[self.display.text doubleValue]];
    }
    else {
        [self.brain pushVariable:self.display.text];
    }

    //self.variableDisplay.text = [self.brain returnVars];
    NSString *djstr = @" ";
    djstr = [[[self.brain returnVars] allObjects] componentsJoinedByString:@" "];
    //self.variableDisplay.text = djstr;
    self.variableDisplay.text = @"";
  /*  if([[self.brain returnVars] containsObject:@"x"])
    {
        NSString *varStr = [@" x = " stringByAppendingString:[[self.brain sendbackDict] valueForKey:@"x"]];
        //NSLog(@" var str %@", varStr);
        self.variableDisplay.text = [self.variableDisplay.text stringByAppendingString:varStr];
    }
    if([[self.brain returnVars] containsObject:@"y"])
    {
        NSString *varStr = [@" y = " stringByAppendingString:[[self.brain sendbackDict] valueForKey:@"y"]];
       // NSLog(@" var str %@", varStr);
        self.variableDisplay.text = [self.variableDisplay.text stringByAppendingString:varStr];
    }
    if([[self.brain returnVars] containsObject:@"z"])
    {
        NSString *varStr = [@" z = " stringByAppendingString:[[self.brain sendbackDict] valueForKey:@"z"]];
        //NSLog(@" var str %@", varStr);
        self.variableDisplay.text = [self.variableDisplay.text stringByAppendingString:varStr];
    }
   // NSLog(@" trying to get dict val %@", [self.brain returnVars]);
   // self.history.text = [self.history.text stringByAppendingString:@" "];
    */
    self.userIsInTheMiddleOfEnteringNumber = NO;
}


- (GraphViewController *)splitViewGraphController
{
    id gvc = [self.splitViewController.viewControllers lastObject];
    if(![gvc isKindOfClass:[GraphViewController class]])
    {
        gvc = nil;
    }
    return gvc;
}


- (IBAction)graphPressed {
    if([self splitViewGraphController])
    {
        [self splitViewGraphController].program = self.brain.program;
    }
    else
    {
        [self performSegueWithIdentifier:@"ShowGraph" sender:self];
    }
    //[self performSegueWithIdentifier:@"ipadGraphSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"ShowGraph"]) {
        [segue.destinationViewController setProgram:self.brain.program];
    }

}

- (IBAction)clearPressed
{
    
    self.history.text = @"";
    self.display.text = @"";
    [self.brain clearStack];
}

/*
- (IBAction)testCasePressed:(id)sender 
{
    NSString *testCase = [sender currentTitle];
    if([@"Test 1" isEqualToString:testCase])
    {
        _testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"-2.3", @"x", @"77", @"y", @"0",@"z", nil]; 
        [self.brain returnDict:_testVariableValues];
        [self enterPressed];
        
        self.history.text = [self.brain returnDescrip];
        
    }
    else if([@"Test 2" isEqualToString:testCase])
    {
        _testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"23", @"x",  @"nil", @"y",@"-110", @"z",  nil]; 
        [self.brain returnDict:_testVariableValues];
     [self enterPressed];
        
        self.history.text = [self.brain returnDescrip];
    }
    else if([@"Test 3" isEqualToString:testCase])
    {
        _testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"0.78", @"x", @"-0.123", @"y", @"96", @"z",nil]; 
        [self.brain returnDict:_testVariableValues];
         [self enterPressed];
        
        self.history.text = [self.brain returnDescrip];
    }
}
*/

- (IBAction)deleteLastChar {
    if(self.userIsInTheMiddleOfEnteringNumber && ([self.display.text length] >= 1))
    {
        self.display.text = [self.display.text substringToIndex:self.display.text.length - 1];
       // self.history.text = [self.history.text substringToIndex:[self.history.text length] - 1];
    }
    else if(!self.userIsInTheMiddleOfEnteringNumber)
    {
        //NSLog(@"get to remove last item?");
        [self.brain removeLastItem];
    }
}
/*
- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = self.title;
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
}
*/
/*
- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if (![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) {
        detailVC = nil;
    }
    return detailVC;
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = self.title;
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
   // GraphViewController *gvc = [self.splitViewController.viewControllers lastObject];
    //gvc.splitViewBarButtonItem = barButtonItem;
    //[].splitViewBarButtonItem = barButtonItem;
}
*/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}



//- (void)viewDidUnload {
//    [self setHistory:nil];
//    [super viewDidUnload];
//}
- (void)viewDidUnload {
    [self setHistory:nil];
    [self setVariableDisplay:nil];
    [super viewDidUnload];
}
@end
