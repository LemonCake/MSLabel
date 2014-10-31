//
//  MSLabel.m
//  Miso
//
//  Created by Joshua Wu on 11/15/11.
//  Copyright (c) 2011 Miso. All rights reserved.
//

#import "MSLabel.h"

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

// small buffer to allow for characters like g,y etc 
static const int kAlignmentBuffer = 5;

@interface MSLabel ()

- (void)setup;
- (NSArray *)stringsFromText:(NSString *)string;

- (NSMutableArray *)arrayOfCharactersInString:(NSString *)string;
- (NSString *)lastWordInString:(NSString *)string;


@property (nonatomic, assign) int drawX;

@end

@implementation MSLabel

@synthesize lineHeight = _lineHeight;
@synthesize verticalAlignment = _verticalAlignment;
@synthesize drawX;

#pragma mark - Initilisation

- (id)initWithFrame:(CGRect)frame {
    
    
    if ((self = [super initWithFrame:frame]))
    {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder]))
    {
        [self setup];
    }
    
    return self;
}


#pragma mark - Drawing

- (void)drawTextInRect:(CGRect)rect 
{
    NSArray *slicedStrings = [self stringsFromText:self.text];
    if (self.highlighted) {
        [self.highlightedTextColor set]; 
    }
    else {
        [self.textColor set];   
    }
    
    int numLines = slicedStrings.count;
    if (numLines > self.numberOfLines && self.numberOfLines != 0) {
        numLines = self.numberOfLines;
    }
    
    int drawY = (self.frame.size.height / 2 - (_lineHeight * numLines) / 2) - kAlignmentBuffer;    
    
    for (int i = 0; i < numLines; i++) {        
        
        NSString *line = [slicedStrings objectAtIndex:i];
        
        // calculate draw Y based on alignment
        switch (_verticalAlignment) {
            case MSLabelVerticalAlignmentTop:
            {
                drawY = i * _lineHeight;
            }
                break;
            case MSLabelVerticalAlignmentMiddle:
            {
                if(i > 0) {
                    drawY += _lineHeight;            
                }
            }
                break;
            case MSLabelVerticalAlignmentBottom:
            {
                drawY = (self.frame.size.height - _lineHeight * numLines) + ((i  * _lineHeight) - kAlignmentBuffer);
            }
                break;
            default:
            {
                if(i > 0) {
                    drawY = i * _lineHeight;
                }
            }
                break;
        }
        
        // calculate draw X based on textAlignmentment
        
        if (self.textAlignment == UITextAlignmentCenter) {
            drawX = floorf((self.frame.size.width - [line sizeWithFont:self.font].width) / 2);
        } else if (self.textAlignment == UITextAlignmentRight) {
            drawX = (self.frame.size.width - [line sizeWithFont:self.font].width);
        }
        
        drawX = drawX < 0 ? 0 : drawX;
        
        CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), self.shadowOffset, 0, self.shadowColor.CGColor);
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            // NOTE: Used to be UILineBreakModeClip but is now deprecated. Checking the headers UILineBreakModeClip == NSLineBreakByClipping,
            // so this is safe even below iOS 6 if using xcode > 4.0.
            [line drawAtPoint:CGPointMake(drawX, drawY) forWidth:self.frame.size.width withFont:self.font fontSize:self.font.pointSize lineBreakMode:NSLineBreakByClipping baselineAdjustment:UIBaselineAdjustmentNone];
        } else {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineBreakMode = NSLineBreakByClipping;
            
            NSShadow *shadowStyle = [[NSShadow alloc] init];
            shadowStyle.shadowColor = self.shadowColor;
            shadowStyle.shadowOffset = self.shadowOffset;
            
            [line drawAtPoint:CGPointMake(drawX, drawY) withAttributes:@{
                                                                         NSParagraphStyleAttributeName : paragraphStyle,
                                                                         NSFontAttributeName : self.font,
                                                                         NSForegroundColorAttributeName : self.textColor,
                                                                         NSShadowAttributeName : shadowStyle
                                                                         }];
        }
    }
}


#pragma mark - Properties

- (void)setLineHeight:(int)lineHeight 
{
    if (_lineHeight == lineHeight) 
    { 
        return; 
    }
    
    _lineHeight = lineHeight;
    [self setNeedsDisplay];
}


#pragma mark - Private Methods

- (void)setup {
    _lineHeight = 12;
    self.minimumFontSize = 12;
    _verticalAlignment = MSLabelVerticalAlignmentMiddle;
}

