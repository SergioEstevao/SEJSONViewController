//
//  AppDelegate.m
//  Example
//
//  Created by Sérgio Estêvão on 15/09/2013.
//  Copyright (c) 2013 Sergio Estevao. All rights reserved.
//

#import "AppDelegate.h"
#import "SEJSONViewController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    // Read the JSON data
    id data = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"data" withExtension:@"json"]] options:NSJSONReadingAllowFragments error:nil];
    // Initialize the view controller
    SEJSONViewController * jsonViewController = [[SEJSONViewController alloc] initWithData:data];
    // display it inside a UINavigationController
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:jsonViewController ];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
