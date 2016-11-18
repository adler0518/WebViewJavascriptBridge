//
//  WebViewJavascriptBridgeBase.h
//
//  Created by @LokiMeyburg on 10/15/14.
//  Copyright (c) 2014 @LokiMeyburg. All rights reserved.
//  实现了OC 注入方法到JS,OC 调用JS 中的方法，即OC -> JS。 实现JS -> OC的调用，在WebViewJavascriptBridge_JS注入到JSContent，其中的_doSend
//

#import <Foundation/Foundation.h>

#define kCustomProtocolScheme @"wvjbscheme"
#define kQueueHasMessage      @"__WVJB_QUEUE_MESSAGE__"
#define kBridgeLoaded         @"__BRIDGE_LOADED__"

typedef void (^WVJBResponseCallback)(id responseData);
typedef void (^WVJBHandler)(id data, WVJBResponseCallback responseCallback);
typedef NSDictionary WVJBMessage;

@protocol WebViewJavascriptBridgeBaseDelegate <NSObject>
- (NSString*) _evaluateJavascript:(NSString*)javascriptCommand;
@end

@interface WebViewJavascriptBridgeBase : NSObject

@property (nonatomic, assign) BOOL *protocolPlanSign;       //采用protocol技术方案

@property (weak, nonatomic) id <WebViewJavascriptBridgeBaseDelegate> delegate;

//[{data: {请求数据}，callbackId: NSString, handlerName: NSString}]  【注：callbackId === objc_cb_%ld】
@property (strong, nonatomic) NSMutableArray* startupMessageQueue;      // call方法的时候注入，有responseCallback则生成callbackId

@property (strong, nonatomic) NSMutableDictionary* responseCallbacks;   //{callbackId: WVJBResponseCallback, ...} 【call方法的时候 注入】
@property (strong, nonatomic) NSMutableDictionary* messageHandlers;     //{handlerName: WVJBHandler} 【子类的registerHandler 注入】
@property (strong, nonatomic) WVJBHandler messageHandler;

+ (void)enableLogging;
+ (void)setLogMaxLength:(int)length;
- (void)reset;


/**
 通过bridge实例，调用js注入的方法

 @param data             携带的参数
 @param responseCallback JS需要处理的回调事件
 @param handlerName      方法名
 */
- (void)sendData:(id)data responseCallback:(WVJBResponseCallback)responseCallback handlerName:(NSString*)handlerName;


/**
 执行response回调处理，即recv处理。【输入日志RCVD】JS -> OC

 @param messageQueueString 数组的str格式 格式为：[{responseId:NSString, responseData: id,    data: {响应数据}，callbackId: NSString, handlerName: NSString },...]
 */
- (void)flushMessageQueue:(NSString *)messageQueueString;


/**
 注入JS代码WebViewJavascriptBridge_js，同时将startupMessageQueue中的全部执行并清空
 环境初始化好之前调用了即将注入的方法，则会被存储到startupMessageQueue中，在环境初始化完成之后，统一调用。
 or 注入新环境的时候调用，以便将之前的作用域数据全部处理掉，并且初始干净的startupMessageQueue。
 判断规则：已特殊的src来判断isQueueMessageURL:
 */
- (void)injectJavascriptFile;

- (BOOL)isCorrectProcotocolScheme:(NSURL*)url;
- (BOOL)isQueueMessageURL:(NSURL*)urll;
- (BOOL)isBridgeLoadedURL:(NSURL*)urll;
- (void)logUnkownMessage:(NSURL*)url;
- (NSString *)webViewJavascriptCheckCommand;
- (NSString *)webViewJavascriptFetchQueyCommand;
- (void)disableJavscriptAlertBoxSafetyTimeout;

@end
