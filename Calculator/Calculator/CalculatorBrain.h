//
//  CalculatorBrain.h
//  Calculator
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University.
//  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)op;
- (void)clearStack;
- (void)pushVariable:(NSString *)variable;
- (void)returnDict:(NSDictionary *)dict;
- (void)removeLastItem;
- (NSSet *)returnVars;
- (NSString *)returnDescrip;
- (NSDictionary *)sendbackDict;

@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program
 usingVariableValues:(NSDictionary *)variableValues;
+ (NSSet *)variablesUsedInProgram:(id)program;
+ (BOOL)isOperation:(NSString *)operation;
+ (BOOL)isTwoOperandOperation:(NSString *)operation;
+ (BOOL)isSingleOperandOperation:(NSString *)operation;
+ (BOOL)isNoOperandOperation:(NSString *)operation;


@end
