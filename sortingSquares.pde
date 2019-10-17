final int SQUARE_COUNT = 500;
final int FADE_COUNT = 10;
final int MIN_SQUARE_SIZE = 3;
final int MAX_SQUARE_SIZE = 100;
final int OPACITY = 125; // 0 transparent, 255 no opacity
final int DELAY_BETWEEN_FRAMES = 25; // Delay between animation frames, in millis

// Implemented: "INSERTION_SORT"
final String ALGORITHM = "INSERTION_SORT";

float circleWidth;
float circleRadius;
float angle;
int animationStep;

SortableSquare[] sortableSquares;
ArrayList<SortableSquare[]> ssHistory;

void setup() {
  size(800,800); 
  background(255);
  rectMode(CENTER);
 
  // assumes square window assigned in size()
  circleWidth = width / 3 * 2;
  circleRadius = circleWidth / 2;
  angle = (-1) * TWO_PI / (float) SQUARE_COUNT;
  animationStep = 1;
  sortableSquares = new SortableSquare[SQUARE_COUNT];
  initSquares();
  sortSquares(sortableSquares);
}

void draw() {
  if (animationStep < ssHistory.size()) {
    background(255);
    for (int i = 0; i < SQUARE_COUNT; i++) {
      int len = sortableSquares.length; 
      PVector pos = ssHistory.get(animationStep)[i].pos;
      PVector col = ssHistory.get(animationStep)[i].col;
      int size = ssHistory.get(animationStep)[i].size;

      noStroke();
      fill(col.x,col.y,col.z,ssHistory.get(animationStep)[i].opacity);
      rect(pos.x,pos.y,size,size);
    
      fill(180);
      textAlign(CENTER);
      textSize(32);
      text(animationStep+1,width/2,height/2);
    }
    animationStep++;
  } 
  delay(DELAY_BETWEEN_FRAMES);
}

// Populate the SortableSquare array with SortableSquare objects.
void initSquares() {
  for(int i = 0; i < SQUARE_COUNT; i++) {
    int size = (int) random(MIN_SQUARE_SIZE, MAX_SQUARE_SIZE);

    // TODO: square color as a function of square size
    PVector squareColor = new PVector(random(255), random(255), random(255));
    PVector squarePos = new PVector(0, 0); // value updated after entire list is generated
    SortableSquare square = new SortableSquare(size, squareColor, OPACITY, squarePos);
    sortableSquares[i] = square;
  }
}

// Sort the SortableSquare array with the sorting algorithm defined in ALGORITHM.
void sortSquares(SortableSquare[] sortableSquares) {
  switch(ALGORITHM) {
    case "BUBBLE_SORT":
      println("Bubble sort");
      break;
    case "INSERTION_SORT":
      insertionSort(sortableSquares);
      break;
    case "SELECTION_SORT":
      println("Selection sort");
      break;
    default:
      println("Invalid algorithm choice. Typo?");
      break;
  }
}

// Sorts the SortableSquare array using Insertion Sort. 
void insertionSort(SortableSquare[] sortableSquares) {
  int len = sortableSquares.length;
  ssHistory = new ArrayList<SortableSquare[]>();
  ssHistory.add(new SortableSquare[len]);
  copyArray(sortableSquares, ssHistory.get(0),-1);
  for(int i = 1; i < len; i++) {
    int j = i;
    SortableSquare temp = sortableSquares[i];
    while(j > 0 && sortableSquares[j].compareTo(sortableSquares[j - 1]) < 0) {
      sortableSquares[j] = sortableSquares[j - 1];
      sortableSquares[j - 1] = temp;
      j--;
    }
    ssHistory.add(new SortableSquare[len]);
    copyArray(sortableSquares, ssHistory.get(i),j);
  }
}

void setPositions(SortableSquare[] sortableSquares) {
  for(int i = 0; i < SQUARE_COUNT; i++) {
    float x = (width/2) - sin(angle * i) * circleRadius;
    float y = (height/2) - cos(angle * i) * circleRadius;
    PVector pos = new PVector(x, y);
    sortableSquares[i].pos = pos;
  }
}





void copyArray(SortableSquare[] source, SortableSquare[] dest, int insert) {
  setPositions(source);
  for (int i = 0; i < source.length; i++) {
    dest[i] = new SortableSquare(source[i]);
  }
  if(insert >= 0) {
    dest[insert].size *= 2;
    dest[insert].opacity = 255;
  }
}

void keyTyped() {
  //saveFrame();
  animationStep = 0;
  background(255);
  initSquares();
}

// for testing insertion sort implementation
void printSquareArray(SortableSquare[] sortableSquares) {
  int len = sortableSquares.length;
  for(int i = 0; i < len; i++) {
    System.out.print("[" + i + "] ");
    System.out.println(sortableSquares[i]);
  }
}

// Defines a SortableSquare object.
// SortableSquares are sorted according to their size.
private class SortableSquare implements Comparable<SortableSquare> {
  int size;
  PVector col;
  float opacity; 
  PVector pos;
  
  public SortableSquare(int size, PVector col, float opacity, PVector pos) {
    this.size = size;
    this.col = col;
    this.opacity = opacity;
    this.pos = pos;
  }
  
  public SortableSquare(SortableSquare copySquare) {
    this.size = copySquare.size;
    this.col = copySquare.col;
    this.opacity = copySquare.opacity;
    this.pos = new PVector(copySquare.pos.x, copySquare.pos.y);
  }
  
  // size of current square minus size of other (comparison) square
  // negative when other > current (equiv. current > other)
  // positive when other < current (equiv. current < other)
  int compareTo(SortableSquare other) {
    return this.getSize() - other.getSize();
  }
  
  int getSize() {
    return this.size;
  }
}
