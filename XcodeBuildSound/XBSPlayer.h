//
//  XBSPlayer.h
//  XcodeBuildSound
//
//  Created by Tanaka Katsuma on 2013/12/26.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBSPlayer : NSObject

@property (nonatomic, copy, readonly) NSArray *successSounds;
@property (nonatomic, copy, readonly) NSArray *failureSounds;

- (void)playWithSuccess:(BOOL)success;

@end
