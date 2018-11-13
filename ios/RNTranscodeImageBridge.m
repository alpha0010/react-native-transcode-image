#import <Foundation/Foundation.h>

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(RNTranscodeImage, NSObject)
+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

RCT_EXTERN_METHOD(transcodeImage:(NSString *)source destination:(NSString *)destination options:(NSDictionary *)options resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)

@end
