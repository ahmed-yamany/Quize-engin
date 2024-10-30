//
//  Flow.swift
//  QuizeEngin
//
//  Created by Ahmed Yamany on 21/08/2024.
//

import Foundation

protocol Router {
    func route(to question: String, answerCallBack: @escaping (String) -> Void)
    func routeToResult(_ result: [String: String])
}

class Flow {
    let router: Router
    let questions: [String]
    var result: [String: String] = [:]

    init(questions: [String], router: Router) {
        self.router = router
        self.questions = questions
    }

    func start() {
        if let firstQuestion = questions.first {
            router.route(to: firstQuestion, answerCallBack: nextCallBack(from: firstQuestion))
        } else {
            router.routeToResult(result)
        }
    }

    private func nextCallBack(from question: String) -> (String) -> Void {
        { [weak self] answer in
            guard let self else {
                return
            }
            routeNext(question, answer: answer)
        }
    }

    private func routeNext(_ question: String, answer: String) {
        if let currentQuestionIndex = questions.firstIndex(of: question) {
            result[question] = answer

            let nextQuestionIndex = currentQuestionIndex + 1

            if nextQuestionIndex < questions.count {
                let nextQuestion = questions[nextQuestionIndex]
                router.route(to: nextQuestion, answerCallBack: nextCallBack(from: nextQuestion))
            } else {
                router.routeToResult(result)
            }
        }
    }
}
