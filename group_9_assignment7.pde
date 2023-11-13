import processing.sound.*;

int cols, rows;
float tileSize = 40;
// create arrays that hold player/dealer cards
ArrayList<Card> playerHand = new ArrayList<>();
ArrayList<Card> dealerHand = new ArrayList<>();
int playerCardSum = 0;
int dealerCardSum = 0;
String gameState = "Playing"; // Possible states: "Playing", "PlayerWins", "DealerWins", "Tie", "PlayerBusts", "DealerBusts"
String endGameMessage = "";
// track scores
int playerScore = 0;
int dealerScore = 0;
PImage audioIcon;
boolean playAudio;
SoundFile sound;

void setup() {
  size(800, 600);
  cols = width / int(tileSize);
  rows = height / int(tileSize);
  background(0, 128, 0);
  audioIcon = loadImage("audioIcon.png");
  audioIcon.resize(100,100);
  sound = new SoundFile(this, "bling.wav");
  resetGame();
}

void draw() {
  drawFelt();
  drawButtons();
  displayHands();
  displayGameState();

  if (!gameState.equals("Playing")) {
    displayEndGameMessage(endGameMessage);
  } 
}

// draw background
void drawFelt() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      float x = i * tileSize;
      float y = j * tileSize;

      fill(0, 80, 0);
      rect(x, y, tileSize, tileSize);

      stroke(0, 200, 0);
      strokeWeight(1);
      noFill();
      rect(x, y, tileSize, tileSize);
    }
  }
}

void drawButtons() {
  drawButton("Hit", 10, height - 50, 80, 40);
  drawButton("Stand", 100, height - 50, 90, 40);
  drawButton("Next Round", 590, height - 50, 100, 40);
  drawButton("New Game", 700, height - 50, 90, 40);
}

void drawButton(String label, float x, float y, float w, float h) {
   
  if (label == "New Game"){
    // make "new game" button red
    fill(255,0,0);
  } else{
    fill(200);
  }
  rect(x, y, w, h); 
  fill(0);
  textSize(16);
  textAlign(CENTER, CENTER);
  text(label, x + w / 2, y + h / 2);
}

void mousePressed() {
  // if audio button is pressed, turn audio on/off
  if (mouseX >= 10 && mouseX <= 110 && mouseY >= 10 && mouseY <= 110) {
    playAudio = !playAudio;
  }
  
  if (playAudio){
  sound.play();}
  
  // next round is pressed
  if (mouseX >= 590 && mouseX <= 690 && mouseY >= height - 50 && mouseY <= height - 10) {
    resetGame();
    return; 
  }
  // new game is pressed
  if (mouseX >= 700 && mouseX <= 790 && mouseY >= height - 50 && mouseY <= height - 10) {
    resetGame();
    playerScore = 0;
    dealerScore = 0;
    return; 
  }

  if (gameState.equals("Playing")) {
    if (mouseX >= 10 && mouseX <= 90 && mouseY >= height - 50 && mouseY <= height - 10) {
      drawCard(true); // Player draws a card
      // checks if player sum is > 21 or == 21, otherwise, game continues
      if (playerCardSum > 21) {
        gameState = "PlayerBusts";
        endGameMessage = "Player busts! Dealer wins.";
      } else if (playerCardSum == 21) {
        gameState = "PlayerWins";
        endGameMessage = "Blackjack! Player wins.";
      }
    } else if (mouseX >= 100 && mouseX <= 190 && mouseY >= height - 50 && mouseY <= height - 10) {
      dealerPlay();
      if (gameState.equals("Playing")) { 
        checkWinCondition();
      }
    }
  }
  
}

