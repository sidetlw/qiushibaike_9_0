//
//  PopAnimation.m
//  Homepwner
//
//  Created by test on 16/1/23.
//  Copyright © 2016年 Mrtang. All rights reserved.
//

#import "PopAnimation.h"

@interface PopAnimation ()
@property (nonatomic) id <UIViewControllerContextTransitioning> transitionContext;
@end

@implementation PopAnimation
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *container = [transitionContext containerView];
    [container insertSubview:toVC.view belowSubview:fromVC.view];
    
    CGRect tempframe = toVC.view.frame;
    CGRect frame = toVC.view.frame;
    frame.origin.x -= 300.0;
    toVC.view.frame = frame;
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration animations:^{
        //----------------pop动画一-------------------------//
        /*
        _transitionContext = transitionContext;
        
        
         [UIView beginAnimations:@"View Flip" context:nil];
         [UIView setAnimationDuration:duration];
         [UIView setAnimationDelegate:self];
         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:container cache:YES];
         [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
         [UIView commitAnimations];//提交UIView动画
         [container exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
         */
        //-------------------------------------------------//
        
        //----------------pop动画二-------------------------//
        /*
         CATransition *tr = [CATransition animation];
         tr.type = @"cube";
         tr.subtype = @"fromLeft";
         tr.duration = duration;
         tr.removedOnCompletion = NO;
         tr.fillMode = kCAFillModeForwards;
         tr.delegate = self;
         [container.layer addAnimation:tr forKey:nil];
         [container exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
         */
         //----------------pop动画二-------------------------//
        
        
        
        
        fromVC.view.transform = CGAffineTransformMakeTranslation([[UIScreen mainScreen] bounds].size.width, 0);
        toVC.view.frame = tempframe;

    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!([transitionContext transitionWasCancelled])];
         toVC.view.frame = tempframe;
    }];
    
    
}

- (void)animationDidStop:(CATransition *)anim finished:(BOOL)flag {
    [_transitionContext completeTransition:!_transitionContext.transitionWasCancelled];
}

@end
