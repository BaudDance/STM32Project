#ifndef INC_WS2812_H_
#define INC_WS2812_H_

#include "tim.h"

#define LED_COUNT	10

void WS2812_Set(uint8_t index, uint8_t r, uint8_t g, uint8_t b);
void WS2812_SetAll(uint8_t r, uint8_t g, uint8_t b);
void WS2812_Update();

#endif /* INC_WS2812_H_ */
