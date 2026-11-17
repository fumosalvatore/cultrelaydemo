//
//  drawingappofflineApp.swift
//  drawingappoffline
//
//  Created by Salvatore Fumo on 19/10/2026.
//
//

//
import SwiftUI

// Tutte le schermate del gioco
enum GameScreen: Hashable {
    case hello
    case players
    case drawing
    case passIt
    case winner
    case culture
}

@main
struct drawingappofflineApp: App {
    @State private var path: [GameScreen] = []
    @State private var game = GameModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                Homepage(path: $path)
                    .navigationDestination(for: GameScreen.self) { screen in
                        switch screen {
                        case .hello:
                            Homepage(path: $path)
                        case .players:
                            PlayersView(path: $path)
                        case .drawing:
                            FreehandDrawingView(path: $path)
                        case .passIt:
                            passit(path: $path)
                        case .winner:
                            winneris(path: $path)
                        case .culture:
                            CultureView(path: $path)
                        }
                    }
            }
            .environment(game)
        }
    }
}
