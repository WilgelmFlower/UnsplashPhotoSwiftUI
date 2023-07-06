import SwiftUI
import Kingfisher

struct PhotoDetailView: View {
    let photo: PhotoModel
    @State private var scale: CGFloat = 1.0
    @GestureState private var currentScale: CGFloat = 1.0
    @Environment(\.colorScheme) var colorScheme

    private let minScale: CGFloat = 0.5
    private let maxScale: CGFloat = 3.0

    var body: some View {
        KFImage(URL(string: photo.urls.regular))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(edges: .bottom)
            .scaleEffect(max(min(scale * currentScale, maxScale), minScale))
            .gesture(MagnificationGesture()
                .updating($currentScale) { value, currentScale, _ in
                    currentScale = value.magnitude
                }
                .onEnded { value in
                    let newScale = scale * value.magnitude
                    scale = max(min(newScale, maxScale), minScale)
                }
            )
            .shadow(color: colorScheme == .dark ? Color.white.opacity(0.5) : Color.black, radius: 5, x: 5, y: 5)
            .padding([.horizontal, .vertical])
    }
}
