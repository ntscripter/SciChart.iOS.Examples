//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDThemeManager3DViewControllerBase.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDThemeManager3DViewControllerBase.h"
#import "SCDSettingsPresenter.h"
#import "SCDToolbarButtonsGroup.h"
#import "SCDToolbarItem.h"
#import "SCDConstants.h"
#import "SCDSelectableItem.h"
#import "SCDToggleButtonsGroup.h"
#import "SCDToolbarPopupItem.h"
#import "SCIStackView.h"

@implementation SCDThemeManager3DViewControllerBase {
    NSArray *_themeNames;
    NSArray *_themeKeys;
    NSInteger _initialThemeIndex;
    
    SCDToolbarPopupItem *_changeThemeItem;
}

- (BOOL)showDefaultModifiersInToolbar {
    return NO;
}

- (void)tryUpdateChartThemeWithKey:(NSString *)themeKey {
    [SCIThemeManager applyThemeToThemeable:self.surface withThemeKey:themeKey];
}

- (void)commonInit {
    _themeNames = @[@"Black Steel", @"Bright Spark", @"Chrome", @"Chart V4 Dark", @"Electric", @"Expression Dark", @"Expression Light", @"Oscilloscope"];
    _themeKeys = @[SCIChart_BlackSteelStyleKey, SCIChart_Bright_SparkStyleKey, SCIChart_ChromeStyleKey, SCIChart_SciChartv4DarkStyleKey, SCIChart_ElectricStyleKey, SCIChart_ExpressionDarkStyleKey, SCIChart_ExpressionLightStyleKey, SCIChart_OscilloscopeStyleKey];
    _initialThemeIndex = 3;
    
    _changeThemeItem = [self p_SCD_createToolbarPopupItem];
}

- (SCDToolbarPopupItem *)p_SCD_createToolbarPopupItem {
    __weak typeof(self) wSelf = self;
    return [[SCDToolbarPopupItem alloc] initWithTitles:_themeNames selectedIndex:_initialThemeIndex andAction:^(NSUInteger selectedIndex) {
        [SCIThemeManager applyThemeToThemeable:wSelf.surface withThemeKey:self->_themeKeys[selectedIndex]];
    }];
}

- (void)loadView {
    [super loadView];
    
    self.view = [SCIView new];
    self.view.autoresizingMask = SCIAutoresizingFlexible;
    
    SCIStackView *stackView = [SCIStackView new];
    stackView.axis = SCILayoutConstraintAxisVertical;
    stackView.spacing = 0;
    
#if TARGET_OS_IOS
    [stackView addArrangedSubview:[self providePanel]];
#endif
    
    SCIView<ISCIChartSurfaceBase> *surface = [[self.associatedType alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [stackView addArrangedSubview:surface];
    _surface = surface;
    
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stackView];
    
    [self.view addConstraints:@[
        [stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [stackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [stackView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [stackView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
}

#if TARGET_OS_OSX
- (NSArray<id<ISCDToolbarItem>> *)provideExampleSpecificToolbarItems {
    return @[_changeThemeItem];
}
#endif

#if TARGET_OS_IOS
- (SCIView *)providePanel {
    return [_changeThemeItem createView];
}
#endif

@end
