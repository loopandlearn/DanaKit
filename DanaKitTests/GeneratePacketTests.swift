@testable import DanaKit
import Testing

@Suite struct GeneratePacketTests {
    @Test func generateBasalCancelTemporary() throws {
        let packet = DanaBasalCancelTemporary()

        #expect(packet.opCode == 98)
        #expect(try packet.generate() == Data())
    }

    @Test func generateBasalGetProfileNumber() throws {
        let packet = DanaBasalGetProfileNumber()

        #expect(packet.opCode == 101)
        #expect(try packet.generate() == Data())
    }

    @Test func generateBasalGetRate() throws {
        let packet = DanaBasalGetRate()

        #expect(packet.opCode == 103)
        #expect(try packet.generate() == Data())
    }

    @Test func generateBasalSetProfileNumber() throws {
        let options = PacketBasalSetProfileNumber(profileNumber: 0)
        let packet = DanaBasalSetProfileNumber(options: options)

        #expect(packet.opCode == 100)
        #expect(try packet.generate() == Data([0]))
    }

    @Test func generateBasalSetProfileRate() throws {
        let profileBasalRate: [Double] = Array(repeating: 0.5, count: 24)
        let options = PacketBasalSetProfileRate(profileNumber: 0, profileBasalRate: profileBasalRate)
        let packet = DanaBasalSetProfileRate(options: options)

        let expectedData = Data([0] + Array(repeating: [50, 0], count: 24).flatMap { $0 })
        #expect(packet.opCode == 102)
        #expect(try packet.generate() == expectedData)
    }

