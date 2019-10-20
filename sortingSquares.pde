// Parameters
final int SQUARE_COUNT          = 50;
final int FADE_COUNT            = 10;
final int MIN_SQUARE_SIZE       = 3;
final int MAX_SQUARE_SIZE       = 100;
final int OPACITY               = 140; // 0 transparent, 255 no opacity
final int DELAY_BETWEEN_FRAMES  = 0; // Delay between animation frames, in millis
final boolean DRAW_SWAPS        = true;


/* Implemented: 
 * "INSERTION_SORT", "BUBBLE_SORT_1", "BUBBLE_SORT_2", "SELECTION_SORT"
 */

final String ALGORITHM = "BUBBLE_SORT_1";

/* Data sets available:
 * random
 * already sorted
 * reverse sorted
 * user defined (maybe? not implemented)
 */

final String DATA_SET = "USER";

float circleWidth;
float circleRadius;
float angle;
int currentFrame;

SortableSquare[] sortableSquares;
ArrayList<SortableSquare[]> ssHistory;

void setup() {
  size(800, 800); 
  background(255);
  rectMode(CENTER);
  textAlign(CENTER);
  
  circleWidth = width / 3 * 2;
  circleRadius = circleWidth / 2;
  angle = (-1) * TWO_PI / (float) SQUARE_COUNT;
  currentFrame = 1;
  sortableSquares = new SortableSquare[SQUARE_COUNT];
  initSquares();
  sortSquares(sortableSquares);
}

void draw() {
  if (currentFrame < ssHistory.size()) {
    background(255);
    fill(140);
    textAlign(CENTER);
    textSize(24);
    text(currentFrame + 1, width / 2, height / 2);
    textSize(16);
    text("comparisons", width/2, height/2 + 25);
    for (int i = 0; i < SQUARE_COUNT; i++) {
      PVector pos = ssHistory.get(currentFrame)[i].pos;
      PVector col = ssHistory.get(currentFrame)[i].col;
      int size = ssHistory.get(currentFrame)[i].size;
      // int size;
      if(ssHistory.get(currentFrame)[i].compared) {
        float r = ssHistory.get(currentFrame)[i].col.x;
        float b = ssHistory.get(currentFrame)[i].col.y;
        float g = ssHistory.get(currentFrame)[i].col.z;
        strokeWeight(1);
        stroke(r, b, g);
        // fill(col.x, col.y, col.z, 255);
        // size = (int) (ssHistory.get(currentFrame)[i].size * 1.1);
      } else {
        noStroke();
        // fill(col.x, col.y, col.z, ssHistory.get(currentFrame)[i].opacity);
        // size = ssHistory.get(currentFrame)[i].size;
      }
      fill(col.x, col.y, col.z, ssHistory.get(currentFrame)[i].opacity);
      rect(pos.x, pos.y, size, size);
      noStroke();
    }
    currentFrame++;
    textAlign(LEFT, TOP);
    textSize(24);
    fill(140);
    switch(ALGORITHM) {
      case "BUBBLE_SORT_1":
        text("bubble-sort", 30, 30);
        break;
      case "BUBBLE_SORT_2":
        text("bubble-sort", 30, 30);
        break;
      case "INSERTION_SORT":
        text("insertion-sort", 30, 30);
        break;
      case "SELECTION_SORT":
        text("selection-sort", 30, 30);
        break;
      default:
        println("Invalid algorithm choice. Typo?");
        break;
    }
    textSize(14);
    text(SQUARE_COUNT + " elements", 30, 60);
    text("data set: " + DATA_SET.toLowerCase(), 30, 80);
  } 
  delay(DELAY_BETWEEN_FRAMES);

}

