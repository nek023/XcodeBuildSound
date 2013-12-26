//
//  NSBundle+Additions.h
//  XcodeBuildSound
//
//  Created by Tanaka Katsuma on 2013/12/26.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (Additions)

- (NSString *)shortVersionString;
- (NSNumber *)buildNumber;

@end
