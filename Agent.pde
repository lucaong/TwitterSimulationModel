class Agent {
  public int id;
  public Status[] timeline = new Status[10];
  public int[] following;
  public Vector position;
  public Vector speed;
  public Vector force;
  public Vector preference;
  
  private float retweet_rate = random(0.4);
  private int following_capacity = ceil(random(5, 15));
  
  Agent(int id) {
    this.id = id;
    this.preference = new Vector(random(255), random(255), random(255));
    this.following = new int[this.following_capacity];
    //this.position = new Vector(random(width), random(height));
    this.position = new Vector(width/2.0 + (width/2.0 - 15)*cos(id*(TWO_PI/NUMBER_OF_AGENTS)), height/2.0 + (height/2.0 - 15)*sin(id*(TWO_PI/NUMBER_OF_AGENTS)));
    this.speed = new Vector(0.0, 0.0);
    this.force = new Vector(0.0, 0.0);
    this.timeline[0] = new Status(this.id, this.preference);
    for(int i = 0; i < this.following_capacity; i++) {
      this.following[i] = -1;
    }
  }
  
  void tweet() {
    for(int i = 9; i > 0; i--) {
      this.timeline[i] = this.timeline[i - 1];
    }
    this.timeline[0] = new Status(this.id, new Vector(this.preference.x + random(-50, 50), this.preference.y + random(-50, 50), this.preference.z + random(-50, 50)));
  }
  
  boolean retweet() {
    boolean r = false;
    Status best_status = new Status(this.id, new Vector(this.preference.x + random(-80, 80), this.preference.y + random(-80, 80), this.preference.z + random(-80, 80)));
    float min_distance = best_status.content.distance(this.preference);
    for(int i = 0; i < this.following_capacity; i++) {
      for(int k = 0; k < 9 && this.following[i] >= 0 && agents[this.following[i]].timeline[k] != null; k++) {
        if(this.following[i] >= 0 && !this.has_in_timeline(agents[this.following[i]].timeline[k]) && agents[this.following[i]].timeline[k].user_id != this.id && agents[this.following[i]].timeline[k].content.distance(this.preference) < min_distance) {
          best_status = agents[this.following[i]].timeline[k];
          min_distance = best_status.content.distance(this.preference);
          r = true;
        }
      }
    }
    for(int i = 9; i > 0; i--) {
      this.timeline[i] = this.timeline[i - 1];
    }
    this.timeline[0] = best_status;
    if(min_distance < sqrt(sq(30)*3) && this.follows(best_status.user_id) == false && best_status.user_id != this.id) {
      considerFollowing(best_status.user_id);
    }
    return r;
  }
  
  void considerFollowing(int user_id) {
    for(int i = 0; i < this.following_capacity; i++) {
      if(this.following[i] < 0) {
        this.following[i] = user_id;
        println(this.id + " -> " + user_id);
        break;
      }
    }
  }
  
  color c() {
    return color(this.preference.x, this.preference.y, this.preference.z);
  }
  
  boolean follows(int user_id) {
    boolean r = false;
    for(int i = 0; i < this.following_capacity; i++) {
      if(this.following[i] < 0) {
        break;
      } else if (this.following[i] == user_id) {
        r = true;
        break;
      }
    }
    return r;
  }
  
  boolean has_in_timeline(Status s) {
    boolean r = false;
    for(int i = 0; i < 10; i++) {
      if(this.timeline[i] == null) {
        break;
      } else if (this.timeline[i] == s) {
        r = true;
        break;
      }
    }
    return r;
  }
  
  boolean has_in_timeline(Integer a) {
    for(int i = 0; i < 10; i++) {
      if(this.timeline[i] == null) {
        break;
      } else if (this.timeline[i].user_id == a) {
        return true;
      }
    }
    return false;
  }
  
  boolean can_see(Integer a) {
    for(int i = 0; i < this.following_capacity; i++) {
      if(this.following[i] < 0) {
        break;
      }
      for(int k = 0; k < 10 && agents[this.following[i]].timeline[k] != null; k++) {
        if(agents[this.following[i]].timeline[k].user_id == a) {
          return true;
        }
      }
    }
    return false;
  }
}

class Status {
  public int user_id;
  public Vector content;
  
  Status(int user_id, Vector content) {
    this.user_id = user_id;
    this.content = content;
  }
  
  color c() {
    return color(this.content.x, this.content.y, this.content.z);
  }
}
