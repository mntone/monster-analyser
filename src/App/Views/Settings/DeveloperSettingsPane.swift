import SwiftUI

struct DeveloperSettingsPane: View {
#if DEBUG
	@AppStorage(settings: \.delayNetworkRequest)
	private var delayNetworkRequest: Bool
#endif

	@AppStorage(settings: \.showInternalInformation)
	private var showInternalInformation: Bool

	var body: some View {
		SettingsPreferredList {
			Section {
#if DEBUG
				SettingsToggle(verbatim: "Delay Network Request",
							   isOn: $delayNetworkRequest)
#endif

				SettingsToggle("Internal Information",
							   isOn: $showInternalInformation)
			}
		}
		.navigationTitle("Developer")
		.modifier(SharedSettingsPaneModifier())
	}
}
