import Combine
import AVFoundation
import Speech

@MainActor
final class SpeechService: NSObject, ObservableObject {
    @Published var transcript = ""
    @Published var isRecording = false
    @Published var statusMessage = ""

    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "fr-FR"))
    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?

    func toggle() { isRecording ? stop() : requestPermissionsAndStart() }

    private func requestPermissionsAndStart() {
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                guard status == .authorized else { self?.statusMessage = "Autorisez la reconnaissance vocale dans Réglages."; return }
                AVAudioApplication.requestRecordPermission { allowed in
                    DispatchQueue.main.async {
                        guard allowed else { self?.statusMessage = "Autorisez le microphone dans Réglages."; return }
                        self?.start()
                    }
                }
            }
        }
    }

    private func start() {
        task?.cancel()
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        self.request = request
        let input = audioEngine.inputNode
        let format = input.outputFormat(forBus: 0)
        input.removeTap(onBus: 0)
        input.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in request.append(buffer) }
        do {
            audioEngine.prepare()
            try audioEngine.start()
            isRecording = true
            statusMessage = "Écoute en cours…"
            task = recognizer?.recognitionTask(with: request) { [weak self] result, error in
                DispatchQueue.main.async {
                    if let result { self?.transcript = result.bestTranscription.formattedString }
                    if error != nil || result?.isFinal == true { self?.stop() }
                }
            }
        } catch {
            statusMessage = "Impossible de démarrer le microphone."
            stop()
        }
    }

    func stop() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        request?.endAudio()
        isRecording = false
        if statusMessage == "Écoute en cours…" { statusMessage = "Dictée terminée." }
    }
}


