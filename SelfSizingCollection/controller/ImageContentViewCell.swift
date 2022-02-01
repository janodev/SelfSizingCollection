import os
import UIKit

final class ImageContentViewCell: UICollectionViewCell, Identifiable
{
    private let log = Logger(subsystem: "dev.jano", category: "ImageContentViewCell")

    private lazy var imageView = AspectFitImageView().configure {
        $0.contentMode = .scaleAspectFit
    }
    private let caption = UILabel().configure {
        $0.numberOfLines = 0
    }

    /// Data used to configure this cell.
    private var item: Item?

    // MARK: - Identifiable

    /// Id refreshed on dequeue.
    /// Used after downloading an image to know if the cell has been recycled.
    private(set) var id = UUID()

    // MARK: - Initialize

    override func prepareForReuse() {
        id = UUID()
        // Don’t nil any other data. All properties are reset on each configure call.
    }

    override init(frame: CGRect){
        super.init(frame: frame)
        layout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configurable

    func configure(_ item: Item, invalidateCellLayout: @escaping (UUID) -> Void) {
        guard case .image(let image) = item else {
            log.error("Wrong item type!. This cell handles Item.image(ImageViewModel).")
            return
        }
        guard self.item != item else {
            log.trace("Same item. Skipping configuration.")
            return
        }

        let uuidString = id.uuidString
        caption.text = image.altText
        Task { [weak self, uuidString] in

            guard let self = self else {
                return /* cell released */
            }
            guard let uiimage = try await ImageDownloader.shared.image(from: image.url) else {
                return /* failed to retrieve the image */
            }
            guard self.id.uuidString == uuidString else {
                return /* cell recycled */
            }
            setImage(image: uiimage)

            // configuration success, set the new item to avoid repeating configuration
            self.item = item

            // layout the new information
            invalidateCellLayout(self.id)
        }
    }

    private func setImage(image: UIImage) {
        imageView.image = image
        guard let collectionView = superview as? UICollectionView else {
            return /* unexpected hierarchy */
        }
        let size = image.aspectFitSizeFor(viewportSize: collectionView.bounds.size)
        imageView.enableAspectFitConstraintsFor(viewportSize: size)
    }

    // MARK: - Layout

    private func layout() {
        contentView.clipsToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(caption)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        caption.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            "H:|[imageView]|",
            "H:|-[caption]-|",
            "V:|[imageView][caption]|"
        ]
        constraints.forEach {
            contentView.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: $0,
                    options: [],
                    metrics: nil,
                    views: ["imageView": imageView, "caption": caption]
                )
            )
        }
    }
}
