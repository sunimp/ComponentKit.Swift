//
//  BadgeView.swift
//  ComponentKit
//
//  Created by Sun on 2024/8/19.
//

import UIKit

import ThemeKit
import SnapKit

public class BadgeView: UIView {
    
    static private let sideMargin: CGFloat = .margin6
    static private let spacing: CGFloat = .margin2

    private let stackView = UIStackView()
    private let label = UILabel()
    private let changeLabel = UILabel()

    public var font: UIFont {
        get { label.font }
        set {
            label.font = newValue
            changeLabel.font = newValue
        }
    }
    
    public var textColor: UIColor {
        get { label.textColor }
        set { label.textColor = newValue }
    }
    
    public var text: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    public var change: Change? {
        didSet {
            changeLabel.isHidden = change == nil
            changeLabel.text = change?.text
            changeLabel.textColor = change?.color
        }
    }

    public var compressionResistance: UILayoutPriority = .required {
        didSet {
            label.setContentCompressionResistancePriority(compressionResistance, for: .horizontal)
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        snp.makeConstraints { maker in
            maker.height.equalTo(0)
        }

        layer.cornerRadius = .cornerRadius8
        layer.cornerCurve = .continuous

        addSubview(stackView)
        stackView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(Self.sideMargin)
            maker.centerY.equalToSuperview()
        }

        stackView.spacing = Self.spacing
        stackView.alignment = .fill

        stackView.addArrangedSubview(label)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)

        stackView.addArrangedSubview(changeLabel)
        changeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        changeLabel.setContentHuggingPriority(.required, for: .horizontal)
        changeLabel.isHidden = true
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func width(for text: String, change: Change?, style: Style) -> CGFloat {
        let textWidth = text.size(containerWidth: .greatestFiniteMagnitude, font: style.font).width
        let changeWidth = change.map { $0.text.size(containerWidth: .greatestFiniteMagnitude, font: style.font).width + spacing } ?? 0
        return textWidth + changeWidth + sideMargin * 2
    }

    public func set(style: Style) {
        backgroundColor = style.backgroundColor
        label.textColor = style.textColor
        label.font = style.font
        changeLabel.font = style.font

        snp.updateConstraints { maker in
            maker.height.equalTo(style.height)
        }
    }

}

extension BadgeView {

    public enum Style {
        case small
        case medium

        var height: CGFloat {
            switch self {
            case .small: return 15
            case .medium: return 18
            }
        }

        var font: UIFont {
            switch self {
            case .small: return .medium9
            case .medium: return .medium11
            }
        }

        var textColor: UIColor {
            switch self {
            case .small: return .zx001
            case .medium: return .zx017
            }
        }

        var backgroundColor: UIColor {
            switch self {
            case .small: return .zx007
            case .medium: return .cg002
            }
        }

    }

    public enum Change {
        case up(String)
        case down(String)

        private var symbol: String {
            switch self {
            case .up: return "↑"
            case .down: return "↓"
            }
        }

        var color: UIColor {
            switch self {
            case .up: return .cg003
            case .down: return .cg004
            }
        }

        var text: String {
            switch self {
            case let .down(text): return symbol + text
            case let .up(text): return symbol + text
            }
        }
    }

}
