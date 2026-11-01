@testable import DanaKit
import Foundation
import LoopKit
import Testing

struct UnfinalizedDoseTests {
    @Test func bolusCarriesDecisionId() {
        let decisionId = UUID()
        let dose = UnfinalizedDose(
            units: 1,
            duration: 12,
            activationType: .automatic,
            insulinType: .novolog,
            decisionId: decisionId
        )

        #expect(dose.toDoseEntry(endDate: nil).decisionId == decisionId)
        #expect(dose.toDoseEntry(endDate: Date.now).decisionId == decisionId)
    }

    @Test func tempBasalCarriesDecisionId() {
        let decisionId = UUID()
        let dose = UnfinalizedDose(
            tempRate: 1,
            duration: .minutes(30),
            insulinType: .novolog,
            automatic: true,
            decisionId: decisionId
        )

        #expect(dose.toDoseEntry(endDate: nil).decisionId == decisionId)
        #expect(dose.toDoseEntry(endDate: Date.now).decisionId == decisionId)
    }

    @Test func decisionIdDefaultsToNil() {
        let dose = UnfinalizedDose(units: 1, duration: 12, activationType: .manualNoRecommendation, insulinType: nil)

        #expect(dose.toDoseEntry(endDate: nil).decisionId == nil)
        #expect(dose.rawValue["decisionId"] == nil)
    }

    @Test func rawValueRoundTripKeepsDecisionId() throws {
        let decisionId = UUID()
        let dose = UnfinalizedDose(
            tempRate: 1,
            duration: .minutes(30),
            insulinType: .novolog,
            automatic: true,
            decisionId: decisionId
        )

        let restored = try #require(UnfinalizedDose(rawValue: dose.rawValue))
        #expect(restored.decisionId == decisionId)
        #expect(restored.toDoseEntry(endDate: nil).decisionId == decisionId)
    }

    @Test func rawValueWithoutDecisionIdRestores() throws {
        let startDate = Date(timeIntervalSince1970: 1_701_774_000)
        let oldRawValue: UnfinalizedDose.RawValue = [
            "type": DoseType.bolus.rawValue,
            "startDate": startDate,
            "expectedEndDate": startDate.addingTimeInterval(12),
            "value": 1.0,
            "deliveredUnits": 0.5,
            "insulinType": InsulinType.novolog.rawValue,
            "automatic": true
        ]

        let restored = try #require(UnfinalizedDose(rawValue: oldRawValue))
        #expect(restored.type == .bolus)
        #expect(restored.startDate == startDate)
        #expect(restored.value == 1.0)
        #expect(restored.deliveredUnits == 0.5)
        #expect(restored.insulinType == .novolog)
        #expect(restored.automatic == true)
        #expect(restored.decisionId == nil)
    }
}
