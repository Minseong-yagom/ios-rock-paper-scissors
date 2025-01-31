import Foundation

struct HandGame {
    private var hasUserWin = false

    private enum kind {
        case rockPaperScissors, mukjipa
    }
    
    private enum Hand: CaseIterable {
        case rock, paper, scissors
        
        var description: String {
            switch self {
            case .scissors:
                return "가위"
            case .rock:
                return "바위"
            case .paper:
                return "보"
            }
        }
    }
    
    private enum Player {
        case userTurn, computerTurn
        
        var description: String {
            switch self {
            case .userTurn:
                return "사용자"
            case .computerTurn:
                return "컴퓨터"
            }
        }
    }
    
    private enum Guide {
        case rockPaperScissorsMessage, mukjipaMessage, numberOne, numberTwo, numberThree, numberZero
        
        var description: String {
            switch self {
            case .rockPaperScissorsMessage:
                return "가위(1), 바위(2), 보(3)! <종료 : 0> : "
            case .mukjipaMessage:
                return "묵(1), 찌(2), 빠(3)! <종료 : 0> : "
            case .numberOne:
                return "1"
            case .numberTwo:
                return "2"
            case .numberThree:
                return "3"
            case .numberZero:
                return "0"
            }
        }
    }
    
    private enum Result {
        case win, lose, draw, endGame, computerWin, userWin
        
        var description: String {
            switch self {
            case .win:
                return "이겼습니다!"
            case .lose:
                return "졌습니다!"
            case .draw:
                return "비겼습니다!"
            case .endGame:
                return "게임 종료"
            case .computerWin:
                return "컴퓨터의 승리!"
            case .userWin:
                return "사용자의 승리!"
            }
        }
    }
    
    private enum Error {
        case wrongInput
        
        var description: String {
            switch self {
            case .wrongInput:
                return "잘못된 입력입니다. 다시 시도해주세요."
            }
        }
    }
    
    mutating func play() {
        printInputGuidanceMessage(gameKind: .rockPaperScissors)
        
        let userHand = receiveUserInputHand()
        if isValueZero(to: userHand) {
            print(HandGame.Result.endGame.description)
            return
        }
        if isWrongInputted(userHand) {
            print(Error.wrongInput.description)
            play()
            return
        }
        let verifiedUserHand = convertedUserHand(userHand, gameKind: .rockPaperScissors)
        let computerHand = generatedRandomHand()
        let userGameResult = judgeUserGameResult(userHand: verifiedUserHand, computerHand: computerHand)
        printGameResult(by: userGameResult)
        if userGameResult != .draw { playMukjipa(didUserWin: self.hasUserWin) }
    }
    
    private func printInputGuidanceMessage(gameKind: kind) {
        if gameKind == .rockPaperScissors {
            print(HandGame.Guide.rockPaperScissorsMessage.description, terminator: "")
        } else if gameKind == .mukjipa {
            print(HandGame.Guide.mukjipaMessage.description, terminator: "")
        }
    }
    
    private func receiveUserInputHand() -> String? {
        let inputtedHand = readLine()?.replacingOccurrences(of: " ", with: "")
        return inputtedHand
    }
    
    private func convertedUserHand(_ inputtedValue: String?, gameKind: kind) -> HandGame.Hand {
        if inputtedValue == HandGame.Guide.numberOne.description {
            if gameKind == .mukjipa { return .rock }
            return .scissors
        } else if inputtedValue == HandGame.Guide.numberTwo.description {
            if gameKind == .mukjipa { return .scissors }
            return .rock
        } else {
            return .paper
        }
    }
    
    private func isValueZero(to userInputted: String?) -> Bool {
        if userInputted == Guide.numberZero.description {
            return true
        }
        return false
    }

    private func generatedRandomHand() -> HandGame.Hand {
        if let hand = HandGame.Hand.allCases.randomElement() {
            return hand
        }
        return generatedRandomHand()
    }

    private mutating func judgeUserGameResult(userHand: HandGame.Hand, computerHand: HandGame.Hand) -> HandGame.Result {
        if userHand == computerHand {
            return .draw
        } else if (userHand, computerHand) == (.scissors, .paper) ||
                    (userHand, computerHand) == (.rock, .scissors) ||
                    (userHand, computerHand) == (.paper, .rock) {
            self.hasUserWin = true
            return .win
        } else {
            self.hasUserWin = false
            return .lose
        }
    }
    
    private mutating func playMukjipa(didUserWin: Bool) {
        printRockPaperScissorsWinnerTurn(by: didUserWin)
        printInputGuidanceMessage(gameKind: .mukjipa)

        let userHand = receiveUserInputHand()
        if isValueZero(to: userHand) {
            print(HandGame.Result.endGame.description)
            return
        }
        if isWrongInputted(userHand) {
            print(Error.wrongInput.description)
            switchTurn(by: didUserWin)
            playMukjipa(didUserWin: self.hasUserWin)
            return
        }
        let verifiedUserHand = convertedUserHand(userHand, gameKind: .mukjipa)
        let computerHand = generatedRandomHand()
        let mukjipaGameResult = judgeUserGameResult(userHand: verifiedUserHand, computerHand: computerHand)
        judgeMukjipaWinner(by: mukjipaGameResult)
    }
    
    private func printRockPaperScissorsWinnerTurn(by gameResult: Bool) {
        if gameResult == true {
            print("[\(Player.userTurn.description) 턴] ", terminator: "")
        } else if gameResult == false {
            print("[\(Player.computerTurn.description) 턴] ", terminator: "")
        }
    }
    
    private func isWrongInputted(_ value: String?) -> Bool {
        let normalValues = ["1", "2", "3", "0"]
        for normalValue in normalValues {
            if normalValue == value { return false }
        }
        return true
    }
    
    private mutating func printGameResult(by user: HandGame.Result) {
        if user == .draw {
            print(HandGame.Result.draw.description)
            play()
        } else if user == .win {
            print(HandGame.Result.win.description)
        } else {
            print(HandGame.Result.lose.description)
        }
    }
    
    private mutating func switchTurn(by gameResult: Bool) {
        if gameResult == true {
            self.hasUserWin = false
        } else {
            self.hasUserWin = true
        }
    }
    
    private func printMukjipaWinnerTurn(by gameResult: Bool) {
        if gameResult == true {
            print("\(Player.userTurn.description) 턴입니다")
        } else if gameResult == false {
            print("\(Player.computerTurn.description) 턴입니다")
        }
    }
    
    private func printMukjipaWinner(didUserWin: Bool) {
        if didUserWin {
            print(Result.userWin.description)
        } else {
            print(Result.computerWin.description)
        }
    }
    
    private mutating func judgeMukjipaWinner(by mukjipaGameResult: HandGame.Result) {
        if mukjipaGameResult == .draw {
            printMukjipaWinner(didUserWin: self.hasUserWin)
            print(Result.endGame.description)
            return
        } else {
            printMukjipaWinnerTurn(by: self.hasUserWin)
            playMukjipa(didUserWin: self.hasUserWin)
            return
        }
    }
}
