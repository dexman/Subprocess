//
//  SubprocessSafeLaunchAndWait.h
//  Subprocess
//
//  Created by Arthur Dexter on 3/28/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTask (SafeLaunchAndWait)

- (BOOL)safeLaunchAndWaitWithError:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
