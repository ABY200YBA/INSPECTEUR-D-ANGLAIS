import SwiftUI
import AVFoundation

enum AppTab: Hashable { case home, coach, training, resources }

struct AppView: View {
    @State private var selectedTab: AppTab = .home
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack { DashboardView(selectedTab: $selectedTab) }.tabItem { Label("Accueil", systemImage: "house.fill") }.tag(AppTab.home)
            NavigationStack { CoachView() }.tabItem { Label("Coach", systemImage: "message.fill") }.tag(AppTab.coach)
            NavigationStack { TrainingView() }.tabItem { Label("Entraînement", systemImage: "checklist") }.tag(AppTab.training)
            NavigationStack { ResourcesView() }.tabItem { Label("Ressources", systemImage: "books.vertical.fill") }.tag(AppTab.resources)
        }.tint(.indigo)
    }
}

struct DashboardView: View {
    @Binding var selectedTab: AppTab
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("IEMS ANGLE").font(.caption.weight(.bold)).foregroundStyle(.indigo)
                Text("Prépa Inspecteur de Spécialité Anglais").font(.largeTitle.bold())
                Text("Un coach mobile pour l'inspection, la didactique de l'anglais, la législation scolaire et l'oral au Sénégal.").foregroundStyle(.secondary)
                Button("Interroger le Coach") { selectedTab = .coach }.buttonStyle(.borderedProminent)
                GroupBox("Parcours recommandé") {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(["Législation et missions IEMS", "Didactique de l'anglais", "Études de cas", "Dissertation", "Oral inspecteur"], id: \.self) {
                            Label($0, systemImage: "checkmark.circle.fill")
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
                GroupBox("Réflexe inspecteur") { Text("Diagnostic → référence → analyse → proposition → indicateur de suivi").font(.headline) }
            }.padding()
        }.navigationTitle("Accueil")
    }
}

struct CoachView: View {
    @StateObject private var speech = SpeechService()
    @State private var question = ""
    @State private var answer = "Bonjour. Posez une question sur l'IEMS, la didactique, l'anglais ou la législation sénégalaise."
    private let synthesizer = AVSpeechSynthesizer()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(answer).textSelection(.enabled).padding().background(.indigo.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
                TextField("Votre question", text: $question, axis: .vertical).textFieldStyle(.roundedBorder).lineLimit(2...5)
                HStack {
                    Button("Répondre") { answer = CoachEngine.answer(to: question) }.buttonStyle(.borderedProminent)
                    Button(speech.isRecording ? "Arrêter" : "Dicter", systemImage: speech.isRecording ? "stop.circle" : "mic.fill") { speech.toggle() }.buttonStyle(.bordered)
                    Button("Écouter", systemImage: "speaker.wave.2.fill") {
                        let utterance = AVSpeechUtterance(string: answer)
                        utterance.voice = AVSpeechSynthesisVoice(language: "fr-FR")
                        utterance.rate = 0.48
                        synthesizer.speak(utterance)
                    }.buttonStyle(.bordered)
                }
                if !speech.statusMessage.isEmpty { Text(speech.statusMessage).font(.footnote).foregroundStyle(.secondary) }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Questions rapides").font(.headline)
                    ForEach(["Missions IEMS et inspection", "Loi 2004-37 au Sénégal", "Analyser un cours communicatif", "Méthode de dissertation IEMS"], id: \.self) { prompt in
                        Button(prompt) { question = prompt; answer = CoachEngine.answer(to: prompt) }.buttonStyle(.bordered)
                    }
                }
            }.padding()
        }.onChange(of: speech.transcript) { _, text in question = text }.navigationTitle("Coach IEMS")
    }
}

struct TrainingView: View {
    @State private var draft = ""
    @State private var feedback: [String] = []
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Faites corriger votre trame").font(.title2.bold())
                Text("Collez une réponse d'oral, un plan ou une étude de cas. Le Coach recherche les éléments attendus par un inspecteur.").foregroundStyle(.secondary)
                TextEditor(text: $draft).frame(minHeight: 180).padding(8).overlay(RoundedRectangle(cornerRadius: 12).stroke(.quaternary))
                Button("Analyser ma réponse") { feedback = CoachEngine.review(draft) }.buttonStyle(.borderedProminent)
                ForEach(feedback, id: \.self) { item in Text(item) }
                GroupBox("Trame de cas pratique") { Text("Faits → problème → causes → cadre → décision → plan d'action → indicateurs → suivi") }
            }.padding()
        }.navigationTitle("Entraînement")
    }
}

struct ResourcesView: View {
    private let pdfURL = URL(string: "https://aby200yba.github.io/INSPECTEUR-D-ANGLAIS/resources/techniques-in-language-teaching.pdf")!
    var body: some View {
        List {
            Section("Corpus didactique") {
                Link(destination: pdfURL) { Label("Techniques and Principles in Language Teaching", systemImage: "doc.richtext") }
                Text("Ouvrage de Larsen-Freeman & Anderson, utilisé comme référence de méthodes et techniques d'enseignement des langues.").font(.footnote).foregroundStyle(.secondary)
            }
            Section("À retenir") {
                Label("Approche communicative et TBLT", systemImage: "bubble.left.and.bubble.right")
                Label("CLIL / Content-based instruction", systemImage: "text.book.closed")
                Label("Observation et évaluation formative", systemImage: "eye")
            }
        }.navigationTitle("Ressources")
    }
}
