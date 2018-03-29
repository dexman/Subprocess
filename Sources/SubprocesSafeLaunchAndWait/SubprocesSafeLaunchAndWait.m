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
    @try {
        [self launch];
    } @catch (NSException *exception) {
        if (error) {
            NSDictionary *userInfo = @{@"exception": exception};
            *error = [NSError errorWithDomain:@"NSTaskSafeLaunchAndWait" code:0 userInfo:userInfo];
        }
        return NO;
    }

    [self waitUntilExit];
    return YES;
}

@end
