# AMVennDiagramView

`AMVennDiagramView` is a view can display the diagram like Venn diagram. It displays two circles whose area ratio is almost an accurate.

## Demo

<img width="625" alt="2018-02-17 18 31 11" src="https://user-images.githubusercontent.com/34936885/36340126-8ab246d8-1419-11e8-9889-82ba9661ab5a.png">


## Usage

```swift
// property
@IBOutlet weak private var vennDiagramView: AMVennDiagramView!
private var timer:Timer?

override func viewDidLoad() {
super.viewDidLoad()

vennDiagramView.setupVennDiagram(value1: 1000, value2: 500, commonValue: 200)
vennDiagramView.dataSource = self
}

```

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
