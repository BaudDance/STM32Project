#include "task_light.h"

#define LightMode_Normal	0x01

void LightTaskLoop(){
	uint8_t command[60];
	uint8_t length = 0;
	length = Command_GetCommand(command);
	if (length > 0){
		if (command[2] == LightMode_Normal){
			for (uint8_t i = 0; i < LED_COUNT; i++){
				WS2812_Set(i, command[3 + 3 * i], command[3 + 3 * i + 1], command[3 + 3 * i + 2]);
			}
			WS2812_Update();
		}
	}
}
