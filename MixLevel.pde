///////////////////////////////////////////////////////////////////////////////
// MixLevel.pde
//
// Copyright (c) 2012 Jeffrey P. Hoskinson
// All rights reserved.
///////////////////////////////////////////////////////////////////////////////

public class MixLevel implements Visualization
{
  public MixLevel()
  {
  }
  
  public void setup( AudioSource source )
  {
  }
  
  public color[] visualize( AudioSource in )
  {
    color[] results = new color[ NUM_LIGHTS ];
  
    int numLightsOn = (int) ( in.mix.level() * (float) NUM_LIGHTS );
    for ( int i = 0; i < NUM_LIGHTS; i++ )
    {
      if ( i < numLightsOn )
      {
        results[ i ] = LIGHT_COLORS[ i ];
      } 
      else
      {
        results[ i ] = color( 0, 0, 0 );
      }
    }
  
    return results;
  }
  
  public void teardown()
  {
  }
}
