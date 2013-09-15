# SEJSONViewController

Easily browse the contents of JSON file.

SEJSONViewController is tested on iOS 5 and requires ARC. Released under the [MIT license](LICENSE).

## Example

![Screenshot]

Open up the included Xcode project for an example app and the tests.

## Usage

``` objc
    // Initialize the view controller
    SEJSONViewController * jsonViewController = [[SEJSONViewController alloc] init];

    // Read the JSON data
    id data = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"data" withExtension:@"json"]] options:NSJSONReadingAllowFragments error:nil];
    
    // set the data to browse in the controller
    [jsonViewController setData:data];
    
    // display it inside a UINavigationController
    [[UINavigationController alloc] initWithRootViewController:jsonViewController ];
```

See the [header](SEJSONViewController/SEJSONViewController.h) for full documentation.

## Installation

Simply add the files in the `SEJSONViewController.h` and `SEJSONViewController.m` to your project or add `SEJSONViewController` to your Podfile if you're using CocoaPods.
