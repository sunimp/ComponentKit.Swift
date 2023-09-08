import SwiftUI

struct PrimaryButton: ButtonStyle {
    let style: Style

    @Environment(\.isEnabled) var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(EdgeInsets(top: 15, leading: .margin32, bottom: 15, trailing: .margin32))
            .font(.themeHeadline2)
            .foregroundColor(style.foregroundColor(isEnabled: isEnabled, isPressed: configuration.isPressed))
            .background(style.backgroundColor(isEnabled: isEnabled, isPressed: configuration.isPressed))
            .clipShape(Capsule(style: .continuous))
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }

    enum Style {
        case yellow
        case red
        case gray
        case transparent

        func foregroundColor(isEnabled: Bool, isPressed: Bool) -> Color {
            switch self {
            case .yellow: return isEnabled ? .themeDark : .themeGray50
            case .red, .gray: return isEnabled ? .themeClaude : .themeGray50
            case .transparent: return isEnabled ? (isPressed ? .themeGray : .themeLeah) : .themeGray50
            }
        }

        func backgroundColor(isEnabled: Bool, isPressed: Bool) -> Color {
            switch self {
            case .yellow: return isEnabled ? (isPressed ? .themeYellow50 : .themeYellow) : .themeSteel20
            case .red: return isEnabled ? (isPressed ? .themeRed50 : .themeLucian) : .themeSteel20
            case .gray: return isEnabled ? (isPressed ? .themeNina : .themeLeah) : .themeSteel20
            case .transparent: return .clear
            }
        }
    }
}

struct ExperimentalView: View {
    @State var testNetEnabled = false
    @State var donatePresented = false

    var body: some View {
        ZStack {
            Color.themeTyler.edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(spacing: .margin32) {
                    Group {
                        HStack {
                            Button("Press Me") {}
                                .buttonStyle(PrimaryButton(style: .yellow))
                            Button("Press Me") {}
                                .buttonStyle(PrimaryButton(style: .yellow)).disabled(true)
                        }
                        .frame(maxWidth: .infinity)

                        HStack {
                            Button("Press Me") {}
                                .buttonStyle(PrimaryButton(style: .red))
                            Button("Press Me") {}
                                .buttonStyle(PrimaryButton(style: .red)).disabled(true)
                        }
                        .frame(maxWidth: .infinity)

                        HStack {
                            Button("Press Me") {}
                                .buttonStyle(PrimaryButton(style: .gray))
                            Button("Press Me") {}
                                .buttonStyle(PrimaryButton(style: .gray)).disabled(true)
                        }
                        .frame(maxWidth: .infinity)

                        HStack {
                            Button("Press Me") {}
                                .buttonStyle(PrimaryButton(style: .transparent))
                            Button("Press Me") {}
                                .buttonStyle(PrimaryButton(style: .transparent)).disabled(true)
                        }
                        .frame(maxWidth: .infinity)
                    }

                    Group {
                        HighlightedDescriptionView(text: "The features below are experimental and should be used with caution. While we have thoroughly tested these features using our own crypto funds, we cannot guarantee they will work as expected in all possible cases.")
                        HighlightedDescriptionView(text: "The features below are experimental", style: .alert)
                    }

                    ListSection(footerText: "Together, with your support, we can make this app even better!") {
                        ClickableRow(action: {
                            donatePresented = true
                        }) {
                            Image("heart_fill_24").themeIcon(color: .themeJacob)
                            Text("Donate").themeBody()
                            Image.disclosureIcon
                        }
                        .sheet(isPresented: $donatePresented) {
                            NavigationView {
                                ButtonsView()
                                    .ignoresSafeArea()
                                    .navigationTitle("Buttons")
                            }
                        }
                    }

                    ListSection {
                        NavigationRow(destination: {
                            ButtonsView()
                                .ignoresSafeArea()
                                .navigationTitle("Buttons")
                        }) {
                            Image("wallet_24").themeIcon()
                            Text("Manage Wallets").themeBody()
                            Image.disclosureIcon
                        }

                        ClickableRow(action: {
                            print("Did Tap Blockchain Settings")
                        }) {
                            Image("wallet_24").themeIcon()
                            Text("Blockchain Settings").themeBody()
                            Image.disclosureIcon
                        }
                    }

                    ListSection {
                        ClickableRow(action: {
                            print("Did Tap WalletConnect")
                        }, content: {
                            Image("wallet_24").themeIcon()
                            Text("WalletConnect").themeBody()
                            Image.disclosureIcon
                        })
                    }

                    ListSection {
                        ClickableRow(action: {
                            print("Did Tap Security")
                        }, content: {
                            Image("wallet_24").themeIcon()
                            Text("Security").themeBody()
                            Image("warning_2_20").themeIcon(color: .themeLucian).padding(.trailing, -.margin8) // TODO: find another way to decrease default spacing
                            Image.disclosureIcon
                        })

                        ClickableRow(action: {
                            print("Did Tap Contacts")
                        }, content: {
                            Image("wallet_24").themeIcon()
                            Text("Contacts").themeBody()
                            Image.disclosureIcon
                        })

                        ClickableRow(action: {
                            print("Did Tap Appearance")
                        }, content: {
                            Image("wallet_24").themeIcon()
                            Text("Appearance").themeBody()
                            Image.disclosureIcon
                        })

                        ClickableRow(action: {
                            print("Did Tap Base Currency")
                        }, content: {
                            Image("wallet_24").themeIcon()
                            Text("Base Currency").themeBody()
                            Text("USD").themeSubhead1(alignment: .trailing).padding(.trailing, -.margin8) // TODO: find another way to decrease default spacing
                            Image.disclosureIcon
                        })

                        ClickableRow(action: {
                            print("Did Tap Language")
                            testNetEnabled = !testNetEnabled
                        }, content: {
                            Image("wallet_24").themeIcon()
                            Text("Language").themeBody()
                            Text("English").themeSubhead1(alignment: .trailing).padding(.trailing, -.margin8) // TODO: find another way to decrease default spacing
                            Image.disclosureIcon
                        })
                    }

                    BrandFooter(name: "Unstoppable", version: "0.35", build: "25", description: "decentralized app")

                    ListSection {
                        Row {
                            Toggle(isOn: $testNetEnabled) {
                                Text("TestNet Enabled").themeBody()
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top: .margin12, leading: .margin16, bottom: .margin32, trailing: .margin16))
            }
        }
    }
}

struct BrandFooter: View {
    let name: String
    let version: String
    let build: String
    let description: String

