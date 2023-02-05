# AsyncDownSamplingImage

`AsyncDownSamplingImage` is a SwiftUI component that has similar interface to original [AsyncImage](https://developer.apple.com/documentation/swiftui/asyncimage) and can perform downsampling so that we can reduce the memory buffer to store image data fetched from a server.

# Impact of Downsampling

with downsampling, we can reduce the huge amount of memory use like the below.

|default AsyncImage| AsyncDownSamplingImage (×2~3 efficient) |
|---|---|
|<img width="480" alt="Screenshot 2023-02-03 at 21 58 31" src="https://user-images.githubusercontent.com/44002126/216665559-7f4efbc5-c649-4f25-b9fa-95f5ca60cf67.png">|<img width="480" alt="Screenshot 2023-02-03 at 21 58 48" src="https://user-images.githubusercontent.com/44002126/216665576-f1b994a7-b7ac-49d3-8e44-bda8f1b64130.png">|


Moreover, the more the number of images increases, the more we can get the benefit.

Below is a comparision when I scrolled and show 100/1000 high resolution images (1000×1000px).
With AsyncDownSamplingImage, we changed Image size `1000x1000` into `160x160` which is same size as rendered `Image`.

|100 Default AsyncImages| 100 AsyncDownSamplingImages (×10~ efficient) |
|---|---|
|<img width="480" alt="Screenshot 2023-02-04 at 2 11 31" src="https://user-images.githubusercontent.com/44002126/216666328-6d4ea99c-45d4-48d0-960d-b162a9155413.png">|<img width="480" alt="Screenshot 2023-02-04 at 2 12 06" src="https://user-images.githubusercontent.com/44002126/216666337-0e079274-5a55-4469-b9ae-4c4dfc5b838d.png">|

|1000 Default AsyncImages| 1000 AsyncDownSamplingImages (×30~ efficient) |
|---|---|
|<img width="480" alt="Screenshot 2023-02-06 at 1 08 46" src="https://user-images.githubusercontent.com/44002126/216831204-06a8dc04-6bd6-44df-8134-290f150abca0.png">|<img width="480" alt="Screenshot 2023-02-06 at 1 07 29" src="https://user-images.githubusercontent.com/44002126/216831199-c5a66b8e-fc1a-4131-a5c5-2f7d57b17a1b.png">|





# How to use AsyncDownSamplingImage

`AsyncDownSamplingImage` aims to be used in a similar way to `AsyncImage` even if the implementation is different.

```swift
public init(
  url: Binding<URL?>,
  downsampleSize: Binding<CGSize>,
  content: @escaping (Image) -> Content,
  placeholder: @escaping () -> Placeholder,
  fail: @escaping (Error) -> Fail
)
```

```swift
public init(
  url: URL?,
  downsampleSize: Binding<CGSize>,
  content: @escaping (Image) -> Content,
  fail: @escaping (Error) -> Fail
)
```

```swift
public init(
  url: URL?,
  downsampleSize: CGSize,
  content: @escaping (Image) -> Content,
  fail: @escaping (Error) -> Fail
)
```

You can use `AsyncDownSamplingImage` in the following way.

```swift

@State private var url = URL(string: "https://via.placeholder.com/1000")
@State private var size: CGSize = .init(width: 160, height: 160)

...

AsyncDownSamplingImage(
  url: url,
  downsampleSize: size
) { image in
  image.resizable()
      .frame(width: size.width, height: size.height)
} fail: { error in
  Text("Error: \(error.localizedDescription)")
}
```


# Contributing

Pull requests, bug reports and feature requests are welcome 🚀

# License

[MIT LICENSE](https://github.com/fummicc1/AsyncDownSamplingImage/blob/main/LICENSE)
