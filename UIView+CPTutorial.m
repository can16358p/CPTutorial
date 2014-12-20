//
//  UIView+CPTutorial.m
//
//  Created by Can Poyrazoğlu on 23.11.14.
//

#import "CPTutorial.h"
#import "UIView+CPTutorial.h"
#import "CPTutorialInvisibleProxyView.h"

@implementation UIView (CPTutorial)

-(CPTutorialBalloon*)displayBalloonTip:(NSString*)text{
    /*
    if(![CPTutorial isRecordingValidTutorial]){
        return nil;
    }
     */
    if([self isKindOfClass:[CPTutorialInvisibleProxyView class]]){
        if(!self.superview){
            [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
        }
    }
    CPTutorialBalloon *balloon = [[CPTutorialBalloon alloc] initWithFrame:self.frame];
    balloon.isManagedExternally = YES;
    balloon.shouldResizeItselfAccordingToContents = YES;
    balloon.text = text;
    balloon.tutorial = [CPTutorial currentTutorial];
    balloon.targetView = self;

    UIView *superviewToAddBalloon = [[[UIApplication sharedApplication] delegate] window];
    [superviewToAddBalloon addSubview:balloon];
    //now, a hacky way to "observe" frame changes:
    self.autoresizesSubviews = YES;
    CPTutorialInvisibleProxyView *proxyView = [CPTutorialInvisibleProxyView proxyView];
    proxyView.delegate = balloon;
    [self addSubview:proxyView];
    return balloon;
}

-(CPTutorial*)displayBalloonTip:(NSString*)text onceWithIdentifier:(NSString*)tipName{
    return [CPTutorial displayWithName:tipName actions:^{
        [self displayBalloonTip:text];
    }];
}

@end
