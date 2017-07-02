//: # Gravity Lab
//  Copyright © 2017 Wei Huang. All rights reserved.
// - Attribution: Colors - developer.apple.com & material.io

import UIKit
import SpriteKit
import PlaygroundSupport

//: ### Shared variables & constants
let indego50 = #colorLiteral(red:0.91, green:0.92, blue:0.96, alpha:1.0), indego100 = #colorLiteral(red:0.77, green:0.79, blue:0.91, alpha:1.0), indego200 = #colorLiteral(red:0.62, green:0.66, blue:0.85, alpha:1.0), indego300 = #colorLiteral(red:0.47, green:0.53, blue:0.80, alpha:1.0), indego400 = #colorLiteral(red:0.36, green:0.42, blue:0.75, alpha:1.0), indego500 = #colorLiteral(red:0.25, green:0.32, blue:0.71, alpha:1.0), indego600 = #colorLiteral(red:0.22, green:0.29, blue:0.67, alpha:1.0), indego700 = #colorLiteral(red:0.19, green:0.25, blue:0.62, alpha:1.0), indego800 = #colorLiteral(red:0.16, green:0.21, blue:0.58, alpha:1.0), indego900 =  #colorLiteral(red:0.10, green:0.14, blue:0.49, alpha:1.0), indegoA100 = #colorLiteral(red:0.55, green:0.62, blue:1.00, alpha:1.0), indegoA200 = #colorLiteral(red:0.33, green:0.43, blue:1.00, alpha:1.0), indegoA400 = #colorLiteral(red:0.24, green:0.35, blue:1.00, alpha:1.0), indegoA700 = #colorLiteral(red:0.19, green:0.31, blue:1.00, alpha:1.0),  lightLightGray = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
let backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
let sceneColor = indegoA100
let kickoffTintColor = indego500
let dashboardTintColor = indegoA100
let astronautSelection = ["🐷", "🐹", "🐻", "🐶", "🐼", "🦊", "🐯", "🐮", "🐨", "🐰", "🐱", "🐭", "🐵", "🦁"]
var randomAstronaut = ""
var astronauts = [String]()
var astronautBodies = [SKLabelNode]()
var affectedByGravity = true
var isDynamic = true
var allowsRotation = true
var friction: CGFloat = 0
var restitution: CGFloat = 0.5
var linearDamping: CGFloat = 0
var angularDamping: CGFloat = 0
var gravityDx: CGFloat = 0
var gravityDy: CGFloat = 0
var impulseDx: CGFloat = 3
var impulseDy: CGFloat = 3

//: ### Scene
class Scene: SKScene, DashboardDelegate {
    var selectedNode: SKNode?
    var borderBody: SKPhysicsBody?
    
