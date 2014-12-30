///////////////////////////////////////////////////////////////////////////////
// Visualization.pde
//
// Copyright (c) 2012 Jeffrey P. Hoskinson
// All rights reserved.
///////////////////////////////////////////////////////////////////////////////

public interface Visualization
{
  public void setup( AudioSource source );
  public color[] visualize( AudioSource source );
  public void teardown();
}
