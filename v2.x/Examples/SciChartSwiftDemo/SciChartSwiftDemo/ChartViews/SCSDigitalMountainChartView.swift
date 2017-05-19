//
//  SCSDigitalMountainChartView.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 3/15/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSDigitalMountainChartView: SCSBaseChartView {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxis()
        addModifiers()
        addDataSeries()
    }
    
    func addModifiers() {
        
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.dragMode = .pan
        
        let extendZoomModifier = SCIZoomExtentsModifier()
        
        let pinchZoomModifier = SCIPinchZoomModifier()
        
        let rolloverModifier = SCIRolloverModifier()
        rolloverModifier.style.hitTestMode = .vertical
        
        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, rolloverModifier])
        
        chartModifiers = groupModifier
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxis() {
        let xAxis = SCIDateTimeAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        xAxes.add(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        yAxes.add(yAxis)
    }
    
    fileprivate func addDataSeries () {
        let brush = SCILinearGradientBrushStyle(colorCodeStart: 0xAAFF8D42,
                                                finish: 0x88090E11,
                                                direction: .vertical)
        let pen = SCISolidPenStyle(colorCode: 0xAAFFC9A8, withThickness: 1.0)
        
        renderableSeries.add(getMountainRenderSeries(withBrush: brush, and: pen))
        invalidateElement()
    }
    
    
    fileprivate func getMountainRenderSeries(withBrush brush:SCILinearGradientBrushStyle, and pen: SCISolidPenStyle) -> SCIFastMountainRenderableSeries {
        let dataSeries = SCIOhlcDataSeries(xType: .dateTime, yType: .float, seriesType: .defaultType)
        SCSDataManager.getPriceIndu(dataSeries: dataSeries, fileName: "INDU_Daily")
        
        let mountainRenderSeries = SCIFastMountainRenderableSeries()
        mountainRenderSeries.zeroLineY = 10000
        mountainRenderSeries.style.isDigitalLine = true
        mountainRenderSeries.areaStyle = brush
        mountainRenderSeries.style.strokeStyle = pen
        mountainRenderSeries.dataSeries = dataSeries
        
        return mountainRenderSeries
    }
}