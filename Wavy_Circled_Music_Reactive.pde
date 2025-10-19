import ddf.minim.*;
import ddf.minim.analysis.*;
import java.util.ArrayList;

class Particle {
  float x, y, vx, vy, baseSize;
  Particle(float x, float y, float vx, float vy, float baseSize) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.baseSize = baseSize;
  }
}

Minim minim;
AudioInput in;
BeatDetect beatDetect;

ArrayList<Particle> particles = new ArrayList<Particle>();

int initialNumParticles = 300;
boolean attractMode = false;
int colorModeOption = 1;
boolean linesBetween = false;

// Waves
class WaveEvent {
  float startTime;
  WaveEvent(float startTime) {
    this.startTime = startTime;
  }
  float radius(float currentTime) {
    float elapsed = (currentTime - startTime) / 1000.0f; // Convert to seconds
    float waveSpeed = 200.0f; // Pixels per second
    return elapsed * waveSpeed;
  }
}

ArrayList<WaveEvent> waves = new ArrayList<WaveEvent>();
float waveAmplitude = 50; 
float waveWidth = 100; 

// Parameters for shooting new particles from the center
float spawnSpeedMin = 5.0f;  // minimum speed for new particles
float spawnSpeedMax = 10.0f; // maximum speed for new particles
int offscreenThreshold = 100; // how far a particle must move out of bounds to be removed
float initialOffset = 10;    // slight random offset from center for new particles

void settings() {
  //fullScreen(2);
  fullScreen();
  //size(800, 600); // Initial window size; can be resized
  smooth(2);
}

void setup() {
  surface.setResizable(true); // Enable window resizing
  noStroke();

  minim = new Minim(this);
  in = minim.getLineIn(Minim.MONO, 1024);
  beatDetect = new BeatDetect();

  // Initialize particles
  for (int i = 0; i < initialNumParticles; i++) {
    float x = random(width);
    float y = random(height);
    float vx = random(-0.5f, 0.5f);
    float vy = random(-0.5f, 0.5f);
    float baseS = random(5, 15);
    particles.add(new Particle(x, y, vx, vy, baseS));
  }
}

void draw() {
  float level = in.mix.level();
  beatDetect.detect(in.mix);
  boolean isBeat = beatDetect.isOnset();

  if (isBeat) {
    waves.add(new WaveEvent(millis()));
  }

  // Remove old waves
  float maxDim = max(width, height);
  for (int w = waves.size() - 1; w >= 0; w--) {
    float r = waves.get(w).radius(millis());
    if (r > maxDim * 2) {
      waves.remove(w);
    }
  }

  fill(0, 20);
  rect(0, 0, width, height);

  float centerX = width / 2f;
  float centerY = height / 2f;

  // Check for off-screen particles and shoot new ones from the center
  int particlesToShoot = 0;
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    if (p.x < -offscreenThreshold || p.x > width + offscreenThreshold ||
        p.y < -offscreenThreshold || p.y > height + offscreenThreshold) {
      particles.remove(i); // Remove the off-screen particle
      particlesToShoot++;  // Increment count of particles to shoot
    }
  }

  // Shoot new particles from the center
  for (int i = 0; i < particlesToShoot; i++) {
    float angle = random(TWO_PI);
    float startX = centerX + cos(angle) * initialOffset;
    float startY = centerY + sin(angle) * initialOffset;

    float spawnSpeed = random(spawnSpeedMin, spawnSpeedMax);
    float vx = cos(angle) * spawnSpeed * 0.5f;
    float vy = sin(angle) * spawnSpeed * 0.5f;

    float baseS = random(5, 15);
    particles.add(new Particle(startX, startY, vx, vy, baseS));
  }

  // Update particle motion
  for (Particle p : particles) {
    if (attractMode) {
      float dx = mouseX - p.x;
      float dy = mouseY - p.y;
      float dist = sqrt(dx * dx + dy * dy);
      if (dist > 1) {
        dx /= dist;
        dy /= dist;
        float force = 0.5f;
        p.vx += dx * force;
        p.vy += dy * force;
      }
    } else {
      // Gentle random drift
      p.vx += random(-0.01f, 0.01f);
      p.vy += random(-0.01f, 0.01f);
      p.vx *= 0.99f;
      p.vy *= 0.99f;
    }

    // Apply wave displacement
    float distFromCenter = dist(p.x, p.y, centerX, centerY);
    float totalDisplacement = 0;
    float currentTime = millis();
    for (WaveEvent wv : waves) {
      float r = wv.radius(currentTime);
      float diff = distFromCenter - r;
      float fadeFactor = max(0, 1 - (r / (maxDim * 2)));
      float waveVal = waveAmplitude * fadeFactor * (float) Math.exp(-(diff * diff) / (2 * waveWidth * waveWidth));
      totalDisplacement += waveVal;
    }

    float dirX = p.x - centerX;
    float dirY = p.y - centerY;
    float d = (distFromCenter == 0) ? 1 : distFromCenter;
    dirX /= d;
    dirY /= d;

    float displacedX = p.x + dirX * totalDisplacement;
    float displacedY = p.y + dirY * totalDisplacement;

    // Update position
    p.x = displacedX + p.vx;
    p.y = displacedY + p.vy;
  }

  // Draw lines between particles if enabled
  if (linesBetween) {
    stroke(255, 50);
    strokeWeight(1);
    for (int i = 0; i < particles.size(); i++) {
      Particle p1 = particles.get(i);
      for (int j = i + 1; j < particles.size(); j++) {
        Particle p2 = particles.get(j);
        float distance = dist(p1.x, p1.y, p2.x, p2.y);
        if (distance < 100) { // Threshold distance for drawing lines
          line(p1.x, p1.y, p2.x, p2.y);
        }
      }
    }
    noStroke();
  }

  // Draw particles
  for (Particle p : particles) {
    float h;
    switch (colorModeOption) {
      case 1:
        colorMode(HSB, 360, 100, 100);
        h = (frameCount * 0.5f + particles.indexOf(p) * 2) % 360;
        fill(h, 80, 100);
        break;
      case 2:
        colorMode(RGB, 255);
        fill(abs(sin((frameCount + particles.indexOf(p)) * 0.01f)) * 255,
             abs(cos((frameCount + particles.indexOf(p)) * 0.01f)) * 255, 200);
        break;
      default:
        colorMode(HSB, 360, 100, 100);
        h = (frameCount * 0.5f + particles.indexOf(p) * 2) % 360;
        fill(h, 80, 100);
    }

    float currentSize = p.baseSize + level * 100;
    ellipse(p.x, p.y, currentSize, currentSize);
  }
}

void mousePressed() {
  attractMode = true;
}

void mouseReleased() {
  attractMode = false;
}

void keyPressed() {
  if (key == '1') {
    colorModeOption = 1;
  } else if (key == '2') {
    colorModeOption = 2;
  } else if (key == 'L' || key == 'l') {
    linesBetween = !linesBetween;
  }
}
