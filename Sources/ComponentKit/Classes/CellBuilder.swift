//
//  CellBuilder.swift
//  ComponentKit
//
//  Created by Sun on 2024/8/20.
//

import UIKit

import SnapKit
import SectionsTableView
import ThemeKit

public enum CellBuilder {
    
    public static let defaultMargin: CGFloat = .margin16
    public static let defaultLayoutMargins: UIEdgeInsets = .symmetric(horizontal: defaultMargin)

    public static func preparedCell(
        tableView: UITableView,
        indexPath: IndexPath,
        isSelectable: Bool,
        rootElement: CellElement,
        layoutMargins: UIEdgeInsets = defaultLayoutMargins
    ) -> UITableViewCell {
        let cellClass = isSelectable ? ComponentSelectableCell.self : ComponentCell.self

        let reuseIdentifier = reuseIdentifier(
            cellClass: cellClass,
            rootElement: rootElement,
            layoutMargins: layoutMargins
        )
        tableView.register(cellClass, forCellReuseIdentifier: reuseIdentifier)

        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        if let cell = cell as? ComponentCell {
            build(cell: cell, rootElement: rootElement, layoutMargins: layoutMargins)
        }
        return cell
    }

    public static func row(
            rootElement: CellElement,
            layoutMargins: UIEdgeInsets = defaultLayoutMargins,
            tableView: UITableView,
            id: String,
            hash: String? = nil,
            height: CGFloat? = nil,
            autoDeselect: Bool = false,
            rowActionProvider: (() -> [RowAction])? = nil,
            dynamicHeight: ((CGFloat) -> CGFloat)? = nil,
            bind: ((ComponentCell) -> Void)? = nil,
            action: (() -> Void)? = nil,
            actionWithCell: ((ComponentCell) -> Void)? = nil
    ) -> RowProtocol {
        let cellClass = action != nil || actionWithCell != nil ? ComponentSelectableCell.self : ComponentCell.self
        let reuseIdentifier = reuseIdentifier(cellClass: cellClass, rootElement: rootElement, layoutMargins: layoutMargins)
        tableView.register(cellClass, forCellReuseIdentifier: reuseIdentifier)

        if action != nil || actionWithCell != nil {
            return Row<ComponentSelectableCell>(
                    id: id,
                    hash: hash,
                    height: height,
                    autoDeselect: autoDeselect,
                    rowActionProvider: rowActionProvider,
                    rowType: .dynamic(reuseIdentifier: reuseIdentifier, prepare: { cell in
                        guard let cell = cell as? ComponentCell else {
                            return
                        }

                        build(cell: cell, rootElement: rootElement, layoutMargins: layoutMargins)
                    }),
                    dynamicHeight: dynamicHeight,
                    bind: { cell, _ in
                        bind?(cell)
                        cell.bind(rootElement: rootElement)
                    },
                    action: { cell in
                        action?()
                        actionWithCell?(cell)
                    }
            )
        } else {
            return Row<ComponentCell>(
                    id: id,
                    hash: hash,
                    height: height,
                    rowActionProvider: rowActionProvider,
                    rowType: .dynamic(reuseIdentifier: reuseIdentifier, prepare: { cell in
                        guard let cell = cell as? ComponentCell else {
                            return
                        }

                        build(cell: cell, rootElement: rootElement, layoutMargins: layoutMargins)
                    }),
                    dynamicHeight: dynamicHeight,
                    bind: { cell, _ in
                        bind?(cell)
                        cell.bind(rootElement: rootElement)
                    }
            )
        }
    }

    public static func build(cell: ComponentCell, rootElement: CellElement, layoutMargins: UIEdgeInsets = defaultLayoutMargins) {
        if cell.id != nil {
            return
        }

        if let rootView = view(element: rootElement) {
            cell.wrapperView.addSubview(rootView)
            rootView.snp.makeConstraints { maker in
                maker.edges.equalToSuperview().inset(layoutMargins)
            }

            cell.rootView = rootView
        }

        cell.id = cellId(rootElement: rootElement, layoutMargins: layoutMargins)
    }

    public static func buildStatic(cell: ComponentCell, rootElement: CellElement, layoutMargins: UIEdgeInsets = defaultLayoutMargins) {
        build(cell: cell, rootElement: rootElement, layoutMargins: layoutMargins)
        cell.bind(rootElement: rootElement)
    }

    public static func height(
        containerWidth: CGFloat,
        backgroundStyle: ComponentCell.BackgroundStyle,
        text: String,
        font: UIFont,
        verticalPadding: CGFloat = defaultMargin,
        elements: [LayoutElement]
    ) -> CGFloat {
        var textWidth = containerWidth - ComponentCell.margin(backgroundStyle: backgroundStyle).width

        var lastMargin = defaultMargin

        for element in elements {
            switch element {
            case .margin0: lastMargin = 0
            case .margin4: lastMargin = .margin4
            case .margin8: lastMargin = .margin8
            case .margin12: lastMargin = .margin12
            case .margin16: lastMargin = .margin16
            case .margin24: lastMargin = .margin24
            case .margin32: lastMargin = .margin32
            case .fixed(let width):
                textWidth -= lastMargin + width
                lastMargin = defaultMargin
            case .multiline:
                textWidth -= lastMargin
                lastMargin = defaultMargin
            }
        }

        textWidth -= lastMargin

        return text.height(forContainerWidth: textWidth, font: font) + 2 * verticalPadding
    }

