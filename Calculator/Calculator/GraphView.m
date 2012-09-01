//
//  GraphView.m
//  Calculator
//
//  Created by Douglas Jones on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView


@synthesize scale = _scale;
@synthesize origin = _origin;
@synthesize dataSource = _dataSource;

#define DEFAULT_SCALE 10.0;

- (CGFloat)scale
{
    if(!_scale && !([[NSUserDefaults standardUserDefaults] floatForKey:@"scale"]))
    {
        return DEFAULT_SCALE;
    }
    else if([[NSUserDefaults standardUserDefaults] floatForKey:@"scale"])
    {
        return [[NSUserDefaults standardUserDefaults] floatForKey:@"scale"];
    }
    else
    {
        return _scale;
    }
}

- (void)setScale:(CGFloat)scale
{
    if(scale != _scale)
    {
        _scale = scale;
        
        [[NSUserDefaults standardUserDefaults] setFloat:scale forKey:@"scale"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self setNeedsDisplay];
    }
}

- (CGPoint)origin
{
   // CGPoint point = CGPointMake(0.0, 0.0);
    if(CGPointEqualToPoint(CGPointZero, _origin)  && !([[NSUserDefaults standardUserDefaults] floatForKey:@"Xaxis"]) && !([[NSUserDefaults standardUserDefaults] floatForKey:@"Yaxis"]))
    {
        
       // CGPoint defaultPoint = CGPointMake(self.bounds.origin.x +10 , self.bounds.size.height - 20);
        
      //  CGPoint defaultPoint = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2 , self.bounds.origin.y + self.bounds.size.height/2 );
        
        CGPoint defaultPoint = CGPointMake(self.bounds.size.width/2 , self.bounds.size.height/2 );
      
        return defaultPoint;
    }
    else if([[NSUserDefaults standardUserDefaults] floatForKey:@"Xaxis"] && [[NSUserDefaults standardUserDefaults] floatForKey:@"Yaxis"])
    {
        CGPoint latestpoint =  CGPointMake([[NSUserDefaults standardUserDefaults] floatForKey:@"Xaxis"], [[NSUserDefaults standardUserDefaults] floatForKey:@"Yaxis"] );
        return latestpoint;
    }
    else
    {
        
   //     NSLog(@"self origin %@", NSStringFromCGPoint(self.origin));
        return _origin;
    }
}

