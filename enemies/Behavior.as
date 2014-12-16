#include "Scripts/shmup/core/Pawn.as";
class Behavior{
  Node@ slave_;
  int mirror_;//if we mirror this effect
  float speed_=5.0f;//incase we dont find one, we should
  Behavior(Node@ slave,const int&in mirror = 0){
    slave_ = slave;
    Pawn@ p = cast<Pawn>(slave_.scriptObject);//get the script that controls this enemy
    speed_ = p.speed_;//get the speed from it to appy here
  }
  void update(float timeStep){
    RigidBody@ body = slave_.GetComponent("RigidBody");
    Pawn@ pawn = cast<Pawn>(slave_.scriptObject);//get the script object, so I can call functions on it
    Node@ target_node = slave_.scene.GetChild("Character",true);//get the main character

    //body_.linearVelocity = body_.linearVelocity+Vector3(0.0f,0.0f,-0.1f);
    body.linearVelocity = Vector3(0.0f,0.0f,-speed_);
    pawn.fire(target_node.worldPosition,timeStep);
  }
}
