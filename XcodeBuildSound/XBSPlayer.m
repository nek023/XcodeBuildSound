//
//  XBSPlayer.m
//  XcodeBuildSound
//
//  Created by Tanaka Katsuma on 2013/12/26.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "XBSPlayer.h"

static XBSPlayer *_sharedPlayer = nil;

@interface XBSPlayer ()

@property (nonatomic, copy, readwrite) NSArray *successSounds;
@property (nonatomic, copy, readwrite) NSArray *failureSounds;

@end

@implementation XBSPlayer

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        // Load sounds
        [self loadSounds];
    }
    
    return self;
}

- (void)loadSounds
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resourcePath = [bundle resourcePath];
    NSString *soundsPath = [resourcePath stringByAppendingPathComponent:@"Sounds"];
    
    // Load success sounds
    NSMutableArray *successSounds = [NSMutableArray array];
    NSString *successSoundPath = [soundsPath stringByAppendingPathComponent:@"Success"];
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:successSoundPath error:NULL];
    
    for (NSString *fileName in contents) {
        NSString *pathExtension = [[fileName pathExtension] lowercaseString];
        if (![pathExtension isEqualToString:@"wav"] && ![pathExtension isEqualToString:@"mp3"]) {
            continue;
        }
        
        // Add sound
        NSString *filePath = [successSoundPath stringByAppendingPathComponent:fileName];
        NSSound *sound = [[NSSound alloc] initWithContentsOfFile:filePath byReference:NO];
        
        [successSounds addObject:sound];
    }
    
    self.successSounds = [successSounds copy];
    
    // Load failure sounds
    NSMutableArray *failureSounds = [NSMutableArray array];
    NSString *failureSoundPath = [soundsPath stringByAppendingPathComponent:@"Failure"];
    contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:failureSoundPath error:NULL];
    
    for (NSString *fileName in contents) {
        NSString *pathExtension = [[fileName pathExtension] lowercaseString];
        if (![pathExtension isEqualToString:@"wav"] && ![pathExtension isEqualToString:@"mp3"]) {
            continue;
        }
        
        // Add sound
        NSString *filePath = [failureSoundPath stringByAppendingPathComponent:fileName];
        NSSound *sound = [[NSSound alloc] initWithContentsOfFile:filePath byReference:NO];
        
        [failureSounds addObject:sound];
    }
    
    self.failureSounds = [failureSounds copy];
}

- (void)playWithSuccess:(BOOL)success
{
    if (success) {
        if (self.successSounds.count == 0) {
            return;
        }
        
        uint32_t index = arc4random_uniform((uint32_t)self.successSounds.count);
        NSSound *sound = [self.successSounds objectAtIndex:index];
        [sound play];
    } else {
        if (self.failureSounds.count == 0) {
            return;
        }
        
        uint32_t index = arc4random_uniform((uint32_t)self.failureSounds.count);
        NSSound *sound = [self.failureSounds objectAtIndex:index];
        [sound play];
    }
}

@end
