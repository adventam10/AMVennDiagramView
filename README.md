# AMVennDiagramView

![Pod Platform](https://img.shields.io/cocoapods/p/AMVennDiagramView.svg?style=flat)
![Pod License](https://img.shields.io/cocoapods/l/AMVennDiagramView.svg?style=flat)
[![Pod Version](https://img.shields.io/cocoapods/v/AMVennDiagramView.svg?style=flat)](http://cocoapods.org/pods/AMVennDiagramView)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

`AMVennDiagramView` is a view can display the diagram like Venn diagram. It displays two circles whose area ratio is almost an accurate.

## Demo

<img width="625" alt="2018-02-17 18 31 11" src="https://user-images.githubusercontent.com/34936885/36340126-8ab246d8-1419-11e8-9889-82ba9661ab5a.png">


## Usage

Create vennDiagramView.

```swift
let vennDiagramView = AMVennDiagramView(frame: view.bounds)
view.addSubview(vennDiagramView)
vennDiagramView.setupVennDiagram(value1: 1000, value2: 500, commonValue: 200)
vennDiagramView.dataSource = self
```

Conform to the protocol in the class implementation.

```swift
// MARK:- Required
func vennDiagramView(_ vennDiagramView: AMVennDiagramView, fillColorForSection section: Int) -> UIColor
func vennDiagramView(_ vennDiagramView: AMVennDiagramView, strokeColorForSection section: Int) -> UIColor
    
// MARK:- Optional
func vennDiagramView(_ vennDiagramView: AMVennDiagramView, titleForSection section: Int, value: CGFloat) -> String
func titleForCommonArea(in vennDiagramView: AMVennDiagramView, value: CGFloat) -> String
func vennDiagramView(_ vennDiagramView: AMVennDiagramView, textColorForSection section: Int) -> UIColor
func textColorForCommonArea(in vennDiagramView: AMVennDiagramView) -> UIColor
func vennDiagramView(_ vennDiagramView: AMVennDiagramView, textFontForSection section: Int) -> UIFont
func textFontForCommonArea(in vennDiagramView: AMVennDiagramView) -> UIFont
```

`section` of `value1` is `0`. `section` of `value2` is `1`.

## Installation

### CocoaPods

Add this to your Podfile.
```ogdl
pod 'AMVennDiagramView'
```

### Carthage

Add this to your Cartfile.

```ogdl
github "adventam10/AMVennDiagramView"
```

## License

MIT
