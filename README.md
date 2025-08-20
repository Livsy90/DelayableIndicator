# Delayable Progress Indicator for SwiftUI

A reusable SwiftUI component that displays a progress indicator **only after a configurable delay**. This helps eliminate unnecessary “flicker” when an operation finishes quickly.

## Features

* Configurable delay before showing the indicator
* Supports any custom content (not limited to `ProgressView`)
* Built-in transition support
* Swift Concurrency–based implementation

## Installation (Swift Package Manager)

In **Xcode**:

1. Go to **File > Add Packages…**
2. Enter the URL of the repository:

```
https://github.com/Livsy90/DelayableIndicator
```

3. Select the package and add it to your target.

## Usage

```swift
import DelayableIndicator
import SwiftUI

struct Demo: View {
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 40) {
            DelayableIndicator(
                isLoading,
                delay: 0.5,
                transition: .scale.combined(with: .opacity)
            ) {
                ProgressView()
                    .controlSize(.extraLarge)
            }

            Button("Toggle") {
                isLoading.toggle()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
```

## How It Works

When the `isIndicating` flag switches to `true`, the component starts an async task that waits for the specified delay. If the flag is still `true` after the delay, the content is displayed with animation. If `isIndicating` becomes `false` before the delay finishes, the pending task is cancelled and the content is never shown.

This pattern removes short-lived flashes of UI and improves perceived responsiveness.

## View Extension (Alternative API)

In addition to using the `DelayableIndicator` view directly, you can also apply it as a modifier through the provided `delayablePresentation` extension:

```swift
.someView()
    .delayablePresentation(
        isPresented: isLoading,
        delay: 0.5,
        transition: .opacity,
        skipFirstPresentation: true
    )
```

This offers a more concise syntax when you want to delay the appearance of an existing View.
