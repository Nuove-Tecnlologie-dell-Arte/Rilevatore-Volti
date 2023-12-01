import gab.opencv.*;
import processing.video.*;
import ddf.minim.*;
import processing.sound.*;
import java.awt.*;
import java.util.ArrayList;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;

Capture video;
OpenCV opencv;
Minim minim;
AudioOutput out;
ArrayList<Face> faces = new ArrayList<Face>();
boolean faceDetected = false;

void setup() {
  size(640, 480);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  video.start();
  minim = new Minim(this);
  out = minim.getLineOut(); // Initialize the audio output
}

void draw() {
  scale(2);
  opencv.loadImage(video);
  image(video, 0, 0);

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  //faces.clear(); // Clear the list of faces on each frame
  Rectangle[] detectedFaces = opencv.detect();

  for (Rectangle face : detectedFaces) {
    rect(face.x, face.y, face.width, face.height);
    faces.add(new Face(face.x, face.y, face.width, face.height));
  }

   if (faceDetected) {
    for (Face face : faces) {
      playSoundForFace(face);
    }
  }
}

void captureEvent(Capture c) {
  c.read();
}

void playSoundForFace(Face face) {
  // Create a sound based on face dimensions
  float soundFrequency = map(face.getWidth(), 0, width, 100, 1000);
  SineWave oscillator = new SineWave(soundFrequency, 0.5f, out.sampleRate());
  out.addSignal(oscillator); // Add the signal to the existing audio output
  out.playNote();
}

class Face {
  float x, y, width, height;

  Face(float x, float y, float width, float height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }

  float getWidth() {
    return width;
  }
}
