//
//  ViewController.swift
//  test
//
//  Created by Pablo Jimenez on 8/3/22.
//

import Cocoa
import SDL2
var myLabel = NSTextField()
var event: SDL_Event = SDL_Event()
class ViewController: NSViewController {
    
    
    @IBOutlet weak var labelTest: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        myLabel = self.labelTest
        //test ()
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    override func viewDidAppear() {
        //gamepad()
        super.viewDidAppear()
        DispatchQueue.global(qos: .background).async {
            print("Run on background thread")
            Sdl_Controller_Joystick()
           
        }
        
    }
    
}


func Sdl_Controller_Joystick (){
    
    
    if (SDL_Init(SDL_INIT_GAMECONTROLLER | SDL_INIT_JOYSTICK )) < 0 {
        print("ERROR")
    }
    
    SDL_JoystickEventState(SDL_ENABLE)
    SDL_GameControllerEventState(SDL_ENABLE)
    //SDL_JoystickUpdate()
    
    
    let joystick = SDL_JoystickOpen(0)
    if SDL_IsGameController(0).rawValue == 1 {
        print("GAMECONTROLLER")
    } else { print ("JOYSTICK")}
    
    print(SDL_JoystickName(joystick) as Any)
    print(SDL_JoystickNumButtons(joystick))
    
    print("JOYSTICKS: \(SDL_NumJoysticks())")
    
    print(SDL_IsGameController(0).rawValue)
    
    var quit = false
    var event: SDL_Event = SDL_Event()
    while(!quit) {
        while SDL_PollEvent(&event) != 0 {
            
            switch SDL_EventType(event.type) {
            case SDL_QUIT,
                SDL_KEYUP where event.key.keysym.sym == SDLK_ESCAPE.rawValue:
                quit = true
            case SDL_JOYAXISMOTION:
                print("AXIS")
                
            case SDL_JOYBUTTONDOWN:
                print("BOTON")
                let boton = event.jbutton.button
                DispatchQueue.main.sync {
                    myLabel.stringValue = "BOTON - \(String(event.jbutton.button)) "
                }
            case SDL_JOYDEVICEADDED:
                DispatchQueue.main.sync {
                    myLabel.stringValue = "JOYSTICK CONECTADO"
                }
            case SDL_JOYDEVICEREMOVED:
                DispatchQueue.main.sync {
                    myLabel.stringValue = "JOYSTICK DESCONECTADO"
                }
            case SDL_JOYHATMOTION:
                var direccion = event.jhat.hat
                var position = SDL_JoystickGetHat(joystick, 0)
                
                DispatchQueue.main.sync {
                    myLabel.stringValue = "DPAD - \(position) "
                }
                
            
            default:
                break
            }
        }
        
        
        
    }
    
    
}


