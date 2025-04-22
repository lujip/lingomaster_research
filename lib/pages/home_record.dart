import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as p;
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:my_app/Widgets/evaluate.dart';

class HomeRecordPage extends StatefulWidget {
  static String? selectedWord;

  const HomeRecordPage({super.key});

  @override
  State<HomeRecordPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeRecordPage> {
  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();
  final AudioPlayer nativeAudioPlayer = AudioPlayer();
  final RecorderController recorderController = RecorderController();
  final PlayerController waveformPlayerController = PlayerController();

  bool isRecording = false;
  bool isPlaying = false;
  bool isNativePlaying = false;
  String? recordingPath; // user recording
  String? nativePath; // selected word

  @override
  void initState() {
    super.initState();
    if (HomeRecordPage.selectedWord != null) {
      loadNativeAudio(HomeRecordPage.selectedWord!);
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    nativeAudioPlayer.dispose();
    recorderController.dispose();
    waveformPlayerController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _recordingButton(),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Scaffold(
      body: Stack(
        children: [
          // Main UI content
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Recording waveform
                if (isRecording)
                  AudioWaveforms(
                    size: const Size(double.infinity, 100),
                    recorderController: recorderController,
                    waveStyle: const WaveStyle(
                      waveColor: Colors.blue,
                      showMiddleLine: false,
                    ),
                    enableGesture: true,
                  ),
                // waveform after recording
                if (recordingPath != null && !isRecording)
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: AudioFileWaveforms(
                        size: const Size(double.infinity, 100),
                        playerController: waveformPlayerController,
                        playerWaveStyle: const PlayerWaveStyle(
                          fixedWaveColor: Colors.green,
                          liveWaveColor: Colors.greenAccent,
                          spacing: 6,
                          waveThickness: 3.0,
                          showSeekLine: true,
                        ),
                        enableSeekGesture: true,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                //Play own recording
                if (recordingPath != null)
                  MaterialButton(
                    onPressed: () async {
                      if (audioPlayer.playing) {
                        await audioPlayer.stop();
                        await waveformPlayerController.stopPlayer();
                        setState(() {
                          isPlaying = false;
                        });
                      } else {
                        await audioPlayer.setFilePath(recordingPath!);
                        await waveformPlayerController.preparePlayer(
                          path: recordingPath!,
                        );
                        await waveformPlayerController.startPlayer();
                        await audioPlayer.play();
                        setState(() {
                          isPlaying = true;
                        });
                      }
                    },
                    color: Theme.of(context).colorScheme.primary,
                    child: Text(
                      isPlaying ? "Play Again" : "Play Recording",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),

                // 🔊 Play native audio for selected word
                if (nativePath != null)
                  MaterialButton(
                    onPressed: () async {
                      if (nativeAudioPlayer.playing) {
                        await nativeAudioPlayer.stop();
                        setState(() {
                          isNativePlaying = false;
                        });
                      } else {
                        await nativeAudioPlayer.setFilePath(nativePath!);
                        await nativeAudioPlayer.play();
                        setState(() {
                          isNativePlaying = true;
                        });
                      }
                    },
                    color: Colors.deepPurple,
                    child: Text(
                      isNativePlaying ? "Play again" : "Play Selected Audio",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),

                if (recordingPath == null && nativePath == null)
                  const Text("No Audio Available"),
              ],
            ),
          ),

          Positioned(
            bottom: 16, // 16px from the bottom
            left: 16, // 16px from the left
            child: ElevatedButton(
              onPressed: () {
                if (recordingPath == null) {
                  _showNoRecordingDialog();
                } else if (HomeRecordPage.selectedWord == null) {
                  _showNoSelectedWordDialog();
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => EvaluatePage(
                      selectedWord: HomeRecordPage.selectedWord!,
                      recordingPath: recordingPath!,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16), 
                textStyle: TextStyle(fontSize: 18), 
                minimumSize: Size(
                    200, 60), 
              ),
              child: Text("Evaluate"),
            ),
          ),
        ],
      ),
    );
  }

  // Show dialog when no recording is available
  void _showNoRecordingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("No Recording Found"),
        content: Text(
            "Please record your audio before proceeding with the evaluation."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  // Show dialog when no selected speech is available
  void _showNoSelectedWordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("No Speech Selected"),
        content: Text(
            "Please select a word from the list before proceeding with the evaluation."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _recordingButton() {
    return FloatingActionButton(
      onPressed: () async {
        if (isRecording) {
          String? filePath = await audioRecorder.stop();
          recorderController.reset();
          if (filePath != null) {
            setState(() {
              isRecording = false;
              recordingPath = filePath;
            });
          }
        } else {
          if (await audioRecorder.hasPermission()) {
            final Directory appDocumentsDir =
                await getApplicationDocumentsDirectory();
            final String filePath =
                p.join(appDocumentsDir.path, "recording.m4a");
            await audioRecorder.start(
              const RecordConfig(),
              path: filePath,
            );
            recorderController.record();
            setState(() {
              isRecording = true;
              recordingPath = null;
            });
          }
        }
      },
      child: Icon(isRecording ? Icons.stop : Icons.mic),
    );
  }

  Future<void> loadNativeAudio(String word) async {
    final String filename = sanitizeFilename(word);
    final String assetPath = 'assets/audio/$filename.wav';
    final File? file = await loadAssetAsFile(assetPath);

    if (file != null && file.existsSync()) {
      setState(() {
        nativePath = file.path;
      });
    } else {
      debugPrint("Native audio not found for word: $word");
    }
  }

  Future<File?> loadAssetAsFile(String assetPath) async {
    try {
      final byteData = await rootBundle.load(assetPath);
      final file = File(
          '${(await getTemporaryDirectory()).path}/${p.basename(assetPath)}');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      return file;
    } catch (e) {
      debugPrint("Error loading asset: $e");
      return null;
    }
  }

  String sanitizeFilename(String word) {
    return word
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '') 
        .replaceAll(RegExp(r'\s+'), '_'); 
  }
}
