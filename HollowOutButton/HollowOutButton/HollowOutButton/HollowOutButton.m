//
//  HollowOutButton.m
//  HollowOutButton
//
//  Created by 小鱼闯江湖 on 2017/3/12.
//  Copyright © 2017年 小鱼闯江湖. All rights reserved.
//

#import "HollowOutButton.h"

@implementation HollowOutButton

- (UIColor*) getPixelColorAtLocation:(CGPoint)point{
    UIColor* color = nil;
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRef inImage = viewImage.CGImage;
    
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) {
        return nil;
    }
    
    size_t w = self.bounds.size.width;
    size_t h = self.bounds.size.height;
    
    CGRect rect = {{0,0},{w,h}};
    CGContextDrawImage(cgctx, rect, inImage);
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
    }
    CGContextRelease(cgctx);
    if (data) { free(data); }
    return color;
}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void * bitmapData;
    int bitmapByteCount;
    int bitmapBytesPerRow;
    
    size_t pixelsWide = self.bounds.size.width;
    size_t pixelsHigh = self.bounds.size.height;
    
    bitmapBytesPerRow   = (int)(pixelsWide * 4);
    bitmapByteCount     = (int)(bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL){
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL){
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    context = CGBitmapContextCreate (bitmapData,pixelsWide,pixelsHigh,8, bitmapBytesPerRow,colorSpace,kCGImageAlphaPremultipliedFirst);
    
    if (context == NULL){
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    CGColorSpaceRelease( colorSpace );
    return context;
}

/**
 Check whether the checkpoint is in view(override method)

 @param point checkpoint
 @param event default event
 @return result
 */
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    UIColor *color = [self getPixelColorAtLocation:point];

#pragma mark - You can override this method to filter custom colors
    //double red = [[color valueForKey:@"redComponent"] doubleValue];
    //double green = [[color valueForKey:@"greenComponent"] doubleValue];
    //double blue = [[color valueForKey:@"blueComponent"] doubleValue];
    
    double alpha = [[color valueForKey:@"alphaComponent"] doubleValue];
    
    //printf("red:%.2f    green:%.2f    blue:%.2f    alpha:%.2f\n",red,green,blue,alpha);
    
    if (alpha != 1 || ![super pointInside:point withEvent:event]) {
        return NO;
    }else{
        return YES;
    }
}
@end
