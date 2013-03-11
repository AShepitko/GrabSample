//
//  AppDelegate.h
//  TestPeerLoft
//
//  Created by Alexey Shepitko on 8/30/12.
//  Copyright (c) 2012 Alexey Shepitko. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

//@property (assign) IBOutlet NSWindow *window;

@property (nonatomic, readonly) NSStatusItem *menuBarStatusItem;
@property (nonatomic, retain) IBOutlet NSMenu *menuBarMenu;

- (IBAction)takeFullScreenshot:(id)sender;
- (IBAction)takeTopLeftScreenshot:(id)sender;
- (IBAction)takeActiveScreenshot:(id)sender;

@end
