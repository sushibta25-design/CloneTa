#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/message.h>
static NSString*const P=@"/var/mobile/VMLHostSniffer.txt";
static void L(NSString*f,...){va_list a;va_start(a,f);NSString*m=[[NSString alloc]initWithFormat:f arguments:a];va_end(a);NSString*s=[NSString stringWithFormat:@"[CLONE-SCENEHOST-16.65] %@\n",m?:@""];NSFileHandle*h=[NSFileHandle fileHandleForWritingAtPath:P];if(!h)[s writeToFile:P atomically:YES encoding:NSUTF8StringEncoding error:nil];else @try{[h seekToEndOfFile];[h writeData:[s dataUsingEncoding:NSUTF8StringEncoding]];[h closeFile];}@catch(__unused NSException*e){}}
static id V(id o,NSString*k){@try{return[o valueForKey:k];}@catch(__unused NSException*e){return nil;}}
static void Probe(UIView*h){if(!h.superview)return;CALayer*l=h.layer;id cid=V(l,@"contextId");id ctx=V(h.window.layer,@"context");L(@"HOST self=%p frame=%@ layer=%@ layerCtxId=%@ window=%@ winCtx=%@ winCtxId=%@ displayId=%@ super=%@ superLayer=%@",h,NSStringFromCGRect(h.frame),NSStringFromClass(l.class),cid,NSStringFromClass(h.window.class),ctx,V(ctx,@"contextId"),V(ctx,@"displayId"),NSStringFromClass(h.superview.class),NSStringFromClass(l.superlayer.class));for(CALayer*x=l,int i=0;x&&i<8;x=x.superlayer,i++)L(@" L%d %@ %p frame=%@ z=%.1f ctxId=%@",i,NSStringFromClass(x.class),x,NSStringFromCGRect(x.frame),x.zPosition,V(x,@"contextId"));}
%hook _UIContextLayerHostView
-(void)didMoveToSuperview{%orig;UIView*h=(UIView*)self;if(h.superview)dispatch_async(dispatch_get_main_queue(),^{Probe(h);});}
%end
%ctor{@autoreleasepool{if(![NSBundle.mainBundle.bundleIdentifier isEqualToString:@"com.apple.CarPlayApp"])return;L(@"SCENE HOST COMPOSITOR PROBE 16.65 ACTIVE — READ ONLY");}}
