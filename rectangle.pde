class Rectangle {
  float posX;
  float posY;
  float rectWidth;
  float rectHeight;
  color fillColor = color(0);
  color strokeColor = color(0);
  boolean fill;
  boolean stroke;
  
  public Rectangle(float x, float y, float w, float h, color fill, color stroke) {
    this.posX = x;
    this.posY = y;
    this.rectWidth = w;
    this.rectHeight = h;
    this.fillColor = fill;
    this.strokeColor = stroke;
    this.fill = true;
    this.stroke = true;
  }
  
  public Rectangle(float x, float y, float w, float h) {
    this.posX = x;
    this.posY = y;
    this.rectWidth = w;
    this.rectHeight = h;
    this.fillColor = -1;
    this.strokeColor = -1;
    this.fill = false;
    this.stroke = false;
  }
  
  public void display() {
    push();
    if (fill) {
      fill(fillColor);
    } else {
      noFill();
    }
    if (stroke) {
      stroke(strokeColor);
    } else {
      noStroke();
    }
    fill(fillColor);
    stroke(strokeColor);
    rect(posX, posY, rectWidth, rectHeight);
    pop();
  }
};
