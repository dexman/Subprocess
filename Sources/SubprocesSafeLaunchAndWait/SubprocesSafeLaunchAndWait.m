//
//  SubprocessSafeLaunchAndWait.m
//  Subprocess
//
//  Created by Arthur Dexter on 3/28/18.
//

#import <SubprocesSafeLaunchAndWait/SubprocesSafeLaunchAndWait.h>

@implementation NSTask (SafeLaunchAndWait)

- (BOOL)safeLaunchAndWaitWithError:(NSError **)error
{
    if (![self launchAndReturnError:error]) {
        return NO;
    }
    [self waitUntilExit];
    return YES;
}

@end
