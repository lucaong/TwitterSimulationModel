class Vector {
  public float x;
  public float y;
  public float z;
  
  Vector() {
    this.x = 0.0;
    this.y = 0.0;
    this.z = 0.0;
  }
  
  Vector(float[] rangeX, float[] rangeY, float[] rangeZ) {
    this.x = random(rangeX[0], rangeX[1]);
    this.y = random(rangeY[0], rangeY[1]);
    this.z = random(rangeZ[0], rangeZ[1]);
  }
  
  Vector(float c) {
    this.x = c;
    this.y = c;
    this.z = c;
  }
  
  Vector(float x, float y) {
    this.x = x;
    this.y = y;
    this.z = 0.0;
  }
  
  Vector(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  float distance(Vector other) {
    return sqrt(sq(this.x - other.x) + sq(this.y - other.y) + sq(this.z - other.z));
  }
  
  Vector subtract(Vector other) {
    return new Vector(this.x - other.x, this.y - other.y, this.z - other.z);
  }
  
  Vector sum(Vector other) {
    return new Vector(this.x + other.x, this.y + other.y, this.z + other.z);
  }
  
  Vector multiply(float n) {
    return new Vector(this.x * n, this.y * n, this.z * n);
  }
  
  String asString() {
    return this.x + "," + this.y + "," + this.z;
  }
}
