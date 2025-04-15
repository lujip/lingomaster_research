import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as p;
import 'package:audio_waveforms/audio_waveforms.dart';

import 'package:my_app/Widgets/footer.dart';
import 'package:my_app/Widgets/header.dart';
import 'package:my_app/Widgets/sidebar.dart';

class HomeRecordPage extends StatefulWidget {
  const HomeRecordPage({super.key});

  @override
  State<HomeRecordPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeRecordPage> {
  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();

  final RecorderController recorderController = RecorderController();

  bool isRecording = false;
  bool isPlaying = false;
  String? recordingPath;

  @override
  void dispose() {
    audioPlayer.dispose();
    recorderController.dispose();
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
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Live waveform when recording
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
          // Static waveform after recording
          if (recordingPath != null && !isRecording)
            AudioFileWaveforms(
              size: const Size(double.infinity, 100),
              playerController: PlayerController()
                ..preparePlayer(
                  path: recordingPath!,
                ),
              playerWaveStyle: const PlayerWaveStyle(
                fixedWaveColor: Colors.green,
                liveWaveColor: Colors.greenAccent,
              ),
            ),
          const SizedBox(height: 16),
          if (recordingPath != null)
            MaterialButton(
              onPressed: () async {
                if (audioPlayer.playing) {
                  await audioPlayer.stop();
                  setState(() {
                    isPlaying = false;
                  });
                } else {
                  await audioPlayer.setFilePath(recordingPath!);
                  await audioPlayer.play();
                  setState(() {
                    isPlaying = true;
                  });
                }
              },
              color: Theme.of(context).colorScheme.primary,
              child: Text(
                isPlaying ? "Stop" : "Play Recording",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          if (recordingPath == null)
            const Text("No Recording"),
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
            final String filePath = p.join(appDocumentsDir.path, "recording.m4a");
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
}