- (NSArray *)stringsFromText:(NSString *)string {
    
    if (self.lineBreakMode == (SYSTEM_VERSION_LESS_THAN(@"6.0") ? UILineBreakModeWordWrap : NSLineBreakByWordWrapping)) {
        return [self stringsWithWordsWrappedFromString:string];
    }
    
    NSMutableArray *characterArray = [self arrayOfCharactersInString:string];
    NSMutableArray *slicedString = [NSMutableArray array];
    
    while (characterArray.count != 0) {
        NSString *line = @"";
        NSMutableIndexSet *charsToRemove = [NSMutableIndexSet indexSet];
        
        for (int i = 0; i < [characterArray count]; i++) {
            NSString *character = [characterArray objectAtIndex:i];
            CGFloat stringWidth = [[line stringByAppendingFormat:@"%@", character] sizeWithFont:self.font].width;
            
            // shrink font to fit text as best as we can
//            if(stringWidth > (self.frame.size.width - 10)) {
//                CGFloat fontSize = self.font.pointSize;
//                
//                while(stringWidth > (self.frame.size.width - 10) && fontSize >= self.minimumFontSize) {
//                    self.font = [UIFont fontWithName:self.font.fontName size:fontSize--];
//                    _lineHeight = self.font.pointSize;
//                    stringWidth = [[line stringByAppendingFormat:@"%@", character] sizeWithFont:self.font].width;
//                }
//            }
            
            if (stringWidth <= (self.frame.size.width - 10)) {
                line = [line stringByAppendingFormat:@"%@", character];
                [charsToRemove addIndex:i];
            } else {
                if (line.length == 0) {
                    line = [line stringByAppendingFormat:@"%@", character];
                    [charsToRemove addIndex:i];
                }
                
                break;
            }
        }
      if (self.lineBreakMode == (SYSTEM_VERSION_LESS_THAN(@"6.0") ? UILineBreakModeWordWrap : NSLineBreakByWordWrapping)) {
        [slicedString addObject:line];
      } else {
        [slicedString addObject:[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
      }
      
        [characterArray removeObjectsAtIndexes:charsToRemove];
    }
    
    return slicedString;
}

- (NSMutableArray *)stringsWithWordsWrappedFromString:(NSString *)string {
    
    NSCharacterSet *delimiterCharacterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSArray *words = [string componentsSeparatedByCharactersInSet:delimiterCharacterSet];
    
    NSMutableArray *outputLines = [[NSMutableArray alloc] init];
    
    int lineNumber = 0;
    
    for (id word in words) {
        if ([outputLines count] == 0) {
            [outputLines insertObject:word atIndex:lineNumber];
            continue;
            
        }
        
        NSString *line = [outputLines objectAtIndex:lineNumber];
        NSString *newLine = [NSString stringWithFormat:@"%@ %@", line, word];
        
        
        
        // Break to new line when adding another word to this line will make it too long
        // so long as we're below the total desired line count
        
        // XXX: I assume self.numberOfLines == 0 is unlimited
        if ([newLine sizeWithFont:self.font].width > self.frame.size.width && (lineNumber < self.numberOfLines - 1 || self.numberOfLines == 0)) {
            lineNumber++;
            [outputLines insertObject:word atIndex:lineNumber];
        } else {
            [outputLines replaceObjectAtIndex:lineNumber withObject:newLine];
        }
        
    }
    
    // Truncate the last line adding an ellipsis (...) until it is within our desired width
    NSString *lastLine = [outputLines lastObject];
    if ([lastLine sizeWithFont:self.font].width > self.frame.size.width) {
        // First, attempt to just replace the last 3 chars with ellipsis since the ellipsis might be
        // sufficiently narrower than the original chars
        lastLine = [lastLine stringByReplacingCharactersInRange:NSMakeRange(lastLine.length - 3, 3) withString:@"..."];
    }
    while ([lastLine sizeWithFont:self.font].width > self.frame.size.width) {
        // If that failed, remove one character at a time from the end of the string
        // until we reach the desired length.
        lastLine = [lastLine stringByReplacingCharactersInRange:NSMakeRange(lastLine.length - 4, 4) withString:@"..."];
    }
    
    // Replace last line with its ellpsis'ed version.
    [outputLines replaceObjectAtIndex:[outputLines count] - 1 withObject:lastLine];
    
    return outputLines;
}

- (NSString *)lastWordInString:(NSString *)string {
    NSString *lastWord;
    
    // Check for whole words
     NSArray *wordArray = [string componentsSeparatedByString:@" "];
    lastWord = wordArray.count > 1 ? lastWord = [wordArray lastObject] : @"";
    
    return lastWord;
}

- (NSMutableArray *)arrayOfCharactersInString:(NSString *)string {
    NSRange theRange = {0, 1};
    
    NSMutableArray *stringsArray  = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [string length]; i++) {
        theRange.location = i;
        [stringsArray addObject:[string substringWithRange:theRange]];
    }
    
    return stringsArray;
}

@end
