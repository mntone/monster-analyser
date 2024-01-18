import Combine
import Foundation
import MonsterAnalyzerCore

final class SettingsViewModel: ObservableObject {
	private let formatter = {
		var formatter = ByteCountFormatter()
		formatter.allowedUnits = [.useBytes, .useKB, .useMB]
		formatter.countStyle = .file
		return formatter
	}()

	private let app: MonsterAnalyzerCore.App
	private let settings: MonsterAnalyzerCore.Settings

	private var cancellable: AnyCancellable?

	@Published
	var storageSize: String?

#if os(watchOS)
	@Published
	var sort: Sort {
		didSet {
			settings.sort = sort
		}
	}

	@Published
	var groupOption: GroupOption {
		didSet {
			settings.groupOption = groupOption
		}
	}
#endif

	@Published
	var trailingSwipeAction: SwipeAction {
		didSet {
			settings.trailingSwipeAction = trailingSwipeAction
		}
	}

#if !os(watchOS)
	@Published
	var includesFavoriteGroupInSearchResult: Bool {
		didSet {
			settings.includesFavoriteGroupInSearchResult = includesFavoriteGroupInSearchResult
		}
	}
#endif

	@Published
	var elementDisplay: WeaknessDisplayMode {
		didSet {
			settings.elementDisplay = elementDisplay
		}
	}

	@Published
	var mergeParts: Bool {
		didSet {
			settings.mergeParts = mergeParts
		}
	}

#if os(iOS)
	@Published
	var keyboardDismissMode: KeyboardDismissMode {
		didSet {
			settings.keyboardDismissMode = keyboardDismissMode
		}
	}
#endif

#if DEBUG
	@Published
	var delayNetworkRequest: Bool {
		didSet {
			settings.delayNetworkRequest = delayNetworkRequest
		}
	}
#endif

	@Published
	var showInternalInformation: Bool {
		didSet {
			settings.showInternalInformation = showInternalInformation
		}
	}

	@Published
	var test: String {
		didSet {
			settings.test = test
		}
	}

	init() {
		guard let app = MAApp.resolver.resolve(MonsterAnalyzerCore.App.self) else {
			fatalError()
		}
		self.app = app
		self.settings = app.settings
#if os(watchOS)
		self.sort = app.settings.sort
		self.groupOption = app.settings.groupOption
#endif
		self.trailingSwipeAction = app.settings.trailingSwipeAction
#if !os(watchOS)
		self.includesFavoriteGroupInSearchResult = app.settings.includesFavoriteGroupInSearchResult
#endif
		self.elementDisplay = app.settings.elementDisplay
		self.mergeParts = app.settings.mergeParts
#if os(iOS)
		self.keyboardDismissMode = app.settings.keyboardDismissMode
#endif
#if DEBUG
		self.delayNetworkRequest = app.settings.delayNetworkRequest
#endif
		self.showInternalInformation = app.settings.showInternalInformation
		self.test = app.settings.test

		let scheduler = DispatchQueue.main
#if os(watchOS)
		settings.$sort.dropFirst().receive(on: scheduler).assign(to: &$sort)
		settings.$groupOption.dropFirst().receive(on: scheduler).assign(to: &$groupOption)
#endif
		settings.$trailingSwipeAction.dropFirst().receive(on: scheduler).assign(to: &$trailingSwipeAction)
#if !os(watchOS)
		settings.$includesFavoriteGroupInSearchResult.dropFirst().receive(on: scheduler).assign(to: &$includesFavoriteGroupInSearchResult)
#endif
		settings.$elementDisplay.dropFirst().receive(on: scheduler).assign(to: &$elementDisplay)
		settings.$mergeParts.dropFirst().receive(on: scheduler).assign(to: &$mergeParts)
#if os(iOS)
		settings.$keyboardDismissMode.dropFirst().receive(on: scheduler).assign(to: &$keyboardDismissMode)
#endif
#if DEBUG
		settings.$delayNetworkRequest.dropFirst().receive(on: scheduler).assign(to: &$delayNetworkRequest)
#endif
		settings.$showInternalInformation.dropFirst().receive(on: scheduler).assign(to: &$showInternalInformation)
		settings.$test.dropFirst().receive(on: scheduler).assign(to: &$test)

		// App should reload to change some settings.
		cancellable = $mergeParts
			.debounce(for: 2.0, scheduler: DispatchQueue.global(qos: .utility))
			.removeDuplicates { oldMergeParts, newMergeParts in
				return oldMergeParts == newMergeParts
			}
			.dropFirst()
			.sink { _ in
				app.resetMemoryData()
			}
	}

	func resetAllCaches() {
		storageSize = nil

		Task(priority: .utility) {
			await app.resetAllData().value
			await updateStorageSize()
		}
	}

	func updateStorageSize() async {
		let sizeString = await app.getCacheSize().map { size in
			formatter.string(fromByteCount: Int64(clamping: size))
		}
		DispatchQueue.main.async {
			self.storageSize = sizeString
		}
	}
}
