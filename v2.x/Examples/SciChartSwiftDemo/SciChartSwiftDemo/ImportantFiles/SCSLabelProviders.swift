//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCSLabelProviders.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import Foundation
import SciChart

class ThousandsLabelProvider: SCINumericLabelProvider {
    override func formatLabel(_ dataValue: SCIGenericType) -> NSAttributedString! {
        let formattedValue = String(format: "%.1fk", SCIGenericDouble(dataValue)/1000)
        return NSMutableAttributedString(string: formattedValue)
    }
}

class BillionsLabelProvider: SCINumericLabelProvider {
    override func formatLabel(_ dataValue: SCIGenericType) -> NSAttributedString! {
        let formattedValue = String(format: "%@B", super.formatLabel(SCIGeneric(SCIGenericDouble(dataValue) / pow(10, 9))).string)
        return NSMutableAttributedString(string: formattedValue)
    }
}
