struct PhotoModel: Decodable, Identifiable, Hashable {
    let id: String
    let urls: Urls

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(urls)
    }
}

extension PhotoModel {
    struct Urls: Decodable, Hashable {
        let small: String
        let regular: String
    }
}
