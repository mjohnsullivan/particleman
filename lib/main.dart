import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:spritewidget/spritewidget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Particle Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyParticlePage(),
    );
  }
}

class MyParticlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.black,
      child: Center(child: MyWidget()),
    ));
  }
}

class MyWidget extends StatefulWidget {
  @override
  createState() => MyWidgetState();
}

class MyWidgetState extends State<MyWidget> {
  NodeWithSize rootNode;

  _setupParticles() async {
    ImageMap images = ImageMap(rootBundle);
    final image = await images.loadImage('assets/particle_blob.png');

    SpriteTexture texture = SpriteTexture(image);

    ParticleSystem particles = ParticleSystem(
      texture,
      posVar: Offset(0.0, 0.0),
      startSize: 1.0,
      startSizeVar: 0.5,
      endSize: 0.5,
      endSizeVar: 0.0,
      life: 0.5,
      lifeVar: 1.0,
      gravity: Offset(0.0, 200.0),
    );

    particles.position = const Offset(50.0, 50.0);

    Node node = Node();
    node.addChild(particles);

    final particleNode = CanvasParticleNode(distance: 1.0);
    // rootNode.addChild(node);
    rootNode.addChild(particleNode);
  }

  @override
  void initState() {
    super.initState();
    rootNode = NodeWithSize(const Size(100.0, 100.0));
    _setupParticles();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        'Particles!',
        style: TextStyle(color: Colors.white),
      ),
      Container(height: 50.0, width: 50.0, child: SpriteWidget(rootNode)),
    ]);
  }
}

/// Following class is modified from code at:
/// https://www.reddit.com/r/FlutterDev/comments/8d6n2m/spritewidget_0916_is_out_includes_awesome/
class CanvasParticleNode extends Node {
  final double distance;
  CanvasParticleNode({this.distance}) {
    _addParticles(distance);
  }

  void _addParticles(double distance) {
    // final image = imageFromUnicode('*', 12.0);
    final image = imagefromIcon(Icons.ac_unit, 9.0);

    SpriteTexture spriteTexture = SpriteTexture(image);

    ParticleSystem particles = ParticleSystem(
      spriteTexture,
      posVar: Offset.zero,
      startSize: 2.0,
      endSize: 2.0,
      endSizeVar: 1.0,
      life: 0.5 * distance,
      lifeVar: 1.0 * distance,
      gravity: Offset(0.0, 250.0),
      numParticlesToEmit: 0,
      transferMode: BlendMode.srcATop,
      autoRemoveOnFinish: true,
      colorSequence: ColorSequence.fromStartAndEndColor(
        Colors.yellow,
        Colors.deepOrange,
      ),
    );

    particles.position = const Offset(50.0, 50.0);

    addChild(particles);
  }

  ui.Image imagefromIcon(IconData icon, double imageSize) => imageFromUnicode(
      String.fromCharCode(icon.codePoint), imageSize, icon.fontFamily);

  ui.Image imageFromUnicode(String unicodeChar, double imageSize,
      [fontFamily]) {
    final style = TextStyle(
      color: const ui.Color(0xFFFFFFFF),
      fontSize: imageSize,
      fontFamily: fontFamily,
    );

    ui.PictureRecorder recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    TextPainter(
      text: TextSpan(text: unicodeChar, style: style),
      textDirection: TextDirection.ltr,
    )
      ..layout(maxWidth: imageSize)
      ..paint(canvas, Offset.zero);

    return recorder.endRecording().toImage(
          imageSize.ceil(),
          imageSize.ceil(),
        );
  }
}