    // Init
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Setup
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        // Background color
        self.backgroundColor = sceneColor
        // Apply physics to frame border
        borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = borderBody
        // Add background objects
        addBackgroundElements()
    }
    
    // Update physics attributes
    func updatePhysics() {
        // update physics for astronaut
        for astr in astronautBodies {
            astr.physicsBody?.affectedByGravity = affectedByGravity
            astr.physicsBody?.isDynamic = isDynamic
            astr.physicsBody?.allowsRotation = allowsRotation
            astr.physicsBody?.friction = friction
            astr.physicsBody?.restitution = restitution
            astr.physicsBody?.linearDamping = linearDamping
            astr.physicsBody?.angularDamping = angularDamping
        }
        // update physics for frame border
        borderBody?.friction = friction
        // update physics for physics world
        physicsWorld.gravity = CGVector(dx: gravityDx, dy: gravityDy)
    }
    
    // Add background elements
    func addBackgroundElements() {
        // Planet One
        let planetOne = SKLabelNode(text: "\u{25CF}")
        planetOne.fontSize = 100
        planetOne.fontColor = indego300
        planetOne.alpha = 1
        planetOne.horizontalAlignmentMode = .center
        planetOne.verticalAlignmentMode = .center
        planetOne.physicsBody = SKPhysicsBody(circleOfRadius: max(planetOne.frame.width / 2,
                                                               planetOne.frame.height / 2))
        planetOne.physicsBody?.isDynamic = false
        planetOne.position = CGPoint(x: self.frame.minX-10, y: 200)
        addChild(planetOne)
        // Planet Two
        let planetTwo = SKLabelNode(text: "\u{25CF}")
        planetTwo.fontSize = 400
        planetTwo.fontColor = indego400
        planetTwo.alpha = 1
        planetTwo.horizontalAlignmentMode = .center
        planetTwo.verticalAlignmentMode = .center
        planetTwo.physicsBody = SKPhysicsBody(circleOfRadius: max(planetTwo.frame.width / 2,
                                                                  planetTwo.frame.height / 2))
        planetTwo.physicsBody?.isDynamic = false
        planetTwo.position = CGPoint(x: self.frame.maxX, y: self.frame.maxY)
        addChild(planetTwo)
    }
    
    // Add an astronaut
    func addAstronaut() {
        randomAstronaut = astronautSelection[Int(arc4random_uniform(UInt32(astronautSelection.count)))]
        // helmet
        let helmet = SKLabelNode(text: "\u{25CF}")
        helmet.fontSize = 40
        helmet.alpha = 0.8
        helmet.horizontalAlignmentMode = .center
        helmet.verticalAlignmentMode = .center
        helmet.physicsBody = SKPhysicsBody(circleOfRadius: max(helmet.frame.width / 2,
                                                               helmet.frame.height / 2))
        helmet.position = CGPoint(x: 30, y: 40)
        astronautBodies.append(helmet)
        addChild(helmet)
        // body
        let body = SKLabelNode(text: "\u{25A0}")
        body.fontSize = 20
        body.horizontalAlignmentMode = .center
        body.verticalAlignmentMode = .center
        body.physicsBody = SKPhysicsBody(circleOfRadius: max(body.frame.width / 2,
                                                             body.frame.height / 2))
        body.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        body.position = CGPoint(x: 30, y: 28)
        astronautBodies.append(body)
        addChild(body)
        // arms
        let leftArm = SKLabelNode(text: "\u{25CF}")
        leftArm.fontSize = 5
        leftArm.horizontalAlignmentMode = .center
        leftArm.verticalAlignmentMode = .center
        leftArm.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        leftArm.position = CGPoint(x: 17.5, y: 25)
        astronautBodies.append(leftArm)
        addChild(leftArm)
        let rightArm = SKLabelNode(text: "\u{25CF}")
        rightArm.fontSize = 5
        rightArm.horizontalAlignmentMode = .center
        rightArm.verticalAlignmentMode = .center
        rightArm.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        rightArm.position = CGPoint(x: 41.5, y: 25)
        astronautBodies.append(rightArm)
        addChild(rightArm)
        // legs
        let leftLeg = SKLabelNode(text: "\u{25CF}")
        leftLeg.fontSize = 5
        leftLeg.horizontalAlignmentMode = .center
        leftLeg.verticalAlignmentMode = .center
        leftLeg.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        leftLeg.position = CGPoint(x: 21.5, y: 20)
        astronautBodies.append(leftLeg)
        addChild(leftLeg)
        let rightLeg = SKLabelNode(text: "\u{25CF}")
        rightLeg.fontSize = 5
        rightLeg.horizontalAlignmentMode = .center
        rightLeg.verticalAlignmentMode = .center
        rightLeg.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        rightLeg.position = CGPoint(x: 37.5, y: 20)
        astronautBodies.append(rightLeg)
        addChild(rightLeg)
        // astronaut
        let astronaut = SKLabelNode(text: randomAstronaut)
        astronaut.fontSize = 30
        astronaut.horizontalAlignmentMode = .center
        astronaut.verticalAlignmentMode = .center
        astronauts.append(randomAstronaut)
        astronaut.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        astronaut.position = CGPoint(x: 30, y: 40)
        astronautBodies.append(astronaut)
        addChild(astronaut)
        // astronaut - helmet joints
        let astronautHelmetJoint = SKPhysicsJointFixed.joint(withBodyA: astronaut.physicsBody!, bodyB: helmet.physicsBody!, anchor: CGPoint(x: astronaut.frame.maxX/2, y: helmet.frame.maxX/2))
        self.physicsWorld.add(astronautHelmetJoint)
        // helmet - body joints
        let helmetBodyJoint = SKPhysicsJointFixed.joint(withBodyA: helmet.physicsBody!, bodyB: body.physicsBody!, anchor: CGPoint(x: astronaut.frame.maxX/2, y: body.frame.maxY))
        self.physicsWorld.add(helmetBodyJoint)
        // arms - body joints
        let leftArmBodyJoint = SKPhysicsJointFixed.joint(withBodyA: leftArm.physicsBody!, bodyB: body.physicsBody!, anchor: CGPoint(x: body.frame.maxX/2, y: body.frame.maxY/2))
        let rightArmBodyJoint = SKPhysicsJointFixed.joint(withBodyA: rightArm.physicsBody!, bodyB: body.physicsBody!, anchor: CGPoint(x: body.frame.maxX/2, y: body.frame.maxY/2))
        self.physicsWorld.add(leftArmBodyJoint)
        self.physicsWorld.add(rightArmBodyJoint)
        // legs - body joints
        let leftLegBodyJoint = SKPhysicsJointFixed.joint(withBodyA: leftLeg.physicsBody!, bodyB: body.physicsBody!, anchor: CGPoint(x: body.frame.maxX/2, y: body.frame.maxY/2))
        let rightLegBodyJoint = SKPhysicsJointFixed.joint(withBodyA: rightLeg.physicsBody!, bodyB: body.physicsBody!, anchor: CGPoint(x: body.frame.maxX/2, y: body.frame.maxY/2))
        self.physicsWorld.add(leftLegBodyJoint)
        self.physicsWorld.add(rightLegBodyJoint)
        
        updatePhysics()
        astronaut.physicsBody!.applyImpulse(CGVector(dx: impulseDx, dy: impulseDy))
    }
}

