//
//  HYBridgeProtocol.m
//  ExampleApp-iOS
//
//  Created by qitmac000260 on 16/11/17.
//  Copyright © 2016年 Marcus Westin. All rights reserved.
//

#import "HYBridgeProtocol.h"
#import "BridgeManager.h"
#import "WebViewJavascriptBridge.h"
static NSString * const kHYBridgeProtocolHandledKey = @"HYBridgeProtocolHandledKey";

@implementation HYBridgeProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSLog(@"xxxxxx canInitWithRequest request:%@", request);
    if ([NSURLProtocol propertyForKey:kHYBridgeProtocolHandledKey inRequest:request]) {
        return NO;
    }
    
    if ([request.URL.path isEqualToString:@"/__WVJB_QUEUE_MESSAGE__"]) {
        return YES;
    }
    
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    NSLog(@"xxxxxx startLoading mutableReqeust:%@", mutableReqeust);
    //标示改request已经处理过了，防止无限循环
    [NSURLProtocol setProperty:@YES forKey:kHYBridgeProtocolHandledKey inRequest:mutableReqeust];
    
    [[BridgeManager sharedInstance].bridge bridgeInterceptor:mutableReqeust];
    
    NSHTTPURLResponse* response = [[NSHTTPURLResponse alloc] initWithURL:self.request.URL
                                                              statusCode:200
                                                             HTTPVersion:@"HTTP/1.1"
                                                            headerFields:nil];
    
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    
    [self.client URLProtocolDidFinishLoading:self];
}

-(void)stopLoading
{
    
}




@end
