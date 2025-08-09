
user/_uthread:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <clear_thread>:
extern void thread_switch(uint64, uint64);

/*
 * helper function to setup the routine for a newly-created thread
 */
void clear_thread(struct thread *t, void (*func)()) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
   e:	892e                	mv	s2,a1
  memset((void *)&t->stack, 0, STACK_SIZE);
  10:	6609                	lui	a2,0x2
  12:	4581                	li	a1,0
  14:	07050513          	addi	a0,a0,112
  18:	00000097          	auipc	ra,0x0
  1c:	514080e7          	jalr	1300(ra) # 52c <memset>
  memset((void *)&t->thread_context, 0, sizeof(struct thread_context));
  20:	07000613          	li	a2,112
  24:	4581                	li	a1,0
  26:	8526                	mv	a0,s1
  28:	00000097          	auipc	ra,0x0
  2c:	504080e7          	jalr	1284(ra) # 52c <memset>
  t->state = RUNNABLE;
  30:	6789                	lui	a5,0x2
  32:	00f48733          	add	a4,s1,a5
  36:	4689                	li	a3,2
  38:	db34                	sw	a3,112(a4)
  t->thread_context.sp = (uint64) ((char *)&t->stack + STACK_SIZE);
  3a:	07078793          	addi	a5,a5,112 # 2070 <__global_pointer$+0xabf>
  3e:	97a6                	add	a5,a5,s1
  40:	e49c                	sd	a5,8(s1)
  t->thread_context.ra = (uint64) func;
  42:	0124b023          	sd	s2,0(s1)
}
  46:	60e2                	ld	ra,24(sp)
  48:	6442                	ld	s0,16(sp)
  4a:	64a2                	ld	s1,8(sp)
  4c:	6902                	ld	s2,0(sp)
  4e:	6105                	addi	sp,sp,32
  50:	8082                	ret

0000000000000052 <thread_init>:

void 
thread_init(void)
{
  52:	1141                	addi	sp,sp,-16
  54:	e422                	sd	s0,8(sp)
  56:	0800                	addi	s0,sp,16
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
  58:	00001797          	auipc	a5,0x1
  5c:	d8878793          	addi	a5,a5,-632 # de0 <all_thread>
  60:	00001717          	auipc	a4,0x1
  64:	d6f73823          	sd	a5,-656(a4) # dd0 <current_thread>
  current_thread->state = RUNNING;
  68:	4785                	li	a5,1
  6a:	00003717          	auipc	a4,0x3
  6e:	def72323          	sw	a5,-538(a4) # 2e50 <__global_pointer$+0x189f>
}
  72:	6422                	ld	s0,8(sp)
  74:	0141                	addi	sp,sp,16
  76:	8082                	ret

0000000000000078 <thread_schedule>:

