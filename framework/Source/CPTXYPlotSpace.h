#import "CPTAnimation.h"
#import "CPTDefinitions.h"
#import "CPTPlotSpace.h"

@class CPTPlotRange;

@interface CPTXYPlotSpace : CPTPlotSpace<CPTAnimationDelegate> {
    @private
    CPTPlotRange *xRange;
    CPTPlotRange *yRange;
    CPTPlotRange *globalXRange;
    CPTPlotRange *globalYRange;
    CPTScaleType xScaleType;
    CPTScaleType yScaleType;
    CGPoint lastDragPoint;
    CGPoint lastDisplacement;
    NSTimeInterval lastDragTime;
    NSTimeInterval lastDeltaTime;
    BOOL isDragging;
    BOOL allowsMomentum;
    NSMutableArray *animations;
}

@property (nonatomic, readwrite, copy) CPTPlotRange *xRange;
@property (nonatomic, readwrite, copy) CPTPlotRange *yRange;
@property (nonatomic, readwrite, copy) CPTPlotRange *globalXRange;
@property (nonatomic, readwrite, copy) CPTPlotRange *globalYRange;
@property (nonatomic, readwrite, assign) CPTScaleType xScaleType;
@property (nonatomic, readwrite, assign) CPTScaleType yScaleType;

@property (nonatomic, readwrite) BOOL allowsMomentum;

@end
