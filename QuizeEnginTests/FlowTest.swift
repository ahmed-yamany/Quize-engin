//
//  FlowTest.swift
//  QuizeEnginTests
//
//  Created by Ahmed Yamany on 21/08/2024.
//

import XCTest
@testable import QuizeEngin

final class FlowTest: XCTestCase {
    
    var router: RouterSpy!
    
    override func setUp() {
        router = RouterSpy()
    }
    
    override func tearDown() {
        router = nil
    }
    
    func makeSut(questions: [String]) -> Flow {
        Flow(questions: questions, router: router)
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_Flow_whenNoQuestionsProvided_shouldNotRouteToQuestion() {
        let sut = makeSut(questions: [])
        sut.start()
        XCTAssertTrue(sut.questions.isEmpty)
    }
    
    func test_Flow_WhenOneQuestionProvided_shouldRouteToOneQuestion() {
        let sut = makeSut(questions: ["Q1"])
        sut.start()
        XCTAssertEqual(router.questions.count, 1)
    }
    
    func test_Flow_WhenOneQuestionProvided_ShouldRouteToTheCorrectQuestion() {
        let sut = makeSut(questions: ["Q1"])
        sut.start()
        XCTAssertEqual(router.questions.last, "Q1")
    }
    
    func test_Flow_WhenOneQuestionProvided_ShouldRouteToTheCorrectQuestion_1() {
        let sut = makeSut(questions: ["Q2"])
        sut.start()
        XCTAssertEqual(router.questions.last, "Q2")
    }
    
    func test_Flow_WhenTwoQuestionProvided_ShouldRouteToFirstQuestionTwice() {
        let sut = makeSut(questions: ["Q1", "Q2"])
        sut.start()
        sut.start()
        XCTAssertEqual(router.questions, ["Q1", "Q1"])
    }
    
    func test_StartAndAnswer_WhenTwoQuestionProvided_ShouldRouteToSecondQuestion() {
        let sut = makeSut(questions: ["Q1", "Q2"])
        sut.start()
        router.answerCallBack("A1")
        XCTAssertEqual(router.questions, ["Q1", "Q2"], "When answer provided to the first question router should router to the next question")
    }
   
    func test_StartAndAnswer_WhenThreeQuestionProvided_ShouldRouteToSecondAndThirdQuestion() {
        let sut = makeSut(questions: ["Q1", "Q2", "Q3"])
        sut.start()
        router.answerCallBack("A1")
        router.answerCallBack("A2")
        XCTAssertEqual(router.questions, ["Q1", "Q2", "Q3"], "When answer provided to the first question router should router to the next question")
    }
    
    func test_Flow_whenNoQuestionsProvided_shouldRoutesToResult() {
        let sut = makeSut(questions: [])
        sut.start()
        XCTAssertEqual(router.routedResult, [:])
    }
    
    func test_Flow_whenOneQuestionProvided_shouldRoutesToResult() {
        let sut = makeSut(questions: ["Q1"])
        sut.start()
        router.answerCallBack("A1")
        XCTAssertEqual(router.routedResult, ["Q1": "A1"])
    }
    
    func test_start_whenOneQuestionProvided_shouldNotRoutesToResult() {
        let sut = makeSut(questions: ["Q1"])
        sut.start()
        XCTAssertNil(router.routedResult)
    }
    
    func test_Flow_whenTwoQuestionsProvided_shouldRoutesToResult() {
        let sut = makeSut(questions: ["Q1", "Q2"])
        sut.start()
        router.answerCallBack("A1")
        router.answerCallBack("A2")
        XCTAssertEqual(router.routedResult, ["Q1": "A1", "Q2": "A2"])
    }
    
    func test_Flow_whenStartAndAnswerFirstQuestion_shouldNotRoutesToResult() {
        let sut = makeSut(questions: ["Q1", "Q2"])
        sut.start()
        router.answerCallBack("A1")
        XCTAssertNil(router.routedResult)
    }

    class RouterSpy: Router {
        var questions: [String] = []
        var routedResult: [String: String]? = nil
        var answerCallBack: (String) -> Void = {_ in }
        
        func route(to question: String, answerCallBack: @escaping (String) -> Void) {
            questions.append(question)
            self.answerCallBack = answerCallBack
        }
        
        func routeToResult(_ result: [String : String]) {
            routedResult = result
        }
    }

}
