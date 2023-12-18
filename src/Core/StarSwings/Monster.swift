import Combine
import Foundation

public final class Monster: FetchableEntity, Entity {
	private let _languageService: LanguageService

	public let id: String
	public let gameID: String
	public let name: String
	public let anotherName: String?
	public let keywords: [String]

	@Published
	public var physiologies: Physiologies?

	private var _cancellable: AnyCancellable?

	init(_ id: String,
		 gameID: String,
		 dataSource: MHDataSource,
		 languageService: LanguageService,
		 localization: MHLocalizationMonster) {
		self._languageService = languageService

		self.id = id
		self.gameID = gameID
		self.name = localization.name
		self.anotherName = localization.anotherName
		self.keywords = MonsterLocalizationMapper.map(localization, languageService: languageService)
		super.init(dataSource: dataSource)
	}

	public func fetchIfNeeded() {
		_lock.withLock {
			guard case .ready = state else { return }
			state = .loading
		}

		_dataSource.getMonster(of: id, for: gameID)
			.map { [_languageService] json in
				Optional(PhysiologyMapper.map(json: json, languageService: _languageService))
			}
			.handleEvents(receiveCompletion: { [weak self] completion in
				guard let self else { fatalError() }
				self._handle(completion: completion)
			})
			.catch { error in
				return Empty<Physiologies?, Never>()
			}
			.assign(to: &$physiologies)
	}
}