    var body: some View {
        VStack(spacing: .margin8) {
            Text("\(name) \(version) (\(build))")
                .font(.caption)
                .foregroundColor(.themeGray)
            Divider()
                .foregroundColor(.themeSteel20)
            Text(description)
                .font(.themeMicro)
                .foregroundColor(.themeGray)
            Image("HS Logo Image")
                .padding(.top, .margin32)
        }
        .fixedSize()
    }
}

extension Text {
    func themeBody(color: Color = .themeLeah, alignment: Alignment = .leading) -> some View {
        frame(maxWidth: .infinity, alignment: alignment)
            .foregroundColor(color)
            .font(.themeBody)
    }

    func themeSubhead1(color: Color = .themeGray, alignment: Alignment = .leading) -> some View {
        frame(maxWidth: .infinity, alignment: alignment)
            .foregroundColor(color)
            .font(.themeSubhead1)
    }

    func themeSubhead2(color: Color = .themeGray, alignment: Alignment = .leading) -> some View {
        frame(maxWidth: .infinity, alignment: alignment)
            .foregroundColor(color)
            .font(.themeSubhead2)
    }
}

extension Image {
    func themeIcon(color: Color = .themeGray) -> some View {
        renderingMode(.template)
            .foregroundColor(color)
    }

    static var disclosureIcon: some View {
        Image("arrow_big_forward_20").themeIcon()
    }
}

struct CellButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color.themeLawrencePressed : Color.themeLawrence)
    }
}

struct ListSection<Content: View>: View {
    var content: Content
    var footerText: String?

    init(footerText: String? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.footerText = footerText
    }

    var body: some View {
        VStack(spacing: 0) {
            _VariadicView.Tree(Layout()) {
                content
            }
            .background(RoundedRectangle(cornerRadius: .cornerRadius12, style: .continuous).fill(Color.themeLawrence))
            .clipShape(RoundedRectangle(cornerRadius: .cornerRadius12, style: .continuous))

            if let footerText {
                Text(footerText)
                    .themeSubhead2()
                    .padding(EdgeInsets(top: .margin12, leading: .margin16, bottom: 0, trailing: .margin16))
            }
        }
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

struct ClickableRow<Content: View>: View {
    let action: () -> Void
    @ViewBuilder let content: Content

    var body: some View {
        Button(action: action, label: {
            Row {
                content
            }
        })
        .buttonStyle(CellButton())
        .contentShape(Rectangle())
    }
}

struct NavigationRow<Content: View, Destination: View>: View {
    @ViewBuilder let destination: () -> Destination
    @ViewBuilder let content: Content

    var body: some View {
        NavigationLink(destination: destination) {
            Row {
                content
            }
        }
        .buttonStyle(CellButton())
    }
}

struct Row<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        HStack(spacing: .margin16) {
            content
        }
        .padding(EdgeInsets(top: .margin12, leading: .margin16, bottom: .margin12, trailing: .margin16))
    }
}

struct HorizontalDivider: View {
    private let color: Color
    private let height: CGFloat

    init(color: Color = .themeSteel10, height: CGFloat = 1) {
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
            .foregroundColor(.themeBran)
            .font(.themeSubhead2)
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
            case .warning: return .themeYellow
            case .alert: return .themeLucian
            }
        }
    }
}

struct ExperimentalView_Preview: PreviewProvider {
    static var previews: some View {
        ExperimentalView()
    }
}

struct ButtonsView: UIViewControllerRepresentable {
    typealias UIViewControllerType = ButtonsController

    func makeUIViewController(context _: Context) -> ButtonsController {
        ButtonsController()
    }

    func updateUIViewController(_: ButtonsController, context _: Context) {}
}
