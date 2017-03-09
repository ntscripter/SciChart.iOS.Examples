//
//  ThemeCustomChartView.m
//  SciChartDemo
//
//  Created by Hrybenuik Mykola on 12/15/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "ThemeCustomChartView.h"
#import "DataManager.h"
#import <SciChart/SciChart.h>

@interface ThemeCustomChartView ()

@property (nonatomic) NSArray <SCDMultiPaneItem*> *dataSource;

@end

@implementation ThemeCustomChartView
@synthesize sciChartSurfaceView;
@synthesize surface;

- (void)initializeSurfaceRenderableSeries{
    
    SCIXyDataSeries * priceDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    [priceDataSeries setSeriesName:@"Line Series"];
    priceDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIFastLineRenderableSeries * priceRenderableSeries = [SCIFastLineRenderableSeries new];
    [priceRenderableSeries.style setDrawPointMarkers: NO];
    [priceRenderableSeries setXAxisId: @"xAxis"];
    [priceRenderableSeries setYAxisId: @"yAxis"];
    [priceRenderableSeries setDataSeries:priceDataSeries];
    [surface.renderableSeries add:priceRenderableSeries];
    
    
    SCIOhlcDataSeries * ohlcDataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Float
                                                                            YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    [ohlcDataSeries setSeriesName:@"Candle Series"];
    
    ohlcDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIFastCandlestickRenderableSeries * candlestickRenderableSeries = [[SCIFastCandlestickRenderableSeries alloc] init];
    candlestickRenderableSeries.xAxisId = @"xAxis";
    candlestickRenderableSeries.yAxisId = @"yAxis";
    [candlestickRenderableSeries setDataSeries: ohlcDataSeries];
    candlestickRenderableSeries.style.drawBorders = NO;
    [surface.renderableSeries add:candlestickRenderableSeries];
    
    SCIXyDataSeries * mountainDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double
                                                                            YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    [mountainDataSeries setSeriesName:@"Mountain Series"];
    mountainDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIFastMountainRenderableSeries * mountainRenderableSeries = [[SCIFastMountainRenderableSeries alloc] init];
    mountainRenderableSeries.xAxisId = @"xAxis";
    mountainRenderableSeries.yAxisId = @"yAxis";
    [mountainRenderableSeries setDataSeries: mountainDataSeries];
    
    [surface.renderableSeries add:mountainRenderableSeries];
    
    SCIXyDataSeries * columnDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double
                                                                          YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    [columnDataSeries setSeriesName:@"Column Series"];
    columnDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIFastColumnRenderableSeries * columnRenderableSeries = [[SCIFastColumnRenderableSeries alloc] init];
    columnRenderableSeries.style.dataPointWidth = 0.3;
    columnRenderableSeries.xAxisId = @"xAxis";
    columnRenderableSeries.yAxisId = @"yAxis";
    [columnRenderableSeries setDataSeries:columnDataSeries];
    [surface.renderableSeries add:columnRenderableSeries];
    
    SCDMovingAverage *averageHigh = [[SCDMovingAverage alloc] initWithLength:20];
    int i = 0;
    for (SCDMultiPaneItem *item in self.dataSource) {
        
        
        SCIGenericType date = SCIGeneric(i);
        SCIGenericType open = SCIGeneric(item.open);
        SCIGenericType high = SCIGeneric(item.high);
        SCIGenericType low = SCIGeneric(item.low);
        SCIGenericType close = SCIGeneric(item.close);
        
        [ohlcDataSeries appendX:date
                           Open:open
                           High:high
                            Low:low
                          Close:close];
        
        [priceDataSeries appendX:date Y:SCIGeneric([averageHigh push:item.close].current)];
        [mountainDataSeries appendX:date Y:SCIGeneric(item.close-1000)];
        [columnDataSeries appendX:date Y:SCIGeneric(item.close-3500)];
        i++;
        
    }
    
    [surface invalidateElement];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _dataSource = [DataManager loadThemeData];
        
        SCIChartSurfaceView * view = [[SCIChartSurfaceView alloc]initWithFrame:frame];
        sciChartSurfaceView = view;
        
        [sciChartSurfaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:sciChartSurfaceView];
        NSDictionary *layout = @{@"SciChart":sciChartSurfaceView};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|"
                                                                     options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|"
                                                                     options:0 metrics:0 views:layout]];

        [self initializeSurfaceData];
    }
    
    return self;
}

