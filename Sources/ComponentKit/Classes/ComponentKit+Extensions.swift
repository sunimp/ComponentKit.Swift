//
//  ComponentKit+Extensions.swift
//
//  Created by Sun on 2021/12/1.
//

import UIKit

extension UIView {
    @IBInspectable
    open var cornerCurve: CALayerCornerCurve {
        get {
            layer.cornerCurve
        }
        set {
            layer.cornerCurve = newValue
        }
    }
}

extension UIRectEdge {
    var toArray: [UIRectEdge] {
        let all: [UIRectEdge] = [.top, .right, .bottom, .left]
        return all.filter { edge in contains(edge) }
    }

    var corners: [UIRectCorner] {
        var corners = [UIRectCorner]()
        if contains([.top, .left]) {
            corners.append(.topLeft)
        }
        if contains([.top, .right]) {
            corners.append(.topRight)
        }
        if contains([.bottom, .left]) {
            corners.append(.bottomLeft)
        }
        if contains([.bottom, .right]) {
            corners.append(.bottomRight)
        }
        return corners
    }
}
