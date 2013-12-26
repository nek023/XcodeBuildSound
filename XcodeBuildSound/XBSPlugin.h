//
//  XBSPlugin.h
//  XcodeBuildSound
//
//  Created by Tanaka Katsuma on 2013/12/27.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBSPlugin : NSObject

@property (readonly) NSBundle *bundle;

+ (void)pluginDidLoad:(NSBundle *)bundle;
+ (instancetype)sharedPlugIn;

@end