- (void)p_applyCustomTheme {
    
    SCIThemeProvider *themeProvider = [SCIThemeProvider new];
    
    
    // Axis
    
    themeProvider.axisTitleLabelStyle.colorCode = 0xFF6495ED;
    themeProvider.axisTickLabelStyle.colorCode = 0xFF6495ED;
    themeProvider.axisMajorGridLineBrush = [[SCISolidPenStyle alloc] initWithColorCode:0xFF102a47 withThickness:1.f];
    themeProvider.axisMinorGridLineBrush = [[SCISolidPenStyle alloc] initWithColorCode:0xFF0d223d withThickness:1.f];
    themeProvider.axisGridBandBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0xFF0e233a];
    
    //Modifier
    
    [themeProvider.modifierRolloverStyle setRolloverPen:[[SCISolidPenStyle alloc] initWithColorCode:0x33fd9f25 withThickness:1.f]];
    [themeProvider.modifierRolloverStyle setAxisTooltipColor:[UIColor fromABGRColorCode:0x33fd9f25]];
    [themeProvider.modifierRolloverStyle.axisTextStyle setColorCode:0xFFeeeeee];
    
    [themeProvider.modifierCursorStyle setCursorPen:[[SCISolidPenStyle alloc] initWithColorCode:0x996495ed withThickness:1.f]];
    [themeProvider.modifierCursorStyle setAxisHorizontalTooltipColor:[UIColor fromABGRColorCode:0x996495ed]];
    [themeProvider.modifierCursorStyle setAxisVerticalTooltipColor:[UIColor fromABGRColorCode:0x996495ed]];
    [themeProvider.modifierCursorStyle.axisVerticalTextStyle setColorCode:0xFFeeeeee];
    [themeProvider.modifierCursorStyle.axisHorizontalTextStyle setColorCode:0xFFeeeeee];
    
    themeProvider.modifierLegendBackgroundColor = [UIColor fromABGRColorCode:0xFF0D213a];
    
    // RendereableSeries
    
    themeProvider.stackedMountainAreaBrushStyle = themeProvider.mountainAreaBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFF094c9f];
    themeProvider.stackedMountainBorderPenStyle = themeProvider.mountainBorderPenStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF76bbd2 withThickness:1.f];
    
    themeProvider.impulseLinePenStyle = themeProvider.linePenStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFC6E6FF withThickness:1.f];
    
    themeProvider.stackedColumnBorderPenStyle = themeProvider.columnBorderPenStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFFFFFF withThickness:1.f];
    themeProvider.stackedColumnFillBrushStyle = themeProvider.columnFillBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFFFFFFFF];
    
    themeProvider.candleUpWickPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF6495ed withThickness:1.f];
    themeProvider.candleDownWickPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF00008b withThickness:1.f];
    themeProvider.candleUpBodyBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0xa06495ed];
    themeProvider.candleDownBodyBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0xa000008b];
    
    themeProvider.ohlcUpWickPenStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF6495ed withThickness:1.f];
    themeProvider.ohlcDownWickPenStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF00008b withThickness:1.f];
    
    themeProvider.bandPen1Style = [[SCISolidPenStyle alloc] initWithColorCode:0xFF6495ed withThickness:1.f];
    themeProvider.bandPen2Style = [[SCISolidPenStyle alloc] initWithColorCode:0xFF00008b withThickness:1.f];
    themeProvider.bandBrush1Style = [[SCISolidBrushStyle alloc] initWithColorCode:0xa06495ed];
    themeProvider.bandBrush2Style = [[SCISolidBrushStyle alloc] initWithColorCode:0xa000008b];
    
    //Chart
    
    themeProvider.chartTitleColor = [UIColor fromABGRColorCode:0xFF6495ED];
    themeProvider.borderPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF102a47 withThickness:1.f];
    themeProvider.seriesBackgroundBrush = [[SCISolidBrushStyle alloc] initWithColor:[UIColor clearColor]];
    themeProvider.backgroundBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0xFF0D213a];
    
    
    //Annotation
    
    themeProvider.annotationTextStyle.colorCode = 0xFF222222;
    themeProvider.annotationTextBackgroundColor = [UIColor fromABGRColorCode:0xFF999999];
    
    themeProvider.annotationAxisMarkerBorderColor = [UIColor clearColor];
    themeProvider.annotationAxisMarkerBackgroundColor = [UIColor fromABGRColorCode:0xFF999999];
    themeProvider.annotationAxisMarkerTextStyle.colorCode = 0xFF222222;
    themeProvider.annotationAxisMarkerLineStyle = [[SCISolidPenStyle alloc] initWithColorCode:0x77333333 withThickness:1.f];
    
    themeProvider.annotationLinePenStyle = [[SCISolidPenStyle alloc] initWithColorCode:0x77333333 withThickness:1.f];
    themeProvider.annotationLineResizeMarker = [[SCIEllipsePointMarker alloc] init];
    [(SCIEllipsePointMarker*)themeProvider.annotationLineResizeMarker setFillBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0x994682b4]];
    [(SCIEllipsePointMarker*)themeProvider.annotationLineResizeMarker setBorderPen:[[SCISolidPenStyle alloc] initWithColorCode:0xFF4682b4 withThickness:1.f]];
    
    themeProvider.annotationBoxPointMarkerStyle = [[SCIEllipsePointMarker alloc] init];
    [(SCIEllipsePointMarker*)themeProvider.annotationBoxPointMarkerStyle setFillBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0x994682b4]];
    [(SCIEllipsePointMarker*)themeProvider.annotationBoxPointMarkerStyle setBorderPen:[[SCISolidPenStyle alloc] initWithColorCode:0xFF4682b4 withThickness:1.f]];
    themeProvider.annotationBoxBorderPenStyle = [[SCISolidPenStyle alloc] initWithColor:[UIColor clearColor] withThickness:.0f];
    themeProvider.annotationBoxFillBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFF999999];
    
    [self.surface applyThemeWithThemeProvider:themeProvider];
}

