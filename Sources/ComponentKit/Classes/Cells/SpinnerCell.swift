//
//  EmptyCell.swift
//  ComponentKit
//
//  Created by Sun on 2024/8/19.
//

import UIKit

import SnapKit
import HUD

open class SpinnerCell: UITableViewCell {
    
    private let spinner = HUDActivityView.create(with: .medium24)

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(spinner)
        spinner.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }

        spinner.startAnimating()
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
