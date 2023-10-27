import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

enum Source { network, asset }

class VideoPlayePage extends StatefulWidget {
  const VideoPlayePage({super.key});

  @override
  State<VideoPlayePage> createState() => _VideoPlayePageState();
}

class _VideoPlayePageState extends State<VideoPlayePage> {
  late CustomVideoPlayerController? _customVideoPlayerController;

  Source currentSource = Source.asset;

  String assetVideopath = "assets/videos/le.mp4";

  late bool isLoading;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer(currentSource);
  }

  @override
  void dispose() {
    super.dispose();
    _customVideoPlayerController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomVideoPlayer(
                  customVideoPlayerController: _customVideoPlayerController!,
                ),
                _sourceButtons(),
              ],
            ),
    );
  }

  void initializeVideoPlayer(Source source) {
    isLoading = true;
    // Dispose of the previous video player if it exists

    VideoPlayerController videoPlayerController;
    if (source == Source.asset) {
      videoPlayerController = VideoPlayerController.asset(assetVideopath)
        ..initialize().then((_) {
          setState(() {
            isLoading = false;
          });
        });
    } else if (source == Source.network) {
      videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(
            "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4"),
      )..initialize().then((_) {
          setState(() {
            isLoading = false;
          });
        });
    } else {
      return;
    }

    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
    );
  }

  Widget _sourceButtons() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MaterialButton(
            color: Colors.red,
            child: const Text(
              "Network",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              setState(() {
                if (_customVideoPlayerController != null) {
                  _customVideoPlayerController!.videoPlayerController.dispose();
                }
                currentSource = Source.network;
                initializeVideoPlayer(currentSource);
              });
            }),
        MaterialButton(
            color: Colors.red,
            child: const Text(
              "Asset",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              setState(() {
                if (_customVideoPlayerController != null) {
                  _customVideoPlayerController!.videoPlayerController.dispose();
                }
                currentSource = Source.asset;
                initializeVideoPlayer(currentSource);
              });
            }),
      ],
    );
  }
}
