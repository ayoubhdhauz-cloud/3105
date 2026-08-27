import SwiftUI
import UIKit

// ══════════════════════════════════════════════════════════════════════════════
// MARK: - Features View
// ══════════════════════════════════════════════════════════════════════════════

struct FeaturesView: View {
    @State private var isFFRunning     = false
    @State private var moduleBase      = "-"
    @State private var enableAimbot    = false
    @State private var silentAim       = false
    @State private var ignoreBots      = false
    @State private var ignoreKnocked   = false
    @State private var visibilityCheck = false
    @State private var noReload        = false
    @State private var fastFire        = false
    @State private var rapidFire       = false
    @State private var flyAlt          = false
    @State private var flyV2           = false
    @State private var telekill        = false
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

                    // Start Aim Engine
                    Button {
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

                    // FreeFire Status
                    VStack(spacing: 0) {
                        FF_InfoRow(title: "FreeFire",
                                   value: isFFRunning ? "running" : "not running",
                                   valueColor: isFFRunning ? .green : .red)
                        Divider().padding(.leading, AppTheme.pageInset)
                        FF_InfoRow(title: "Module base", value: moduleBase)
                        Divider().padding(.leading, AppTheme.pageInset)
                        Button {
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

                    // Aimbot
                    FF_SectionCard(header: "Aimbot") {
                        FF_ToggleRow(title: "Enable Aimbot",    isOn: $enableAimbot)
                        FF_ToggleRow(title: "Silent Aim",       isOn: $silentAim)
                        FF_ToggleRow(title: "Ignore Bots",      isOn: $ignoreBots)
                        FF_ToggleRow(title: "Ignore Knocked",   isOn: $ignoreKnocked)
                        FF_ToggleRow(title: "Visibility Check", isOn: $visibilityCheck)
                        FF_ToggleRow(title: "No Reload",        isOn: $noReload)
                        FF_ToggleRow(title: "Fast Fire",        isOn: $fastFire)
                        FF_ToggleRow(title: "Rapid Fire",       isOn: $rapidFire, isLast: true)
                    }
                    .padding(.horizontal, AppTheme.pageInset)

                    // Movement
                    FF_SectionCard(header: "Movement") {
                        FF_ToggleRow(title: "Fly Alt",  isOn: $flyAlt)
                        FF_ToggleRow(title: "Fly V2",   isOn: $flyV2)
                        FF_ToggleRow(title: "Telekill", isOn: $telekill, isLast: true)
                    }
                    .padding(.horizontal, AppTheme.pageInset)

                    // ESP
                    FF_SectionCard(header: "ESP") {
                        FF_ToggleRow(title: "Enable ESP", isOn: $espEnable)
                        FF_ToggleRow(title: "Box",        isOn: $espBox)
                        FF_ToggleRow(title: "Health",     isOn: $espHealth)
                        FF_ToggleRow(title: "Name",       isOn: $espName)
                        FF_ToggleRow(title: "Distance",   isOn: $espDistance)
                        FF_ToggleRow(title: "Skeleton",   isOn: $espSkeleton, isLast: true)
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

// ══════════════════════════════════════════════════════════════════════════════
// MARK: - Account View
// ══════════════════════════════════════════════════════════════════════════════

struct AccountView: View {
    private let packageName = "EXTERNAL"
    private let key         = "••••••••SP"
    private let expiresOn   = "2026-09-13"

    private var iosVersion: String { UIDevice.current.systemVersion }

    private var batteryInfo: String {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let level = Int(UIDevice.current.batteryLevel * 100)
        let state = UIDevice.current.batteryState
        let plugged = (state == .charging || state == .full) ? "Plugged" : "Unplugged"
        return "\(level < 0 ? 0 : level)% (\(plugged))"
    }

    private var isJailbroken: Bool {
        FileManager.default.fileExists(atPath: "/Applications/Cydia.app")
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    // Key Info
                    VStack(spacing: 0) {
                        FF_InfoRow(title: "Package Name", value: packageName)
                        Divider().padding(.leading, AppTheme.pageInset)
                        FF_InfoRow(title: "Key", value: key)
                        Divider().padding(.leading, AppTheme.pageInset)
                        FF_InfoRow(title: "Expires On", value: expiresOn)
                        Divider().padding(.leading, AppTheme.pageInset)
                        Button(role: .destructive) {
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

                    // Device Info
                    VStack(spacing: 0) {
                        FF_InfoRow(title: "Device Name",  value: UIDevice.current.name)
                        Divider().padding(.leading, AppTheme.pageInset)
                        FF_InfoRow(title: "Device Model", value: UIDevice.current.model)
                        Divider().padding(.leading, AppTheme.pageInset)
                        FF_InfoRow(title: "iOS Version",  value: "iOS \(iosVersion)")
                        Divider().padding(.leading, AppTheme.pageInset)
                        FF_InfoRow(title: "Battery Info", value: batteryInfo)
                        Divider().padding(.leading, AppTheme.pageInset)
                        FF_InfoRow(title: "Jailbreak",    value: isJailbroken ? "Yes" : "No")
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

// ══════════════════════════════════════════════════════════════════════════════
// MARK: - Reusable Components
// ══════════════════════════════════════════════════════════════════════════════

struct FF_SectionCard<Content: View>: View {
    let header: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(header.uppercased())
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                content
            }
            .background(AppTheme.cardBackground,
                        in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay { AppCardBorder() }
        }
    }
}

struct FF_ToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    var isLast: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Toggle(isOn: $isOn) {
                Text(title).font(.body)
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

struct FF_InfoRow: View {
    let title: String
    let value: String
    var valueColor: Color = .secondary

    var body: some View {
        HStack {
            Text(title).font(.body)
            Spacer()
            Text(value).font(.body).foregroundStyle(valueColor)
        }
        .padding(.horizontal, AppTheme.pageInset)
        .frame(minHeight: 50)
    }
}

// ══════════════════════════════════════════════════════════════════════════════
// MARK: - ContentView
// ══════════════════════════════════════════════════════════════════════════════

struct ContentView: View {
    @Environment(\.appLanguage) private var language
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @EnvironmentObject private var patchDraftCoordinator: PatchDraftCoordinator
    @EnvironmentObject private var patchStore: PatchProjectStore
    @EnvironmentObject private var repositoryStore: PackageRepositoryStore
    @AppStorage(FeatureVisibility.developerModeStorageKey)
    private var developerModeEnabled = false
    @State private var tabNavigation: AppTabNavigationState
    @State private var showSettings = false
    @State private var showLogs = false

    init() {
        _tabNavigation = State(initialValue: AppTabNavigationState())
    }

    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                regularLayout
            } else {
                compactLayout
            }
        }
        .tint(AppTheme.accent)
        .imageScale(.small)
        .onChange(of: patchDraftCoordinator.request?.id) { requestID in
            if requestID != nil { tabNavigation.select(AppSection.installed.rawValue) }
        }
        .onChange(of: patchDraftCoordinator.importRequest?.id) { requestID in
            if requestID != nil { tabNavigation.select(AppSection.installed.rawValue) }
        }
        .onChange(of: developerModeEnabled) { _ in
            tabNavigation.reconcileSelection(with: featureVisibility)
        }
        .onAppear {
            tabNavigation.reconcileSelection(with: featureVisibility)
        }
        .sheet(isPresented: $showSettings) { SettingsView() }
        .sheet(isPresented: $showLogs) { LogView() }
        .patchStorePresentation(patchStore)
        .repositoryStorePresentation(repositoryStore, patchStore: patchStore)
    }

    private var compactLayout: some View {
        ZStack(alignment: .bottom) {
            sectionContent(selectedVisibleSection)
                .id(selectedVisibleSection.rawValue)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    Color.clear.frame(height: 78)
                }
            CompactFloatingTabBar(
                sections: featureVisibility.visibleSections,
                selection: tabSelection
            )
            .padding(.horizontal, 18)
            .padding(.bottom, 8)
        }
        .background(AppTheme.pageBackground.ignoresSafeArea())
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    private var regularLayout: some View {
        NavigationSplitView {
            List {
                ForEach(featureVisibility.visibleSections) { section in
                    Button {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            tabNavigation.select(section.rawValue)
                        }
                    } label: {
                        Label(tabTitle(section), systemImage: tabIcon(section))
                            .fontWeight(section.rawValue == tabNavigation.selectedTab ? .semibold : .regular)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(
                        section.rawValue == tabNavigation.selectedTab
                            ? AppTheme.accent.opacity(0.14) : Color.clear
                    )
                }
            }
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)
            .background(AppTheme.pageBackground)
            .navigationTitle("3105")
        } detail: {
            sectionContent(selectedVisibleSection).id(selectedVisibleSection.rawValue)
        }
        .navigationSplitViewStyle(.balanced)
    }

    @ViewBuilder
    private func sectionContent(_ section: AppSection) -> some View {
        switch section {
        case .features:
            FeaturesView()
        case .account:
            AccountView()
        case .home:
            RepositoryHomeView(onOpenSettings: openSettings, onOpenLogs: openLogs)
        case .new:
            RepositoryNewView(onOpenSettings: openSettings, onOpenLogs: openLogs)
        case .sources:
            RepositorySourcesView(onOpenSettings: openSettings, onOpenLogs: openLogs)
        case .installed:
            PatchProjectsView(onOpenSettings: openSettings, onOpenLogs: openLogs)
        case .files:
            AppDataBrowserView(tabSession: filesTabSession, onOpenSettings: openSettings, onOpenLogs: openLogs)
        case .search:
            RepositorySearchView(onOpenSettings: openSettings, onOpenLogs: openLogs)
        }
    }

    private var tabSelection: Binding<Int> {
        Binding(get: { tabNavigation.selectedTab }, set: { tabNavigation.select($0) })
    }

    private var filesTabSession: Binding<FilesTabSession> {
        Binding(get: { tabNavigation.filesTabs }, set: { tabNavigation.setFilesTabs($0) })
    }

    private var featureVisibility: FeatureVisibility {
        FeatureVisibility(developerModeEnabled: developerModeEnabled)
    }

    private var selectedVisibleSection: AppSection {
        let selected = AppSection(rawValue: tabNavigation.selectedTab)
        return selected.flatMap {
            featureVisibility.isVisible($0) ? $0 : nil
        } ?? .features
    }

    private func openSettings() { showSettings = true }
    private func openLogs()     { showLogs = true }

    private func tabTitle(_ section: AppSection) -> String {
        switch section {
        case .features:  return "Features"
        case .account:   return "Account"
        case .home:      return language.text("tab.home")
        case .new:       return language.text("tab.new")
        case .sources:   return language.text("tab.sources")
        case .installed: return language.text("tab.installed")
        case .files:     return language.text("tab.files")
        case .search:    return language.text("tab.search")
        }
    }

    private func tabIcon(_ section: AppSection) -> String {
        switch section {
        case .features:  return "gamecontroller.fill"
        case .account:   return "person.fill"
        case .home:      return "house.fill"
        case .new:       return "clock.fill"
        case .sources:   return "shippingbox.fill"
        case .installed: return "tray.full.fill"
        case .files:     return "folder.fill"
        case .search:    return "magnifyingglass"
        }
    }
}

// ══════════════════════════════════════════════════════════════════════════════
// MARK: - Floating Tab Bar
// ══════════════════════════════════════════════════════════════════════════════

private struct CompactFloatingTabBar: View {
    let sections: [AppSection]
    @Binding var selection: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(sections) { section in
                let isSelected = section.rawValue == selection
                Button {
                    withAnimation(.easeInOut(duration: 0.18)) { selection = section.rawValue }
                } label: {
                    VStack(spacing: 3) {
                        Image(systemName: tabIcon(section))
                            .font(.system(size: 17, weight: isSelected ? .semibold : .medium))
                        Text(tabTitle(section))
                            .font(.caption2.weight(.semibold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.72)
                    }
                    .foregroundStyle(isSelected ? .primary : .secondary)
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .contentShape(Capsule())
                    .background(isSelected ? AppTheme.cardBackground : Color.clear, in: Capsule())
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(isSelected ? .isSelected : [])
            }
        }
        .padding(5)
        .background(.ultraThinMaterial, in: Capsule())
        .overlay { Capsule().stroke(Color.white.opacity(0.72), lineWidth: 0.8) }
        .shadow(color: .black.opacity(0.16), radius: 18, y: 8)
    }

    private func tabTitle(_ section: AppSection) -> String {
        switch section {
        case .features:  return "Features"
        case .account:   return "Account"
        case .home:      return "Home"
        case .new:       return "New"
        case .sources:   return "Sources"
        case .installed: return "Installed"
        case .files:     return "Files"
        case .search:    return "Search"
        }
    }

    private func tabIcon(_ section: AppSection) -> String {
        switch section {
        case .features:  return "gamecontroller.fill"
        case .account:   return "person.fill"
        case .home:      return "house.fill"
        case .new:       return "clock.fill"
        case .sources:   return "shippingbox.fill"
        case .installed: return "tray.full.fill"
        case .files:     return "folder.fill"
        case .search:    return "magnifyingglass"
        }
    }
}
