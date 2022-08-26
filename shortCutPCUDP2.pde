import controlP5.*;  // for Textfield
import hypermedia.net.*;  // UDP Library
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.awt.*;
import java.awt.Robot.*;
import java.awt.event.KeyEvent.*;

ControlP5 cp5;
UDP udp;
Robot robot;

String ip = "";
String ownIP = "";
String message = "";
String buttonsAsString = "00000000";
Rectangle[] rects = new Rectangle[8];
int[] keys = { 88, 89, 32, 8, 68, 70, 74, 75 };

String state = "";

void setup() {
  size(480, 360);
  
  PFont font = createFont("arial", 20);
  
  cp5 = new ControlP5(this);
  
  cp5.addTextfield("IP input")
     .setPosition(width*0.5-100, height*0.25)
     .setSize(200, 40)
     .setFont(font)
     .setFocus(true)
     .setAutoClear(false)
     ;
  
  udp = new UDP(this, 6000);
  //udp.log(true);
  udp.listen(true);
  udp.send("test", "localhost", 6000);
  
  try(final DatagramSocket socket = new DatagramSocket()){
    socket.connect(InetAddress.getByName("8.8.8.8"), 10002);
    ownIP = socket.getLocalAddress().getHostAddress();
  } catch (Exception e) {
    e.printStackTrace();
  }
  
  try {
    robot = new Robot();
  } catch (Exception e) {
    e.printStackTrace();
  }
  
  rects[0] = new Rectangle(0, height*0.5, width*0.25, height*0.25);
  rects[1] = new Rectangle(width*0.25, height*0.5, width*0.25, height*0.25);
  rects[2] = new Rectangle(width*0.5, height*0.5, width*0.25, height*0.25);
  rects[3] = new Rectangle(width*0.75, height*0.5, width*0.25, height*0.25);
  rects[4] = new Rectangle(0, height*0.75, width*0.25, height*0.25);
  rects[5] = new Rectangle(width*0.25, height*0.75, width*0.25, height*0.25);
  rects[6] = new Rectangle(width*0.5, height*0.75, width*0.25, height*0.25);
  rects[7] = new Rectangle(width*0.75, height*0.75, width*0.25, height*0.25);
}

void draw() {
  background(0);
  switch (state) {
    case "connected" :
      for (int i = 0; i < 8; i++) {
        if (buttonsAsString.charAt(i) == '1') {
          rects[i].fillColor = color(200);
          robot.keyPress(keys[i]);
        } else {
          rects[i].fillColor = color(0);
          robot.keyRelease(keys[i]);
        }
        rects[i].display();
      }
      
      break;
  }
  stroke(255);
    line(0, height*0.75, width, height*0.75);  // horizontal middle line
    line(0, height*0.5, width, height*0.5);  // horizontal top line
    line(width*0.25, height*0.5, width*0.25, height);  // vertical left line
    line(width*0.5, height*0.5, width*0.5, height);  // vertical middle line
    line(width*0.75, height*0.5, width*0.75, height);  // vertical right line
}

void controlEvent(ControlEvent theEvent) {
  if(theEvent.isAssignableFrom(Textfield.class)) {
    println("controlEvent: accessing a string from controller '"
            +theEvent.getName()+"': "
            +theEvent.getStringValue()
            );
  }
  
  switch (state) {
    case "idle" :
      break;
    case "waiting" :
      if (message.equals("connected!")) {
        state = "connected";
      }
      break;
    case "connected" :
      break;
  }
}

public void input(String theText) {
  // automatically receives results from controller input
  println("a textfield event for controller 'input' : "+theText);
  ip = theText;
}

void receive(byte[] data/*, String ip, int port*/) {
  message = new String(data);
  //println("PC: receive: \"" + message + "\" from " + ip + " on port " + port);
  if (message.equals("connected!")) {
    state = "connected";
  }
  buttonsAsString = binary(byte(int(message)));
}

void keyPressed() {
  switch (key) {
    case ENTER :
      ip = cp5.get(Textfield.class, "IP input").getText();
      udp.send("PC:" + ownIP, ip, 6000);
      state = "waiting";
      cp5.get(Textfield.class, "IP input").lock();
      cp5.get(Textfield.class, "IP input").hide();
      break;
    case ESC :
      key = 0;
      udp.send("disconnect!", ip, 6000);
      state= "idle";
      cp5.get(Textfield.class, "IP input").unlock();
      cp5.get(Textfield.class, "IP input").show();
      break;
  }
}
