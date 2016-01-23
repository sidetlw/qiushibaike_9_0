//
//  PopAnimationViewController.m
//  Homepwner
//
//  Created by test on 16/1/23.
//  Copyright © 2016年 Mrtang. All rights reserved.
//

#import "PopAnimationViewController.h"
#import "PopAnimation.h"

@interface PopAnimationViewController () <UIGestureRecognizerDelegate>
@property (nonatomic,weak) UINavigationController *nav;
@property (nonatomic) UIPanGestureRecognizer *panGesture;
@property (nonatomic) UIPercentDrivenInteractiveTransition *percentDrivenInteractiveTransition;
@end

@implementation PopAnimationViewController

-(instancetype)initWithNavigationController:(UINavigationController *)vc
{
    self = [super init];
    if (self) {
        _nav = vc;
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandel:)];
        self.panGesture.delegate = self;
        self.nav.delegate = self;
        [self.nav.view addGestureRecognizer:self.panGesture];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)panGestureHandel:(UIPanGestureRecognizer *)gesture
{
    CGPoint transpoint = [gesture translationInView:self.view];
    CGPoint point = [gesture locationInView:nil];
    NSLog(@"translationInView :%f  %f  locationInView:,%f  %f",transpoint.x,transpoint.y,point.x,point.y);
    CGFloat process = transpoint.x / self.view.bounds.size.width;
    process = MIN( MAX(0.0, process),1.0);
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.percentDrivenInteractiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.nav popViewControllerAnimated:YES];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        [self.percentDrivenInteractiveTransition updateInteractiveTransition:process];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        if (process > 0.3) {
            [self.percentDrivenInteractiveTransition finishInteractiveTransition];
        }
        else {
            [self.percentDrivenInteractiveTransition cancelInteractiveTransition];
        }
        self.percentDrivenInteractiveTransition = nil;
    }
}


#pragma mark - navigation delegate
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController NS_AVAILABLE_IOS(7_0)
{
    if ([animationController isKindOfClass:[PopAnimation class]]) {
        //_percentDrivenInteractiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        return self.percentDrivenInteractiveTransition;
    }
    return nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0)
{
    if (operation == UINavigationControllerOperationPop) {
        return [[PopAnimation alloc] init];
    }
    return nil;
}

#pragma mark - gesture delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return [[self.nav viewControllers] count] != 1 && ![[self.nav valueForKey:@"_isTransitioning"] boolValue];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
