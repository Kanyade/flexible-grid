# FlexibleGrid

[![Version](https://img.shields.io/pub/v/flexible_grid.svg)](https://pub.dev/packages/flexible_grid) ![GitHub license](https://img.shields.io/badge/license-BSD3-blue.svg?style=flat)

### A bare-bones flexible grid for dynamic layouts in Flutter.

## Usage

`FlexibleGrid` behaves similarly to a simple `Column` or `Row`, just add your children and let it lay everything out.
It does not have inherent scrolling, you need to handle that, this is truly a bare-bones widget to simply lay everything out.

```dart
FlexibleGrid(
  columnCount: 3,
  enforceRowHeight: true,
  children: [
    FlexibleGridItemProxy(columnSpan: 2, child: Container(color: Colors.green, height: 100)),
    Container(color: Colors.red, height: 75),
    Container(color: Colors.blue, height: 150),
    Container(color: Colors.yellow, height: 125),
    Container(color: Colors.purple, height: 100),
  ],
)
```

`enforceRowHeight` is true
<img src="example/flexible_grid_demo_enforced.png" alt="FlexibleGrid Demo" width="260">

`enforceRowHeight` is false
<img src="example/flexible_grid_demo.png" alt="FlexibleGrid Demo" width="260">

## Parameters

| Parameter           | Description                                                                                                                                                     |
| ------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `columnCount`       | Controls how many children are laid out in a row. Defaults to 2.                                                                                                |
| `verticalSpacing`   | Sets the vertical spacing between children. Defaults to 0.                                                                                                      |
| `horizontalSpacing` | Sets the horizontal spacing between children. Defaults to 0.                                                                                                    |
| `enforceRowHeight`  | Whether children are set to be the height of the row they are in or can be less. Note that e.g. Containers with fixed height will be stretched out to the row's height due to using `BoxConstraints.tightFor`. |
| `children`          | Widgets to be displayed.                                                                                                                                        |

## License

```
Copyright 2025 Norbert Csörgő

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```
