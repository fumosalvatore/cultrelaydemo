//
//  Untitled.swift
//  drawingappoffline
//
//  Created by Salvatore Fumo on 21/10/2026.
//
//
//  passit.swift
//  drawingappoffline
//
import SwiftUI

struct passit: View {
    @Binding var path: [GameScreen]
    @Environment(GameModel.self) private var game

    var body: some View {
        ZStack {
            // Sfondo a quadretti
            Image("sfondocarta")
                .resizable()
                .ignoresSafeArea()

            VStack {
                Spacer()

                Image("passitillu")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 230, height: 220)
                    .offset(x: 20, y: 0)

                Text("Pass it!")
                    .font(.system(size: 35, weight: .heavy))
                    .foregroundColor(Color(red: 0.45, green: 0.45, blue: 0.25))
                    .padding(.top, 15)

                Text("It's \(game.currentPlayer)'s turn! Pass the phone.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)

                Spacer()

                Button(action: ready) {
                    Text("Ready!")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color.orange)
                        .cornerRadius(30)
                        .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 3)
                }
                .padding(.horizontal, 120)
                .padding(.bottom, 35)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func ready() {
        path.append(.drawing)
    }
}

#Preview {
    passit(path: .constant([]))
        .environment({
            let g = GameModel()
            g.players = ["Gamora", "Totore"]
            return g
        }())
}
