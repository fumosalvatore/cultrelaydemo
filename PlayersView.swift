import SwiftUI

// 1. SCHERMATA PRINCIPALE
struct PlayersView: View {
    @Binding var path: [GameScreen]
    @Environment(GameModel.self) private var game
    @State private var isPresentingAdd: Bool = false
    @State private var newPlayerName: String = ""

    var body: some View {
        ZStack {
            Image("sfondocarta")
                .resizable()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack(alignment: .center) {
                    Button(action: {
                        if !path.isEmpty { path.removeLast() }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                    .accessibilityLabel("come back")

                    Spacer()

                    Image("players")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)

                    Spacer()

                    Button(action: { isPresentingAdd = true }) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 32, weight: .regular))
                            .foregroundColor(.primary)
                    }
                    .accessibilityLabel("Aggiungi giocatore")
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 12)

                // Contenuto principale
                if game.players.isEmpty {
                    ContentUnavailableView(
                        "No player",
                        systemImage: "person.3",
                        description: Text("Tap the + button in the top right to add a name.")
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.clear)
                } else {
                    List {
                        ForEach(Array(game.players.enumerated()), id: \.offset) { _, name in
                            Text(name)
                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                }

                // Pulsante Start Game
                Button(action: startGame) {
                    Text("Start Game")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 15, weight: .bold))
                        .padding()
                        .background(game.players.isEmpty ? Color.orange : Color.blue)
                        .cornerRadius(30)
                        .padding(.horizontal,100)
                }
                .disabled(game.players.isEmpty)
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isPresentingAdd) {
            AddPlayerSheet(newPlayerName: $newPlayerName) {
                addPlayer()
            }
            .presentationDetents([.medium])
        }
    }

    private func addPlayer() {
        let trimmed = newPlayerName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        game.players.append(trimmed)
        newPlayerName = ""
        isPresentingAdd = false
    }

    private func delete(at offsets: IndexSet) {
        game.players.remove(atOffsets: offsets)
    }

    private func startGame() {
        game.resetRound()
        path.append(.drawing)
    }
}

// 2. SCHERMATA PER AGGIUNGERE IL GIOCATORE
struct AddPlayerSheet: View {
    @Binding var newPlayerName: String
    var onConfirm: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("New player") {
                    TextField("Name", text: $newPlayerName)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled(false)
                        .submitLabel(.done)
                        .onSubmit { onConfirm() }
                }
            }
            .navigationTitle("Add")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Back") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onConfirm()
                    }
                    .disabled(newPlayerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PlayersView(path: .constant([]))
    }
    .environment(GameModel())
}
