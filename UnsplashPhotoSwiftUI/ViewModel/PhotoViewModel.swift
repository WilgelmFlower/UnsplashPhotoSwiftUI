import SwiftUI
import Combine

final class PhotoViewModel: ObservableObject {
    @Published private(set) var photos: [PhotoModel] = []
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var isShowingProgress: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    private var page = 1

    func fetchMorePhotos(completion: @escaping (Bool) -> Void) {
        page += 1
        fetchPhotos(page: page, completion: completion)
    }

    func fetchPhotos(page: Int = 1, completion: @escaping (Bool) -> Void) {
        let service = PhotoService.fetchPhotos(page: page)

        service.makeRequest()
            .receive(on: DispatchQueue.main)
            .assertNoFailure()
            .sink(receiveValue: { [weak self] data in
                do {
                    let photos = try JSONDecoder().decode([PhotoModel].self, from: data)
                    self?.photos.append(contentsOf: photos)
                    completion(true)
                } catch {
                    print("Error parsing photos: \(error)")
                    completion(false)
                }
            })
            .store(in: &cancellables)
    }
}
