//class Character : ScriptObject{
//#include "Scripts/outlyer/InputPlayer.as"
#include "Scripts/outlyer/Pawn.as"
//#include "Scripts/outlyer/ControllerPlayer.as"
#include "Scripts/outlyer/Actor.as"
#include "Scripts/outlyer/ProjectileExploder.as"
#include "Scripts/outlyer/ProjectileNoisy.as"

//class Character : InputPlayer{
class Character{
  Node@ node_;

  Character(Scene@ scene){

    node_ = scene.CreateChild("Character");

    StaticModel@ coneObject = node_.CreateComponent("StaticModel");
    coneObject.model = cache.GetResource("Model", "Models/Cone.mdl");
    coneObject.material = cache.GetResource("Material", "Materials/StoneTiled.xml");
    //---------------------------

    RigidBody@ body_ = node_.CreateComponent("RigidBody");
    body_.mass = 0.25f;
    body_.friction = 0.75f;
    body_.linearDamping = 0.6f;
    body_.useGravity = false;

    body_.mass=10.0f;//heavy mass makes it so stuff doesnt effect it as much
    //body_.angularDamping = 1000.0f;
    body_.angularFactor = Vector3(0.0f, 0.0f, 0.0f);
    body_.collisionEventMode = COLLISION_ALWAYS;

    CollisionShape@ shape = node_.CreateComponent("CollisionShape");
    shape.SetBox(Vector3(1.0f, 1.0f, 1.0f));

    Character_Script@ character_script_ = cast<Character_Script>(node_.CreateScriptObject(scriptFile, "Character_Script"));
  }

  //-------from old pawn
  /*void set_position(Vector3 pos){
    node_.position = pos;
  }

  void set_enemytarget(Node@ target){
    enemytarget_ = target;
  }*/

}


class Character_Script:Pawn{

  void Update(float timeStep){
    float my_y = node.position.y;
    if(my_y<0){
      RigidBody@ body_ = node.GetComponent("RigidBody");
      body_.linearVelocity =body_.linearVelocity*Vector3(1.0f,0.0f,1.0f);
      node.position=Vector3(node.position.x,0.0f,node.position.z);
    }
  }
  //projetiles are so far specifically exploder variety
  void spawn_projectile(Vector3 dir, Vector3 hit = Vector3(0.0f,0.0f,0.0f)){
    Vector3 pos = node.position+(dir.Normalized()*1.4f);
    const float OBJECT_VELOCITY = 4.5f;
    //Projectile@ projectile_ = Projectile(node.scene,pos,dir,OBJECT_VELOCITY,hit);
    //ProjectileExploder@ projectile_ = ProjectileExploder(node.scene,node.position,dir,OBJECT_VELOCITY,hit);
    ProjectileNoisy@ projectile_ = ProjectileNoisy(node.scene,node.position,dir,OBJECT_VELOCITY,hit);
  }
}