void displayHands() {
  float playerCardX = 100; 
  float dealerCardX = 100; 
  float cardY = height / 2; 
  float cardSpacing = 70; 

  // Display the player's hand
  for (int i = 0; i < playerHand.size(); i++) {
    Card card = playerHand.get(i);
    card.x = playerCardX + (i * cardSpacing);
    card.y = cardY;
    card.show(); 
    card.display();
  }

  for (int i = 0; i < dealerHand.size(); i++) {
    Card card = dealerHand.get(i);
    card.x = dealerCardX + (i * cardSpacing);
    card.y = cardY - 100; 
    if (gameState.equals("Playing") && i == 0) {
      card.isVisible = false;
    } else {
      card.show();
    }
    card.display();
  }
}

void displayGameState() {
  fill(255);
  textSize(20);
  textAlign(CENTER);
  text("Game State: " + gameState, width / 2, 30);
  text("Player Card Sum: " + playerCardSum, width / 2, 60);
  text("Dealer Card Sum: " + (gameState.equals("Playing") ? "?" : dealerCardSum), width / 2, 90);
  text("Player Score: " + playerScore + "     Dealer Score: " + dealerScore, width / 2, 550);
  text("Dealer: ", 50, 250);
  text("Player: ", 50, 350);
  image(audioIcon, 10, 10);
}

void displayEndGameMessage(String message) {
  fill(255, 0, 0);
  textSize(30);
  textAlign(CENTER);
  text(message, width /2 , height / 2);
}

// resets player/dealer hands and game state
void resetGame() {
  playerHand.clear();
  dealerHand.clear();
  playerCardSum = 0;
  dealerCardSum = 0;
  gameState = "Playing";
  endGameMessage = "";
  drawFelt();
  drawButtons();
}

// implement game rules, face cards = 10, aces = 1
int getCardValue(int rank) {
  if (rank >= 11 && rank <= 13) { // Face cards are worth 10
    return 10;
  } else { // Aces are 1, and other number cards are worth their face value
    return rank;
  }
}

// used to print text on cards
String getCardText(int rank, String suit) {
  if (rank == 1) {
    return "Ace of " + suit;
  } else if (rank == 11) {
    return "Jack of " + suit;
  } else if (rank == 12) {
    return "Queen of " + suit;
  } else if (rank == 13) {
    return "King of " + suit;
  } else {
    return rank + " of " + suit;
  }
}

// randomizes a card and adds it to the specified hand
void drawCard(boolean isPlayer) {
  int rank = int(random(1, 14)); // Generate a random card rank between 1 and 13
  String[] suits = {"Hearts", "Diamonds", "Clubs", "Spades"};
  String suit = suits[int(random(4))]; // Pick a random suit

  String cardText = getCardText(rank, suit); 
  float cardX = isPlayer ? width / 4 : 3 * width / 4; 
  float cardY = height / 2;

  Card card = new Card(cardText, cardX, cardY, getCardValue(rank));
  card.display();

  if (isPlayer) {
    playerHand.add(card);
    playerCardSum += card.value;
  } else {
    dealerHand.add(card);
    dealerCardSum += card.value;
  }

  // After a card is drawn, check for player bust
  if (isPlayer && playerCardSum > 21) {
    gameState = "PlayerBusts";
    endGameMessage = "Player busts! Dealer wins.";
    dealerScore += 1;
  }
}

void dealerPlay() {
  while (dealerCardSum < 17) {
    drawCard(false); // Dealer draws a card
    // Check for bust immediately after drawing a card
    if (dealerCardSum > 21) {
      gameState = "DealerBusts";
      endGameMessage = "Dealer busts! Player wins.";
      dealerScore += 1;
      return; 
    }
  }
  checkWinCondition();
}

void checkWinCondition() {
  if (dealerCardSum > 21) {
    gameState = "DealerBusts";
    endGameMessage = "Dealer busts! Player wins.";
    playerScore += 1;
  } else if (dealerCardSum > playerCardSum) {
    gameState = "DealerWins";
    endGameMessage = "Dealer wins.";
    dealerScore += 1;
  } else if (dealerCardSum < playerCardSum) {
    gameState = "PlayerWins";
    endGameMessage = "Player wins.";
    playerScore += 1;
  } else {
    gameState = "Tie";
    endGameMessage = "It's a tie!";
  }
}
