

import de.bezier.guido.*;
public final static int NUM_ROWS =20;
public final static int NUM_COLS = 20;
public final static int NUM_BOMBS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton> ();

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to declare and initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for(int r=0;r<NUM_ROWS;r++)
    for(int c=0;c<NUM_COLS;c++)
      buttons[r][c]=new MSButton(r,c);
    
    setBombs();
}
public void setBombs()
{
    while(bombs.size()<NUM_BOMBS)
    {
      int row = (int)(Math.random()*NUM_ROWS);
      int col = (int)(Math.random()*NUM_COLS);
      if(!bombs.contains(buttons[row][col]))
      {
        bombs.add(buttons[row][col]);
        //System.out.println(row+","+col);
      }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();

}
public boolean isWon()
{
    //your code here
    int check = 0;
    for(int r=0; r<NUM_ROWS; r++)
    {
      for(int c=0; c<NUM_COLS; c++)
      {
      if(buttons[r][c].isMarked()==true && bombs.contains(buttons[r][c]))
      check++;
      }
    }
    if(check == NUM_BOMBS)
    return true;
    else
    return false;
    
}
public void displayLosingMessage()
{
    buttons[9][4].setLabel("Y");
    buttons[9][5].setLabel("O");
    buttons[9][6].setLabel("U");
    buttons[9][8].setLabel("L");
    buttons[9][9].setLabel("O");
    buttons[9][10].setLabel("S");
    buttons[9][11].setLabel("E");
    buttons[9][12].setLabel("!");
    buttons[9][13].setLabel("!");
    buttons[9][14].setLabel("!");
    buttons[9][15].setLabel("!");
}
public void displayWinningMessage()
{
    buttons[9][4].setLabel("Y");
    buttons[9][5].setLabel("O");
    buttons[9][6].setLabel("U");
    buttons[9][8].setLabel("W");
    buttons[9][9].setLabel("I");
    buttons[9][10].setLabel("N");
    buttons[9][11].setLabel("!");
    buttons[9][12].setLabel("!");
    buttons[9][13].setLabel("!");
    buttons[9][14].setLabel("!");
    buttons[9][15].setLabel("!");
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
         width = 400/NUM_COLS;
         height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        //your code here
        if(mouseButton == RIGHT)
        {
          if(marked == false)
          {
            marked = true;
            clicked = false;
          }
          else
          {
            marked = false;
            clicked = false;
          }
        }
        else if(bombs.contains(this))
        displayLosingMessage();
        else if(countBombs(r,c)>0)
        label = "" + countBombs(r,c);
        else
        {
          if(isValid(r,c-1) && !buttons[r][c-1].isClicked())
          buttons[r][c-1].mousePressed(); //left
          if(isValid(r,c+1) && !buttons[r][c+1].isClicked())
          buttons[r][c+1].mousePressed(); //right
          if(isValid(r-1,c) && !buttons[r-1][c].isClicked())
          buttons[r-1][c].mousePressed(); //top
          if(isValid(r+1,c) && !buttons[r+1][c].isClicked())
          buttons[r+1][c].mousePressed(); //bottom
          if(isValid(r-1,c-1) && !buttons[r-1][c-1].isClicked())
          buttons[r-1][c-1].mousePressed(); //top left diagonal
          if(isValid(r+1,c-1) && !buttons[r+1][c-1].isClicked())
          buttons[r+1][c-1].mousePressed(); //bottom left diagonal
          if(isValid(r-1,c+1) && !buttons[r-1][c+1].isClicked())
          buttons[r-1][c+1].mousePressed(); //top right diagonal
          if(isValid(r+1,c+1) && !buttons[r+1][c+1].isClicked())
          buttons[r+1][c+1].mousePressed(); //bottom right diagonal
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else
            fill( 100 );
            

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if(r>=0 && r<NUM_ROWS && c>=0 && c<NUM_COLS)
        return true;
        else
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        if(isValid(row,col-1)==true && bombs.contains(buttons[row][col-1]))//left
        numBombs++;
        if(isValid(row,col+1)==true && bombs.contains(buttons[row][col+1]))//right
        numBombs++;
        if(isValid(row-1,col)==true && bombs.contains(buttons[row-1][col]))//top
        numBombs++;
        if(isValid(row+1,col)==true && bombs.contains(buttons[row+1][col]))//bottom
        numBombs++;
        if(isValid(row-1,col-1)==true && bombs.contains(buttons[row-1][col-1]))//top left diagonal
        numBombs++;
        if(isValid(row+1,col-1)==true && bombs.contains(buttons[row+1][col-1]))//bottom left diagonal
        numBombs++;
        if(isValid(row-1,col+1)==true && bombs.contains(buttons[row-1][col+1]))//top right diagonal
        numBombs++;
        if(isValid(row+1,col+1)==true && bombs.contains(buttons[row+1][col+1]))//bottom right diagonal
        numBombs++;
        return numBombs;
    }
}