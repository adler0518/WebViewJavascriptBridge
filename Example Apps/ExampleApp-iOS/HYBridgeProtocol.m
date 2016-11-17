//
//  HYBridgeProtocol.m
//  ExampleApp-iOS
//
//  Created by qitmac000260 on 16/11/17.
//  Copyright © 2016年 Marcus Westin. All rights reserved.
//

#import "HYBridgeProtocol.h"
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
    
    NSString *data = [mutableReqeust valueForHTTPHeaderField:@"data"];
    data = [self urlDecoded: data];
    NSLog(@"data:%@", data);
    
    //TODO: 待完善，这里通过具体的调用来处理即可。这样就不需要通过webview的shouldStartLoadWithRequest去拦截处理
    
    if (data) {
        NSHTTPURLResponse* response = [[NSHTTPURLResponse alloc] initWithURL:self.request.URL
                                                                  statusCode:200
                                                                 HTTPVersion:@"HTTP/1.1"
                                                                headerFields:nil];
        
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        
        [self.client URLProtocolDidFinishLoading:self];

    }
    else {
//        self.connection = [NSURLConnection connectionWithRequest:mutableReqeust delegate:self];
    }
}

-(void)stopLoading
{
    
}

- (NSString *)urlDecoded:(NSString*)str
{
    NSString *result = (__bridge_transfer NSString *)
    CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                            (CFStringRef)str,
                                                            CFSTR(""),
                                                            kCFStringEncodingUTF8);
    return result;
}




@end