//: ### Dashboard
class DashboardView: UIView {
    // Delegate
    weak var delegate: DashboardDelegate?
    // Splash items
    let splashCircle = UIView(frame: CGRect(x: 0, y: 0, width: 1500, height: 1500))
    let kickoffSwith = UISwitch(frame: CGRect(x: 20, y: 40, width: 20 , height: 20))
    let splashLabelOne = UILabel(frame: CGRect(x: 20, y: -150, width: 500, height: 30))
    let splashLabelTwo = UILabel(frame: CGRect(x: 20, y: -120, width: 500, height: 80))
    // Labels
    var labels = [UILabel]()
    let seperatorTwoLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 1))
    let seperatorThreeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 1))
    let restartLabel = UILabel(frame: CGRect(x: 20, y: 10, width: 160, height: 70))
    let dynamicLabel = UILabel(frame: CGRect(x: 100, y: 10, width: 160, height: 70))
    let launchLabel = UILabel(frame: CGRect(x: 20, y: 80, width: 160, height: 70))
    let impulseLabel = UILabel(frame: CGRect(x: 20, y: 150, width: 160, height: 70))
    //    let impulseDyLabel = UILabel(frame: CGRect(x: 100, y: 150, width: 160, height: 70))
    let onDutyLabel = UILabel(frame: CGRect(x: 220, y: 10, width: 160, height: 70))
    let onDutyBoxLabel = UILabel(frame: CGRect(x: 220, y: 20, width: 160, height: 70))
    let onDutyAstronautLabel = UILabel(frame: CGRect(x: 220, y: 20, width: 160, height: 70))
    let gravityDyLabel = UILabel(frame: CGRect(x: 220, y: 80, width: 160, height: 70))
    let gravityDxLabel = UILabel(frame: CGRect(x: 220, y: 150, width: 160, height: 70))
    let restitutionLabel = UILabel(frame: CGRect(x: 420, y: 10, width: 160, height: 70))
    let frictionLabel = UILabel(frame: CGRect(x: 420, y: 80, width: 160, height: 70))
    let dampingLabel = UILabel(frame: CGRect(x: 420, y: 150, width: 160, height: 70))
    // Switchs
    let finishOffSwitch = UISwitch(frame: CGRect(x: 20, y: 40, width: 20 , height: 20))
    let isDynamicSwitch = UISwitch(frame: CGRect(x: 100, y: 40, width: 20 , height: 20))
    // SLiders
    let impulseSlider = UISlider(frame: CGRect(x: 20, y: 180, width: 160 , height: 20))
    let gravityDySlider = UISlider(frame: CGRect(x: 220, y: 110, width: 160, height: 20))
    let gravityDxSlider = UISlider(frame: CGRect(x: 220, y: 180, width: 160, height: 20))
    let restitutionSlider = UISlider(frame: CGRect(x: 420, y: 40, width: 160, height: 20))
    let frictionSlider = UISlider(frame: CGRect(x: 420, y: 110, width: 160, height: 20))
    let dampingSlider = UISlider(frame: CGRect(x: 420, y: 180, width: 160, height: 20))
    // Buttons
    let addAstronautButton = UIButton(frame: CGRect(x: 20, y: 110, width: 160 , height: 30))
    
    // Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLabels()
        initSliders()
        initSwitchs()
        initButtons()
        initSplashScreen()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Init labels
    func initLabels() {
        labels.append(seperatorTwoLabel)
        labels.append(seperatorThreeLabel)
        labels.append(restartLabel)
        labels.append(dynamicLabel)
        labels.append(launchLabel)
        labels.append(impulseLabel)
        labels.append(onDutyLabel)
        labels.append(onDutyBoxLabel)
        labels.append(gravityDyLabel)
        labels.append(gravityDxLabel)
        labels.append(restitutionLabel)
        labels.append(frictionLabel)
        labels.append(dampingLabel)
        labels.append(onDutyAstronautLabel)
        restartLabel.text = "\u{25A0} RESTART\n\n\n"
        dynamicLabel.text = "\u{25A0} DYNAMIC\n\n\n"
        launchLabel.text = "\u{25A0} LAUNCH\n\n\n"
        impulseLabel.text = "\u{25A0} LAUNCH IMPULSE\n\n\n0                                          50"
        onDutyLabel.text = "\u{25A0} ON DUTY\n\n\n"
        onDutyBoxLabel.text = "\u{25A1} \u{25A1} \u{25A1} \u{25A1} \u{25A1}"
        onDutyAstronautLabel.text = ""
        gravityDyLabel.text = "\u{25A0} GRAVITY DY\n\n\n-15                                       15"
        gravityDxLabel.text = "\u{25A0} GRAVITY DX\n\n\n-15                                       15"
        restitutionLabel.text = "\u{25A0} RESTITUTION\n\n\n0                                             1"
        frictionLabel.text = "\u{25A0} FRICTION\n\n\n0                                        100"
        dampingLabel.text = "\u{25A0} DAMPING\n\n\n0                                             1"
        
        for label in labels {
            label.textColor = UIColor.lightGray
            label.font = UIFont(name: ".SFUIText-Semibold", size: 12)
            label.numberOfLines = 0
            self.addSubview(label)
        }
        
        onDutyBoxLabel.font = UIFont(name: ".SFUIText", size: 25)
        onDutyAstronautLabel.font = UIFont(name: ".SFUIText", size: 21)
        seperatorTwoLabel.backgroundColor = UIColor.lightGray
        seperatorTwoLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        seperatorTwoLabel.center = CGPoint(x: 200, y: 115)
        seperatorTwoLabel.alpha = 0.3
        seperatorThreeLabel.backgroundColor = UIColor.lightGray
        seperatorThreeLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        seperatorThreeLabel.center = CGPoint(x: 400, y: 115)
        seperatorThreeLabel.alpha = 0.3
    }
    
    // Init sliders
    func initSliders() {
        // Impulse slider
        impulseSlider.minimumValue = 0
        impulseSlider.maximumValue = 50
        impulseSlider.isContinuous = true
        impulseSlider.tintColor = dashboardTintColor
        impulseSlider.value = 3
        impulseSlider.addTarget(self, action: #selector(impulseSliderValueDidChange(_:)), for: .valueChanged)
        self.addSubview(impulseSlider)
        // Gravity slider - dy
        gravityDySlider.minimumValue = -15
        gravityDySlider.maximumValue = 15
        gravityDySlider.isContinuous = true
        gravityDySlider.tintColor = dashboardTintColor
        gravityDySlider.value = 0
        gravityDySlider.addTarget(self, action: #selector(gravityDySliderValueDidChange(_:)), for: .valueChanged)
        self.addSubview(gravityDySlider)
        // Gravity slider - dx
        gravityDxSlider.minimumValue = -15
        gravityDxSlider.maximumValue = 15
        gravityDxSlider.isContinuous = true
        gravityDxSlider.tintColor = dashboardTintColor
        gravityDxSlider.value = 0
        gravityDxSlider.addTarget(self, action: #selector(gravityDxSliderValueDidChange(_:)), for: .valueChanged)
        self.addSubview(gravityDxSlider)
        // Restitution slider
        restitutionSlider.minimumValue = 0
        restitutionSlider.maximumValue = 1
        restitutionSlider.isContinuous = true
        restitutionSlider.tintColor = dashboardTintColor
        restitutionSlider.value = 0.5
        restitutionSlider.addTarget(self, action: #selector(restitutionSliderValueDidChange(_:)), for: .valueChanged)
        self.addSubview(restitutionSlider)
        // Friction slider
        frictionSlider.minimumValue = 0
        frictionSlider.maximumValue = 100
        frictionSlider.isContinuous = true
        frictionSlider.tintColor = dashboardTintColor
        frictionSlider.value = 0
        frictionSlider.addTarget(self, action: #selector(frictionSliderValueDidChange(_:)), for: .valueChanged)
        self.addSubview(frictionSlider)
        // Damping slider
        dampingSlider.minimumValue = 0
        dampingSlider.maximumValue = 1
        dampingSlider.isContinuous = true
        dampingSlider.tintColor = dashboardTintColor
        dampingSlider.value = 0
        dampingSlider.addTarget(self, action: #selector(dampingSliderValueDidChange(_:)), for: .valueChanged)
        self.addSubview(dampingSlider)
    }
    
    // Init buttons
    func initButtons() {
        // Add astronaut button
        addAstronautButton.setTitle("Launch an Astronaut", for: .normal)
        addAstronautButton.titleLabel?.font = UIFont(name: ".SFUIText-Bold", size: 12)
        addAstronautButton.setTitleColor(UIColor.lightGray, for: .normal)
        addAstronautButton.layer.cornerRadius = 2
        addAstronautButton.layer.borderWidth = 1
        addAstronautButton.layer.borderColor = UIColor.lightGray.cgColor
        addAstronautButton.backgroundColor = UIColor.clear  // indego200 //lightLightGray
        addAstronautButton.addTarget(self, action: #selector(buttonDidTouchedInside), for: .touchUpInside)
        addAstronautButton.addTarget(self, action: #selector(buttonDidTouched), for: .touchDown)
        self.addSubview(addAstronautButton)
    }
    
    // Init switches
    func initSwitchs() {
        // Finishoff switch
        finishOffSwitch.isOn = true
        finishOffSwitch.setOn(true, animated: false)
        finishOffSwitch.onTintColor = kickoffTintColor
        finishOffSwitch.addTarget(self, action: #selector(finishOffSwitchValueDidChange(_:)), for: .valueChanged)
        self.addSubview(finishOffSwitch)
        // IsDynamic switch
        isDynamicSwitch.isOn = true
        isDynamicSwitch.setOn(true, animated: false)
        isDynamicSwitch.onTintColor = dashboardTintColor
        isDynamicSwitch.addTarget(self, action: #selector(isDynamicSwitchValueDidChange(_:)), for: .valueChanged)
        self.addSubview(isDynamicSwitch)
    }
    
    // Button actions
    func buttonDidTouchedInside(_ sender: UIButton!) {
        print("button--pressed")
        addAstronautButton.layer.borderColor = UIColor.lightGray.cgColor
        addAstronautButton.backgroundColor = UIColor.clear
        addAstronautButton.setTitleColor(UIColor.lightGray, for: .normal)
        // if astrouants not full
        if (astronauts.count < 5) {
            self.delegate?.addAstronaut()
            // update on duty label
            onDutyAstronautLabel.text = onDutyAstronautLabel.text! + "\(randomAstronaut) "
            // disable button
            addAstronautButton.isEnabled = false
            // if full
            if (astronauts.count >= 5) {
                onDutyLabel.text = "\u{25A0} ON DUTY (FULL)\n\n\n"
                onDutyLabel.textColor = indegoA100
            } else {
                // delay re-enable
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(enableButton), userInfo: nil, repeats: false)
            }
        }
    }
    func buttonDidTouched(_ sender: UIButton!) {
        print("button--pressed")
        addAstronautButton.layer.borderColor = dashboardTintColor.cgColor
        addAstronautButton.backgroundColor = dashboardTintColor
        addAstronautButton.setTitleColor(UIColor.white, for: .normal)
    }
    func enableButton() {
        addAstronautButton.isEnabled = true
    }
    
    // Sliders' actions
    func impulseSliderValueDidChange(_ sender: UISlider!)
    {
        impulseDx = CGFloat(sender.value)
        impulseDy = CGFloat(sender.value)
        impulseLabel.text = "\u{25A0} LAUNCH IMPULSE \(formatDecimal(impulseDx, 1))\n\n\n0                                          50"
        self.delegate?.updatePhysics()
    }
    func gravityDySliderValueDidChange(_ sender: UISlider!)
    {
        gravityDy = CGFloat(sender.value)
        gravityDyLabel.text = "\u{25A0} GRAVITY DY \(formatDecimal(gravityDy, 1))\n\n\n-15                                       15"
        self.delegate?.updatePhysics()
    }
    func gravityDxSliderValueDidChange(_ sender: UISlider!)
    {
        print("value--\(sender.value)")
        gravityDx = CGFloat(sender.value)
        gravityDxLabel.text = "\u{25A0} GRAVITY DX \(formatDecimal(gravityDx, 1))\n\n\n-15                                       15"
        self.delegate?.updatePhysics()
    }
    func restitutionSliderValueDidChange(_ sender: UISlider!)
    {
        print("value--\(sender.value)")
        restitution = CGFloat(sender.value)
        restitutionLabel.text = "\u{25A0} RESTITUTION \(formatDecimal(restitution, 2))\n\n\n0                                             1"
        self.delegate?.updatePhysics()
    }
    func frictionSliderValueDidChange(_ sender: UISlider!)
    {
        print("value--\(sender.value)")
        friction = CGFloat(sender.value)
        frictionLabel.text = "\u{25A0} FRICTION \(formatDecimal(friction, 1))\n\n\n0                                        100"
        self.delegate?.updatePhysics()
    }
    func dampingSliderValueDidChange(_ sender: UISlider!)
    {
        print("value--\(sender.value)")
        linearDamping = CGFloat(sender.value)
        angularDamping = CGFloat(sender.value)
        dampingLabel.text = "\u{25A0} DAMPING \(formatDecimal(linearDamping, 2))\n\n\n0                                             1"
        self.delegate?.updatePhysics()
    }
    
    // Switch actions
    func finishOffSwitchValueDidChange(_ sender: UISwitch!)
    {
        if !sender.isOn {
            showSplashScreen()
        }
    }
    func kickoffSwitchValueDidChange(_ sender: UISwitch!)
    {
        if sender.isOn {
            hideSplashScreen()
        }
    }
    func isDynamicSwitchValueDidChange(_ sender: UISwitch!)
    {
        isDynamic = sender.isOn
        self.delegate?.updatePhysics()
    }
    
    // Splash screen
    func initSplashScreen() {
        // Init circle
        splashCircle.layer.cornerRadius = 750
        splashCircle.backgroundColor = kickoffTintColor
        splashCircle.clipsToBounds = true
        splashCircle.center = CGPoint(x: 55, y: 55)
        // Init kickoff switch
        kickoffSwith.isOn = false
        kickoffSwith.setOn(false, animated: false)
        kickoffSwith.onTintColor = kickoffTintColor
        kickoffSwith.addTarget(self, action: #selector(kickoffSwitchValueDidChange(_:)), for: .valueChanged)
        // Init label
        splashLabelOne.text = "\u{25A0} GRAVITY LAB"
        splashLabelTwo.text = "Created to win WWDC2017 scholarship,\nand to make your SpriteKit learning experience a little more fun.\n\nby Wei Huang @ where fun comes to die (the University of Chicago)"
        splashLabelOne.adjustsFontSizeToFitWidth
        splashLabelTwo.adjustsFontSizeToFitWidth
        splashLabelOne.textColor = sceneColor
        splashLabelTwo.textColor = sceneColor
        splashLabelTwo.numberOfLines = 0
        splashLabelOne.font = UIFont(name: ".SFUIText-Semibold", size: 30)
        splashLabelTwo.font = UIFont(name: ".SFUIText", size: 12)
        // Add views
        self.addSubview(splashCircle)
        self.addSubview(kickoffSwith)
        self.addSubview(splashLabelOne)
        self.addSubview(splashLabelTwo)
    }
    
    // Hide splash screen
    func hideSplashScreen() {
        // Animte
        UIView.animate(withDuration: 0.3, animations: {
            self.splashCircle.transform = CGAffineTransform(scaleX: 0.002, y: 0.002)
        }) {
            _ in
            self.splashLabelOne.removeFromSuperview()
            self.splashLabelTwo.removeFromSuperview()
            self.splashCircle.removeFromSuperview()
            self.kickoffSwith.removeFromSuperview()
            self.kickoffSwith.isOn = false
            self.delegate?.addAstronaut()
            self.onDutyAstronautLabel.text = self.onDutyAstronautLabel.text! + "\(randomAstronaut) "
        }
    }
    
    // Show splash screen
    func showSplashScreen() {
        self.addSubview(splashCircle)
        self.addSubview(kickoffSwith)
        self.addSubview(splashLabelOne)
        self.addSubview(splashLabelTwo)
        // Animte
        UIView.animate(withDuration: 0.3, animations: {
            self.splashCircle.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) {
            _ in
            self.finishOffSwitch.isOn = true
            self.reset()
        }
    }
    
    // Reset
    func reset() {
        for astr in astronautBodies {
            astr.removeFromParent()
        }
        astronauts.removeAll()
        astronautBodies.removeAll()
        addAstronautButton.isEnabled = true
        affectedByGravity = true
        isDynamic = true
        allowsRotation = true
        friction = 0
        restitution = 1
        linearDamping = 0
        angularDamping = 0
        gravityDx = 0
        gravityDy = 0
        impulseDx = 3
        impulseDy = 3
        isDynamicSwitch.isOn = true
        frictionSlider.value = 0
        restitutionSlider.value = 0.5
        dampingSlider.value = 0
        gravityDySlider.value = 0
        gravityDxSlider.value = 0
        impulseSlider.value = 3
        onDutyLabel.text = "\u{25A0} ON DUTY\n\n\n"
        onDutyLabel.textColor = UIColor.lightGray
        impulseLabel.text = "\u{25A0} LAUNCH IMPULSE\n\n\n0                                          50"
        gravityDyLabel.text = "\u{25A0} GRAVITY DY\n\n\n-15                                       15"
        gravityDxLabel.text = "\u{25A0} GRAVITY DX\n\n\n-15                                       15"
        restitutionLabel.text = "\u{25A0} RESTITUTION\n\n\n0                                             1"
        frictionLabel.text = "\u{25A0} FRICTION\n\n\n0                                        100"
        dampingLabel.text = "\u{25A0} DAMPING\n\n\n0                                             1"
        onDutyAstronautLabel.text = ""
    }
    
    // Format CGFloat to n decimal point string
    func formatDecimal(_ number: CGFloat, _ decimal: Int) -> String {
        let formatted = String(format: "%.\(decimal)f", number)
        return formatted
    }
}

//: ### Protocol
protocol DashboardDelegate: class {
    func updatePhysics()
    func addAstronaut()
}

//: ### Init Playground Views
// Create frames and views and scene
let masterFrame = CGRect(x: 0, y: 0, width: 620, height: 660)
let masterView = UIView(frame: masterFrame)
let sceneFrame = CGRect(x: 10, y: 10, width: 600, height: 400)
let sceneView = SKView(frame: sceneFrame)
let dashboardFrame = CGRect(x: 10, y: 420, width: 600, height: 230)
let dashboardView = DashboardView(frame: dashboardFrame)
let scene = Scene(size: sceneFrame.size)
dashboardView.delegate = scene

// Customize background colors
masterView.backgroundColor = backgroundColor
dashboardView.backgroundColor = UIColor.white

// Display views
masterView.addSubview(sceneView)
masterView.addSubview(dashboardView)
sceneView.presentScene(scene)
PlaygroundPage.current.liveView = masterView






