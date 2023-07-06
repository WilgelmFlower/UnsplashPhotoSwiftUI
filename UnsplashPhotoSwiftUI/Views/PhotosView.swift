import SwiftUI
import Kingfisher

struct PhotosView: View {
    @ObservedObject private var viewModel = PhotoViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    private let gridItems = [
        GridItem(.adaptive(minimum: 160))
    ]

    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: gridItems, spacing: 10) {
                        ForEach(viewModel.photos, id: \.self) { photo in
                            if let imageUrlString = photo.urls.small,
                               let imageUrl = URL(string: imageUrlString) {
                                NavigationLink(destination: PhotoDetailView(photo: photo)) {
                                    KFImage(imageUrl)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 160, height: 160)
                                        .cornerRadius(15)
                                        .shadow(color: colorScheme == .dark ? Color.white.opacity(0.5) : Color.black, radius: 5, x: 5, y: 5)
                                        .onAppear {
                                            if photo == viewModel.photos.last {
                                                viewModel.isShowingProgress = true
                                                getMoreData()
                                            }
                                        }
                                }
                            }
                        }
                    }
                    .padding(.vertical, 10)
                    .padding([.leading, .trailing])
                    .navigationTitle("Photos")
                    .onAppear {
                        viewModel.fetchPhotos { success in
                            if !success {
                                viewModel.showAlert = true
                            }
                        }
                    }
                }
                if viewModel.isShowingProgress {
                    ProgressView("Loading new photos...")
                        .padding()
                        .background(Color.white)
                }
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Ooops something went wrong"),
                message: Text("Failed to fetch data from the API."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    func getMoreData() {
        guard !viewModel.isLoading else {
            return
        }
        viewModel.isLoading = true
        viewModel.fetchMorePhotos { success in
            if !success {
                viewModel.showAlert = true
            }
            viewModel.isLoading = false
            viewModel.isShowingProgress = false
        }
    }
}

struct PhotosView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosView()
    }
}
