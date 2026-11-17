//
//  Gamemodel.swift
//  drawingappoffline
//
//  Created by Salvatore Fumo on 21/10/2026.
//

//
//  GameModel.swift
//  drawingappoffline
//
import SwiftUI
import Observation

@Observable
final class GameModel {
    var players: [String] = []
    var currentIndex: Int = 0
    var winnerName: String = ""

    var currentPlayer: String {
        guard players.indices.contains(currentIndex) else { return "" }
        return players[currentIndex]
    }

    var isLastPlayer: Bool {
        currentIndex >= players.count - 1
    }

    // Riparte dal primo giocatore (i nomi restano)
    func resetRound() {
        currentIndex = 0
        winnerName = ""
    }

    func nextPlayer() {
        if currentIndex < players.count - 1 {
            currentIndex += 1
        }
    }

    // Per ora il vincitore e' scelto a caso
    func pickWinner() {
        winnerName = players.randomElement() ?? ""
    }

    // Azzera tutto (Back to home)
    func resetAll() {
        players.removeAll()
        resetRound()
    }
}
