import SwiftUI
import UIKit

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

    // ── Compact layout (iPhone) ───────────────────────────────────────────────
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

    // ── Regular layout (iPad) ─────────────────────────────────────────────────
    private var regularLayout: some View {
        NavigationSplitView {
            List {
                ForEach(featureVisibility.visibleSections) { section in
                    Button {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            tabNavigation.select(section.rawValue)
                        }
                    } label: {
                        Label(sectionTitle(section), systemImage: sectionIcon(section))
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
            sectionContent(selectedVisibleSection)
                .id(selectedVisibleSection.rawValue)
        }
        .navigationSplitViewStyle(.balanced)
    }

    // ── Section content ───────────────────────────────────────────────────────
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

    // ── Helpers ───────────────────────────────────────────────────────────────
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

    private func sectionTitle(_ section: AppSection) -> String {
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

    private func sectionIcon(_ section: AppSection) -> String {
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

// ── Floating Tab Bar ──────────────────────────────────────────────────────────
private struct CompactFloatingTabBar: View {
    let sections: [AppSection]
    @Binding var selection: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(sections) { section in
                let isSelected = section.rawValue == selection
                Button {
                    withAnimation(.easeInOut(duration: 0.18)) {
                        selection = section.rawValue
                    }
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
