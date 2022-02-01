import os
import UIKit

final class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{
    private let data: [Item] = [
        ImageViewModel.jennefer(),
        ImageViewModel.gerald(),
        ImageViewModel.cast(),
        ImageViewModel.redCarpet(),
        ImageViewModel.ciri()
    ].map { Item.image($0) }

    private static let CellId = "ImageCellId"

    private static func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }

    init() {
        let layout = Self.createCompositionalLayout()
        super.init(collectionViewLayout: layout)
        collectionView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        collectionView?.register(ImageContentViewCell.self, forCellWithReuseIdentifier: Self.CellId)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.CellId, for: indexPath) as? ImageContentViewCell {
            cell.configure(data[indexPath.item], invalidateCellLayout: invalidateCellLayout(cellId: cell.id, cellIndexPath: indexPath))
            return cell
        }
        return UICollectionViewCell()
    }

    private func invalidateCellLayout(cellId: UUID, cellIndexPath: IndexPath) -> (UUID) -> Void {
        { [weak self, cellId] uuid in
            guard cellId.uuidString == uuid.uuidString else {
                return /* cell recycled */
            }
            guard let collectionView = self?.collectionView else {
                return /* controller released */
            }
            let context = UICollectionViewLayoutInvalidationContext()
            context.invalidateItems(at: [cellIndexPath])
            collectionView.collectionViewLayout.invalidateLayout(with: context)
        }
    }
}
