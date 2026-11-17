
//  Container.swift
//  drawingappoffline
//
import SwiftUI

struct CultureView: View {
    @Binding var path: [GameScreen]
    @Environment(GameModel.self) private var game

    // Struttura dati per le card
    struct CultureCard: Identifiable {
        let id = UUID()
        let title: String
        let description: String
    }

    // Dati di esempio
    let items: [CultureCard] = [
        CultureCard(title: "Venetian Carnival", description: "World-famous Italian festival known for elaborate masks, historic costumes, and enchanting canal parades."),
        CultureCard(title: "Polenta", description: "Traditional Northern Italian dish made from boiled cornmeal, often served warm with ragù, cheese, or meat."),
        CultureCard(title: "Trulli", description: "Iconic whitewashed stone huts with conical roofs, unique to the region of Apulia in Southern Italy."),
        CultureCard(title: "Murano Glass", description: "Renowned handcrafted glassware produced for centuries by master artisans on the Venetian island of Murano.")
    ]

    var body: some View {
        ZStack {
            // Sfondo con texture carta
            Image("sfondocarta")
                .resizable()
                .ignoresSafeArea()

            // Contenuto scorrevole
            ScrollView(showsIndicators: true) {
                VStack(spacing: 20) {

                    // Titolo principale
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Discover")
                            .font(.system(size: 38, weight: .heavy, design: .monospaced))
                        Text("Italian Culture")
                            .font(.system(size: 38, weight: .heavy, design: .monospaced))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 20)

                    Divider()
                        .padding(.horizontal, 24)

                    // Lista delle card
                    ForEach(items) { item in
                        VStack(spacing: 8) {
                            Text(item.title)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.orange)

                            Text(item.description)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                        .padding(.horizontal, 24)
                    }

                    Divider()
                        .padding(.horizontal, 24)
                        .padding(.top, 8)

                    // Play Again
                    Button(action: {
                        game.resetRound()
                        path = [.players]
                    }) {
                        Text("Play Again")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .cornerRadius(25)
                    }
                    .padding(.horizontal, 120)

                    // Back to home
                    Button(action: {
                        game.resetAll()
                        path.removeAll()
                    }) {
                        Text("Back to home")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(25)
                    }
                    .padding(.horizontal, 120)
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CultureView(path: .constant([]))
        .environment(GameModel())
}