    public static func stackComponent(axis: NSLayoutConstraint.Axis, elements: [CellElement], centered: Bool = false) -> StackComponent {
        let component = StackComponent(centered: centered)

        var lastView: UIView?
        var lastMargin: CGFloat?

        for element in elements {
            switch element {
            case .margin(let value): lastMargin = value
            case .margin0: lastMargin = 0
            case .margin4: lastMargin = .margin4
            case .margin8: lastMargin = .margin8
            case .margin12: lastMargin = .margin12
            case .margin16: lastMargin = .margin16
            case .margin24: lastMargin = .margin24
            case .margin32: lastMargin = .margin32
            default:
                if let view = view(element: element) {
                    if let last = lastMargin, let lastView = lastView {
                        component.stackView.setCustomSpacing(last, after: lastView)
                        lastMargin = nil
                    }
                    component.stackView.addArrangedSubview(view)
                    lastView = view
                }
            }
        }

        component.stackView.axis = axis
        component.stackView.distribution = .fill
        component.stackView.alignment = .fill
        component.stackView.spacing = defaultMargin

        return component
    }

    private static func view(element: CellElement) -> UIView? {
        switch element {
        case let .hStack(elements, _): return stackComponent(axis: .horizontal, elements: elements)
        case let .vStack(elements, _): return stackComponent(axis: .vertical, elements: elements)
        case let .vStackCentered(elements, _): return stackComponent(axis: .vertical, elements: elements, centered: true)

        case .text: return TextComponent()
        case .textButton: return TextButtonComponent()
        case .image16: return ImageComponent(size: .iconSize16)
        case .image20: return ImageComponent(size: .iconSize20)
        case .image24: return ImageComponent(size: .iconSize24)
        case .image32: return ImageComponent(size: .iconSize32)
        case .transactionImage: return TransactionImageComponent()
        case .switch: return SwitchComponent()
        case .primaryButton: return PrimaryButtonComponent()
        case .primaryCircleButton: return PrimaryCircleButtonComponent()
        case .secondaryButton: return SecondaryButtonComponent()
        case .secondaryCircleButton: return SecondaryCircleButtonComponent()
        case .sliderButton: return SliderButtonComponent()
        case .badge: return BadgeComponent()
        case .spinner20: return SpinnerComponent(style: .small20)
        case .spinner24: return SpinnerComponent(style: .medium24)
        case .spinner48: return SpinnerComponent(style: .large48)
        case .determiniteSpinner20: return DeterminiteSpinnerComponent(size: .iconSize20)
        case .determiniteSpinner24: return DeterminiteSpinnerComponent(size: .iconSize24)
        case .determiniteSpinner48: return DeterminiteSpinnerComponent(size: .iconSize48)
        default: return nil
        }
    }

    private static func reuseIdentifier(cellClass: AnyClass, rootElement: CellElement, layoutMargins: UIEdgeInsets = defaultLayoutMargins) -> String {
        "\(cellClass)|\(cellId(rootElement: rootElement, layoutMargins: layoutMargins))"
    }

    private static func cellId(rootElement: CellElement, layoutMargins: UIEdgeInsets) -> String {
        "\(rootElement.id)|\(Int(layoutMargins.top))-\(Int(layoutMargins.left))-\(Int(layoutMargins.bottom))-\(Int(layoutMargins.right))"
    }

}

extension CellBuilder {

    public enum CellElement {
        case hStack(_ elements: [CellElement], _ bind: ((StackComponent) -> Void)? = nil)
        case vStack(_ elements: [CellElement], _ bind: ((StackComponent) -> Void)? = nil)
        case vStackCentered(_ elements: [CellElement], _ bind: ((StackComponent) -> Void)? = nil)

        case margin(_ value: CGFloat)
        case margin0
        case margin4
        case margin8
        case margin12
        case margin16
        case margin24
        case margin32

