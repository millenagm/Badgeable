//
//  Badgeable.swift
//
//  Created by Millena Galvão on 12/09/2020.
//  Copyright © 2020 Millena Galvão. All rights reserved.
//

import UIKit

public protocol Badgeable {

    var badgeCount: Int { get set }
    var badgeColor: UIColor { get set }
    var maxValue: Int { get set }
    var badgePosition: BadgePosition { get set }
}

private struct BadgeAssociatedKeys {

    static var badgeCount = "badgeCount"
    static var maxValue = "badgeMaxValue"
    static var badgeColor = "badgeColor"
    static var badgePosition = "badgePosition"
    static var badgeLabel = "badgeLabel"
}

public enum BadgePosition {

    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

private enum Defaults {

    static let position: BadgePosition = .topRight
    static let count: Int = 0
    static let color: UIColor = .red
    static let padding: CGFloat = 4.0
    static var label: UILabel {

        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .white
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }
}

public extension Badgeable {

    var badgeCount: Int {

        get { objc_getAssociatedObject(self, &BadgeAssociatedKeys.badgeCount) as? Int ?? Defaults.count }
        set {
            objc_setAssociatedObject(self, &BadgeAssociatedKeys.badgeCount, newValue, .OBJC_ASSOCIATION_RETAIN)
            show()
        }
    }

    var maxValue: Int {

        get { objc_getAssociatedObject(self, &BadgeAssociatedKeys.maxValue) as? Int ?? badgeCount }
        set {
            objc_setAssociatedObject(self, &BadgeAssociatedKeys.maxValue, newValue, .OBJC_ASSOCIATION_RETAIN)
            show()
        }
    }

    var badgeColor: UIColor {

        get { objc_getAssociatedObject(self, &BadgeAssociatedKeys.badgeColor) as? UIColor ?? Defaults.color }
        set {
            objc_setAssociatedObject(self, &BadgeAssociatedKeys.badgeColor, newValue, .OBJC_ASSOCIATION_RETAIN)
            show()
        }
    }

    var badgePosition: BadgePosition {

        get { objc_getAssociatedObject(self, &BadgeAssociatedKeys.badgePosition) as? BadgePosition ?? Defaults.position }
        set {
            objc_setAssociatedObject(self, &BadgeAssociatedKeys.badgePosition, newValue, .OBJC_ASSOCIATION_RETAIN)
            show()
        }
    }
}

extension Badgeable {

    private var label: UILabel {

        mutating get {

            guard let label = objc_getAssociatedObject(self, &BadgeAssociatedKeys.badgeLabel) as? UILabel else {

                self.label = Defaults.label
                return self.label
            }
            return label
        }
        set { objc_setAssociatedObject(self, &BadgeAssociatedKeys.badgeLabel, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    private mutating func show() {

        if let barButtonItem = self as? UIBarButtonItem, let customView = barButtonItem.customView {

            addLabel(on: customView)
        } else if let view = self as? UIView {

            addLabel(on: view)
        }
    }

    private mutating func addLabel(on superview: UIView) {

        label.removeFromSuperview()
        label.constraints.forEach { label.removeConstraint($0) }

        if badgeCount > maxValue {

            label.text = "\(maxValue)+"
        } else {

            label.text = "\(badgeCount)"
        }

        label.sizeToFit()

        var labelBounds = label.bounds
        labelBounds.size.width += Defaults.padding
        labelBounds.size.height += Defaults.padding

        if labelBounds.size.width < labelBounds.size.height {
            labelBounds.size.width = labelBounds.size.height
        }

        label.widthAnchor.constraint(equalToConstant: labelBounds.size.height).isActive = true
        label.heightAnchor.constraint(equalToConstant: labelBounds.size.height).isActive = true
        label.layer.cornerRadius = labelBounds.size.height / 2

        label.isHidden = badgeCount == 0
        label.backgroundColor = badgeColor

        superview.clipsToBounds = false
        superview.addSubview(label)
        addLabelConstraints(on: superview)
    }

    private mutating func addLabelConstraints(on superview: UIView) {

        label.translatesAutoresizingMaskIntoConstraints = false

        switch badgePosition {
        case .topRight:
            label.centerYAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            label.centerXAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        case .topLeft:
            label.centerYAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            label.centerXAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
        case .bottomRight:
            label.centerYAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
            label.centerXAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        case .bottomLeft:
            label.centerYAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
            label.centerXAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
        }
    }
}
