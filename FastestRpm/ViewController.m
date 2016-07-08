//
//  ViewController.m
//  FastestRpm
//
//  Created by Jeff Eom on 2016-07-07.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

#import "ViewController.h"

#define RADIANS(degrees) (((degrees) * M_PI) / 180.0)
#define MIN_DEGREES      -135.0
#define MAX_DEGREES      135.0
#define RANGE_DEGREES    (MAX_DEGREES - MIN_DEGREES)

#define LIMIT_VELOCITY   7500.0
#define VELOCITY_DELTA   10.0

#define RESET_DELAY      0.1
#define VELOCITY_DELAY   0.1

@interface ViewController ()

@property CGFloat currentVelocity;
@property CGFloat maxVelocity;

@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *needleImage;

@property double startAngle;

//@property CGAffineTransform minRotationTransform;

-(void)moveNeedleWithVelocity:(CGFloat)velocity;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _maxVelocity = LIMIT_VELOCITY;
    _currentVelocity = 0;
    self.startAngle = RADIANS(140);
    self.needleImage.transform = CGAffineTransformMakeRotation(self.startAngle);
    
    self.speedLabel.text = [NSString stringWithFormat:@"Speed: 0 RPM"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)moveNeedleWithVelocity:(CGFloat)velocity{
    
    self.currentVelocity = velocity;
    self.maxVelocity = MAX(self.maxVelocity, velocity);
    CGFloat velocityProportion = velocity / LIMIT_VELOCITY;
    double degrees = MIN(RANGE_DEGREES * velocityProportion, RANGE_DEGREES);
    self.needleImage.transform = CGAffineTransformMakeRotation(self.startAngle + RADIANS(degrees));
    
}

- (IBAction)panGesture:(id)sender {
    
    UIPanGestureRecognizer *panGesture = sender;
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.speedLabel.text = [NSString stringWithFormat:@"Speed: 0 RPM"];
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            CGFloat velocity1 = [sender velocityInView:self.view].x;
            CGFloat velocity2 = [sender velocityInView:self.view].y;
            CGFloat velocity = MAX(velocity1, velocity2);
            self.speedLabel.text = [NSString stringWithFormat:@"Speed: %f RPM", velocity];
            [self moveNeedleWithVelocity:velocity];
            
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        {
            [UIView animateWithDuration:1.5 animations:^{
                self.needleImage.transform = CGAffineTransformMakeRotation(self.startAngle);
            }];
            break;
        }
    
        default:
            break;
    }
}


@end
