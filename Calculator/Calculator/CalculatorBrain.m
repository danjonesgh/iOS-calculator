//
//  CalculatorBrain.m
//  Calculator
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University.
//  All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@property (nonatomic, strong) NSDictionary *variableDict;
@property (nonatomic, strong) NSMutableSet *setOfVars;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;
@synthesize variableDict = _variableDict;
@synthesize setOfVars = _setOfVars;

- (NSMutableArray *)programStack
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSString *descrip;
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    descrip = [NSString stringWithFormat:@"%@",[[self class] descriptionOfTopOfStack:stack]];   //works
    
    return descrip;
}

-(void)returnDict:(NSDictionary *)dict
{
    
    _variableDict = dict;
    
    [[self class] runProgram:self.program usingVariableValues:_variableDict];
    
    [[self class] descriptionOfProgram:self.program];
}

-(NSDictionary *)sendbackDict
{
    return [self variableDict];
}


-(void)pushVariable:(NSString *)variable
{
    [self.programStack addObject:variable];
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
    NSLog(@"programstack %@", self.programStack);
    NSLog(@"program %@", self.program);
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    double aa = 0;
    if([self.program containsObject:@"x"] || [self.program containsObject:@"y"]  || [self.program containsObject:@"z"] )
    {
        aa = [[self class] runProgram:self.program usingVariableValues:_variableDict];
    }
    else {
        aa = [[self class] runProgram:self.program];
    }

    [[self class] descriptionOfProgram:self.program];
    
    //NSLog(@"descrip in perform op %@", [[self class] descriptionOfProgram:self.program]);
    
    return aa;
    //return [[self class] runProgram:self.program];
    
}

+(NSString *)descriptionOfTopOfStack:(NSMutableArray *)ourStack
{
    NSString *sequence = @"";
    NSString *returnStr = @"";
    //NSString *finalstr = @"";

    id topOfStack = [ourStack lastObject];
    if (topOfStack) [ourStack removeLastObject];
     
    if([topOfStack isKindOfClass:[NSNumber class]])
    {
        returnStr = [NSString stringWithFormat:@"%@", topOfStack];
    }
    else if([topOfStack isKindOfClass:[NSString class]])
    {
        // is a variable
        if(!([self isOperation:topOfStack]) && ![@"," isEqualToString:topOfStack])
        {
            returnStr = [NSString stringWithFormat:@"%@", topOfStack];
        }
        else if([self isTwoOperandOperation:topOfStack])
        {
            // operation, second operand, first operand
            sequence = [NSString stringWithFormat:@"%@", topOfStack];
            sequence = [sequence stringByAppendingString:[self descriptionOfTopOfStack:ourStack]];
            sequence = [[self descriptionOfTopOfStack:ourStack] stringByAppendingString:sequence];
            sequence = [@"(" stringByAppendingString:sequence];
            sequence = [sequence stringByAppendingString:@")"];
            // if stack is empty
            if(!ourStack || !ourStack.count)
            {
                returnStr = [returnStr stringByAppendingString:sequence];
            }
            else 
            {
                sequence = [@" " stringByAppendingString:sequence];
                //finalstr = [finalstr stringByAppendingString:sequence];
                //returnStr = [[self descriptionOfTopOfStack:ourStack] stringByAppendingString:finalstr];
                returnStr = [[self descriptionOfTopOfStack:ourStack] stringByAppendingString:sequence];
            }
        }
        else if([self isSingleOperandOperation:topOfStack])
        {
           // if([self isOperation:[self descriptionOfTopOfStack:ourStack]])
          //  {
                // keeping this here and empty works 
                
           // }
            if(![self isOperation:[self descriptionOfTopOfStack:ourStack]])
            {
                //NSLog(@"top os stack %@", topOfStack);
                sequence = [sequence stringByAppendingString:topOfStack];
                sequence = [sequence stringByAppendingString:@"("];
                sequence = [sequence stringByAppendingString:[self descriptionOfTopOfStack:ourStack]];
                
                sequence = [sequence stringByAppendingString:@")"];
                if(!ourStack || !ourStack.count)
                {
                    returnStr = [returnStr stringByAppendingString:sequence];
                }
                else 
                {
                    sequence = [@" " stringByAppendingString:sequence];
                   // finalstr = [finalstr stringByAppendingString:sequence];
                   // returnStr = [[self descriptionOfTopOfStack:ourStack] stringByAppendingString:finalstr];
                    returnStr = [[self descriptionOfTopOfStack:ourStack] stringByAppendingString:sequence];
                }
            }
        }
    }
    return returnStr; 
}

