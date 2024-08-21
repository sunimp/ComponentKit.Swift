//
//  ExperimentalView.swift
//  ComponentKit-Example
//
//  Created by Sun on 2024/8/19.
//

import SwiftUI

import ComponentKit

struct ExperimentalView: View {
    
    var body: some View {
        ZStack {
            Color.zx009.edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(spacing: .margin24) {
                    HighlightedDescriptionView(text: "The features below are experimental and should be used with caution. While we have thoroughly tested these features using our own crypto funds, we cannot guarantee they will work as expected in all possible cases.")
                    HighlightedDescriptionView(text: "The features below are experimental", style: .alert)
                    
                    ListSection {
                        Button(action: {
                            print("TAP")
                        }, label: {
                            HStack {
                                Text("Time Lock")
                                    .padding(EdgeInsets(top: .margin12, leading: .margin16, bottom: .margin12, trailing: .margin16))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.zx001)
                                    .font(.regular15)
                                
                                Image("icon_20")
                                    .renderingMode(.template)
                                    .foregroundColor(.zx003)
                                    .padding(EdgeInsets(top: .margin12, leading: .margin16, bottom: .margin12, trailing: .margin16))
                            }
                        })
                        .contentShape(Rectangle())
                        
                        HStack {
                            Text("Evm TestNet")
                                .padding(EdgeInsets(top: .margin12, leading: .margin16, bottom: .margin12, trailing: .margin16))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.zx001)
                                .font(.regular15)
                            
                            Image("icon_20")
                                .renderingMode(.template)
                                .foregroundColor(.zx003)
                                .padding(EdgeInsets(top: .margin12, leading: .margin16, bottom: .margin12, trailing: .margin16))
                        }
                    }
                }
                .padding(EdgeInsets(top: .margin12, leading: .margin16, bottom: .margin32, trailing: .margin16))
            }
        }
    }
    
}

struct ListSection<Content: View>: View {
    var content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        _VariadicView.Tree(Layout()) {
            content
        }
        .background(RoundedRectangle(cornerRadius: .cornerRadius12, style: .continuous).fill(Color.zx008))
    }
    
    struct Layout: _VariadicView_UnaryViewRoot {
        @ViewBuilder
        func body(children: _VariadicView.Children) -> some View {
            let last = children.last?.id
            
            VStack(spacing: 0) {
                ForEach(children) { child in
                    child
                    
                    if child.id != last {
                        HorizontalDivider()
                    }
                }
            }
        }
    }
    
}

struct HorizontalDivider: View {
    private let color: Color
    private let height: CGFloat
    
    init(color: Color = .zx005.opacity(0.5), height: CGFloat = 1) {
        self.color = color
        self.height = height
    }
    
    var body: some View {
        color.frame(height: height)
    }
    
}

struct HighlightedDescriptionView: View {
    private let text: String
    private let style: Style
    
    init(text: String, style: Style = .warning) {
        self.text = text
        self.style = style
    }
    
    var body: some View {
        Text(text)
            .padding(EdgeInsets(top: .margin12, leading: .margin16, bottom: .margin12, trailing: .margin16))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.zx001)
            .font(.regular13)
            .background(RoundedRectangle(cornerRadius: .cornerRadius12, style: .continuous).fill(style.color.opacity(0.2)))
            .overlay(
                RoundedRectangle(cornerRadius: .cornerRadius12, style: .continuous).stroke(style.color, lineWidth: .heightOneDp)
            )
    }
    
    enum Style {
        case warning
        case alert
        
        var color: Color {
            switch self {
            case .warning: return .fz002
            case .alert: return .cg002
            }
        }
    }
    
}
