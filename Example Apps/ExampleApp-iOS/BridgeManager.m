//
//  BridgeManager.m
//  ExampleApp-iOS
//
//  Created by qitmac000260 on 16/11/18.
//  Copyright © 2016年 Marcus Westin. All rights reserved.
//

#import "BridgeManager.h"

@implementation BridgeManager
+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
@end