        case text(_ bind: (TextComponent) -> Void)
        case textButton(_ bind: (TextButtonComponent) -> Void)
        case image16(_ bind: (ImageComponent) -> Void)
        case image20(_ bind: (ImageComponent) -> Void)
        case image24(_ bind: (ImageComponent) -> Void)
        case image32(_ bind: (ImageComponent) -> Void)
        case transactionImage(_ bind: (TransactionImageComponent) -> Void)
        case `switch`(_ bind: (SwitchComponent) -> Void)
        case primaryButton(_ bind: (PrimaryButtonComponent) -> Void)
        case primaryCircleButton(_ bind: (PrimaryCircleButtonComponent) -> Void)
        case secondaryButton(_ bind: (SecondaryButtonComponent) -> Void)
        case secondaryCircleButton(_ bind: (SecondaryCircleButtonComponent) -> Void)
        case sliderButton(_ bind: (SliderButtonComponent) -> Void)
        case badge(_ bind: (BadgeComponent) -> Void)
        case spinner20(_ bind: (SpinnerComponent) -> Void)
        case spinner24(_ bind: (SpinnerComponent) -> Void)
        case spinner48(_ bind: (SpinnerComponent) -> Void)
        case determiniteSpinner20(_ bind: (DeterminiteSpinnerComponent) -> Void)
        case determiniteSpinner24(_ bind: (DeterminiteSpinnerComponent) -> Void)
        case determiniteSpinner48(_ bind: (DeterminiteSpinnerComponent) -> Void)

        var id: String {
            switch self {
            case let .hStack(elements, _): return "hStack[\(elements.map { $0.id }.joined(separator: "-"))]"
            case let .vStack(elements, _): return "vStack[\(elements.map { $0.id }.joined(separator: "-"))]"
            case let .vStackCentered(elements, _): return "vStackCentered[\(elements.map { $0.id }.joined(separator: "-"))]"

            case .margin(let value): return "margin\(value)"
            case .margin0: return "margin0"
            case .margin4: return "margin4"
            case .margin8: return "margin8"
            case .margin12: return "margin12"
            case .margin16: return "margin16"
            case .margin24: return "margin24"
            case .margin32: return "margin32"

            case .text: return "text"
            case .textButton: return "textButton"
            case .image16: return "image16"
            case .image20: return "image20"
            case .image24: return "image24"
            case .image32: return "image32"
            case .transactionImage: return "transactionImage"
            case .switch: return "switch"
            case .primaryButton: return "primaryButton"
            case .primaryCircleButton: return "primaryCircleButton"
            case .secondaryButton: return "secondaryButton"
            case .secondaryCircleButton: return "secondaryCircleButton"
            case .sliderButton: return "sliderButton"
            case .badge: return "badge"
            case .spinner20: return "spinner20"
            case .spinner24: return "spinner24"
            case .spinner48: return "spinner48"
            case .determiniteSpinner20: return "determiniteSpinner20"
            case .determiniteSpinner24: return "determiniteSpinner24"
            case .determiniteSpinner48: return "determiniteSpinner48"
            }
        }

        var isView: Bool {
            switch self {
            case .margin, .margin0, .margin4, .margin8, .margin12, .margin16, .margin24, .margin32: return false
            default: return true
            }
        }

        func bind(view: UIView) {
            switch self {
            case .hStack(let elements, let bind), .vStack(let elements, let bind), .vStackCentered(let elements, let bind):
                if let component = view as? StackComponent {
                    if let bind = bind {
                        bind(component)
                    }
                    for (index, element) in elements.filter({ $0.isView }).enumerated() {
                        element.bind(view: component.stackView.arrangedSubviews[index])
                    }
                }
            case .text(let bind):
                if let component = view as? TextComponent {
                    bind(component)
                }
            case .textButton(let bind):
                if let component = view as? TextButtonComponent {
                    bind(component)
                }
            case .image16(let bind), .image20(let bind), .image24(let bind), .image32(let bind):
                if let component = view as? ImageComponent {
                    bind(component)
                }
            case .transactionImage(let bind):
                if let component = view as? TransactionImageComponent {
                    bind(component)
                }
            case .switch(let bind):
                if let component = view as? SwitchComponent {
                    bind(component)
                }
            case .primaryButton(let bind):
                if let component = view as? PrimaryButtonComponent {
                    bind(component)
                }
            case .primaryCircleButton(let bind):
                if let component = view as? PrimaryCircleButtonComponent {
                    bind(component)
                }
            case .secondaryButton(let bind):
                if let component = view as? SecondaryButtonComponent {
                    bind(component)
                }
            case .secondaryCircleButton(let bind):
                if let component = view as? SecondaryCircleButtonComponent {
                    bind(component)
                }
            case .sliderButton(let bind):
                if let component = view as? SliderButtonComponent {
                    bind(component)
                }
            case .badge(let bind):
                if let component = view as? BadgeComponent {
                    bind(component)
                }
            case .spinner20(let bind), .spinner24(let bind), .spinner48(let bind):
                if let component = view as? SpinnerComponent {
                    bind(component)
                }
            case .determiniteSpinner20(let bind), .determiniteSpinner24(let bind), .determiniteSpinner48(let bind):
                if let component = view as? DeterminiteSpinnerComponent {
                    bind(component)
                }
            default: ()
            }
        }
    }

    public enum LayoutElement {
        case fixed(width: CGFloat)
        case multiline

        case margin0
        case margin4
        case margin8
        case margin12
        case margin16
        case margin24
        case margin32
    }

}