- (void)setOrigin:(CGPoint)origin
{
    if(!CGPointEqualToPoint(origin, _origin))
    {
        _origin = origin;
        [[NSUserDefaults standardUserDefaults] setFloat:origin.x forKey:@"Xaxis"];
       [[NSUserDefaults standardUserDefaults] setFloat:origin.y forKey:@"Yaxis"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //self.origin = CGPointMake(self.bounds.origin.x +10 , self.bounds.size.height - 20);
        [self setNeedsDisplay];
    }
  
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded))
    {
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

- (void)pan:(UIPanGestureRecognizer *)panGesture
{
    if((panGesture.state == UIGestureRecognizerStateChanged) || (panGesture.state == UIGestureRecognizerStateEnded))
    {
        CGPoint translation = [panGesture translationInView:self];
        self.origin = CGPointMake(self.origin.x + translation.x, self.origin.y + translation.y);
        [panGesture setTranslation:CGPointZero inView:self];
    }
}



- (void)tap:(UITapGestureRecognizer *)tapGesture
{
    if((tapGesture.state == UIGestureRecognizerStateChanged) || (tapGesture.state == UIGestureRecognizerStateEnded))
    {
        self.origin = [tapGesture locationInView:self];
    }
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    
    //float pixelsPerPoint = self.contentScaleFactor;
   // self.scale /=  pixelsPerPoint;

    [self setup]; // get initialized when we come out of a storyboard
}


- (CGPoint)convertToGraphCoordinateFromViewCoordinate:(CGPoint)coordinate {
    
	CGPoint graphCoordinate;
    
	graphCoordinate.x = (coordinate.x - self.origin.x) / self.scale;
	graphCoordinate.y = (self.origin.y - coordinate.y) / self.scale;
    
	return graphCoordinate;
}

- (CGPoint) convertToViewCoordinateFromGraphCoordinate:(CGPoint)coordinate {
    
	CGPoint viewCoordinate;
    
	viewCoordinate.x = (coordinate.x * self.scale) + self.origin.x;
	viewCoordinate.y = self.origin.y - (coordinate.y * self.scale);
    
	return viewCoordinate;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.origin scale:self.scale];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
	UIGraphicsPushContext(context);
    
	CGContextBeginPath(context);
    
  
    CGContextMoveToPoint(context, self.bounds.origin.x, self.origin.y - ([self.dataSource pointY:(self.bounds.origin.x - self.origin.x) inview:self] ));
    
    //NSLog(@"pointzz %f", self.bounds.size.height - ([self.dataSource pointY:(self.bounds.origin.x - self.origin.x) inview:self] / self.scale));
   // NSLog(@"height %f", self.bounds.size.height);
  //  NSLog(@"width %f", self.bounds.size.width);
  //  NSLog(@"pointzz11 %f", [self.dataSource pointY:(self.bounds.origin.x - self.origin.x)
     //                                       inview:self]);
  //  NSLog(@"newest %f", self.origin.y - ([self.dataSource pointY:(self.bounds.origin.x - self.origin.x) inview:self] ));
   // NSLog(@"pointzz22 %f", ([self.dataSource pointY:(self.bounds.origin.x - self.origin.x) inview:self] / self.scale));
    for(float x = self.bounds.origin.x; x < self.bounds.size.width; x+= 1/self.contentScaleFactor)
    //for(int x = -(self.bounds.origin.x; x < self.bounds.size.width; x++)
    {
        
        //double yvalforx = [self.dataSource pointY:(x - self.origin.x) inview:self];
        
        
        
        CGPoint coordinate;
		coordinate.x = x;
		coordinate = [self convertToGraphCoordinateFromViewCoordinate:coordinate];
		coordinate.y = [self.dataSource pointY:coordinate.x inview:self];
		coordinate = [self convertToViewCoordinateFromGraphCoordinate:coordinate];
		coordinate.x = x;
        CGContextAddLineToPoint(context, coordinate.x, coordinate.y);
        
        //CGContextMoveToPoint(context, self.origin.x + x , self.origin.y - (some * self.scale ) );
        if(x == 384)
        {
          //  NSLog(@"this is some %f", yvalforx);
        }
        
        if(x == 1)
        {
            
            //NSLog(@"where we draw %f", self.origin.y );
          //  NSLog(@"where we draw %f", self.origin.x );
       // NSLog(@"thi s is some %f", yvalforx);
            //NSLog(@"where we draw %f", self.origin.y - (some *self.scale));
            //NSLog(@"where we draw %f", self.origin.x + (x *self.scale));
        }
        if(x == 2) {
        //    NSLog(@"thi s is some %f", yvalforx);
           // NSLog(@"where we draw %f", self.origin.y - (some *self.scale));
           // NSLog(@"where we draw %f", self.origin.x + (x *self.scale));
        }
        if(x == 3) {
        //    NSLog(@"thi s is some %f", yvalforx);
            //NSLog(@"where we draw %f", self.origin.y - (some *self.scale));
            //NSLog(@"where we draw %f", self.origin.x + (x *self.scale));
        }
        if(x == 4) {
        //    NSLog(@"thi s is some %f", yvalforx);
            //NSLog(@"where we draw %f", self.origin.y - (some *self.scale));
            //NSLog(@"where we draw %f", self.origin.x + (x *self.scale));
        }
        if(x == 5) {
            //NSLog(@"thi s is some %f", yvalforx);
            //NSLog(@"where we draw %f", self.origin.y - (some *self.scale));
            //NSLog(@"where we draw %f", self.origin.x + (x *self.scale));
        }
        if(x == 6) {
           // NSLog(@"thi s is some %f", yvalforx);
           // NSLog(@"where we draw %f", self.origin.y - (some *self.scale));
           // NSLog(@"where we draw %f", self.origin.x + (x *self.scale));
        }
        //CGContextAddLineToPoint(context, (self.bounds.origin.x ) + x , ((self.bounds.size.height ) - some) - self.scale);
        
 
        // CGContextAddLineToPoint(context, self.bounds.origin.x + (x ), self.origin.y - (yvalforx ));
        
    }
    
    
    CGContextStrokePath(context);
 
}


@end
