import SwiftUI
import Combine

enum PhotoService {
    case fetchPhotos(page: Int)
}

extension PhotoService {
    private enum NetworkConstants {
        static let clientID = "w8ZPpc08Dps3V2901Qlp2MRqS6vw3m65fk8tM-QknK8"
    }

    private var baseURL: URL {
        return URL(string: "https://api.unsplash.com")!
    }

    private var path: String {
        switch self {
        case .fetchPhotos:
            return "/photos"
        }
    }

    private var method: String {
        return "GET"
    }

    private var parameters: [String: Any] {
        switch self {
        case let .fetchPhotos(page):
            return [
                "client_id": NetworkConstants.clientID,
                "per_page": 20,
                "page": page
            ]
        }
    }

    private var headers: [String: String]? {
        return nil
    }

    func makeRequest() -> AnyPublisher<Data, Error> {
        guard let url = URL(string: baseURL.absoluteString + path) else {
            return Fail(error: URLError(.badURL))
                .mapError { $0 as Error }
                .eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers

        let urlParameters = parameters.map { URLQueryItem(name: $0, value: String(describing: $1)) }
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            urlComponents.queryItems = urlParameters
            request.url = urlComponents.url
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
