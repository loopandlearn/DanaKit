@testable import DanaKit
import LoopKit
import Testing

struct DanaKitNotificationTests {
    @Test func identifiersUseDanaManagerIdentifier() {
        #expect(DanaKitNotification.disconnectWarning.identifier.managerIdentifier == "Dana")
        #expect(DanaKitNotification.disconnectedReminder(after: 60).identifier.managerIdentifier == "Dana")
    }

    @Test func retractableIdentifiersIncludeLegacyMedtrumScope() {
        let identifiers = DanaKitNotification.retractableIdentifiers
        let expected: [Alert.Identifier] = [
            Alert.Identifier(managerIdentifier: "Dana", alertIdentifier: "com.bastiaanv.continuous-ble.disconnect-warning"),
            Alert.Identifier(managerIdentifier: "Medtrum", alertIdentifier: "com.bastiaanv.continuous-ble.disconnect-warning"),
            Alert.Identifier(managerIdentifier: "Dana", alertIdentifier: "com.bastiaanv.continuous-ble.disconnect-reminder"),
            Alert.Identifier(managerIdentifier: "Medtrum", alertIdentifier: "com.bastiaanv.continuous-ble.disconnect-reminder")
        ]

        #expect(identifiers == expected)
    }
}
