#include "Scripts/outlyer/InputBasics.as"
#include "Scripts/outlyer/Pawn.as"
#include "Scripts/outlyer/Graph.as"

class InputPlayer : InputBasics{

  Node@ node_;
  Graph@ graph_;
  Node@ camera_node_;

  float mouse_sensitivity_ = 0.1f;

  InputPlayer(uint i){
    super(i);
    SubscribeToEvent("Update", "update");
  }

  void update(StringHash eventType, VariantMap& eventData){
    float timeStep = eventData["TimeStep"].GetFloat();
    ui.cursor.visible = !input.mouseButtonDown[MOUSEB_RIGHT];
    Vector3 direction = Vector3(0.0f,0.0f,0.0f);

    // Do not move if the UI has a focused element (the console)
    if (ui.focusElement !is null)
        return;

    // Use this frame's mouse motion to adjust camera node yaw and pitch. Clamp the pitch between -90 and 90 degrees
    // Only move the camera when the cursor is hidden
    if (!ui.cursor.visible){//this makes it update only on right mouse down
      move_mouse(input.mouseMove);
    }

    if (input.mouseButtonPress[MOUSEB_LEFT])
        left_mouse();

    // Read WASD keys and move the camera scene node to the corresponding direction if they are pressed
    if (input.keyDown['W'])
      direction+=Vector3(0.0f, 0.0f, 1.0f);
    if (input.keyDown['S'])
      direction+=Vector3(0.0f, 0.0f, -1.0f);
    if (input.keyDown['A'])
      direction+=Vector3(-1.0f, 0.0f, 0.0f);
    if (input.keyDown['D'])
      direction+=Vector3(1.0f, 0.0f, 0.0f);

    if(direction.length>0.5)
      move(direction.Normalized(),timeStep);

  }
  //------------------------
  void set_controlnode(Node@ control_node){
    Pawn@ pawn = cast<Pawn>(control_node.scriptObject);
    if (pawn !is null)
      node_ = control_node;
  }
  void set_graph(Graph@ graph){
    graph_ = graph;
  }
  void set_cameranode(Node@ cameranode){
    camera_node_ = cameranode;
  }
  //---------what to do with inputs, send to the controller
  void move( Vector3 direction, float timeStep){
    if(node_ !is null){
      Pawn@ pawn = cast<Pawn>(node_.scriptObject);
      pawn.move( direction, timeStep);
    }
  }
  void move_mouse(IntVector2 mousemove){
    if(camera_node_ is null)
      return;
    CameraLogic@ camera_logic_ = cast<CameraLogic>(camera_node_.GetScriptObject("CameraLogic"));
    if(camera_logic_ is null)
      return;
    camera_logic_.move_mouse(mousemove,mouse_sensitivity_);
  }
  void left_mouse(){
    if(node_ !is null){

      Pawn@ pawn = cast<Pawn>(node_.scriptObject);

      Vector3 target_position = Vector3(0.0f,1.0f,0.0f);

      if(graph_ !is null)
        target_position = graph_.hit_;

      pawn.fire_projectile(target_position);
    }
  }
}
