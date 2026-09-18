#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

static NSString *const kLog=@"/var/mobile/BubbleLab.txt";
static UIWindow *gWindow=nil;

static void BLLog(NSString *fmt,...){
 va_list a; va_start(a,fmt); NSString*m=[[NSString alloc]initWithFormat:fmt arguments:a]; va_end(a);
 NSString*s=[NSString stringWithFormat:@"[BUBBLE-LAB-1.0] %@\n",m?:@""];
 NSFileHandle*h=[NSFileHandle fileHandleForWritingAtPath:kLog];
 if(!h)[s writeToFile:kLog atomically:YES encoding:NSUTF8StringEncoding error:nil];
 else @try{[h seekToEndOfFile];[h writeData:[s dataUsingEncoding:NSUTF8StringEncoding]];[h closeFile];}@catch(__unused NSException*e){}
}
static UIWindowScene *CarScene(void){
 for(UIScene*raw in UIApplication.sharedApplication.connectedScenes){
  if(![raw isKindOfClass:UIWindowScene.class])continue; UIWindowScene*s=(UIWindowScene*)raw;
  NSString*r=s.session.role?:@""; CGSize z=s.screen.bounds.size;
  if([r localizedCaseInsensitiveContainsString:@"CarPlay"]||(z.width>z.height&&z.width>=300&&z.height<=500))return s;
 } return nil;
}
static void Build(void){
 UIWindowScene*s=CarScene(); if(!s){BLLog(@"NO CARPLAY SCENE");return;}
 CGRect b=s.screen.bounds; gWindow=[[UIWindow alloc]initWithWindowScene:s]; gWindow.frame=b; gWindow.windowLevel=2500;
 UIViewController*vc=[UIViewController new]; vc.view.backgroundColor=UIColor.clearColor; gWindow.rootViewController=vc;
 UIView*v=[[UIView alloc]initWithFrame:CGRectMake(8,8,88,88)]; v.backgroundColor=UIColor.systemYellowColor; v.layer.cornerRadius=44;
 v.layer.borderWidth=7;v.layer.borderColor=UIColor.systemGreenColor.CGColor;v.userInteractionEnabled=NO;[vc.view addSubview:v];
 UILabel*l=[[UILabel alloc]initWithFrame:v.bounds];l.text=@"LAB";l.textAlignment=NSTextAlignmentCenter;l.font=[UIFont boldSystemFontOfSize:20];l.textColor=UIColor.blackColor;[v addSubview:l];
 gWindow.hidden=NO;
 @try{id c=[gWindow.layer valueForKey:@"context"];BLLog(@"CREATED scene=%@ size=%@ windowLevel=%.1f contextId=%@ displayId=%@",s.session.persistentIdentifier,NSStringFromCGSize(b.size),gWindow.windowLevel,[c valueForKey:@"contextId"],[c valueForKey:@"displayId"]);}@catch(NSException*e){BLLog(@"INSPECT %@",e.reason);}
}
%ctor{@autoreleasepool{
 if(![NSBundle.mainBundle.bundleIdentifier isEqualToString:@"com.apple.CarPlayApp"])return;
 BLLog(@"ACTIVE bundle=%@",NSBundle.mainBundle.bundleIdentifier);
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW,1500*NSEC_PER_MSEC),dispatch_get_main_queue(),^{Build();});
}}
