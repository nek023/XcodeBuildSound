//
//  XBSPlugin.m
//  XcodeBuildSound
//
//  Created by Tanaka Katsuma on 2013/12/27.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "XBSPlugin.h"

// Xcode5-Headers
#import "IDEBuildOperation.h"

// Categories
#import "NSBundle+Additions.h"

#import "XBSUserDefaultsManager.h"
#import "XBSPlayer.h"

static XBSPlugin *_sharedPlugin = nil;

@interface XBSPlugin ()

@property (nonatomic, strong) XBSPlayer *player;

@property (nonatomic, strong) NSMenuItem *successMenuItem;
@property (nonatomic, strong) NSMenuItem *failureMenuItem;

@end

@implementation XBSPlugin

+ (void)pluginDidLoad:(NSBundle *)bundle
{
    static dispatch_once_t _onceToken;
    dispatch_once(&_onceToken, ^{
        _sharedPlugin = [[XBSPlugin alloc] init];
    });
}

+ (instancetype)sharedPlugIn
{
    return _sharedPlugin;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        // Create directories
        NSString *resourcePath = [self.bundle resourcePath];
        NSString *soundsPath = [resourcePath stringByAppendingPathComponent:@"Sounds"];
        NSString *successSoundPath = [soundsPath stringByAppendingPathComponent:@"Success"];
        NSString *failureSoundPath = [soundsPath stringByAppendingPathComponent:@"Failure"];
        
        [[NSFileManager defaultManager] createDirectoryAtPath:successSoundPath withIntermediateDirectories:YES attributes:nil error:NULL];
        [[NSFileManager defaultManager] createDirectoryAtPath:failureSoundPath withIntermediateDirectories:YES attributes:nil error:NULL];
        
        // Load sounds
        XBSPlayer *player = [[XBSPlayer alloc] init];
        self.player = player;
        
        // Create menu items
        [self createMenuItems];
        
        // Add observer
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(buildOperationDidStop:)
                                                     name:@"IDEBuildOperationDidStopNotification"
                                                   object:nil];
        
        // Show the version information
        NSLog(@"XcodeBuildSound v%@ was successfully loaded.", [self.bundle shortVersionString]);
    }
    
    return self;
}


#pragma mark - Accessors

- (NSBundle *)bundle
{
    return [NSBundle bundleForClass:[self class]];
}


#pragma mark - Notifications

- (void)buildOperationDidStop:(NSNotification *)notification
{
    IDEBuildOperation *operation = (IDEBuildOperation *)notification.object;
    
    int result = [[operation valueForKey:@"_result"] intValue];
    switch (result) {
        case 1: // Success
        {
            if ([[XBSUserDefaultsManager sharedManager] isSuccessSoundsEnabled]) {
                [self.player playWithSuccess:YES];
            }
        }
            break;
            
        case 2: // Failure
        {
            if ([[XBSUserDefaultsManager sharedManager] isFailureSoundsEnabled]) {
                [self.player playWithSuccess:NO];
            }
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - Menu

- (void)createMenuItems
{
    NSMenuItem *productMenuItem = [[NSApp mainMenu] itemWithTitle:@"Product"];
    
    if (productMenuItem && [[productMenuItem submenu] itemWithTitle:@"Build Sounds"] == nil) {
        NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:@"Build Sounds" action:NULL keyEquivalent:@""];
        
        NSMenu *submenu = [[NSMenu alloc] initWithTitle:@"Build Sounds"];
        menuItem.submenu = submenu;
        
        // Success
        NSMenuItem *successMenuItem = [[NSMenuItem alloc] initWithTitle:@"Success" action:@selector(toggleSuccess) keyEquivalent:@""];
        [successMenuItem setTarget:self];
        successMenuItem.state = [[XBSUserDefaultsManager sharedManager] isSuccessSoundsEnabled] ? NSOnState : NSOffState;
        
        [submenu addItem:successMenuItem];
        self.successMenuItem = successMenuItem;
        
        // Failure
        NSMenuItem *failureMenuItem = [[NSMenuItem alloc] initWithTitle:@"Failure" action:@selector(toggleFailure) keyEquivalent:@""];
        [failureMenuItem setTarget:self];
        failureMenuItem.state = [[XBSUserDefaultsManager sharedManager] isFailureSoundsEnabled] ? NSOnState : NSOffState;
        
        [submenu addItem:failureMenuItem];
        self.failureMenuItem = failureMenuItem;
        
        // Separator
        [submenu addItem:[NSMenuItem separatorItem]];
        
        // Manage Sounds
        NSMenuItem *manageSoundsMenuItem = [[NSMenuItem alloc] initWithTitle:@"Manage Sounds" action:@selector(manageSounds) keyEquivalent:@""];
        [manageSoundsMenuItem setTarget:self];
        
        [submenu addItem:manageSoundsMenuItem];
        
        // Add menu items
        [[productMenuItem submenu] addItem:[NSMenuItem separatorItem]];
        [[productMenuItem submenu] addItem:menuItem];
    }
}

- (void)toggleSuccess
{
    BOOL successSoundsEnabled = ![[XBSUserDefaultsManager sharedManager] isSuccessSoundsEnabled];
    [[XBSUserDefaultsManager sharedManager] setSuccessSoundsEnabled:successSoundsEnabled];
    
    self.successMenuItem.state = successSoundsEnabled ? NSOnState : NSOffState;
}

- (void)toggleFailure
{
    BOOL failureSoundsEnabled = ![[XBSUserDefaultsManager sharedManager] isFailureSoundsEnabled];
    [[XBSUserDefaultsManager sharedManager] setFailureSoundsEnabled:failureSoundsEnabled];
    
    self.failureMenuItem.state = failureSoundsEnabled ? NSOnState : NSOffState;
}

- (void)manageSounds
{
    NSString *resourcePath = [self.bundle resourcePath];
    NSString *soundsPath = [resourcePath stringByAppendingPathComponent:@"Sounds"];
    
    [[NSWorkspace sharedWorkspace] openFile:soundsPath];
}

@end
