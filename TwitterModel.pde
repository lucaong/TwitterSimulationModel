int NUMBER_OF_AGENTS = 500;
float drag = 0.05;
float elastic_constant = 0.002;
float repulsion = 10.0;
boolean reach_highlight_mode = false;
int selected_agent = 10;

Agent[] agents;

void setup() {
  size(900, 700);
  background(#000000);
  agents = new Agent[NUMBER_OF_AGENTS];
  for(int i = 0; i < NUMBER_OF_AGENTS; i++) {
    agents[i] = new Agent(i);
  }
  for(int i = 0; i < NUMBER_OF_AGENTS; i++) {
    int k = 0;
    int j = i + 1;
    float kk = random(1, 3);
    while(k < kk && j != i) {
      if(j >= NUMBER_OF_AGENTS) {
        j = 0;
      }
      if(j != i && random(0.1) < (442.0/(agents[i].preference.distance(agents[j].preference) + 442.0) - 0.9))
      {
        agents[i].following[k] = j;
        k++;
        stroke(255, 255, 255, 30);
        line(agents[i].position.x, agents[i].position.y, agents[j].position.x, agents[j].position.y);
      }
      j++;
    }
    stroke(agents[i].c());
    fill(agents[i].c());
    ellipse(agents[i].position.x, agents[i].position.y, 10, 10);
  }
  noStroke();
}

void draw() {
  background(#000000);
  int tot_links = 0;
  for(int i = 0; i < NUMBER_OF_AGENTS; i++) {
    agents[i].speed = agents[i].speed.sum(agents[i].force).multiply(drag);
    agents[i].position = agents[i].position.sum(agents[i].speed);
    agents[i].force = new Vector(0.0, 0.0, 0.0);
  }
  for(int i = 0; i < NUMBER_OF_AGENTS; i++) {
    for(int j = 0; j < NUMBER_OF_AGENTS; j++) {
      if(i != j) {
        agents[i].force = agents[i].force.sum(agents[i].position.subtract(agents[j].position).multiply(repulsion/sq(agents[j].position.distance(agents[i].position))));
        if(agents[i].follows(j) == true || agents[j].follows(i) == true) {
          agents[i].force = agents[i].force.sum(agents[j].position.subtract(agents[i].position).multiply(elastic_constant*agents[j].position.distance(agents[i].position)));
        }
      }
    }
    boolean retwitting = false;
    if(random(1.0) < agents[i].retweet_rate) {
      // retweet
      retwitting = agents[i].retweet();
    } else {
      agents[i].tweet();
    }
    if(reach_highlight_mode) {
      if(i == selected_agent) {
        stroke(0, 255, 0, 255);
        fill(0, 255, 0, 255);
      } else if(agents[selected_agent].can_see(i)) {
        stroke(255, 0, 0, 255);
        fill(255, 0, 0, 255);
      } else {
        stroke(255, 255, 255, 30);
        fill(255, 255, 255, 30);
      }
    } else {
      stroke(agents[i].c());
      fill(agents[i].c());
    }
    if (retwitting) {
      ellipse(agents[i].position.x, agents[i].position.y, 10, 10);
    } else {
      ellipse(agents[i].position.x, agents[i].position.y, 7, 7);
    }
    int n = 0;
    for(n = 0; n < agents[i].following.length && agents[i].following[n] >= 0; n++) {
      stroke(255, 255, 255, 30);
      line(agents[i].position.x, agents[i].position.y, agents[agents[i].following[n]].position.x, agents[agents[i].following[n]].position.y);
    }
    tot_links += n;
  }
  println(tot_links);
}

void keyPressed() {
  if (key == 'n' || key == 'N') {
    PrintWriter output = createWriter("network.csv");
    String row;
    for(int i = 0; i < NUMBER_OF_AGENTS; i++) {
      row = "";
      for(int j = 0; j < NUMBER_OF_AGENTS; j++) {
        if(j > 0) {
          row += ",";
        }
        row += agents[i].follows(j) ? "1" : "0";
      }
      output.println(row);
    }
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
  }
  else if (key == 'u' || key == 'U') {
    PrintWriter output = createWriter("users.csv");
    output.println("\"id\",\"preference_x\",\"preference_y\",\"preference_z\",\"retweet_rate\"");
    String row;
    for(int i = 0; i < NUMBER_OF_AGENTS; i++) {
      row = agents[i].id + "," + agents[i].preference.asString() +"," + agents[i].retweet_rate;
      output.println(row);
    }
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
  }
  else if (key == 'r' || key == 'R') {
    reach_highlight_mode = !reach_highlight_mode;
  }
  else if (key == CODED) {
    if (keyCode == UP) {
      selected_agent++;
      if(selected_agent > 500) {
        selected_agent = 0;
      }
    }
    else if (keyCode == DOWN) {
      selected_agent--;
      if(selected_agent < 0) {
        selected_agent = 500;
      }
    }
  }
}
