/* Copyright (c) 2007 Scott Lembcke
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
 
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#include "chipmunk.h"

extern cpSpace *space;
extern cpBody *staticBody;

void demo1_update(int ticks)
{
	int steps = 2;
	cpFloat dt = 1.0/60.0/(cpFloat)steps;
	
	for(int i=0; i<steps; i++){
		cpSpaceStep(space, dt);
	}
}

int some_value = 42;

static int
collFunc(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data)
{
	int *some_ptr = (int *)data;
	
	for(int i=0; i<numContacts; i++)
		printf("Collision at %s. (%d - %d) %d\n", cpvstr(contacts[i].p), a->collision_type, b->collision_type, *some_ptr);
	
	return 1;
}

void demo1_init(void)
{
	staticBody = cpBodyNew(INFINITY, INFINITY);
	
	cpResetShapeIdCounter();
	space = cpSpaceNew();
	cpSpaceResizeStaticHash(space, 20.0, 999);
	space->gravity = cpv(0, -100);
	
	cpBody *body;
	
	cpShape *shape;
	
	int num = 4;
	cpVect verts[] = {
		cpv(-15,-15),
		cpv(-15, 15),
		cpv( 15, 15),
		cpv( 15,-15),
	};
	
	shape = cpSegmentShapeNew(staticBody, cpv(-320,-240), cpv(-320,240), 0.0f);
	shape->e = 1.0; shape->u = 1.0;
	cpSpaceAddStaticShape(space, shape);

	shape = cpSegmentShapeNew(staticBody, cpv(320,-240), cpv(320,240), 0.0f);
	shape->e = 1.0; shape->u = 1.0;
	cpSpaceAddStaticShape(space, shape);

	shape = cpSegmentShapeNew(staticBody,cpv(-320,-240), cpv(320,-240), 0.0f);
	shape->e = 1.0; shape->u = 1.0;
	cpSpaceAddStaticShape(space, shape);

		
	for(int i=0; i<50; i++){
		int j = i + 1;
		cpVect a = cpv(i*10 - 320, i*-10 + 240);
		cpVect b = cpv(j*10 - 320, i*-10 + 240);
		cpVect c = cpv(j*10 - 320, j*-10 + 240);
		
		shape = cpSegmentShapeNew(staticBody, a, b, 0.0f);
		shape->e = 1.0; shape->u = 1.0;
		cpSpaceAddStaticShape(space, shape);
		
		shape = cpSegmentShapeNew(staticBody, b, c, 0.0f);
		shape->e = 1.0; shape->u = 1.0;
		cpSpaceAddStaticShape(space, shape);
	}
			
	body = cpBodyNew(1.0, cpMomentForPoly(1.0, num, verts, cpvzero));
	body->p = cpv(-280, 240);
	cpSpaceAddBody(space, body);
	shape = cpPolyShapeNew(body, num, verts, cpvzero);
	shape->e = 0.0; shape->u = 1.5;
	shape->collision_type = 1;
	cpSpaceAddShape(space, shape);
	
	cpSpaceAddCollisionPairFunc(space, 1, 0, &collFunc, &some_value);
}
