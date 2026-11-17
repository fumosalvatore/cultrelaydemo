//
//  thewinneris.swift
//  drawingappoffline
//
//  Created by Salvatore Fumo on 21/10/2026.
//

import SwiftUI
 
struct winneris: View {
    @Binding var path: [GameScreen]
    @Environment(GameModel.self) private var game
 
    var body: some View {
        ZStack {
            Image("sfondocarta")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
 
            VStack(spacing: 10) {
 
                Image("cup_illustration")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 200)
                    .padding(.top, 200)
 
                Image("thewinneris")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 250)
                    .padding(.top, -100)
 
                VStack(spacing: 10) {
                    Text(game.winnerName)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.orange)
                        .padding(.top, -90)
 
                    Text("You never run out ideas!")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, -50)
                }
                .multilineTextAlignment(.center)
                .padding(.vertical, 30)
 
                Spacer()
 
                Button(action: {
                    path.append(.culture)
                }) {
                    Text("Discover")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 12)
                        .background(Color.orange)
                        .cornerRadius(30)
                }
                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
 
                Button(action: {
                    game.resetRound()
                    path = [.players]
                }) {
                    Text("Play again")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.horizontal, 35)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .cornerRadius(30)
                }
                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                .padding(.top, 12)
 
                Text("Back to home")
                    .font(.footnote)
                    .foregroundColor(.blue)
                    .underline()
                    .onTapGesture {
                        game.resetAll()
                        path.removeAll()
                    }
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarBackButtonHidden(true)
    }
}
 
#Preview {
    winneris(path: .constant([]))
        .environment({
            let g = GameModel()
            g.winnerName = "TOTORE"
            return g
        }())
}