- (void)initializeSurfaceData {
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    [surface setChartTitle:@"Chart Title"];
    [[surface style] setBackgroundBrush: [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [[surface style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [self addAxes];
    [self addModifiers];
    [self initializeSurfaceRenderableSeries];
    
    [self p_applyCustomTheme];
    
}

- (void)addAxes{
    SCISolidPenStyle * majorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF323539 withThickness:0.5];
    SCISolidBrushStyle * gridBandPen = [[SCISolidBrushStyle alloc] initWithColorCode:0xE1202123];
    SCISolidPenStyle * minorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232426 withThickness:0.5];
    
    SCITextFormattingStyle *  textFormatting= [[SCITextFormattingStyle alloc] init];
    [textFormatting setFontSize:16];
    [textFormatting setFontName:@"Helvetica"];
    [textFormatting setColorCode:0xFFb6b3af];
    
    SCIAxisStyle * axisStyle = [[SCIAxisStyle alloc]init];
    [axisStyle setMajorTickBrush:majorPen];
    [axisStyle setGridBandBrush: gridBandPen];
    [axisStyle setMajorGridLineBrush:majorPen];
    [axisStyle setMinorTickBrush:minorPen];
    [axisStyle setMinorGridLineBrush:minorPen];
    [axisStyle setLabelStyle:textFormatting];
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setStyle: axisStyle];
    axis.axisId = @"yAxis";
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [axis setAxisTitle:@"Right Axis Title"];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"yAxis2";
    [axis setStyle: axisStyle];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [axis setAxisTitle:@"Left Axis Title"];
    [axis setAxisAlignment:SCIAxisAlignment_Left];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"xAxis";
    [axis setStyle: axisStyle];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [axis setAxisTitle:@"Bottom Axis Title"];
    [surface.xAxes add:axis];
    
}

- (void)addModifiers{
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.axisId = @"xAxis";
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIZoomPanClipMode_None;
    [xDragModifier setModifierName:@"XAxis DragModifier"];
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.axisId = @"yAxis";
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    [yDragModifier setModifierName:@"YAxis DragModifier"];
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    [pzm setModifierName:@"PinchZoom Modifier"];
    
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    [zem setModifierName:@"ZoomExtents Modifier"];
    
    SCIRolloverModifier * rollover = [[SCIRolloverModifier alloc] init];
    rollover.style.tooltipSize = CGSizeMake(200, NAN);
    [rollover setModifierName:@"Rollover Modifier"];
    
    SCILegendCollectionModifier *legend = [[SCILegendCollectionModifier alloc] initWithPosition:SCILegendPositionLeft | SCILegendPositionTop
                                                                                 andOrientation:SCILegendOrientationVertical];
    legend.showCheckBoxes = NO;
    legend.styleOfItemCell = [SCILegendCellStyle new];
    legend.styleOfItemCell.seriesNameFont = [UIFont systemFontOfSize:10];
    legend.styleOfItemCell.cornerRadiusMarkerView = .0f;
    legend.styleOfItemCell.borderWidthMarkerView = .0f;
    legend.styleOfItemCell.seriesNameTextColor = [UIColor whiteColor];
    legend.styleOfItemCell.sizeMarkerView = CGSizeMake(30.f, 6.f);
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, rollover, legend]];
    surface.chartModifier = gm;
}

@end