import os
import UIKit

enum FetchError: Error {
    case badID
    case badImage
    case badURL
}

actor ImageDownloader
{
    private let log = Logger(subsystem: "dev.jano", category: "ImageDownloader")
    static let shared = ImageDownloader()

    private enum CacheEntry {
        case inProgress(Task<UIImage, Error>)
        case ready(UIImage)
    }

    private var cache: [URL: CacheEntry] = [:]

    func image(from urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString) else {
            log.error("Ignoring request. URL is not valid: \(urlString)")
            return nil
        }
        if let cached = cache[url] {
            switch cached {
                case .ready(let image):
                    return image
                case .inProgress(let handle):
                    return try await handle.value
            }
        }

        let handle = Task {
            try await downloadImage(from: urlString)
        }

        cache[url] = .inProgress(handle)

        do {
            let image = try await handle.value
            cache[url] = .ready(image)
            return image
        } catch {
            cache[url] = nil
            throw error
        }
    }

    private func downloadImage(from urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw FetchError.badURL
        }
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw FetchError.badID
        }
        guard let image = UIImage(data: data) else {
            throw FetchError.badImage
        }
        return image
    }
}
