import SwiftUI
import PhotosUI
import Combine
 
@Observable
final class DrawingModel {
    var strokes: [Stroke] = []
    var currentStroke = Stroke()
 
    // MARK: Undo / Redo
    private(set) var undoStack: [[Stroke]] = []
    private(set) var redoStack: [[Stroke]] = []
 
    func pushSnapshot() {
        undoStack.append(strokes)
        redoStack.removeAll()
    }
 
    func undo() {
        guard let last = undoStack.popLast() else { return }
        redoStack.append(strokes)
        strokes = last
    }
 
    func redo() {
        guard let next = redoStack.popLast() else { return }
        undoStack.append(strokes)
        strokes = next
    }
}
 
struct Stroke: Identifiable {
    let id = UUID()
    var points: [CGPoint] = []
    var color: Color = .black
    var lineWidth: CGFloat = 2.0
}
 
struct FreehandDrawingView: View {
    @Binding var path: [GameScreen]
 
    // MARK: Environment
    @Environment(\.displayScale) private var displayScale
    @Environment(GameModel.self) private var game
 
    // MARK: State
    @State private var model = DrawingModel()
    @State private var selectedColor: Color = .black
    @State private var lineWidth: CGFloat = 3.0
 
    // Timer
    @State private var timeRemaining = 180
    @State private var isTimeUp = false
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
 
    var body: some View {
        VStack(spacing: 12) {
            // ---------- TOP BAR ----------
            HStack {
                Text(timeString)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(isTimeUp ? .red : .primary)
                Spacer()
                    Text("Draw somenthing about italy")
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
 
                Spacer()
 
                Button(action: finishTurn) {
                    Text("Done")
                        .fontWeight(.semibold)
                }
                .disabled(isTimeUp)
            }
            .padding(.horizontal)
 
            // ---------- TOOLBAR ----------
            HStack(spacing: 20) {
                ColorPicker("", selection: $selectedColor)
                    .labelsHidden()
                    .frame(width: 44, height: 44)
                    .overlay(RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.secondary, lineWidth: 1))
 
                Slider(value: $lineWidth, in: 1...10) {
                    Text("Spessore")
                }
                .frame(width: 150)
 
                Button(action: { model.strokes.removeAll() }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .accessibilityLabel("Pulisci tutto")
                .disabled(isTimeUp)
 
                // Undo / Redo
                HStack {
                    Button(action: { model.undo() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                    }
                    .disabled(model.undoStack.isEmpty || isTimeUp)
 
                    Button(action: { model.redo() }) {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                    }
                    .disabled(model.redoStack.isEmpty || isTimeUp)
                }
            }
            .padding(.horizontal)
 
            // ---------- CANVAS ----------
            GeometryReader { _ in
                ZStack {
                    Color.white
                    Canvas { context, size in
                        for stroke in model.strokes {
                            draw(stroke, in: context)
                        }
                        if !model.currentStroke.points.isEmpty {
                            draw(model.currentStroke, in: context)
                        }
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                guard !isTimeUp else { return }
                                if model.currentStroke.points.isEmpty {
                                    model.currentStroke = Stroke(
                                        color: selectedColor,
                                        lineWidth: lineWidth
                                    )
                                }
                                model.currentStroke.points.append(value.location)
                            }
                            .onEnded { _ in
                                guard !isTimeUp else { return }
                                model.pushSnapshot()
                                model.strokes.append(model.currentStroke)
                                model.currentStroke = Stroke()
                            }
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle("\(game.currentPlayer) is drawing")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onReceive(timer) { _ in
            guard !isTimeUp else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                finishTurn()
            }
        }
    }
 
    // MARK: - Helper
    private var timeString: String {
        let mins = timeRemaining / 60
        let secs = timeRemaining % 60
        return String(format: "%02d:%02d", mins, secs)
    }
 
    // Chiude il turno: salva il disegno e passa al giocatore successivo (o al vincitore)
    private func finishTurn() {
        guard !isTimeUp else { return }   // evita di navigare due volte
        isTimeUp = true                   // ferma anche il timer
        saveCanvasToPhotos()
 
        if game.isLastPlayer {
            game.pickWinner()
            path.append(.winner)
        } else {
            game.nextPlayer()
            path.append(.passIt)
        }
    }
 
    private func draw(_ stroke: Stroke, in context: GraphicsContext) {
        guard let first = stroke.points.first else { return }
        var path = Path()
        path.move(to: first)
        for pt in stroke.points.dropFirst() {
            path.addLine(to: pt)
        }
        context.stroke(path, with: .color(stroke.color), lineWidth: stroke.lineWidth)
    }
 
    // MARK: - Salvataggio
    @MainActor
    private func saveCanvasToPhotos() {
        let exportContent = canvasContent.frame(width: 300, height: 400)
 
        let renderer = ImageRenderer(content: exportContent)
        renderer.scale = displayScale
 
        guard let uiImage = renderer.uiImage, let imageData = uiImage.pngData() else {
            return
        }
 
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            guard status == .authorized || status == .limited else { return }
 
            PHPhotoLibrary.shared().performChanges {
                PHAssetCreationRequest.forAsset().addResource(
                    with: .photo,
                    data: imageData,
                    options: nil
                )
            } completionHandler: { success, error in
                if !success {
                    print("Errore salvataggio: \(error?.localizedDescription ?? "sconosciuto")")
                }
            }
        }
    }
 
    private var canvasContent: some View {
        Canvas { context, size in
            for stroke in model.strokes {
                draw(stroke, in: context)
            }
        }
        .background(.white)
    }
}
 
#Preview {
    NavigationStack {
        FreehandDrawingView(path: .constant([]))
    }
    .environment(GameModel())
}
