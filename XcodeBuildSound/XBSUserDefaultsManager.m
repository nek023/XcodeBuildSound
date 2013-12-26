//
//  XBSUserDefaultsManager.m
//  XcodeBuildSound
//
//  Created by Tanaka Katsuma on 2013/12/27.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "XBSUserDefaultsManager.h"

static NSString * const kXBSUserDefaultsManagerSuccessSoundsEnabledKey = @"successSoundsEnabled";
static NSString * const kXBSUserDefaultsManagerFailureSoundsEnabledKey = @"failureSoundsEnabled";

@implementation XBSUserDefaultsManager

+ (instancetype)sharedManager
{
    static id _sharedManager;
	static dispatch_once_t _onceToken;
    
	dispatch_once(&_onceToken, ^{
		_sharedManager = [[self alloc] init];
	});
    
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        // Register defaults
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults registerDefaults:@{
                                         kXBSUserDefaultsManagerSuccessSoundsEnabledKey: @(YES),
                                         kXBSUserDefaultsManagerFailureSoundsEnabledKey: @(YES)
                                         }];
        [userDefaults synchronize];
    }
    
    return self;
}


#pragma mark - Accessors

- (void)setSuccessSoundsEnabled:(BOOL)successSoundsEnabled
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:successSoundsEnabled forKey:kXBSUserDefaultsManagerSuccessSoundsEnabledKey];
    [userDefaults synchronize];
}

- (BOOL)isSuccessSoundsEnabled
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:kXBSUserDefaultsManagerSuccessSoundsEnabledKey];
}

- (void)setFailureSoundsEnabled:(BOOL)failureSoundsEnabled
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:failureSoundsEnabled forKey:kXBSUserDefaultsManagerFailureSoundsEnabledKey];
    [userDefaults synchronize];
}

- (BOOL)isFailureSoundsEnabled
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:kXBSUserDefaultsManagerFailureSoundsEnabledKey];
}

@end
