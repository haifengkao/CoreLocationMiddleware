// https://github.com/Quick/Quick

@testable import CoreLocationMiddleware
import Foundation
import Nimble
import Quick
import SpecLeaks
import Combine
import CombineRex
import SwiftRex

class TableOfContentsSpec: QuickSpec {
    override func spec() {
        describe("leak test") {
            it("must not leak") {
                let sut = LeakTest {
                    let subject = CurrentValueSubject<LocationState, Never>.init(.unknown)
                    let replaySubject = UnfailableReplayLastSubjectType<LocationState>.init(currentValueSubject: subject)

                    _ = ReduxStoreBase<LocationAction, LocationState>(
                        subject: replaySubject,
                        reducer: .identity,
                        middleware: CoreLocationMiddleware().eraseToAnyMiddleware()
                    )
                    return subject
                }

                expect(sut).toNot(leak())
            }
        }
    }
}
