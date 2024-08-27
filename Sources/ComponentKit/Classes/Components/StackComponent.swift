//
//  StackComponent.swift
//  ComponentKit
//
//  Created by Sun on 2024/8/20.
//

import UIKit

import SnapKit
import ThemeKit

public class StackComponent: UIView {
    
    public let stackView = UIStackView()

    public init(centered: Bool) {
        super.init(frame: .zero)

        addSubview(stackView)
        stackView.snp.makeConstraints { maker in
            if centered {
                maker.leading.trailing.equalToSuperview()
                maker.centerY.equalToSuperview()
            } else {
                maker.edges.equalToSuperview()
            }
        }
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
