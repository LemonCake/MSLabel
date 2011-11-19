MSLabel is a custom UILabel that allows you to specify LineHeight and Anchor point. 
There is another custom UILabel that supports line heights here: https://github.com/Tuszy/MTLabel
It works great, except it uses coreText so it won't work on iOS < v3.2
MSLabel doesn't use coreText and simply overrides drawRect.

Usage
-----
It supports most UILabel properties including text alignment, font, colors...etc.

line height specifies the number of pixels between draw points of each line.
anchorToBottom specifies whether the text grows from the top of the frame or the bottom.

eg.
MSLabel *titleLabel = [[[MSLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)] autorelease];
titleLabel.lineHeight = 13;
titleLabel.anchorToBottom = YES;
titleLabel.numberOfLines = 2;
titleLabel.text = @"Some really really long text that goes to the second line";
[self.view addSubview:titleLabel];

Unsupported
-----------
- \n line breaks are ignored
- Does not support UILineBreakModes. By default MSLabel truncates the last line with ...
