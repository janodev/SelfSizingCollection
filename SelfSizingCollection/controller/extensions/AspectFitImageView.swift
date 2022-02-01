import os
import UIKit

final class AspectFitImageView: UIImageView
{
    private let log = Logger(subsystem: "dev.jano", category: "AspectFitImageView")

    private lazy var heightConstraint = heightAnchor.constraint(equalToConstant: 0).configure {
        $0.priority = .defaultHigh
    }
    private lazy var widthConstraint = widthAnchor.constraint(equalToConstant: 0)

    func enableAspectFitConstraintsFor(viewportSize: CGSize) {
        heightConstraint.constant = viewportSize.height
        widthConstraint.constant = viewportSize.width
        heightConstraint.isActive = true
        widthConstraint.isActive = true
    }
    func disableAspectFitConstraints() {
        heightConstraint.isActive = false
        widthConstraint.isActive = false
    }
}
