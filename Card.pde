class Card {
  String text;
  int value;
  float x, y;
  boolean isVisible; // To control visibility of the card

  Card(String text, float x, float y, int value) {
    this.text = text;
    this.x = x;
    this.y = y;
    this.value = value;
    this.isVisible = false; // Cards are hidden by default
  }

  void display() {
    stroke(0);
    strokeWeight(2);
    fill(255);
    rect(x, y, 60, 80); // Drawing the card as a white rectangle
    if (isVisible) {
      fill(0);
      textSize(10);
      textAlign(LEFT, TOP);
      text(text, x + 5, y + 5); // Display the card's text on the top-left
      textAlign(RIGHT, BOTTOM);
      text(text, x + 55, y + 75); // Display the card's text on the bottom-right
    } else {
      fill(100);
      textSize(12);
      textAlign(CENTER, CENTER);
      text("?", x + 30, y + 40); // A question mark indicates a face-down card
    }
  }

  // Method to set the card visibility
  void show() {
    isVisible = true;
  }
}
