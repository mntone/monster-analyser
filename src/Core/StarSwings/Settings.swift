
public final class Settings {
	fileprivate enum Key: String {
		case firstTime = "fsttm"
		case trailingSwipeAction = "trgSwipe"
#if os(iOS)
		case keyboardDismissMode = "kbdDismiss"
#endif
		case source = "source"
#if DEBUG
		case delayNetworkRequest = "delayReq"
#endif
		case showInternalInformation = "intlInfo"
		case monsterRowStyle = "_t"
	}

	fileprivate enum DefaultValues {
		public static var firstTime: Bool {
#if DEBUG
			false
#else
			true
#endif
		}

		public static var trailingSwipeAction: SwipeAction {
			.none
		}

#if os(iOS)
		public static var keyboardDismissMode: KeyboardDismissMode {
			.button
		}
#endif

		public static var source: String {
			""
		}

#if DEBUG
		public static var delayNetworkRequest: Bool {
			false
		}
#endif

		public static var showInternalInformation: Bool {
#if DEBUG
			true
#else
			false
#endif
		}

		public static var monsterRowStyle: String {
			"A"
		}
	}

	public var firstTime: Bool {
		fatalError("This is dummy property. Use AppStorage(settings:).")
	}

	@UserDefault("trgSwipe", initial: SwipeAction.none)
	public var trailingSwipeAction: SwipeAction

#if os(macOS)
	@UserDefault("favInSearch", initial: true)
	public var includesFavoriteGroupInSearchResult: Bool
#elseif os(iOS)
	@UserDefault("favInSearch", initial: false)
	public var includesFavoriteGroupInSearchResult: Bool
#endif

#if DEBUG
	@UserDefault("phys", initial: true)
	public var showPhysicalAttack: Bool

	@UserDefault("elem", initial: .number)
	public var elementAttack: ElementWeaknessDisplayMode
#else
	@UserDefault("phys", initial: false)
	public var showPhysicalAttack: Bool

	@UserDefault("elem", initial: .sign)
	public var elementAttack: ElementWeaknessDisplayMode
#endif

	@UserDefault("mrgPart", initial: true)
	public var mergeParts: Bool

#if os(iOS)
	@UserDefault(Key.keyboardDismissMode.rawValue,
				 initial: DefaultValues.keyboardDismissMode)
	public var keyboardDismissMode: KeyboardDismissMode
#endif

	@UserDefault(Key.source.rawValue, initial: DefaultValues.source)
	public var source: String

	@UserDefault("sort", initial: .inGame(reversed: false))
	public var sort: Sort

	@UserDefault("group", initial: GroupOption.none)
	public var groupOption: GroupOption

	@UserDefault("selMaster", initial: true)
	public var selectedMasterOrG: Bool

#if DEBUG
	@UserDefault(Key.delayNetworkRequest.rawValue,
				 initial: DefaultValues.delayNetworkRequest)
	public var delayNetworkRequest: Bool
#endif

	public var showInternalInformation: Bool {
		fatalError("This is dummy property. Use AppStorage(settings:).")
	}

	public var monsterRowStyle: String {
		fatalError("This is dummy property. Use AppStorage(settings:).")
	}
}

extension PartialKeyPath where Root == Settings {
	@inline(__always)
	public var userDefaultKeyName: String {
		switch self {
		case \.firstTime:
			Settings.Key.firstTime.rawValue
		case \.trailingSwipeAction:
			Settings.Key.trailingSwipeAction.rawValue
#if os(iOS)
		case \.keyboardDismissMode:
			Settings.Key.keyboardDismissMode.rawValue
#endif
		case \.source:
			Settings.Key.source.rawValue
#if DEBUG
		case \.delayNetworkRequest:
			Settings.Key.delayNetworkRequest.rawValue
#endif
		case \.showInternalInformation:
			Settings.Key.showInternalInformation.rawValue
		case \.monsterRowStyle:
			Settings.Key.monsterRowStyle.rawValue
		default:
			fatalError("Failed to get UserDefault key name.")
		}
	}

	@inline(__always)
	public func getDefaultValue() -> Bool {
		switch self {
		case \.firstTime:
			Settings.DefaultValues.firstTime
#if DEBUG
		case \.delayNetworkRequest:
			Settings.DefaultValues.delayNetworkRequest
#endif
		case \.showInternalInformation:
			Settings.DefaultValues.showInternalInformation
		default:
			fatalError("Failed to get default value.")
		}
	}

	@inline(__always)
	public func getDefaultValue() -> String {
		switch self {
		case \.trailingSwipeAction:
			Settings.DefaultValues.trailingSwipeAction.rawValue
#if os(iOS)
		case \.keyboardDismissMode:
			Settings.DefaultValues.keyboardDismissMode.rawValue
#endif
		case \.source:
			Settings.DefaultValues.source
		case \.monsterRowStyle:
			Settings.DefaultValues.monsterRowStyle
		default:
			fatalError("Failed to get default value.")
		}
	}
}
