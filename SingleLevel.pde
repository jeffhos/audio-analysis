///////////////////////////////////////////////////////////////////////////////
// SingleLevel.pde
//
// Copyright (c) 2012 Jeffrey P. Hoskinson
// All rights reserved.
///////////////////////////////////////////////////////////////////////////////

public class SingleLevel implements Visualization
{
  public SingleLevel()
  {
  }
  
  public void setup( AudioSource source )
  {
  }
  
  public color[] visualize( AudioSource in )
  {
    color[] results = new color[ NUM_LIGHTS ];  
    int level = (int) ( in.mix.level() * 255 );  
    for ( int i = 0; i < NUM_LIGHTS; i++ )
    {
      results[ i ] = color( level, level, level );
    }
    
    return results;
  }
  
  public void teardown()
  {
  }
}
