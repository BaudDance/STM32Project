#ifndef INC_WS2812_H_
#define INC_WS2812_H_

#include <tim.h>

#define LED_COUNT 10

void WS2812_Update();
void WS2812_Set(int index, uint8_t r, uint8_t g, uint8_t b);
void WS2812_SetAll(uint8_t r, uint8_t g, uint8_t b);
void WS2812_GradientUpdate(uint8_t step, uint8_t delay);



#endif /* INC_WS2812_H_ */
