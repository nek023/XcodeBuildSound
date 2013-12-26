//
//  XBSUserDefaultsManager.h
//  XcodeBuildSound
//
//  Created by Tanaka Katsuma on 2013/12/27.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBSUserDefaultsManager : NSObject

@property (nonatomic, assign, getter = isSuccessSoundsEnabled) BOOL successSoundsEnabled;
@property (nonatomic, assign, getter = isFailureSoundsEnabled) BOOL failureSoundsEnabled;

+ (instancetype)sharedManager;

@end
