
#import "CPGraph.h"
#import "CPExceptions.h"
#import "CPPlot.h"
#import "CPPlotArea.h"
#import "CPPlotSpace.h"


@implementation CPGraph

@synthesize axisSet;
@synthesize plotArea;
@synthesize defaultPlotSpace;

#pragma mark Init/Dealloc
-(id)init
{
	if ( self = [super init] ) {
        self.bounds = CGRectMake(0.0, 0.0, 100.0, 100.0);
		plots = [[NSMutableArray alloc] init];
        plotArea = [[CPPlotArea alloc] init];
		plotArea.frame = CGRectInset(self.bounds, 20.0, 20.0); // Replace later with true margins
		plotSpaces = [[NSMutableArray alloc] init];
        [self addSublayer:plotArea];
		self.autoresizingMask = (kCALayerHeightSizable | kCALayerWidthSizable | kCALayerMinXMargin | kCALayerMaxXMargin | kCALayerMinYMargin | kCALayerMaxYMargin);
	}
	return self;
}

-(void)dealloc
{
	self.axisSet = nil;
	self.plotArea = nil;
	[plots release];
	[plotSpaces release];
	[super dealloc];
}

#pragma mark Retrieving Plots
-(NSArray *)allPlots 
{    
	return [NSArray arrayWithArray:plots];
}

-(CPPlot *)plotAtIndex:(NSUInteger)index
{
    return [plots objectAtIndex:index];
}

-(CPPlot *)plotWithIdentifier:(id <NSCopying>)identifier 
{
	for (CPPlot *plot in plots) {
        if ( [[plot identifier] isEqual:identifier] ) return plot;
	}
    return nil;
}

#pragma mark Organizing Plots
-(void)addPlot:(CPPlot *)plot
{
	[self addPlot:plot toPlotSpace:self.defaultPlotSpace];
}

-(void)addPlot:(CPPlot *)plot toPlotSpace:(CPPlotSpace *)space
{
	plot.frame = space.bounds;
	[plots addObject:plot];
    plot.plotSpace = space;
	[space addSublayer:plot];	
}

-(void)removePlot:(CPPlot *)plot
{
    if ( [plots containsObject:plot] ) {
        [plots removeObject:plot];
        plot.plotSpace = nil;
        [plot removeFromSuperlayer];
    }
    else {
        [NSException raise:CPException format:@"Tried to remove CPPlot which did not exist."];
    }
}

-(void)insertPlot:(CPPlot* )plot atIndex:(NSUInteger)index 
{
	[self insertPlot:plot atIndex:index intoPlotSpace:self.defaultPlotSpace];
}

-(void)insertPlot:(CPPlot* )plot atIndex:(NSUInteger)index intoPlotSpace:(CPPlotSpace *)space
{
	[plots insertObject:plot atIndex:index];
    plot.plotSpace = space;
    [space addSublayer:plot];
}

-(void)removePlotWithIdentifier:(id <NSCopying>)identifier 
{
	CPPlot* plotToRemove = [self plotWithIdentifier:identifier];
	[plotToRemove setPlotSpace:nil];
	[plotToRemove removeFromSuperlayer];
	[plots removeObjectIdenticalTo:plotToRemove];
}

-(void)replacePlotAtIndex:(NSUInteger)index withPlot:(CPPlot *)plot 
{
	[(CPPlot*)[plots objectAtIndex:index] removeFromSuperlayer];
	[(CPPlot*)[plots objectAtIndex:index] setPlotSpace:nil];
	[plotArea addSublayer:plot];
	plot.plotSpace = [self defaultPlotSpace];
	[plots replaceObjectAtIndex:index withObject:plot];
}

-(void)replacePlotAtIndex:(NSUInteger)index withPlot:(CPPlot *)plot inPlotSpace:(CPPlotSpace *)space
{
	[(CPPlot*)[plots objectAtIndex:index] removeFromSuperlayer];
	[(CPPlot*)[plots objectAtIndex:index] setPlotSpace:nil];
	[plotArea addSublayer:plot];
	plot.plotSpace = space;
	[plots replaceObjectAtIndex:index withObject:plot];
}

#pragma mark Retrieving Plot Spaces
-(CPPlotSpace *)defaultPlotSpace {
    return ( plotSpaces.count > 0 ? [plotSpaces objectAtIndex:0] : nil );
}

-(NSArray *)allPlotSpaces
{
	return [NSArray arrayWithArray:plotSpaces];
}

-(CPPlotSpace *)plotSpaceAtIndex:(NSUInteger)index
{
	return ( plotSpaces.count > index ? [plotSpaces objectAtIndex:index] : nil );
}

-(CPPlotSpace *)plotSpaceWithIdentifier:(id <NSCopying>)identifier
{
	for (CPPlotSpace *plotSpace in plotSpaces) {
        if ( [[plotSpace identifier] isEqual:identifier] ) return plotSpace;
	}
    return nil;	
}


#pragma mark Organizing Plot Spaces
-(void)addPlotSpace:(CPPlotSpace *)space
{
	space.frame = self.plotArea.bounds;
	[plotSpaces addObject:space];
	[self.plotArea addSublayer:space];
}

-(void)removePlotSpace:(CPPlotSpace *)plotSpace
{
	if ( [plotSpaces containsObject:plotSpace] ) {
        [plotSpaces removeObject:plotSpace];
        [plotSpace removeFromSuperlayer];
    }
    else {
        [NSException raise:CPException format:@"Tried to remove CPPlotSpace which did not exist."];
    }
	
}


#pragma mark Dimensions
-(CGRect)plotAreaFrame
{
	return plotArea.frame;
}

-(void)setPlotAreaFrame:(CGRect)frame
{
    plotArea.frame = frame;
}

@end