// Populate the SortableSquare array with SortableSquare objects.
void initSquares() {
  int sizeArray[] = new int[SQUARE_COUNT];
  
  // Choose a set of sizes specified by DATA_SET
  switch(DATA_SET.toLowerCase()) {
    case "random":
      for (int i = 0; i < SQUARE_COUNT; i++) {
        sizeArray[i] = (int) random(MIN_SQUARE_SIZE, MAX_SQUARE_SIZE);
      }
      break;
    case "sorted": 
      // evenly distribute from min to max size.
      for (int i = 0; i < SQUARE_COUNT; i++) {
        sizeArray[i] = MIN_SQUARE_SIZE + (int)(((MAX_SQUARE_SIZE - MIN_SQUARE_SIZE)/(float)SQUARE_COUNT) * i);
      }
      break;
    case "reverse":
    // reverse of sorted. should provide some really lousy behavior for some searches. (N^2, yay!)
      for (int i = 0; i < SQUARE_COUNT; i++) {
        sizeArray[i] = MAX_SQUARE_SIZE - (int)(((MAX_SQUARE_SIZE - MIN_SQUARE_SIZE)/(float)SQUARE_COUNT) * i);
      }
      break;
    case "user":
      // todo. fixed values for now.
      for (int i = 0; i < SQUARE_COUNT; i++) {
        sizeArray[i] = (MAX_SQUARE_SIZE + MIN_SQUARE_SIZE) / 2;
      }
      break;
    default:
      System.out.println("Invalid value for data set: " + DATA_SET);
      break;
  }

  
  
  for(int i = 0; i < SQUARE_COUNT; i++) {
    int size = sizeArray[i];
    // TODO: square color as a function of square size
    PVector squareColor = new PVector(random(255), random(255), random(255));
    PVector squarePos = new PVector(0, 0); // value updated after entire list is generated
    boolean compared = false;
    SortableSquare square = new SortableSquare(size, squareColor, OPACITY, squarePos, compared);
    sortableSquares[i] = square;
  }
}

// Sort the SortableSquare array with the sorting algorithm defined in ALGORITHM.
void sortSquares(SortableSquare[] sortableSquares) {
  switch(ALGORITHM) {
    case "BUBBLE_SORT_1":
      bubbleSort1(sortableSquares);
      break;
    case "BUBBLE_SORT_2":
      bubbleSort2(sortableSquares);
      break;
    case "INSERTION_SORT":
      insertionSort(sortableSquares);
      break;
    case "SELECTION_SORT":
      selectionSort(sortableSquares);
      break;
    default:
      println("Invalid algorithm choice. Typo?");
      break;
  }
}

// Sorts the SortableSquare array using insertion sort.
// Stores every state of sortableSquares in ssHistory as it is sorted. 
void insertionSort(SortableSquare[] sortableSquares) {
  ssHistory = new ArrayList<SortableSquare[]>();

  // Store the initial array in ssHistory
  ssHistory.add(copyAndCircularizeArray(sortableSquares, -1, -1));
  for(int i = 1; i < SQUARE_COUNT; i++) {
    int j = i;
    SortableSquare temp = sortableSquares[i];
    while(j > 0 && sortableSquares[j].compareTo(sortableSquares[j - 1]) < 0) {
      sortableSquares[j] = sortableSquares[j - 1];
      sortableSquares[j - 1] = temp;
      j--;
      if(DRAW_SWAPS){
        ssHistory.add(copyAndCircularizeArray(sortableSquares, j, j - 1));
      }
    }
    ssHistory.add(copyAndCircularizeArray(sortableSquares, -1, -1));
  }
}

// Bubble sort implementation using two for loops.
void bubbleSort1(SortableSquare[] sortableSquares) {
  ssHistory = new ArrayList<SortableSquare[]>();
  ssHistory.add(copyAndCircularizeArray(sortableSquares, -1, -1));
  for(int i = 0; i < SQUARE_COUNT - 1; i++) {
    for(int j = 0; j < SQUARE_COUNT - i - 1; j++) {
      if(sortableSquares[j].compareTo(sortableSquares[j + 1]) > 0) {
        SortableSquare temp = sortableSquares[j + 1];
        sortableSquares[j + 1] = sortableSquares[j];
        sortableSquares[j] = temp;
      }
      ssHistory.add(copyAndCircularizeArray(sortableSquares, j, j + 1));
    }
  }
}