    @Test func generateBasalSetProfileRate_InvalidRateLength() {
        let profileBasalRate: [Double] = Array(repeating: 0.5, count: 23)
        let options = PacketBasalSetProfileRate(profileNumber: 0, profileBasalRate: profileBasalRate)

        let expectedError = NSError(
            domain: "INVALID_LENGTH",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: "Invalid basal rate. Expected length = 24"]
        )
        #expect(throws: expectedError) { try DanaBasalSetProfileRate(options: options).generate() }
    }

    @Test func generateBasalSetSuspendOff() throws {
        let packet = DanaBasalSetSuspendOff()

        #expect(packet.opCode == 106)
        #expect(try packet.generate() == Data())
    }

    @Test func generateBasalSetSuspendOn() throws {
        let packet = DanaBasalSetSuspendOn()

        #expect(packet.opCode == 105)
        #expect(try packet.generate() == Data())
    }

    @Test func generateBasalSetTemporary() throws {
        let options = PacketBasalSetTemporary(temporaryBasalRatio: 200, temporaryBasalDuration: 1)
        let packet = DanaBasalSetTemporary(options: options)

        #expect(packet.opCode == 96)
        #expect(try packet.generate() == Data([200, 1]))
    }

    @Test func generateBolusCancelExtended() throws {
        let packet = DanaBolusCancelExtended()

        #expect(packet.opCode == 73)
        #expect(try packet.generate() == Data())
    }

    @Test func generateBolusGet24Circf() throws {
        let packet = DanaBolusGet24CIRCFArray()

        #expect(packet.opCode == 82)
        #expect(try packet.generate() == Data())
    }

    @Test func generateBolusGetCalculationInformation() throws {
        let packet = DanaBolusGetCalculationInformation()

        #expect(packet.opCode == 75)
        #expect(try packet.generate() == Data())
    }

    @Test func generateBolusGetCircf() throws {
        let packet = DanaBolusGetCIRCFArray()

        #expect(packet.opCode == 78)
        #expect(try packet.generate() == Data())
    }

    @Test func generateBolusGetOption() throws {
        let packet = DanaBolusGetOption()

        #expect(packet.opCode == 80)
        #expect(try packet.generate() == Data())
    }

    @Test func generateBolusGetStepOptionInformation() throws {
        let packet = DanaBolusGetStepInformation()

        #expect(packet.opCode == 64)
        #expect(try packet.generate() == Data())
    }

    @Test func generateBolusSet24Circf_mmolPerL() throws {
        let options = PacketBolusSet24CIRCFArray(
            unit: 1,
            ic: Array(repeating: 0.5, count: 24),
            isf: Array(repeating: 1, count: 24)
        )
        let packet = DanaBolusSet24CIRCFArray(options: options)

        let expectedData = Data(
            Array(repeating: [1, 0], count: 24).flatMap { $0 } + Array(repeating: [100, 0], count: 24).flatMap { $0 }
        )
        #expect(packet.opCode == 83)
        #expect(try packet.generate() == expectedData)
    }

    @Test func generateBolusSet24Circf() throws {
        let options = PacketBolusSet24CIRCFArray(
            unit: 0,
            ic: Array(repeating: 0.5, count: 24),
            isf: Array(repeating: 1, count: 24)
        )
        let packet = DanaBolusSet24CIRCFArray(options: options)

        let expectedData = Data(Array(repeating: [1, 0], count: 48).flatMap { $0 })
        #expect(packet.opCode == 83)
        #expect(try packet.generate() == expectedData)
    }

    @Test func generateBolusSet24Circf_InvalidInput() {
        let optionsInvalidIc = PacketBolusSet24CIRCFArray(
            unit: 0,
            ic: Array(repeating: 0.5, count: 23),
            isf: Array(repeating: 1, count: 24)
        )
        let optionsInvalidIsf = PacketBolusSet24CIRCFArray(
            unit: 0,
            ic: Array(repeating: 0.5, count: 24),
            isf: Array(repeating: 1, count: 23)
        )

        let expectedError = NSError(
            domain: "INVALID_LENGTH",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: "Invalid length isf or ic"]
        )
        #expect(throws: expectedError) { try DanaBolusSet24CIRCFArray(options: optionsInvalidIc).generate() }
        #expect(throws: expectedError) { try DanaBolusSet24CIRCFArray(options: optionsInvalidIsf).generate() }
    }

    @Test func generateBolusSetExtended() throws {
        let options = PacketBolusSetExtended(extendedAmount: 5, extendedDurationInHalfHours: 4)
        let packet = DanaBolusSetExtended(options: options)

        #expect(packet.opCode == 71)
        #expect(try packet.generate() == Data([5, 0, 4]))
    }

    @Test func generateBolusSetOption() throws {
        let options = PacketBolusSetOption(
            extendedBolusOptionOnOff: 0,
            bolusCalculationOption: 1,
            missedBolusConfig: 1,
            missedBolus01StartHour: 0,
            missedBolus01StartMin: 0,
            missedBolus01EndHour: 0,
            missedBolus01EndMin: 0,
            missedBolus02StartHour: 0,
            missedBolus02StartMin: 0,
            missedBolus02EndHour: 0,
            missedBolus02EndMin: 0,
            missedBolus03StartHour: 0,
            missedBolus03StartMin: 0,
            missedBolus03EndHour: 0,
            missedBolus03EndMin: 0,
            missedBolus04StartHour: 0,
            missedBolus04StartMin: 0,
            missedBolus04EndHour: 0,
            missedBolus04EndMin: 0
        )
        let packet = DanaBolusSetOption(options: options)

        #expect(packet.opCode == 81)
        #expect(try packet.generate() == Data([0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]))
    }

    @Test func generateBolusStart_Speed12() throws {
        let options = PacketBolusStart(amount: 5, speed: .speed12)
        let packet = DanaBolusStart(options: options)

        #expect(packet.opCode == 74)
        #expect(try packet.generate() == Data([244, 1, 0]))
    }

    @Test func generateBolusStart_Speed30() throws {
        let options = PacketBolusStart(amount: 5, speed: .speed30)
        let packet = DanaBolusStart(options: options)

        #expect(packet.opCode == 74)
        #expect(try packet.generate() == Data([244, 1, 1]))
    }

    @Test func generateBolusStart_Speed60() throws {
        let options = PacketBolusStart(amount: 5, speed: .speed60)
        let packet = DanaBolusStart(options: options)

        #expect(packet.opCode == 74)
        #expect(try packet.generate() == Data([244, 1, 2]))
    }

    @Test func generateBolusStop() throws {
        let packet = DanaBolusStop()

        #expect(packet.opCode == 68)
        #expect(try packet.generate() == Data())
    }

    @Test func generateGeneralAvgBolus() throws {
        let packet = DanaGeneralAvgBolus()

        #expect(packet.opCode == 16)
        #expect(try packet.generate() == Data())
    }

    @Test func generateGeneralClearUserTimeChangeFlag() throws {
        let packet = DanaGeneralClearUserTimeChangeFlag()

        #expect(packet.opCode == 35)
        #expect(try packet.generate() == Data())
    }

    @Test func generateGeneralGetDecRatio() throws {
        let packet = DanaGeneralGetPumpDecRatio()

        #expect(packet.opCode == 128)
        #expect(try packet.generate() == Data())
    }

    @Test func generateGeneralGetInitialScreenInformation() throws {
        let packet = DanaGeneralGetInitialScreenInformation()

        #expect(packet.opCode == 2)
        #expect(try packet.generate() == Data())
    }

    @Test func generateGeneralGetPumpCheck() throws {
        let packet = DanaGeneralGetPumpCheck()

        #expect(packet.opCode == 33)
        #expect(try packet.generate() == Data())
    }

    @Test func generateGeneralGetPumpTime() throws {
        let packet = DanaGeneralGetPumpTime()

        #expect(packet.opCode == 112)
        #expect(try packet.generate() == Data())
    }

    @Test func generateGeneralGetPumpTimeWithUtc() throws {
        let packet = DanaGeneralGetPumpTimeUtcWithTimezone()

        #expect(packet.opCode == 120)
        #expect(try packet.generate() == Data())
    }

    @Test func generateGeneralGetShippingInformation() throws {
        let packet = DanaGeneralGetShippingInformation()

        #expect(packet.opCode == 32)
        #expect(try packet.generate() == Data())
    }

    @Test func generateGeneralGetShippingVersion() throws {
        let packet = DanaGeneralGetShippingVersion()

        #expect(packet.opCode == 129)
        #expect(try packet.generate() == Data())
    }

    @Test func generateGeneralGetUserOption() throws {
        let packet = DanaGeneralGetUserOption()

        #expect(packet.opCode == 114)
        #expect(try packet.generate() == Data())
    }

    @Test func generateGeneralGetUserTimeChangeFlag() throws {
        let packet = DanaGeneralGetUserTimeChangeFlag()

        #expect(packet.opCode == 34)
        #expect(try packet.generate() == Data())
    }

    @Test func generateGeneralKeepConnection() throws {
        let packet = DanaGeneralKeepConnection()

        #expect(packet.opCode == 255)
        #expect(try packet.generate() == Data())
    }

    @Test func generateGeneralSaveHistory() throws {
        let options = PacketGeneralSaveHistory(
            historyType: 1,
            historyDate: Date(timeIntervalSince1970: 1_701_774_000),
            historyCode: 1,
            historyValue: 1
        )
        let packet = DanaGeneralSaveHistory(options: options)

        #expect(packet.opCode == 224)
        #expect(try packet.generate() == Data([1, 23, 12, 5, 11, 0, 0, 1, 1, 0]))
    }

    @Test func generateGeneralSetHistoryUploadMode_TurnOff() throws {
        let options = PacketGeneralSetHistoryUploadMode(mode: 0)
        let packet = DanaGeneralSetHistoryUploadMode(options: options)

        #expect(packet.opCode == 37)
        #expect(try packet.generate() == Data([0]))
    }

    @Test func generateGeneralSetHistoryUploadMode_TurnOn() throws {
        let options = PacketGeneralSetHistoryUploadMode(mode: 1)
        let packet = DanaGeneralSetHistoryUploadMode(options: options)

        #expect(packet.opCode == 37)
        #expect(try packet.generate() == Data([1]))
    }

    @Test func generateGeneralSetPumpTime() throws {
        // 2023-12-05T11:00:00.000 UTC
        let options = PacketGeneralSetPumpTime(time: Date(timeIntervalSince1970: 1_701_774_000))
        let packet = DanaGeneralSetPumpTime(options: options)

        #expect(packet.opCode == 113)
        #expect(try packet.generate() == Data([23, 12, 5, 12, 0, 0]))
    }

    @Test func generateGeneralSetPumpTimeWithTimezone() throws {
        let options = PacketGeneralSetPumpTimeUtcWithTimezone(time: Date(timeIntervalSince1970: 1_701_774_000), zoneOffset: 1)
        let packet = DanaGeneralSetPumpTimeUtcWithTimezone(options: options)

        #expect(packet.opCode == 121)
        #expect(try packet.generate() == Data([23, 12, 5, 11, 0, 0, 1]))
    }

    @Test func generateGeneralSetUserOption() throws {
        let options = PacketGeneralSetUserOption(
            isTimeDisplay24H: true,
            isButtonScrollOnOff: true,
            beepAndAlarm: 0,
            lcdOnTimeInSec: 10,
            backlightOnTimeInSec: 10,
            selectedLanguage: 1,
            units: 1,
            shutdownHour: 0,
            lowReservoirRate: 20,
            cannulaVolume: 250,
            refillAmount: 7,
            targetBg: 55
        )
        let packet = DanaGeneralSetUserOption(options: options)

        #expect(packet.opCode == 115)
        #expect(try packet.generate() == Data([0, 1, 0, 10, 10, 1, 1, 0, 20, 250, 0, 7, 0, 55, 0]))
    }

    @Test func generateHistoryAlarmFromDate() throws {
        let options = PacketHistoryBase(from: Date(timeIntervalSince1970: 1_701_774_000), usingUtc: true)
        let packet = DanaHistoryAlarm(options: options)

        #expect(packet.opCode == 25)
        #expect(try packet.generate() == Data([23, 12, 5, 11, 0, 0]))
    }

    @Test func generateHistoryAlarm() throws {
        let options = PacketHistoryBase(from: nil, usingUtc: true)
        let packet = DanaHistoryAlarm(options: options)

        #expect(packet.opCode == 25)
        #expect(try packet.generate() == Data([0, 1, 1, 0, 0, 0]))
    }

    @Test func generateHistoryAll() throws {
        let options = PacketHistoryBase(from: nil, usingUtc: true)
        let packet = DanaHistoryAll(options: options)

        #expect(packet.opCode == 31)
        #expect(try packet.generate() == Data([0, 1, 1, 0, 0, 0]))
    }

    @Test func generateHistoryBasal() throws {
        let options = PacketHistoryBase(from: nil, usingUtc: true)
        let packet = DanaHistoryBasal(options: options)

        #expect(packet.opCode == 26)
        #expect(try packet.generate() == Data([0, 1, 1, 0, 0, 0]))
    }

    @Test func generateHistoryBloodGlucose() throws {
        let options = PacketHistoryBase(from: nil, usingUtc: true)
        let packet = DanaHistoryBloodGlucose(options: options)

        #expect(packet.opCode == 21)
        #expect(try packet.generate() == Data([0, 1, 1, 0, 0, 0]))
    }

    @Test func generateHistoryBolus() throws {
        let options = PacketHistoryBase(from: nil, usingUtc: true)
        let packet = DanaHistoryBolus(options: options)

        #expect(packet.opCode == 17)
        #expect(try packet.generate() == Data([0, 1, 1, 0, 0, 0]))
    }

    @Test func generateHistoryCarbohydrates() throws {
        let options = PacketHistoryBase(from: nil, usingUtc: true)
        let packet = DanaHistoryCarbohydrates(options: options)

        #expect(packet.opCode == 22)
        #expect(try packet.generate() == Data([0, 1, 1, 0, 0, 0]))
    }

    @Test func generateHistoryDaily() throws {
        let options = PacketHistoryBase(from: nil, usingUtc: true)
        let packet = DanaHistoryDaily(options: options)

        #expect(packet.opCode == 18)
        #expect(try packet.generate() == Data([0, 1, 1, 0, 0, 0]))
    }

    @Test func generateHistoryPrime() throws {
        let options = PacketHistoryBase(from: nil, usingUtc: true)
        let packet = DanaHistoryPrime(options: options)

        #expect(packet.opCode == 19)
        #expect(try packet.generate() == Data([0, 1, 1, 0, 0, 0]))
    }

    @Test func generateHistoryRefill() throws {
        let options = PacketHistoryBase(from: nil, usingUtc: true)
        let packet = DanaHistoryRefill(options: options)

        #expect(packet.opCode == 20)
        #expect(try packet.generate() == Data([0, 1, 1, 0, 0, 0]))
    }

    @Test func generateHistorySuspend() throws {
        let options = PacketHistoryBase(from: nil, usingUtc: true)
        let packet = DanaHistorySuspend(options: options)

        #expect(packet.opCode == 24)
        #expect(try packet.generate() == Data([0, 1, 1, 0, 0, 0]))
    }

    @Test func generateHistoryTemporary() throws {
        let options = PacketHistoryBase(from: nil, usingUtc: true)
        let packet = DanaHistoryTemporary(options: options)

        #expect(packet.opCode == 23)
        #expect(try packet.generate() == Data([0, 1, 1, 0, 0, 0]))
    }

    @Test func generateLoopHistoryEventsFromDateInUTC() throws {
        let options = PacketHistoryBase(from: Date(timeIntervalSince1970: 1_701_774_000), usingUtc: true)
        let packet = DanaLoopHistoryEvents(options: options)

        #expect(packet.opCode == 194)
        #expect(try packet.generate() == Data([23, 12, 5, 11, 0, 0]))
    }

    @Test func generateLoopHistoryEvents() throws {
        let options = PacketHistoryBase(from: nil, usingUtc: true)
        let packet = DanaLoopHistoryEvents(options: options)

        #expect(packet.opCode == 194)
        #expect(try packet.generate() == Data([0, 1, 1, 0, 0, 0]))
    }

    @Test func generateLoopSetHistoryEvent() throws {
        let options = PacketLoopSetEventHistory(
            packetType: LoopHistoryEvents.carbs,
            time: Date(timeIntervalSince1970: 1_701_774_000),
            param1: 0,
            param2: 0
        )
        let packet = DanaLoopSetEventHistory(options: options)

        #expect(packet.opCode == 195)
        #expect(try packet.generate() == Data([14, 23, 12, 5, 11, 0, 0, 0, 0, 0, 0]))
    }

    @Test func generateLoopSetTemporaryBasal() throws {
        let options = PacketLoopSetTemporaryBasal(percent: 200, duration: .min30)
        let packet = DanaLoopSetTemporaryBasal(options: options)

        #expect(packet.opCode == 193)
        #expect(try packet.generate() == Data([200, 0, 160]))
    }

    @Test func generateLoopSetTemporaryBasalPercentGreaterThan500() throws {
        let options = PacketLoopSetTemporaryBasal(percent: 750, duration: .min15)
        let packet = DanaLoopSetTemporaryBasal(options: options)

        #expect(packet.opCode == 193)
        #expect(try packet.generate() == Data([244, 1, 150]))
    }
}