void 
thread_schedule(void)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e406                	sd	ra,8(sp)
  7c:	e022                	sd	s0,0(sp)
  7e:	0800                	addi	s0,sp,16
  struct thread *t, *next_thread;

  /* Find another runnable thread. */
  next_thread = 0;
  t = current_thread + 1;
  80:	00001517          	auipc	a0,0x1
  84:	d5053503          	ld	a0,-688(a0) # dd0 <current_thread>
  88:	6589                	lui	a1,0x2
  8a:	07858593          	addi	a1,a1,120 # 2078 <__global_pointer$+0xac7>
  8e:	95aa                	add	a1,a1,a0
  90:	4791                	li	a5,4
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD)
  92:	00009817          	auipc	a6,0x9
  96:	f2e80813          	addi	a6,a6,-210 # 8fc0 <base>
      t = all_thread;
    if(t->state == RUNNABLE) {
  9a:	6689                	lui	a3,0x2
  9c:	4609                	li	a2,2
      next_thread = t;
      break;
    }
    t = t + 1;
  9e:	07868893          	addi	a7,a3,120 # 2078 <__global_pointer$+0xac7>
  a2:	a809                	j	b4 <thread_schedule+0x3c>
    if(t->state == RUNNABLE) {
  a4:	00d58733          	add	a4,a1,a3
  a8:	5b38                	lw	a4,112(a4)
  aa:	02c70963          	beq	a4,a2,dc <thread_schedule+0x64>
    t = t + 1;
  ae:	95c6                	add	a1,a1,a7
  for(int i = 0; i < MAX_THREAD; i++){
  b0:	37fd                	addiw	a5,a5,-1
  b2:	cb81                	beqz	a5,c2 <thread_schedule+0x4a>
    if(t >= all_thread + MAX_THREAD)
  b4:	ff05e8e3          	bltu	a1,a6,a4 <thread_schedule+0x2c>
      t = all_thread;
  b8:	00001597          	auipc	a1,0x1
  bc:	d2858593          	addi	a1,a1,-728 # de0 <all_thread>
  c0:	b7d5                	j	a4 <thread_schedule+0x2c>
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
  c2:	00001517          	auipc	a0,0x1
  c6:	b7e50513          	addi	a0,a0,-1154 # c40 <malloc+0xe8>
  ca:	00001097          	auipc	ra,0x1
  ce:	9d6080e7          	jalr	-1578(ra) # aa0 <printf>
    exit(-1);
  d2:	557d                	li	a0,-1
  d4:	00000097          	auipc	ra,0x0
  d8:	652080e7          	jalr	1618(ra) # 726 <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  dc:	00b50e63          	beq	a0,a1,f8 <thread_schedule+0x80>
    next_thread->state = RUNNING;
  e0:	6789                	lui	a5,0x2
  e2:	97ae                	add	a5,a5,a1
  e4:	4705                	li	a4,1
  e6:	dbb8                	sw	a4,112(a5)
    t = current_thread;
    current_thread = next_thread;
  e8:	00001797          	auipc	a5,0x1
  ec:	ceb7b423          	sd	a1,-792(a5) # dd0 <current_thread>
    /* YOUR CODE HERE
     * Invoke thread_switch to switch from t to next_thread:
     * thread_switch(??, ??);
     */
    thread_switch((uint64) t, (uint64) current_thread);
  f0:	00000097          	auipc	ra,0x0
  f4:	360080e7          	jalr	864(ra) # 450 <thread_switch>
  } else
    next_thread = 0;
}
  f8:	60a2                	ld	ra,8(sp)
  fa:	6402                	ld	s0,0(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret

0000000000000100 <thread_create>:

void 
thread_create(void (*func)())
{
 100:	1141                	addi	sp,sp,-16
 102:	e406                	sd	ra,8(sp)
 104:	e022                	sd	s0,0(sp)
 106:	0800                	addi	s0,sp,16
 108:	85aa                	mv	a1,a0
  struct thread *t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 10a:	00001517          	auipc	a0,0x1
 10e:	cd650513          	addi	a0,a0,-810 # de0 <all_thread>
    if (t->state == FREE) break;
 112:	6789                	lui	a5,0x2
 114:	07078693          	addi	a3,a5,112 # 2070 <__global_pointer$+0xabf>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 118:	07878793          	addi	a5,a5,120
 11c:	00009617          	auipc	a2,0x9
 120:	ea460613          	addi	a2,a2,-348 # 8fc0 <base>
    if (t->state == FREE) break;
 124:	00d50733          	add	a4,a0,a3
 128:	4318                	lw	a4,0(a4)
 12a:	c701                	beqz	a4,132 <thread_create+0x32>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 12c:	953e                	add	a0,a0,a5
 12e:	fec51be3          	bne	a0,a2,124 <thread_create+0x24>
  }
  // YOUR CODE HERE
  clear_thread(t, func);
 132:	00000097          	auipc	ra,0x0
 136:	ece080e7          	jalr	-306(ra) # 0 <clear_thread>
}
 13a:	60a2                	ld	ra,8(sp)
 13c:	6402                	ld	s0,0(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret

0000000000000142 <thread_yield>:

void 
thread_yield(void)
{
 142:	1141                	addi	sp,sp,-16
 144:	e406                	sd	ra,8(sp)
 146:	e022                	sd	s0,0(sp)
 148:	0800                	addi	s0,sp,16
  current_thread->state = RUNNABLE;
 14a:	00001797          	auipc	a5,0x1
 14e:	c867b783          	ld	a5,-890(a5) # dd0 <current_thread>
 152:	6709                	lui	a4,0x2
 154:	97ba                	add	a5,a5,a4
 156:	4709                	li	a4,2
 158:	dbb8                	sw	a4,112(a5)
  thread_schedule();
 15a:	00000097          	auipc	ra,0x0
 15e:	f1e080e7          	jalr	-226(ra) # 78 <thread_schedule>
}
 162:	60a2                	ld	ra,8(sp)
 164:	6402                	ld	s0,0(sp)
 166:	0141                	addi	sp,sp,16
 168:	8082                	ret

000000000000016a <thread_a>:
volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void 
thread_a(void)
{
 16a:	7179                	addi	sp,sp,-48
 16c:	f406                	sd	ra,40(sp)
 16e:	f022                	sd	s0,32(sp)
 170:	ec26                	sd	s1,24(sp)
 172:	e84a                	sd	s2,16(sp)
 174:	e44e                	sd	s3,8(sp)
 176:	e052                	sd	s4,0(sp)
 178:	1800                	addi	s0,sp,48
  int i;
  printf("thread_a started\n");
 17a:	00001517          	auipc	a0,0x1
 17e:	aee50513          	addi	a0,a0,-1298 # c68 <malloc+0x110>
 182:	00001097          	auipc	ra,0x1
 186:	91e080e7          	jalr	-1762(ra) # aa0 <printf>
  a_started = 1;
 18a:	4785                	li	a5,1
 18c:	00001717          	auipc	a4,0x1
 190:	c4f72023          	sw	a5,-960(a4) # dcc <a_started>
  while(b_started == 0 || c_started == 0)
 194:	00001497          	auipc	s1,0x1
 198:	c3448493          	addi	s1,s1,-972 # dc8 <b_started>
 19c:	00001917          	auipc	s2,0x1
 1a0:	c2890913          	addi	s2,s2,-984 # dc4 <c_started>
 1a4:	a029                	j	1ae <thread_a+0x44>
    thread_yield();
 1a6:	00000097          	auipc	ra,0x0
 1aa:	f9c080e7          	jalr	-100(ra) # 142 <thread_yield>
  while(b_started == 0 || c_started == 0)
 1ae:	409c                	lw	a5,0(s1)
 1b0:	2781                	sext.w	a5,a5
 1b2:	dbf5                	beqz	a5,1a6 <thread_a+0x3c>
 1b4:	00092783          	lw	a5,0(s2)
 1b8:	2781                	sext.w	a5,a5
 1ba:	d7f5                	beqz	a5,1a6 <thread_a+0x3c>
  
  for (i = 0; i < 100; i++) {
 1bc:	4481                	li	s1,0
    printf("thread_a %d\n", i);
 1be:	00001a17          	auipc	s4,0x1
 1c2:	ac2a0a13          	addi	s4,s4,-1342 # c80 <malloc+0x128>
    a_n += 1;
 1c6:	00001917          	auipc	s2,0x1
 1ca:	bfa90913          	addi	s2,s2,-1030 # dc0 <a_n>
  for (i = 0; i < 100; i++) {
 1ce:	06400993          	li	s3,100
    printf("thread_a %d\n", i);
 1d2:	85a6                	mv	a1,s1
 1d4:	8552                	mv	a0,s4
 1d6:	00001097          	auipc	ra,0x1
 1da:	8ca080e7          	jalr	-1846(ra) # aa0 <printf>
    a_n += 1;
 1de:	00092783          	lw	a5,0(s2)
 1e2:	2785                	addiw	a5,a5,1
 1e4:	00f92023          	sw	a5,0(s2)
    thread_yield();
 1e8:	00000097          	auipc	ra,0x0
 1ec:	f5a080e7          	jalr	-166(ra) # 142 <thread_yield>
  for (i = 0; i < 100; i++) {
 1f0:	2485                	addiw	s1,s1,1
 1f2:	ff3490e3          	bne	s1,s3,1d2 <thread_a+0x68>
  }
  printf("thread_a: exit after %d\n", a_n);
 1f6:	00001597          	auipc	a1,0x1
 1fa:	bca5a583          	lw	a1,-1078(a1) # dc0 <a_n>
 1fe:	00001517          	auipc	a0,0x1
 202:	a9250513          	addi	a0,a0,-1390 # c90 <malloc+0x138>
 206:	00001097          	auipc	ra,0x1
 20a:	89a080e7          	jalr	-1894(ra) # aa0 <printf>

  current_thread->state = FREE;
 20e:	00001797          	auipc	a5,0x1
 212:	bc27b783          	ld	a5,-1086(a5) # dd0 <current_thread>
 216:	6709                	lui	a4,0x2
 218:	97ba                	add	a5,a5,a4
 21a:	0607a823          	sw	zero,112(a5)
  thread_schedule();
 21e:	00000097          	auipc	ra,0x0
 222:	e5a080e7          	jalr	-422(ra) # 78 <thread_schedule>
}
 226:	70a2                	ld	ra,40(sp)
 228:	7402                	ld	s0,32(sp)
 22a:	64e2                	ld	s1,24(sp)
 22c:	6942                	ld	s2,16(sp)
 22e:	69a2                	ld	s3,8(sp)
 230:	6a02                	ld	s4,0(sp)
 232:	6145                	addi	sp,sp,48
 234:	8082                	ret

0000000000000236 <thread_b>:

void 
thread_b(void)
{
 236:	7179                	addi	sp,sp,-48
 238:	f406                	sd	ra,40(sp)
 23a:	f022                	sd	s0,32(sp)
 23c:	ec26                	sd	s1,24(sp)
 23e:	e84a                	sd	s2,16(sp)
 240:	e44e                	sd	s3,8(sp)
 242:	e052                	sd	s4,0(sp)
 244:	1800                	addi	s0,sp,48
  int i;
  printf("thread_b started\n");
 246:	00001517          	auipc	a0,0x1
 24a:	a6a50513          	addi	a0,a0,-1430 # cb0 <malloc+0x158>
 24e:	00001097          	auipc	ra,0x1
 252:	852080e7          	jalr	-1966(ra) # aa0 <printf>
  b_started = 1;
 256:	4785                	li	a5,1
 258:	00001717          	auipc	a4,0x1
 25c:	b6f72823          	sw	a5,-1168(a4) # dc8 <b_started>
  while(a_started == 0 || c_started == 0)
 260:	00001497          	auipc	s1,0x1
 264:	b6c48493          	addi	s1,s1,-1172 # dcc <a_started>
 268:	00001917          	auipc	s2,0x1
 26c:	b5c90913          	addi	s2,s2,-1188 # dc4 <c_started>
 270:	a029                	j	27a <thread_b+0x44>
    thread_yield();
 272:	00000097          	auipc	ra,0x0
 276:	ed0080e7          	jalr	-304(ra) # 142 <thread_yield>
  while(a_started == 0 || c_started == 0)
 27a:	409c                	lw	a5,0(s1)
 27c:	2781                	sext.w	a5,a5
 27e:	dbf5                	beqz	a5,272 <thread_b+0x3c>
 280:	00092783          	lw	a5,0(s2)
 284:	2781                	sext.w	a5,a5
 286:	d7f5                	beqz	a5,272 <thread_b+0x3c>
  
  for (i = 0; i < 100; i++) {
 288:	4481                	li	s1,0
    printf("thread_b %d\n", i);
 28a:	00001a17          	auipc	s4,0x1
 28e:	a3ea0a13          	addi	s4,s4,-1474 # cc8 <malloc+0x170>
    b_n += 1;
 292:	00001917          	auipc	s2,0x1
 296:	b2a90913          	addi	s2,s2,-1238 # dbc <b_n>
  for (i = 0; i < 100; i++) {
 29a:	06400993          	li	s3,100
    printf("thread_b %d\n", i);
 29e:	85a6                	mv	a1,s1
 2a0:	8552                	mv	a0,s4
 2a2:	00000097          	auipc	ra,0x0
 2a6:	7fe080e7          	jalr	2046(ra) # aa0 <printf>
    b_n += 1;
 2aa:	00092783          	lw	a5,0(s2)
 2ae:	2785                	addiw	a5,a5,1
 2b0:	00f92023          	sw	a5,0(s2)
    thread_yield();
 2b4:	00000097          	auipc	ra,0x0
 2b8:	e8e080e7          	jalr	-370(ra) # 142 <thread_yield>
  for (i = 0; i < 100; i++) {
 2bc:	2485                	addiw	s1,s1,1
 2be:	ff3490e3          	bne	s1,s3,29e <thread_b+0x68>
  }
  printf("thread_b: exit after %d\n", b_n);
 2c2:	00001597          	auipc	a1,0x1
 2c6:	afa5a583          	lw	a1,-1286(a1) # dbc <b_n>
 2ca:	00001517          	auipc	a0,0x1
 2ce:	a0e50513          	addi	a0,a0,-1522 # cd8 <malloc+0x180>
 2d2:	00000097          	auipc	ra,0x0
 2d6:	7ce080e7          	jalr	1998(ra) # aa0 <printf>

  current_thread->state = FREE;
 2da:	00001797          	auipc	a5,0x1
 2de:	af67b783          	ld	a5,-1290(a5) # dd0 <current_thread>
 2e2:	6709                	lui	a4,0x2
 2e4:	97ba                	add	a5,a5,a4
 2e6:	0607a823          	sw	zero,112(a5)
  thread_schedule();
 2ea:	00000097          	auipc	ra,0x0
 2ee:	d8e080e7          	jalr	-626(ra) # 78 <thread_schedule>
}
 2f2:	70a2                	ld	ra,40(sp)
 2f4:	7402                	ld	s0,32(sp)
 2f6:	64e2                	ld	s1,24(sp)
 2f8:	6942                	ld	s2,16(sp)
 2fa:	69a2                	ld	s3,8(sp)
 2fc:	6a02                	ld	s4,0(sp)
 2fe:	6145                	addi	sp,sp,48
 300:	8082                	ret

0000000000000302 <thread_c>:

void 
thread_c(void)
{
 302:	7179                	addi	sp,sp,-48
 304:	f406                	sd	ra,40(sp)
 306:	f022                	sd	s0,32(sp)
 308:	ec26                	sd	s1,24(sp)
 30a:	e84a                	sd	s2,16(sp)
 30c:	e44e                	sd	s3,8(sp)
 30e:	e052                	sd	s4,0(sp)
 310:	1800                	addi	s0,sp,48
  int i;
  printf("thread_c started\n");
 312:	00001517          	auipc	a0,0x1
 316:	9e650513          	addi	a0,a0,-1562 # cf8 <malloc+0x1a0>
 31a:	00000097          	auipc	ra,0x0
 31e:	786080e7          	jalr	1926(ra) # aa0 <printf>
  c_started = 1;
 322:	4785                	li	a5,1
 324:	00001717          	auipc	a4,0x1
 328:	aaf72023          	sw	a5,-1376(a4) # dc4 <c_started>
  while(a_started == 0 || b_started == 0)
 32c:	00001497          	auipc	s1,0x1
 330:	aa048493          	addi	s1,s1,-1376 # dcc <a_started>
 334:	00001917          	auipc	s2,0x1
 338:	a9490913          	addi	s2,s2,-1388 # dc8 <b_started>
 33c:	a029                	j	346 <thread_c+0x44>
    thread_yield();
 33e:	00000097          	auipc	ra,0x0
 342:	e04080e7          	jalr	-508(ra) # 142 <thread_yield>
  while(a_started == 0 || b_started == 0)
 346:	409c                	lw	a5,0(s1)
 348:	2781                	sext.w	a5,a5
 34a:	dbf5                	beqz	a5,33e <thread_c+0x3c>
 34c:	00092783          	lw	a5,0(s2)
 350:	2781                	sext.w	a5,a5
 352:	d7f5                	beqz	a5,33e <thread_c+0x3c>
  
  for (i = 0; i < 100; i++) {
 354:	4481                	li	s1,0
    printf("thread_c %d\n", i);
 356:	00001a17          	auipc	s4,0x1
 35a:	9baa0a13          	addi	s4,s4,-1606 # d10 <malloc+0x1b8>
    c_n += 1;
 35e:	00001917          	auipc	s2,0x1
 362:	a5a90913          	addi	s2,s2,-1446 # db8 <c_n>
  for (i = 0; i < 100; i++) {
 366:	06400993          	li	s3,100
    printf("thread_c %d\n", i);
 36a:	85a6                	mv	a1,s1
 36c:	8552                	mv	a0,s4
 36e:	00000097          	auipc	ra,0x0
 372:	732080e7          	jalr	1842(ra) # aa0 <printf>
    c_n += 1;
 376:	00092783          	lw	a5,0(s2)
 37a:	2785                	addiw	a5,a5,1
 37c:	00f92023          	sw	a5,0(s2)
    thread_yield();
 380:	00000097          	auipc	ra,0x0
 384:	dc2080e7          	jalr	-574(ra) # 142 <thread_yield>
  for (i = 0; i < 100; i++) {
 388:	2485                	addiw	s1,s1,1
 38a:	ff3490e3          	bne	s1,s3,36a <thread_c+0x68>
  }
  printf("thread_c: exit after %d\n", c_n);
 38e:	00001597          	auipc	a1,0x1
 392:	a2a5a583          	lw	a1,-1494(a1) # db8 <c_n>
 396:	00001517          	auipc	a0,0x1
 39a:	98a50513          	addi	a0,a0,-1654 # d20 <malloc+0x1c8>
 39e:	00000097          	auipc	ra,0x0
 3a2:	702080e7          	jalr	1794(ra) # aa0 <printf>

  current_thread->state = FREE;
 3a6:	00001797          	auipc	a5,0x1
 3aa:	a2a7b783          	ld	a5,-1494(a5) # dd0 <current_thread>
 3ae:	6709                	lui	a4,0x2
 3b0:	97ba                	add	a5,a5,a4
 3b2:	0607a823          	sw	zero,112(a5)
  thread_schedule();
 3b6:	00000097          	auipc	ra,0x0
 3ba:	cc2080e7          	jalr	-830(ra) # 78 <thread_schedule>
}
 3be:	70a2                	ld	ra,40(sp)
 3c0:	7402                	ld	s0,32(sp)
 3c2:	64e2                	ld	s1,24(sp)
 3c4:	6942                	ld	s2,16(sp)
 3c6:	69a2                	ld	s3,8(sp)
 3c8:	6a02                	ld	s4,0(sp)
 3ca:	6145                	addi	sp,sp,48
 3cc:	8082                	ret

00000000000003ce <main>:

int 
main(int argc, char *argv[]) 
{
 3ce:	1141                	addi	sp,sp,-16
 3d0:	e406                	sd	ra,8(sp)
 3d2:	e022                	sd	s0,0(sp)
 3d4:	0800                	addi	s0,sp,16
  a_started = b_started = c_started = 0;
 3d6:	00001797          	auipc	a5,0x1
 3da:	9e07a723          	sw	zero,-1554(a5) # dc4 <c_started>
 3de:	00001797          	auipc	a5,0x1
 3e2:	9e07a523          	sw	zero,-1558(a5) # dc8 <b_started>
 3e6:	00001797          	auipc	a5,0x1
 3ea:	9e07a323          	sw	zero,-1562(a5) # dcc <a_started>
  a_n = b_n = c_n = 0;
 3ee:	00001797          	auipc	a5,0x1
 3f2:	9c07a523          	sw	zero,-1590(a5) # db8 <c_n>
 3f6:	00001797          	auipc	a5,0x1
 3fa:	9c07a323          	sw	zero,-1594(a5) # dbc <b_n>
 3fe:	00001797          	auipc	a5,0x1
 402:	9c07a123          	sw	zero,-1598(a5) # dc0 <a_n>
  thread_init();
 406:	00000097          	auipc	ra,0x0
 40a:	c4c080e7          	jalr	-948(ra) # 52 <thread_init>
  thread_create(thread_a);
 40e:	00000517          	auipc	a0,0x0
 412:	d5c50513          	addi	a0,a0,-676 # 16a <thread_a>
 416:	00000097          	auipc	ra,0x0
 41a:	cea080e7          	jalr	-790(ra) # 100 <thread_create>
  thread_create(thread_b);
 41e:	00000517          	auipc	a0,0x0
 422:	e1850513          	addi	a0,a0,-488 # 236 <thread_b>
 426:	00000097          	auipc	ra,0x0
 42a:	cda080e7          	jalr	-806(ra) # 100 <thread_create>
  thread_create(thread_c);
 42e:	00000517          	auipc	a0,0x0
 432:	ed450513          	addi	a0,a0,-300 # 302 <thread_c>
 436:	00000097          	auipc	ra,0x0
 43a:	cca080e7          	jalr	-822(ra) # 100 <thread_create>
  thread_schedule();
 43e:	00000097          	auipc	ra,0x0
 442:	c3a080e7          	jalr	-966(ra) # 78 <thread_schedule>
  exit(0);
 446:	4501                	li	a0,0
 448:	00000097          	auipc	ra,0x0
 44c:	2de080e7          	jalr	734(ra) # 726 <exit>

0000000000000450 <thread_switch>:
         */

	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
        sd ra, 0(a0)
 450:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
 454:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
 458:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
 45a:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
 45c:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
 460:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
 464:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
 468:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
 46c:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
 470:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
 474:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
 478:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
 47c:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
 480:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
 484:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
 488:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
 48c:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
 48e:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
 490:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
 494:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
 498:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
 49c:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
 4a0:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
 4a4:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
 4a8:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
 4ac:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
 4b0:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
 4b4:	0685bd83          	ld	s11,104(a1)
 4b8:	8082                	ret

00000000000004ba <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 4ba:	1141                	addi	sp,sp,-16
 4bc:	e422                	sd	s0,8(sp)
 4be:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4c0:	87aa                	mv	a5,a0
 4c2:	0585                	addi	a1,a1,1
 4c4:	0785                	addi	a5,a5,1
 4c6:	fff5c703          	lbu	a4,-1(a1)
 4ca:	fee78fa3          	sb	a4,-1(a5)
 4ce:	fb75                	bnez	a4,4c2 <strcpy+0x8>
    ;
  return os;
}
 4d0:	6422                	ld	s0,8(sp)
 4d2:	0141                	addi	sp,sp,16
 4d4:	8082                	ret

00000000000004d6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4d6:	1141                	addi	sp,sp,-16
 4d8:	e422                	sd	s0,8(sp)
 4da:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 4dc:	00054783          	lbu	a5,0(a0)
 4e0:	cb91                	beqz	a5,4f4 <strcmp+0x1e>
 4e2:	0005c703          	lbu	a4,0(a1)
 4e6:	00f71763          	bne	a4,a5,4f4 <strcmp+0x1e>
    p++, q++;
 4ea:	0505                	addi	a0,a0,1
 4ec:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 4ee:	00054783          	lbu	a5,0(a0)
 4f2:	fbe5                	bnez	a5,4e2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4f4:	0005c503          	lbu	a0,0(a1)
}
 4f8:	40a7853b          	subw	a0,a5,a0
 4fc:	6422                	ld	s0,8(sp)
 4fe:	0141                	addi	sp,sp,16
 500:	8082                	ret

0000000000000502 <strlen>:

uint
strlen(const char *s)
{
 502:	1141                	addi	sp,sp,-16
 504:	e422                	sd	s0,8(sp)
 506:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 508:	00054783          	lbu	a5,0(a0)
 50c:	cf91                	beqz	a5,528 <strlen+0x26>
 50e:	0505                	addi	a0,a0,1
 510:	87aa                	mv	a5,a0
 512:	4685                	li	a3,1
 514:	9e89                	subw	a3,a3,a0
 516:	00f6853b          	addw	a0,a3,a5
 51a:	0785                	addi	a5,a5,1
 51c:	fff7c703          	lbu	a4,-1(a5)
 520:	fb7d                	bnez	a4,516 <strlen+0x14>
    ;
  return n;
}
 522:	6422                	ld	s0,8(sp)
 524:	0141                	addi	sp,sp,16
 526:	8082                	ret
  for(n = 0; s[n]; n++)
 528:	4501                	li	a0,0
 52a:	bfe5                	j	522 <strlen+0x20>

000000000000052c <memset>:

void*
memset(void *dst, int c, uint n)
{
 52c:	1141                	addi	sp,sp,-16
 52e:	e422                	sd	s0,8(sp)
 530:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 532:	ca19                	beqz	a2,548 <memset+0x1c>
 534:	87aa                	mv	a5,a0
 536:	1602                	slli	a2,a2,0x20
 538:	9201                	srli	a2,a2,0x20
 53a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 53e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 542:	0785                	addi	a5,a5,1
 544:	fee79de3          	bne	a5,a4,53e <memset+0x12>
  }
  return dst;
}
 548:	6422                	ld	s0,8(sp)
 54a:	0141                	addi	sp,sp,16
 54c:	8082                	ret

000000000000054e <strchr>:

char*
strchr(const char *s, char c)
{
 54e:	1141                	addi	sp,sp,-16
 550:	e422                	sd	s0,8(sp)
 552:	0800                	addi	s0,sp,16
  for(; *s; s++)
 554:	00054783          	lbu	a5,0(a0)
 558:	cb99                	beqz	a5,56e <strchr+0x20>
    if(*s == c)
 55a:	00f58763          	beq	a1,a5,568 <strchr+0x1a>
  for(; *s; s++)
 55e:	0505                	addi	a0,a0,1
 560:	00054783          	lbu	a5,0(a0)
 564:	fbfd                	bnez	a5,55a <strchr+0xc>
      return (char*)s;
  return 0;
 566:	4501                	li	a0,0
}
 568:	6422                	ld	s0,8(sp)
 56a:	0141                	addi	sp,sp,16
 56c:	8082                	ret
  return 0;
 56e:	4501                	li	a0,0
 570:	bfe5                	j	568 <strchr+0x1a>

0000000000000572 <gets>:

char*
gets(char *buf, int max)
{
 572:	711d                	addi	sp,sp,-96
 574:	ec86                	sd	ra,88(sp)
 576:	e8a2                	sd	s0,80(sp)
 578:	e4a6                	sd	s1,72(sp)
 57a:	e0ca                	sd	s2,64(sp)
 57c:	fc4e                	sd	s3,56(sp)
 57e:	f852                	sd	s4,48(sp)
 580:	f456                	sd	s5,40(sp)
 582:	f05a                	sd	s6,32(sp)
 584:	ec5e                	sd	s7,24(sp)
 586:	1080                	addi	s0,sp,96
 588:	8baa                	mv	s7,a0
 58a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 58c:	892a                	mv	s2,a0
 58e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 590:	4aa9                	li	s5,10
 592:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 594:	89a6                	mv	s3,s1
 596:	2485                	addiw	s1,s1,1
 598:	0344d863          	bge	s1,s4,5c8 <gets+0x56>
    cc = read(0, &c, 1);
 59c:	4605                	li	a2,1
 59e:	faf40593          	addi	a1,s0,-81
 5a2:	4501                	li	a0,0
 5a4:	00000097          	auipc	ra,0x0
 5a8:	19a080e7          	jalr	410(ra) # 73e <read>
    if(cc < 1)
 5ac:	00a05e63          	blez	a0,5c8 <gets+0x56>
    buf[i++] = c;
 5b0:	faf44783          	lbu	a5,-81(s0)
 5b4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 5b8:	01578763          	beq	a5,s5,5c6 <gets+0x54>
 5bc:	0905                	addi	s2,s2,1
 5be:	fd679be3          	bne	a5,s6,594 <gets+0x22>
  for(i=0; i+1 < max; ){
 5c2:	89a6                	mv	s3,s1
 5c4:	a011                	j	5c8 <gets+0x56>
 5c6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 5c8:	99de                	add	s3,s3,s7
 5ca:	00098023          	sb	zero,0(s3)
  return buf;
}
 5ce:	855e                	mv	a0,s7
 5d0:	60e6                	ld	ra,88(sp)
 5d2:	6446                	ld	s0,80(sp)
 5d4:	64a6                	ld	s1,72(sp)
 5d6:	6906                	ld	s2,64(sp)
 5d8:	79e2                	ld	s3,56(sp)
 5da:	7a42                	ld	s4,48(sp)
 5dc:	7aa2                	ld	s5,40(sp)
 5de:	7b02                	ld	s6,32(sp)
 5e0:	6be2                	ld	s7,24(sp)
 5e2:	6125                	addi	sp,sp,96
 5e4:	8082                	ret

00000000000005e6 <stat>:

int
stat(const char *n, struct stat *st)
{
 5e6:	1101                	addi	sp,sp,-32
 5e8:	ec06                	sd	ra,24(sp)
 5ea:	e822                	sd	s0,16(sp)
 5ec:	e426                	sd	s1,8(sp)
 5ee:	e04a                	sd	s2,0(sp)
 5f0:	1000                	addi	s0,sp,32
 5f2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5f4:	4581                	li	a1,0
 5f6:	00000097          	auipc	ra,0x0
 5fa:	170080e7          	jalr	368(ra) # 766 <open>
  if(fd < 0)
 5fe:	02054563          	bltz	a0,628 <stat+0x42>
 602:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 604:	85ca                	mv	a1,s2
 606:	00000097          	auipc	ra,0x0
 60a:	178080e7          	jalr	376(ra) # 77e <fstat>
 60e:	892a                	mv	s2,a0
  close(fd);
 610:	8526                	mv	a0,s1
 612:	00000097          	auipc	ra,0x0
 616:	13c080e7          	jalr	316(ra) # 74e <close>
  return r;
}
 61a:	854a                	mv	a0,s2
 61c:	60e2                	ld	ra,24(sp)
 61e:	6442                	ld	s0,16(sp)
 620:	64a2                	ld	s1,8(sp)
 622:	6902                	ld	s2,0(sp)
 624:	6105                	addi	sp,sp,32
 626:	8082                	ret
    return -1;
 628:	597d                	li	s2,-1
 62a:	bfc5                	j	61a <stat+0x34>

000000000000062c <atoi>:

int
atoi(const char *s)
{
 62c:	1141                	addi	sp,sp,-16
 62e:	e422                	sd	s0,8(sp)
 630:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 632:	00054683          	lbu	a3,0(a0)
 636:	fd06879b          	addiw	a5,a3,-48
 63a:	0ff7f793          	zext.b	a5,a5
 63e:	4625                	li	a2,9
 640:	02f66863          	bltu	a2,a5,670 <atoi+0x44>
 644:	872a                	mv	a4,a0
  n = 0;
 646:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 648:	0705                	addi	a4,a4,1 # 2001 <__global_pointer$+0xa50>
 64a:	0025179b          	slliw	a5,a0,0x2
 64e:	9fa9                	addw	a5,a5,a0
 650:	0017979b          	slliw	a5,a5,0x1
 654:	9fb5                	addw	a5,a5,a3
 656:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 65a:	00074683          	lbu	a3,0(a4)
 65e:	fd06879b          	addiw	a5,a3,-48
 662:	0ff7f793          	zext.b	a5,a5
 666:	fef671e3          	bgeu	a2,a5,648 <atoi+0x1c>
  return n;
}
 66a:	6422                	ld	s0,8(sp)
 66c:	0141                	addi	sp,sp,16
 66e:	8082                	ret
  n = 0;
 670:	4501                	li	a0,0
 672:	bfe5                	j	66a <atoi+0x3e>

0000000000000674 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 674:	1141                	addi	sp,sp,-16
 676:	e422                	sd	s0,8(sp)
 678:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 67a:	02b57463          	bgeu	a0,a1,6a2 <memmove+0x2e>
    while(n-- > 0)
 67e:	00c05f63          	blez	a2,69c <memmove+0x28>
 682:	1602                	slli	a2,a2,0x20
 684:	9201                	srli	a2,a2,0x20
 686:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 68a:	872a                	mv	a4,a0
      *dst++ = *src++;
 68c:	0585                	addi	a1,a1,1
 68e:	0705                	addi	a4,a4,1
 690:	fff5c683          	lbu	a3,-1(a1)
 694:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 698:	fee79ae3          	bne	a5,a4,68c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 69c:	6422                	ld	s0,8(sp)
 69e:	0141                	addi	sp,sp,16
 6a0:	8082                	ret
    dst += n;
 6a2:	00c50733          	add	a4,a0,a2
    src += n;
 6a6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 6a8:	fec05ae3          	blez	a2,69c <memmove+0x28>
 6ac:	fff6079b          	addiw	a5,a2,-1
 6b0:	1782                	slli	a5,a5,0x20
 6b2:	9381                	srli	a5,a5,0x20
 6b4:	fff7c793          	not	a5,a5
 6b8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 6ba:	15fd                	addi	a1,a1,-1
 6bc:	177d                	addi	a4,a4,-1
 6be:	0005c683          	lbu	a3,0(a1)
 6c2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 6c6:	fee79ae3          	bne	a5,a4,6ba <memmove+0x46>
 6ca:	bfc9                	j	69c <memmove+0x28>

00000000000006cc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 6cc:	1141                	addi	sp,sp,-16
 6ce:	e422                	sd	s0,8(sp)
 6d0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 6d2:	ca05                	beqz	a2,702 <memcmp+0x36>
 6d4:	fff6069b          	addiw	a3,a2,-1
 6d8:	1682                	slli	a3,a3,0x20
 6da:	9281                	srli	a3,a3,0x20
 6dc:	0685                	addi	a3,a3,1
 6de:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 6e0:	00054783          	lbu	a5,0(a0)
 6e4:	0005c703          	lbu	a4,0(a1)
 6e8:	00e79863          	bne	a5,a4,6f8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 6ec:	0505                	addi	a0,a0,1
    p2++;
 6ee:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 6f0:	fed518e3          	bne	a0,a3,6e0 <memcmp+0x14>
  }
  return 0;
 6f4:	4501                	li	a0,0
 6f6:	a019                	j	6fc <memcmp+0x30>
      return *p1 - *p2;
 6f8:	40e7853b          	subw	a0,a5,a4
}
 6fc:	6422                	ld	s0,8(sp)
 6fe:	0141                	addi	sp,sp,16
 700:	8082                	ret
  return 0;
 702:	4501                	li	a0,0
 704:	bfe5                	j	6fc <memcmp+0x30>

0000000000000706 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 706:	1141                	addi	sp,sp,-16
 708:	e406                	sd	ra,8(sp)
 70a:	e022                	sd	s0,0(sp)
 70c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 70e:	00000097          	auipc	ra,0x0
 712:	f66080e7          	jalr	-154(ra) # 674 <memmove>
}
 716:	60a2                	ld	ra,8(sp)
 718:	6402                	ld	s0,0(sp)
 71a:	0141                	addi	sp,sp,16
 71c:	8082                	ret

000000000000071e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 71e:	4885                	li	a7,1
 ecall
 720:	00000073          	ecall
 ret
 724:	8082                	ret

0000000000000726 <exit>:
.global exit
exit:
 li a7, SYS_exit
 726:	4889                	li	a7,2
 ecall
 728:	00000073          	ecall
 ret
 72c:	8082                	ret

000000000000072e <wait>:
.global wait
wait:
 li a7, SYS_wait
 72e:	488d                	li	a7,3
 ecall
 730:	00000073          	ecall
 ret
 734:	8082                	ret

0000000000000736 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 736:	4891                	li	a7,4
 ecall
 738:	00000073          	ecall
 ret
 73c:	8082                	ret

000000000000073e <read>:
.global read
read:
 li a7, SYS_read
 73e:	4895                	li	a7,5
 ecall
 740:	00000073          	ecall
 ret
 744:	8082                	ret

0000000000000746 <write>:
.global write
write:
 li a7, SYS_write
 746:	48c1                	li	a7,16
 ecall
 748:	00000073          	ecall
 ret
 74c:	8082                	ret

000000000000074e <close>:
.global close
close:
 li a7, SYS_close
 74e:	48d5                	li	a7,21
 ecall
 750:	00000073          	ecall
 ret
 754:	8082                	ret

0000000000000756 <kill>:
.global kill
kill:
 li a7, SYS_kill
 756:	4899                	li	a7,6
 ecall
 758:	00000073          	ecall
 ret
 75c:	8082                	ret

000000000000075e <exec>:
.global exec
exec:
 li a7, SYS_exec
 75e:	489d                	li	a7,7
 ecall
 760:	00000073          	ecall
 ret
 764:	8082                	ret

0000000000000766 <open>:
.global open
open:
 li a7, SYS_open
 766:	48bd                	li	a7,15
 ecall
 768:	00000073          	ecall
 ret
 76c:	8082                	ret

000000000000076e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 76e:	48c5                	li	a7,17
 ecall
 770:	00000073          	ecall
 ret
 774:	8082                	ret

0000000000000776 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 776:	48c9                	li	a7,18
 ecall
 778:	00000073          	ecall
 ret
 77c:	8082                	ret

000000000000077e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 77e:	48a1                	li	a7,8
 ecall
 780:	00000073          	ecall
 ret
 784:	8082                	ret

0000000000000786 <link>:
.global link
link:
 li a7, SYS_link
 786:	48cd                	li	a7,19
 ecall
 788:	00000073          	ecall
 ret
 78c:	8082                	ret

000000000000078e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 78e:	48d1                	li	a7,20
 ecall
 790:	00000073          	ecall
 ret
 794:	8082                	ret

0000000000000796 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 796:	48a5                	li	a7,9
 ecall
 798:	00000073          	ecall
 ret
 79c:	8082                	ret

000000000000079e <dup>:
.global dup
dup:
 li a7, SYS_dup
 79e:	48a9                	li	a7,10
 ecall
 7a0:	00000073          	ecall
 ret
 7a4:	8082                	ret

00000000000007a6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 7a6:	48ad                	li	a7,11
 ecall
 7a8:	00000073          	ecall
 ret
 7ac:	8082                	ret

00000000000007ae <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 7ae:	48b1                	li	a7,12
 ecall
 7b0:	00000073          	ecall
 ret
 7b4:	8082                	ret

00000000000007b6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 7b6:	48b5                	li	a7,13
 ecall
 7b8:	00000073          	ecall
 ret
 7bc:	8082                	ret

00000000000007be <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 7be:	48b9                	li	a7,14
 ecall
 7c0:	00000073          	ecall
 ret
 7c4:	8082                	ret

00000000000007c6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7c6:	1101                	addi	sp,sp,-32
 7c8:	ec06                	sd	ra,24(sp)
 7ca:	e822                	sd	s0,16(sp)
 7cc:	1000                	addi	s0,sp,32
 7ce:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7d2:	4605                	li	a2,1
 7d4:	fef40593          	addi	a1,s0,-17
 7d8:	00000097          	auipc	ra,0x0
 7dc:	f6e080e7          	jalr	-146(ra) # 746 <write>
}
 7e0:	60e2                	ld	ra,24(sp)
 7e2:	6442                	ld	s0,16(sp)
 7e4:	6105                	addi	sp,sp,32
 7e6:	8082                	ret

00000000000007e8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7e8:	7139                	addi	sp,sp,-64
 7ea:	fc06                	sd	ra,56(sp)
 7ec:	f822                	sd	s0,48(sp)
 7ee:	f426                	sd	s1,40(sp)
 7f0:	f04a                	sd	s2,32(sp)
 7f2:	ec4e                	sd	s3,24(sp)
 7f4:	0080                	addi	s0,sp,64
 7f6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7f8:	c299                	beqz	a3,7fe <printint+0x16>
 7fa:	0805c963          	bltz	a1,88c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7fe:	2581                	sext.w	a1,a1
  neg = 0;
 800:	4881                	li	a7,0
 802:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 806:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 808:	2601                	sext.w	a2,a2
 80a:	00000517          	auipc	a0,0x0
 80e:	59650513          	addi	a0,a0,1430 # da0 <digits>
 812:	883a                	mv	a6,a4
 814:	2705                	addiw	a4,a4,1
 816:	02c5f7bb          	remuw	a5,a1,a2
 81a:	1782                	slli	a5,a5,0x20
 81c:	9381                	srli	a5,a5,0x20
 81e:	97aa                	add	a5,a5,a0
 820:	0007c783          	lbu	a5,0(a5)
 824:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 828:	0005879b          	sext.w	a5,a1
 82c:	02c5d5bb          	divuw	a1,a1,a2
 830:	0685                	addi	a3,a3,1
 832:	fec7f0e3          	bgeu	a5,a2,812 <printint+0x2a>
  if(neg)
 836:	00088c63          	beqz	a7,84e <printint+0x66>
    buf[i++] = '-';
 83a:	fd070793          	addi	a5,a4,-48
 83e:	00878733          	add	a4,a5,s0
 842:	02d00793          	li	a5,45
 846:	fef70823          	sb	a5,-16(a4)
 84a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 84e:	02e05863          	blez	a4,87e <printint+0x96>
 852:	fc040793          	addi	a5,s0,-64
 856:	00e78933          	add	s2,a5,a4
 85a:	fff78993          	addi	s3,a5,-1
 85e:	99ba                	add	s3,s3,a4
 860:	377d                	addiw	a4,a4,-1
 862:	1702                	slli	a4,a4,0x20
 864:	9301                	srli	a4,a4,0x20
 866:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 86a:	fff94583          	lbu	a1,-1(s2)
 86e:	8526                	mv	a0,s1
 870:	00000097          	auipc	ra,0x0
 874:	f56080e7          	jalr	-170(ra) # 7c6 <putc>
  while(--i >= 0)
 878:	197d                	addi	s2,s2,-1
 87a:	ff3918e3          	bne	s2,s3,86a <printint+0x82>
}
 87e:	70e2                	ld	ra,56(sp)
 880:	7442                	ld	s0,48(sp)
 882:	74a2                	ld	s1,40(sp)
 884:	7902                	ld	s2,32(sp)
 886:	69e2                	ld	s3,24(sp)
 888:	6121                	addi	sp,sp,64
 88a:	8082                	ret
    x = -xx;
 88c:	40b005bb          	negw	a1,a1
    neg = 1;
 890:	4885                	li	a7,1
    x = -xx;
 892:	bf85                	j	802 <printint+0x1a>

0000000000000894 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 894:	7119                	addi	sp,sp,-128
 896:	fc86                	sd	ra,120(sp)
 898:	f8a2                	sd	s0,112(sp)
 89a:	f4a6                	sd	s1,104(sp)
 89c:	f0ca                	sd	s2,96(sp)
 89e:	ecce                	sd	s3,88(sp)
 8a0:	e8d2                	sd	s4,80(sp)
 8a2:	e4d6                	sd	s5,72(sp)
 8a4:	e0da                	sd	s6,64(sp)
 8a6:	fc5e                	sd	s7,56(sp)
 8a8:	f862                	sd	s8,48(sp)
 8aa:	f466                	sd	s9,40(sp)
 8ac:	f06a                	sd	s10,32(sp)
 8ae:	ec6e                	sd	s11,24(sp)
 8b0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 8b2:	0005c903          	lbu	s2,0(a1)
 8b6:	18090f63          	beqz	s2,a54 <vprintf+0x1c0>
 8ba:	8aaa                	mv	s5,a0
 8bc:	8b32                	mv	s6,a2
 8be:	00158493          	addi	s1,a1,1
  state = 0;
 8c2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 8c4:	02500a13          	li	s4,37
 8c8:	4c55                	li	s8,21
 8ca:	00000c97          	auipc	s9,0x0
 8ce:	47ec8c93          	addi	s9,s9,1150 # d48 <malloc+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 8d2:	02800d93          	li	s11,40
  putc(fd, 'x');
 8d6:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8d8:	00000b97          	auipc	s7,0x0
 8dc:	4c8b8b93          	addi	s7,s7,1224 # da0 <digits>
 8e0:	a839                	j	8fe <vprintf+0x6a>
        putc(fd, c);
 8e2:	85ca                	mv	a1,s2
 8e4:	8556                	mv	a0,s5
 8e6:	00000097          	auipc	ra,0x0
 8ea:	ee0080e7          	jalr	-288(ra) # 7c6 <putc>
 8ee:	a019                	j	8f4 <vprintf+0x60>
    } else if(state == '%'){
 8f0:	01498d63          	beq	s3,s4,90a <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 8f4:	0485                	addi	s1,s1,1
 8f6:	fff4c903          	lbu	s2,-1(s1)
 8fa:	14090d63          	beqz	s2,a54 <vprintf+0x1c0>
    if(state == 0){
 8fe:	fe0999e3          	bnez	s3,8f0 <vprintf+0x5c>
      if(c == '%'){
 902:	ff4910e3          	bne	s2,s4,8e2 <vprintf+0x4e>
        state = '%';
 906:	89d2                	mv	s3,s4
 908:	b7f5                	j	8f4 <vprintf+0x60>
      if(c == 'd'){
 90a:	11490c63          	beq	s2,s4,a22 <vprintf+0x18e>
 90e:	f9d9079b          	addiw	a5,s2,-99
 912:	0ff7f793          	zext.b	a5,a5
 916:	10fc6e63          	bltu	s8,a5,a32 <vprintf+0x19e>
 91a:	f9d9079b          	addiw	a5,s2,-99
 91e:	0ff7f713          	zext.b	a4,a5
 922:	10ec6863          	bltu	s8,a4,a32 <vprintf+0x19e>
 926:	00271793          	slli	a5,a4,0x2
 92a:	97e6                	add	a5,a5,s9
 92c:	439c                	lw	a5,0(a5)
 92e:	97e6                	add	a5,a5,s9
 930:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 932:	008b0913          	addi	s2,s6,8
 936:	4685                	li	a3,1
 938:	4629                	li	a2,10
 93a:	000b2583          	lw	a1,0(s6)
 93e:	8556                	mv	a0,s5
 940:	00000097          	auipc	ra,0x0
 944:	ea8080e7          	jalr	-344(ra) # 7e8 <printint>
 948:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 94a:	4981                	li	s3,0
 94c:	b765                	j	8f4 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 94e:	008b0913          	addi	s2,s6,8
 952:	4681                	li	a3,0
 954:	4629                	li	a2,10
 956:	000b2583          	lw	a1,0(s6)
 95a:	8556                	mv	a0,s5
 95c:	00000097          	auipc	ra,0x0
 960:	e8c080e7          	jalr	-372(ra) # 7e8 <printint>
 964:	8b4a                	mv	s6,s2
      state = 0;
 966:	4981                	li	s3,0
 968:	b771                	j	8f4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 96a:	008b0913          	addi	s2,s6,8
 96e:	4681                	li	a3,0
 970:	866a                	mv	a2,s10
 972:	000b2583          	lw	a1,0(s6)
 976:	8556                	mv	a0,s5
 978:	00000097          	auipc	ra,0x0
 97c:	e70080e7          	jalr	-400(ra) # 7e8 <printint>
 980:	8b4a                	mv	s6,s2
      state = 0;
 982:	4981                	li	s3,0
 984:	bf85                	j	8f4 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 986:	008b0793          	addi	a5,s6,8
 98a:	f8f43423          	sd	a5,-120(s0)
 98e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 992:	03000593          	li	a1,48
 996:	8556                	mv	a0,s5
 998:	00000097          	auipc	ra,0x0
 99c:	e2e080e7          	jalr	-466(ra) # 7c6 <putc>
  putc(fd, 'x');
 9a0:	07800593          	li	a1,120
 9a4:	8556                	mv	a0,s5
 9a6:	00000097          	auipc	ra,0x0
 9aa:	e20080e7          	jalr	-480(ra) # 7c6 <putc>
 9ae:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9b0:	03c9d793          	srli	a5,s3,0x3c
 9b4:	97de                	add	a5,a5,s7
 9b6:	0007c583          	lbu	a1,0(a5)
 9ba:	8556                	mv	a0,s5
 9bc:	00000097          	auipc	ra,0x0
 9c0:	e0a080e7          	jalr	-502(ra) # 7c6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9c4:	0992                	slli	s3,s3,0x4
 9c6:	397d                	addiw	s2,s2,-1
 9c8:	fe0914e3          	bnez	s2,9b0 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 9cc:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 9d0:	4981                	li	s3,0
 9d2:	b70d                	j	8f4 <vprintf+0x60>
        s = va_arg(ap, char*);
 9d4:	008b0913          	addi	s2,s6,8
 9d8:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 9dc:	02098163          	beqz	s3,9fe <vprintf+0x16a>
        while(*s != 0){
 9e0:	0009c583          	lbu	a1,0(s3)
 9e4:	c5ad                	beqz	a1,a4e <vprintf+0x1ba>
          putc(fd, *s);
 9e6:	8556                	mv	a0,s5
 9e8:	00000097          	auipc	ra,0x0
 9ec:	dde080e7          	jalr	-546(ra) # 7c6 <putc>
          s++;
 9f0:	0985                	addi	s3,s3,1
        while(*s != 0){
 9f2:	0009c583          	lbu	a1,0(s3)
 9f6:	f9e5                	bnez	a1,9e6 <vprintf+0x152>
        s = va_arg(ap, char*);
 9f8:	8b4a                	mv	s6,s2
      state = 0;
 9fa:	4981                	li	s3,0
 9fc:	bde5                	j	8f4 <vprintf+0x60>
          s = "(null)";
 9fe:	00000997          	auipc	s3,0x0
 a02:	34298993          	addi	s3,s3,834 # d40 <malloc+0x1e8>
        while(*s != 0){
 a06:	85ee                	mv	a1,s11
 a08:	bff9                	j	9e6 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 a0a:	008b0913          	addi	s2,s6,8
 a0e:	000b4583          	lbu	a1,0(s6)
 a12:	8556                	mv	a0,s5
 a14:	00000097          	auipc	ra,0x0
 a18:	db2080e7          	jalr	-590(ra) # 7c6 <putc>
 a1c:	8b4a                	mv	s6,s2
      state = 0;
 a1e:	4981                	li	s3,0
 a20:	bdd1                	j	8f4 <vprintf+0x60>
        putc(fd, c);
 a22:	85d2                	mv	a1,s4
 a24:	8556                	mv	a0,s5
 a26:	00000097          	auipc	ra,0x0
 a2a:	da0080e7          	jalr	-608(ra) # 7c6 <putc>
      state = 0;
 a2e:	4981                	li	s3,0
 a30:	b5d1                	j	8f4 <vprintf+0x60>
        putc(fd, '%');
 a32:	85d2                	mv	a1,s4
 a34:	8556                	mv	a0,s5
 a36:	00000097          	auipc	ra,0x0
 a3a:	d90080e7          	jalr	-624(ra) # 7c6 <putc>
        putc(fd, c);
 a3e:	85ca                	mv	a1,s2
 a40:	8556                	mv	a0,s5
 a42:	00000097          	auipc	ra,0x0
 a46:	d84080e7          	jalr	-636(ra) # 7c6 <putc>
      state = 0;
 a4a:	4981                	li	s3,0
 a4c:	b565                	j	8f4 <vprintf+0x60>
        s = va_arg(ap, char*);
 a4e:	8b4a                	mv	s6,s2
      state = 0;
 a50:	4981                	li	s3,0
 a52:	b54d                	j	8f4 <vprintf+0x60>
    }
  }
}
 a54:	70e6                	ld	ra,120(sp)
 a56:	7446                	ld	s0,112(sp)
 a58:	74a6                	ld	s1,104(sp)
 a5a:	7906                	ld	s2,96(sp)
 a5c:	69e6                	ld	s3,88(sp)
 a5e:	6a46                	ld	s4,80(sp)
 a60:	6aa6                	ld	s5,72(sp)
 a62:	6b06                	ld	s6,64(sp)
 a64:	7be2                	ld	s7,56(sp)
 a66:	7c42                	ld	s8,48(sp)
 a68:	7ca2                	ld	s9,40(sp)
 a6a:	7d02                	ld	s10,32(sp)
 a6c:	6de2                	ld	s11,24(sp)
 a6e:	6109                	addi	sp,sp,128
 a70:	8082                	ret

0000000000000a72 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a72:	715d                	addi	sp,sp,-80
 a74:	ec06                	sd	ra,24(sp)
 a76:	e822                	sd	s0,16(sp)
 a78:	1000                	addi	s0,sp,32
 a7a:	e010                	sd	a2,0(s0)
 a7c:	e414                	sd	a3,8(s0)
 a7e:	e818                	sd	a4,16(s0)
 a80:	ec1c                	sd	a5,24(s0)
 a82:	03043023          	sd	a6,32(s0)
 a86:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a8a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a8e:	8622                	mv	a2,s0
 a90:	00000097          	auipc	ra,0x0
 a94:	e04080e7          	jalr	-508(ra) # 894 <vprintf>
}
 a98:	60e2                	ld	ra,24(sp)
 a9a:	6442                	ld	s0,16(sp)
 a9c:	6161                	addi	sp,sp,80
 a9e:	8082                	ret

0000000000000aa0 <printf>:

void
printf(const char *fmt, ...)
{
 aa0:	711d                	addi	sp,sp,-96
 aa2:	ec06                	sd	ra,24(sp)
 aa4:	e822                	sd	s0,16(sp)
 aa6:	1000                	addi	s0,sp,32
 aa8:	e40c                	sd	a1,8(s0)
 aaa:	e810                	sd	a2,16(s0)
 aac:	ec14                	sd	a3,24(s0)
 aae:	f018                	sd	a4,32(s0)
 ab0:	f41c                	sd	a5,40(s0)
 ab2:	03043823          	sd	a6,48(s0)
 ab6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 aba:	00840613          	addi	a2,s0,8
 abe:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ac2:	85aa                	mv	a1,a0
 ac4:	4505                	li	a0,1
 ac6:	00000097          	auipc	ra,0x0
 aca:	dce080e7          	jalr	-562(ra) # 894 <vprintf>
}
 ace:	60e2                	ld	ra,24(sp)
 ad0:	6442                	ld	s0,16(sp)
 ad2:	6125                	addi	sp,sp,96
 ad4:	8082                	ret

0000000000000ad6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ad6:	1141                	addi	sp,sp,-16
 ad8:	e422                	sd	s0,8(sp)
 ada:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 adc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ae0:	00000797          	auipc	a5,0x0
 ae4:	2f87b783          	ld	a5,760(a5) # dd8 <freep>
 ae8:	a02d                	j	b12 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 aea:	4618                	lw	a4,8(a2)
 aec:	9f2d                	addw	a4,a4,a1
 aee:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 af2:	6398                	ld	a4,0(a5)
 af4:	6310                	ld	a2,0(a4)
 af6:	a83d                	j	b34 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 af8:	ff852703          	lw	a4,-8(a0)
 afc:	9f31                	addw	a4,a4,a2
 afe:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b00:	ff053683          	ld	a3,-16(a0)
 b04:	a091                	j	b48 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b06:	6398                	ld	a4,0(a5)
 b08:	00e7e463          	bltu	a5,a4,b10 <free+0x3a>
 b0c:	00e6ea63          	bltu	a3,a4,b20 <free+0x4a>
{
 b10:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b12:	fed7fae3          	bgeu	a5,a3,b06 <free+0x30>
 b16:	6398                	ld	a4,0(a5)
 b18:	00e6e463          	bltu	a3,a4,b20 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b1c:	fee7eae3          	bltu	a5,a4,b10 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 b20:	ff852583          	lw	a1,-8(a0)
 b24:	6390                	ld	a2,0(a5)
 b26:	02059813          	slli	a6,a1,0x20
 b2a:	01c85713          	srli	a4,a6,0x1c
 b2e:	9736                	add	a4,a4,a3
 b30:	fae60de3          	beq	a2,a4,aea <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 b34:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b38:	4790                	lw	a2,8(a5)
 b3a:	02061593          	slli	a1,a2,0x20
 b3e:	01c5d713          	srli	a4,a1,0x1c
 b42:	973e                	add	a4,a4,a5
 b44:	fae68ae3          	beq	a3,a4,af8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 b48:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b4a:	00000717          	auipc	a4,0x0
 b4e:	28f73723          	sd	a5,654(a4) # dd8 <freep>
}
 b52:	6422                	ld	s0,8(sp)
 b54:	0141                	addi	sp,sp,16
 b56:	8082                	ret

0000000000000b58 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b58:	7139                	addi	sp,sp,-64
 b5a:	fc06                	sd	ra,56(sp)
 b5c:	f822                	sd	s0,48(sp)
 b5e:	f426                	sd	s1,40(sp)
 b60:	f04a                	sd	s2,32(sp)
 b62:	ec4e                	sd	s3,24(sp)
 b64:	e852                	sd	s4,16(sp)
 b66:	e456                	sd	s5,8(sp)
 b68:	e05a                	sd	s6,0(sp)
 b6a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b6c:	02051493          	slli	s1,a0,0x20
 b70:	9081                	srli	s1,s1,0x20
 b72:	04bd                	addi	s1,s1,15
 b74:	8091                	srli	s1,s1,0x4
 b76:	0014899b          	addiw	s3,s1,1
 b7a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b7c:	00000517          	auipc	a0,0x0
 b80:	25c53503          	ld	a0,604(a0) # dd8 <freep>
 b84:	c515                	beqz	a0,bb0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b86:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b88:	4798                	lw	a4,8(a5)
 b8a:	02977f63          	bgeu	a4,s1,bc8 <malloc+0x70>
 b8e:	8a4e                	mv	s4,s3
 b90:	0009871b          	sext.w	a4,s3
 b94:	6685                	lui	a3,0x1
 b96:	00d77363          	bgeu	a4,a3,b9c <malloc+0x44>
 b9a:	6a05                	lui	s4,0x1
 b9c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ba0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ba4:	00000917          	auipc	s2,0x0
 ba8:	23490913          	addi	s2,s2,564 # dd8 <freep>
  if(p == (char*)-1)
 bac:	5afd                	li	s5,-1
 bae:	a895                	j	c22 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 bb0:	00008797          	auipc	a5,0x8
 bb4:	41078793          	addi	a5,a5,1040 # 8fc0 <base>
 bb8:	00000717          	auipc	a4,0x0
 bbc:	22f73023          	sd	a5,544(a4) # dd8 <freep>
 bc0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 bc2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 bc6:	b7e1                	j	b8e <malloc+0x36>
      if(p->s.size == nunits)
 bc8:	02e48c63          	beq	s1,a4,c00 <malloc+0xa8>
        p->s.size -= nunits;
 bcc:	4137073b          	subw	a4,a4,s3
 bd0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 bd2:	02071693          	slli	a3,a4,0x20
 bd6:	01c6d713          	srli	a4,a3,0x1c
 bda:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 bdc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 be0:	00000717          	auipc	a4,0x0
 be4:	1ea73c23          	sd	a0,504(a4) # dd8 <freep>
      return (void*)(p + 1);
 be8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 bec:	70e2                	ld	ra,56(sp)
 bee:	7442                	ld	s0,48(sp)
 bf0:	74a2                	ld	s1,40(sp)
 bf2:	7902                	ld	s2,32(sp)
 bf4:	69e2                	ld	s3,24(sp)
 bf6:	6a42                	ld	s4,16(sp)
 bf8:	6aa2                	ld	s5,8(sp)
 bfa:	6b02                	ld	s6,0(sp)
 bfc:	6121                	addi	sp,sp,64
 bfe:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 c00:	6398                	ld	a4,0(a5)
 c02:	e118                	sd	a4,0(a0)
 c04:	bff1                	j	be0 <malloc+0x88>
  hp->s.size = nu;
 c06:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c0a:	0541                	addi	a0,a0,16
 c0c:	00000097          	auipc	ra,0x0
 c10:	eca080e7          	jalr	-310(ra) # ad6 <free>
  return freep;
 c14:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 c18:	d971                	beqz	a0,bec <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c1a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c1c:	4798                	lw	a4,8(a5)
 c1e:	fa9775e3          	bgeu	a4,s1,bc8 <malloc+0x70>
    if(p == freep)
 c22:	00093703          	ld	a4,0(s2)
 c26:	853e                	mv	a0,a5
 c28:	fef719e3          	bne	a4,a5,c1a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 c2c:	8552                	mv	a0,s4
 c2e:	00000097          	auipc	ra,0x0
 c32:	b80080e7          	jalr	-1152(ra) # 7ae <sbrk>
  if(p == (char*)-1)
 c36:	fd5518e3          	bne	a0,s5,c06 <malloc+0xae>
        return 0;
 c3a:	4501                	li	a0,0
 c3c:	bf45                	j	bec <malloc+0x94>