// Bubble sort implementation using a while and a for loop.
void bubbleSort2(SortableSquare[] sortableSquares) {
  ssHistory = new ArrayList<SortableSquare[]>();
  ssHistory.add(copyAndCircularizeArray(sortableSquares, -1, -1));
  boolean isSorted = false;
  while(!isSorted) {
    isSorted = true;
    for(int i = 0; i < SQUARE_COUNT - 1; i++) {
      if(sortableSquares[i].compareTo(sortableSquares[i + 1]) > 0) {
        SortableSquare temp = sortableSquares[i + 1];
        sortableSquares[i + 1] = sortableSquares[i];
        sortableSquares[i] = temp;
        isSorted = false;
      }
      ssHistory.add(copyAndCircularizeArray(sortableSquares, i, i + 1));
    }
  }
}

// Sorts the array using selection sort. 
void selectionSort(SortableSquare[] sortableSquares) {
  ssHistory = new ArrayList<SortableSquare[]>();
  ssHistory.add(copyAndCircularizeArray(sortableSquares, -1, -1));
  for(int i = 0; i < SQUARE_COUNT - 1; i++) {
    // Assume arr[i] is the smallest and search for a smaller square.
    int min = i;
    for(int j = i + 1; j < SQUARE_COUNT; j++) {
      // Check if the current square is smaller than the smallest found so far.
      if(sortableSquares[j].compareTo(sortableSquares[min]) < 0) {
        min = j;
      }
      ssHistory.add(copyAndCircularizeArray(sortableSquares, j, min));
    }
    // If a smaller square has been found, swap arr[i] with arr[min].
    if(min != i) {
      SortableSquare temp = sortableSquares[i];
      sortableSquares[i] = sortableSquares[min];
      sortableSquares[min] = temp;
    }
    ssHistory.add(copyAndCircularizeArray(sortableSquares, -1, -1));
  }
}

// Copy each square into a new array. 
// Calculate where each square should be drawn on the ring.
SortableSquare[] copyAndCircularizeArray(SortableSquare[] source, int compA, int compB) {
  SortableSquare[] dest = new SortableSquare[SQUARE_COUNT];
  for(int i = 0; i < SQUARE_COUNT; i++) {
    dest[i] = new SortableSquare(source[i]);
    float x = (width/2) - sin(angle * i) * circleRadius;
    float y = (height/2) - cos(angle * i) * circleRadius;
    dest[i].pos = new PVector(x, y);
    if(i == compA || i == compB) {
      dest[i].compared = true;
    } else {
      dest[i].compared = false;
    }
  }
  return dest;
}

// Takes a screenshot of the sketch when any key is pressed. 
void keyTyped() {
  saveFrame(ALGORITHM + "####.png");
}

// Debugging sorting algorithm implementations.
void printSquareArray(SortableSquare[] sortableSquares) {
  for(int i = 0; i < SQUARE_COUNT; i++) {
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
  boolean compared;
  
  public SortableSquare(int size, PVector col, float opacity, PVector pos, boolean compared) {
    this.size = size;
    this.col = col;
    this.opacity = opacity;
    this.pos = pos;
    this.compared = compared;
  }
  
  public SortableSquare(SortableSquare copySquare) {
    this.size = copySquare.size;
    this.col = copySquare.col;
    this.opacity = copySquare.opacity;
    this.pos = new PVector(copySquare.pos.x, copySquare.pos.y);
    this.compared = copySquare.compared;
  }

  // Returns a positive value when self is larger than other.
  // Similarly, returns a negative value when self is smaller than other.
  int compareTo(SortableSquare other) {
    int result = this.getSize() - other.getSize();
    return result;
  }
  
  int getSize() {
    return this.size;
  }
}
