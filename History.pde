///////////////////////////////////////////////////////////////////////////////
// History.pde
//
// Copyright (c) 2012 Jeffrey P. Hoskinson
// All rights reserved.
///////////////////////////////////////////////////////////////////////////////

public class History implements Visualization
{
  public History()
  {
  }
  
  public void setup( AudioSource source )
  {
  }
  
  public color[] visualize( AudioSource in )
  {
    int value = (int) ( in.mix.level() * 1536.0 );
    color newLightColor = wheel( value );
  
    arrayCopy( lightHistory, 0, lightHistory, 1, NUM_LIGHTS - 1 );
    lightHistory[ 0 ] = newLightColor;
  
    return lightHistory;
  }
  
  public void teardown()
  {
  }
  
  final color[] lightHistory = new color[ NUM_LIGHTS ];
}
