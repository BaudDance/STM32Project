#include "ws2812.h"

#define	Code0		30
#define Code1		60
#define CodeReset	0

uint8_t color[LED_COUNT][3];

void WS2812_Set(uint8_t index, uint8_t r, uint8_t g, uint8_t b){
	color[index][0] = r;
	color[index][1] = g;
	color[index][2] = b;
}

void WS2812_SetAll(uint8_t r, uint8_t g, uint8_t b){
	for (uint8_t i = 0; i < LED_COUNT; i++){
		WS2812_Set(i, r, g, b);
	}
}

void WS2812_Update(){
	static uint16_t data[LED_COUNT * 3 * 8 + 1];

	for (int i = 0; i < LED_COUNT; i++) {
		uint8_t r = color[i][0];
		uint8_t g = color[i][1];
		uint8_t b = color[i][2];

		for (int j = 0; j < 8; j++) {
			data[24 * i + j] = (g & (0x80 >> j)) ? Code1 : Code0;
			data[24 * i + 8 + j] = (r & (0x80 >> j)) ? Code1 : Code0;
			data[24 * i + 16 + j] = (b & (0x80 >> j)) ? Code1 : Code0;
		}
	}
	data[LED_COUNT * 24] = CodeReset;

	HAL_TIM_PWM_Stop_DMA(&htim3, TIM_CHANNEL_1);
	__HAL_TIM_SetCounter(&htim3, 0);
	HAL_TIM_PWM_Start_DMA(&htim3, TIM_CHANNEL_1, (uint32_t*)data, sizeof(data)/sizeof(uint16_t));
}





