+ (BOOL)isTwoOperandOperation:(NSString *)operation
{
    BOOL returnVal = FALSE;
    if([@"/" isEqualToString:operation] || [@"*" isEqualToString:operation] || [@"+" isEqualToString:operation] || [@"-" isEqualToString:operation])
    {
        returnVal = TRUE;
    }
    return returnVal;
}
+ (BOOL)isSingleOperandOperation:(NSString *)operation
{
    BOOL returnVal = FALSE;
    if([@"sin" isEqualToString:operation] || [@"cos" isEqualToString:operation] || [@"sqrt" isEqualToString:operation])
    {
        returnVal = TRUE;
    }
    return returnVal;
}
+ (BOOL)isNoOperandOperation:(NSString *)operation
{
    return TRUE;
}


+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
  
    
    if (topOfStack) [stack removeLastObject];
  
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] +
            [self popOperandOffProgramStack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack] *
            [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        }
        else if ([@"sin" isEqualToString:operation])
        {
            result = sin([self popOperandOffProgramStack:stack]);
        }
        else if ([@"cos" isEqualToString:operation])
        {
            result = cos([self popOperandOffProgramStack:stack]);
        }
        else if ([@"sqrt" isEqualToString:operation])
        {
            result = sqrt([self popOperandOffProgramStack:stack]);
        }
        else if([@"pi" isEqualToString:operation])
        {
            result = 3.141592654;
        }
        else if([@"+ / -" isEqualToString:operation])
        {
            result = -([self popOperandOffProgramStack:stack]);
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    //NSLog(@" stack in run prog %@", stack);
    return [self popOperandOffProgramStack:stack];
}

+ (double)runProgram:(id)program
 usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }

    
    for ( int x = 0; x < [program count]; x++) {
        if([@"x"isEqualToString:[program objectAtIndex:x]])
        {
            double dub = [[variableValues valueForKey:@"x"] doubleValue];
            [stack replaceObjectAtIndex:x withObject:[NSNumber numberWithDouble:dub]];
        }
        if([@"y"isEqualToString:[program objectAtIndex:x]])
        {
            double dub = [[variableValues valueForKey:@"y"] doubleValue];
            [stack replaceObjectAtIndex:x withObject:[NSNumber numberWithDouble:dub]];
        }
        if([@"z"isEqualToString:[program objectAtIndex:x]])
        {
            double dub = [[variableValues valueForKey:@"z"] doubleValue];
            [stack replaceObjectAtIndex:x withObject:[NSNumber numberWithDouble:dub]];
        }
    }
    return [self popOperandOffProgramStack:stack];
}

+ (BOOL)isOperation:(NSString *)operation
{
    BOOL returnVal = FALSE;
    if([@"/" isEqualToString:operation] || [@"*" isEqualToString:operation] || [@"+" isEqualToString:operation] || [@"-" isEqualToString:operation] || [@"sin" isEqualToString:operation] || [@"cos" isEqualToString:operation] || [@"sqrt" isEqualToString:operation] )
    {
        returnVal = TRUE;
    }
    return returnVal;
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
    NSMutableArray *testarray =  [[NSMutableArray alloc] init];
    for(int x=0; x< [program count]; x++)
    {
        if([@"x" isEqualToString:[program objectAtIndex:x]])
        {
            [testarray addObject:@"x"];
        }
        if([@"y" isEqualToString:[program objectAtIndex:x]])
        {
            [testarray addObject:@"y"];
        }
        if([@"z" isEqualToString:[program objectAtIndex:x]])
        {
            [testarray addObject:@"z"];
        }
    }
    
    NSSet *newset = [NSSet setWithArray:testarray];
   
    return newset;

}

-(NSSet *)returnVars
{
    // works, make sure return type is string   
    NSSet *testset = nil;

    NSSet *secondset = nil;
    testset = [[self class] variablesUsedInProgram:self.program];   // worsk 
   
    secondset = [NSSet setWithSet:testset];
    return secondset;

    
}

-(NSString *)returnDescrip
{
    
    NSString *newdescrip = [[self class] descriptionOfProgram:self.program];
    //NSLog(@" this is new descrip %@", [[self class] descriptionOfProgram:self.program]);
    return newdescrip;
}

-(void)clearStack
{
    [self.programStack removeAllObjects];
}



-(void)removeLastItem
{
    [self.programStack removeLastObject];
    
}



@end
