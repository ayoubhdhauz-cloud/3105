import SwiftUI

// ── Models ────────────────────────────────────────────────────────────────────

struct FeatureToggle: Identifiable {
    let id = UUID()
    let title: String
    var isOn: Bool
}

// ── Main Features View ────────────────────────────────────────────────────────

struct FeaturesView: View {
    // FreeFire status
    @State private var isFFRunning = false
    @State private var moduleBase: String = "-"

    // Aimbot
    @State private var enableAimbot    = false
    @State private var silentAim       = false
    @State private var ignoreBots      = false
    @State private var ignoreKnocked   = false
    @State private var visibilityCheck = false
    @State private var noReload        = false
    @State private var fastFire        = false
    @State private var rapidFire       = false

    // Movement
    @State private var flyAlt          = false
    @State private var flyV2           = false
    @State private var telekill        = false

    // ESP
    @State private var espEnable       = false
    @State private var espBox          = false
    @State private var espHealth       = false
    @State private var espName         = false
    @State private var espDistance     = false
    @State private var espSkeleton     = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    // ── Start Aim Engine Button ───────────────────────────
                    Button {
                        // TODO: start aim engine
                    } label: {
                        Text("Start Aim Engine")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(AppTheme.cardBackground,
                                        in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .overlay {
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .strokeBorder(Color(uiColor: .separator).opacity(0.3), lineWidth: 0.5)
                            }
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, AppTheme.pageInset)

                    // ── FreeFire Status Card ──────────────────────────────
                    VStack(spacing: 0) {
                        FeatureInfoRow(
                            title: "FreeFire",
                            value: isFFRunning ? "running" : "not running",
                            valueColor: isFFRunning ? .green : .red
                        )
                        Divider().padding(.leading, AppTheme.pageInset)
                        FeatureInfoRow(title: "Module base", value: moduleBase)
                        Divider().padding(.leading, AppTheme.pageInset)

                        Button {
                            // TODO: attach to FreeFire
                        } label: {
                            Text("Attach to FreeFire")
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                    .background(AppTheme.cardBackground,
                                in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay { AppCardBorder() }
                    .padding(.horizontal, AppTheme.pageInset)

                    // ── Aimbot Section ────────────────────────────────────
                    FeatureSectionCard(header: "Aimbot") {
                        FeatureToggleRow(title: "Enable Aimbot",    isOn: $enableAimbot)
                        FeatureToggleRow(title: "Silent Aim",       isOn: $silentAim)
                        FeatureToggleRow(title: "Ignore Bots",      isOn: $ignoreBots)
                        FeatureToggleRow(title: "Ignore Knocked",   isOn: $ignoreKnocked)
                        FeatureToggleRow(title: "Visibility Check", isOn: $visibilityCheck)
                        FeatureToggleRow(title: "No Reload",        isOn: $noReload)
                        FeatureToggleRow(title: "Fast Fire",        isOn: $fastFire)
                        FeatureToggleRow(title: "Rapid Fire",       isOn: $rapidFire, isLast: true)
                    }
                    .padding(.horizontal, AppTheme.pageInset)

                    // ── Movement Section ──────────────────────────────────
                    FeatureSectionCard(header: "Movement") {
                        FeatureToggleRow(title: "Fly Alt",   isOn: $flyAlt)
                        FeatureToggleRow(title: "Fly V2",    isOn: $flyV2)
                        FeatureToggleRow(title: "Telekill",  isOn: $telekill, isLast: true)
                    }
                    .padding(.horizontal, AppTheme.pageInset)

                    // ── ESP Section ───────────────────────────────────────
                    FeatureSectionCard(header: "ESP") {
                        FeatureToggleRow(title: "Enable ESP",  isOn: $espEnable)
                        FeatureToggleRow(title: "Box",         isOn: $espBox)
                        FeatureToggleRow(title: "Health",      isOn: $espHealth)
                        FeatureToggleRow(title: "Name",        isOn: $espName)
                        FeatureToggleRow(title: "Distance",    isOn: $espDistance)
                        FeatureToggleRow(title: "Skeleton",    isOn: $espSkeleton, isLast: true)
                    }
                    .padding(.horizontal, AppTheme.pageInset)

                    Spacer(minLength: 32)
                }
                .padding(.top, 12)
            }
            .background(AppTheme.pageBackground.ignoresSafeArea())
            .navigationTitle("Features")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// ── Account View ──────────────────────────────────────────────────────────────

struct AccountView: View {
    // Key info (ใส่ข้อมูลจริงทีหลัง)
    private let packageName = "EXTERNAL"
    private let key         = "••••••••SP"
    private let expiresOn   = "2026-09-13"

    // Device info
    private var deviceModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)
        return mirror.children.compactMap {
            $0.value as? Int8
        }.filter { $0 != 0 }.map {
            String(UnicodeScalar(UInt8(bitPattern: $0)))
        }.joined()
    }

    private var iosVersion: String {
        UIDevice.current.systemVersion
    }

    private var batteryInfo: String {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let level = Int(UIDevice.current.batteryLevel * 100)
        let state = UIDevice.current.batteryState
        let plugged = (state == .charging || state == .full) ? "Plugged" : "Unplugged"
        return "\(level)% (\(plugged))"
    }

    private var isJailbroken: Bool {
        FileManager.default.fileExists(atPath: "/Applications/Cydia.app")
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    // ── Key Info Card ─────────────────────────────────────
                    VStack(spacing: 0) {
                        AccountInfoRow(label: "Package Name", value: packageName)
                        Divider().padding(.leading, AppTheme.pageInset)
                        AccountInfoRow(label: "Key", value: key)
                        Divider().padding(.leading, AppTheme.pageInset)
                        AccountInfoRow(label: "Expires On", value: expiresOn)
                        Divider().padding(.leading, AppTheme.pageInset)

                        Button(role: .destructive) {
                            // TODO: logout
                        } label: {
                            Text("Logout")
                                .font(.body.weight(.semibold))
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                    .background(AppTheme.cardBackground,
                                in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay { AppCardBorder() }
                    .padding(.horizontal, AppTheme.pageInset)

                    Text("This shows your key and its expiration date.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, AppTheme.pageInset + 4)

                    // ── Device Info Card ──────────────────────────────────
                    VStack(spacing: 0) {
                        AccountInfoRow(label: "Device Name",  value: UIDevice.current.name)
                        Divider().padding(.leading, AppTheme.pageInset)
                        AccountInfoRow(label: "Device Model", value: deviceModel)
                        Divider().padding(.leading, AppTheme.pageInset)
                        AccountInfoRow(label: "iOS Version",  value: "iOS \(iosVersion)")
                        Divider().padding(.leading, AppTheme.pageInset)
                        AccountInfoRow(label: "Battery Info", value: batteryInfo)
                        Divider().padding(.leading, AppTheme.pageInset)
                        AccountInfoRow(label: "Jailbreak",    value: isJailbroken ? "Yes" : "No",
                                       isLast: true)
                    }
                    .background(AppTheme.cardBackground,
                                in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay { AppCardBorder() }
                    .padding(.horizontal, AppTheme.pageInset)

                    Text("Device information for diagnostics and support.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, AppTheme.pageInset + 4)

                    Spacer(minLength: 32)
                }
                .padding(.top, 12)
            }
            .background(AppTheme.pageBackground.ignoresSafeArea())
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// ── Reusable Components ───────────────────────────────────────────────────────

/// Section card พร้อม header สีเทา
struct FeatureSectionCard<Content: View>: View {
    let header: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(spacing: 0) {
            // Section header
            Text(header.uppercased())
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, AppTheme.pageInset)
                .padding(.bottom, 6)

            VStack(spacing: 0) {
                content
            }
            .background(AppTheme.cardBackground,
                        in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay { AppCardBorder() }
        }
    }
}

/// Toggle row แบบ iOS native
struct FeatureToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    var isLast: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Toggle(isOn: $isOn) {
                Text(title)
                    .font(.body)
            }
            .toggleStyle(SwitchToggleStyle(tint: AppTheme.accent))
            .padding(.horizontal, AppTheme.pageInset)
            .frame(minHeight: 50)

            if !isLast {
                Divider().padding(.leading, AppTheme.pageInset)
            }
        }
    }
}

/// Info row (label + value ขวา) ไม่มี toggle
struct FeatureInfoRow: View {
    let title: String
    let value: String
    var valueColor: Color = .secondary

    var body: some View {
        HStack {
            Text(title).font(.body)
            Spacer()
            Text(value)
                .font(.body)
                .foregroundStyle(valueColor)
        }
        .padding(.horizontal, AppTheme.pageInset)
        .frame(minHeight: 50)
    }
}

/// Account info row
struct AccountInfoRow: View {
    let label: String
    let value: String
    var isLast: Bool = false

    var body: some View {
        HStack {
            Text(label).font(.body)
            Spacer()
            Text(value)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, AppTheme.pageInset)
        .frame(minHeight: 50)
    }
}

// ── Preview ───────────────────────────────────────────────────────────────────
#Preview("Features") { FeaturesView() }
#Preview("Account")  { AccountView() }
