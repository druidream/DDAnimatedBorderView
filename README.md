![DDAnimatedBorderView](https://github.com/druidream/HelloWorld/blob/master/DDAnimatedBorderView-demo.gif?raw=true)
#### USAGE
1. copy "DDAnimatedBorderView.h" and "DDAnimatedBorderView.m" and include the header file.

        #import "DDAnimatedBorderView.h"
2. settings

required: **frame**, typically set with the frame of the view below

        borderView = [[DDAnimatedBorderView alloc] initWithFrame:CGRectMake(40, 40, 240, 60)];
optional: **borderWidth**, **borderColor**, **animationDuration**

Default value will be used if no value set, specifically:
borderWidth : 1.0f
borderColor : {1.0f, 0.5f, 0.0f, 1.0f} (RGBA)
animationDuration : 1.5f

3. add to superview

        [self.view addSubview:borderView];
4. trigger animation by instance method

        - (void)animateIn;
and

        - (void)animateOut;
That's all.
