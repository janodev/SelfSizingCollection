import UIKit

extension UIImage
{
    func aspectFitSizeFor(viewportSize: CGSize) -> CGSize
    {
        let imageAspectRatio = size.width / size.height
        let screenAspectRatio = viewportSize.width / viewportSize.height

        if imageAspectRatio > screenAspectRatio {
            let width = min(size.width, viewportSize.width)
            return CGSize(width: width, height: width / imageAspectRatio)
        } else {
            let height = min(size.height, viewportSize.height)
            let width = height * imageAspectRatio
            return CGSize(width: width, height: height)
        }
    }
}
