//
//  AppDelegate.m
//  TestPeerLoft
//
//  Created by Alexey Shepitko on 8/30/12.
//  Copyright (c) 2012 Alexey Shepitko. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate()

- (void)takeRectScreenshot:(CGRect)rect withWindowID:(CGWindowID)windowID withOption:(CGWindowListOption)windowOption;
- (void)saveImage:(NSImage*)image;

@end

@implementation AppDelegate

@synthesize menuBarMenu = _menuBarMenu;
@synthesize menuBarStatusItem = _menuBarStatusItem;

- (NSStatusItem*)menuBarStatusItem
{
    if (!_menuBarStatusItem) {
        NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
        if (statusBar) {
            _menuBarStatusItem = [statusBar statusItemWithLength:NSVariableStatusItemLength];
            _menuBarStatusItem.highlightMode = YES;
            //NSString *imagePath = [[NSBundle mainBundle] pathForImageResource:@"Image.png"];
            NSImage *menuBarStatusItemImage = [NSImage imageNamed:@"Image.png"];
            if (menuBarStatusItemImage) {
                _menuBarStatusItem.image = menuBarStatusItemImage;
            }
            _menuBarStatusItem.toolTip = @"Test Peer Loft";
            _menuBarStatusItem.menu = self.menuBarMenu;
        }
    }
    return _menuBarStatusItem;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self menuBarStatusItem];
}

- (void)takeRectScreenshot:(CGRect)rect withWindowID:(CGWindowID)windowID withOption:(CGWindowListOption)windowOption
{
    CGImageRef screenShot = CGWindowListCreateImage(rect, windowOption, windowID, kCGWindowImageDefault);
    NSImage *image = [[NSImage alloc] initWithCGImage:screenShot size:NSZeroSize];
    CGImageRelease(screenShot);
    [self saveImage:image];
}

- (void)saveImage:(NSImage*)image
{
    if (image) {
        NSData* imageTiffData = [image TIFFRepresentationUsingCompression:NSTIFFCompressionJPEG factor:1];
        NSError *error = nil;
        NSURL *desktopUrl = [[NSFileManager defaultManager] URLForDirectory:NSDesktopDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:&error];
        if (desktopUrl) {
            [imageTiffData writeToURL:[desktopUrl URLByAppendingPathComponent:[NSString stringWithFormat:@"%@ - Screenshot.tiff", [[NSDate date] description]]] atomically:YES];
        }
    }
}

- (IBAction)takeFullScreenshot:(id)sender
{
    [self takeRectScreenshot:CGRectInfinite withWindowID:kCGNullWindowID withOption:kCGWindowListOptionOnScreenOnly];
}

- (IBAction)takeTopLeftScreenshot:(id)sender
{
    [self takeRectScreenshot:CGRectMake(0, 0, 500, 400) withWindowID:kCGNullWindowID withOption:kCGWindowListOptionOnScreenOnly];
}

- (IBAction)takeActiveScreenshot:(id)sender
{
    CFArrayRef arrayRef = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly | kCGWindowListExcludeDesktopElements, kCGNullWindowID);
    NSArray *array = (__bridge NSArray*)arrayRef;
    __block CGWindowID windowID = 0;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSDictionary *dict = (NSDictionary*)obj;
        NSString *applicationName = [dict valueForKey:(id)kCGWindowOwnerName];
        if ([applicationName compare:@"Finder"] == NSOrderedSame) {
            NSNumber *number = [dict valueForKey:(id)kCGWindowNumber];
            windowID = (CGWindowID)[number longValue];
            *stop = YES;
        }
        
    }];
    if (windowID > 0) [self takeRectScreenshot:CGRectNull withWindowID:windowID withOption:kCGWindowListOptionIncludingWindow];
}

@end
