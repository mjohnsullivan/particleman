import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spritewidget/spritewidget.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyParticlePage(),
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
  MyWidgetState createState() => new MyWidgetState();
}

class MyWidgetState extends State<MyWidget> {
  NodeWithSize rootNode;

  _setupParticles() async {
    ImageMap images = new ImageMap(rootBundle);
    final image = await images.loadImage('assets/particle.png');

    SpriteTexture texture = SpriteTexture(image);

    ParticleSystem particles = ParticleSystem(texture,
        posVar: Offset(0.0, 0.0),
        startSize: 1.0,
        startSizeVar: 0.5,
        endSize: 2.0,
        endSizeVar: 1.0,
        life: 1.5 * 10,
        lifeVar: 1.0 * 10);

    particles.position = const Offset(200.0, 200.0);

    Node node = Node();
    node.addChild(particles);

    rootNode.addChild(node);
  }

  @override
  void initState() {
    super.initState();
    rootNode = new NodeWithSize(const Size(400.0, 400.0));
    _setupParticles();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('Hello'),
      Container(height: 100.0, width: 100.0, child: SpriteWidget(rootNode)),
    ]);
  }
}
