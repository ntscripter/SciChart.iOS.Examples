//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ColumnChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import SciChart.Protected.SCIPaletteProviderBase

class ColumnsTripleColorPalette : SCIPaletteProviderBase<SCIFastColumnRenderableSeries>, ISCIFillPaletteProvider {
    
    let colors = SCIUnsignedIntegerValues()
    let desiredColors:[UInt32] = [0xffa9d34f, 0xfffc9930, 0xffd63b3f]
    
    override init!(renderableSeriesType: AnyClass!) {
        super.init(renderableSeriesType: renderableSeriesType)
    }
    
    init() {
        super.init(renderableSeriesType: SCIFastColumnRenderableSeries.self)
    }
    
    override func update() {
        let count = renderableSeries.currentRenderPassData.pointsCount
        colors.count = count
        
        for i in 0..<count {
            colors.set(desiredColors[i % 3], at: i)
        }
    }
    
    var fillColors: SCIUnsignedIntegerValues! { return colors }
}

class ColumnChartView: SingleChartLayout {
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0, max: 0.1)
        
        let dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        let yValues = [50, 35, 61, 58, 50, 50, 40, 53, 55, 23, 45, 12, 59, 60];
        for i in 0..<yValues.count {
            dataSeries.append(x: i, y: yValues[i])
        }
        
        let rSeries = SCIFastColumnRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.paletteProvider = ColumnsTripleColorPalette()
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers.add(ExampleViewBase.createDefaultModifiers())
            
            SCIAnimations.wave(rSeries, duration: 3.0, andEasingFunction: SCICubicEase())
        }
    }
}