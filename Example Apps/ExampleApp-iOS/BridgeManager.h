//
//  BridgeManager.h
//  ExampleApp-iOS
//
//  Created by qitmac000260 on 16/11/18.
//  Copyright © 2016年 Marcus Westin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebViewJavascriptBridge;
@interface BridgeManager : NSObject

@property (nonatomic, strong) WebViewJavascriptBridge *bridge;

+ (instancetype)sharedInstance;

@end
