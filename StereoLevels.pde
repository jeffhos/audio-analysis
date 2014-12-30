///////////////////////////////////////////////////////////////////////////////
// StereoLevels.pde
//
// Copyright (c) 2012 Jeffrey P. Hoskinson
// All rights reserved.
///////////////////////////////////////////////////////////////////////////////

public class StereoLevels implements Visualization
{
  public StereoLevels()
  {
  }
  
  public void setup( AudioSource source )
  {
  }
  
  public color[] visualize( AudioSource in )
  {
    color[] results = new color[ NUM_LIGHTS ];
    int leftLights = (int) ( in.left.level() * HALF_LIGHTS );
    int rightLights = (int) ( in.right.level() * HALF_LIGHTS );
    
    for ( int i = 0; i < NUM_LIGHTS; i++ )
    {
      results[ i ] = color( 0, 0, 0 );
    }
    
    for ( int i = 0; i < leftLights; i++ )
    {
      results[ i ] = LIGHT_COLORS[ i * 2 ];
    }
    
    for ( int i = 0; i < rightLights; i++ )
    {
      results[ NUM_LIGHTS - i - 1 ] = LIGHT_COLORS[ i * 2 ];
    }
    
    return results;
  }
  
  
  public void teardown()
  {
  }
}
