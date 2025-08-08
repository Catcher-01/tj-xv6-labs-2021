
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	9e013103          	ld	sp,-1568(sp) # 800089e0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	73c050ef          	jal	ra,80005752 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	156080e7          	jalr	342(ra) # 8000019e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	0de080e7          	jalr	222(ra) # 80006138 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	17e080e7          	jalr	382(ra) # 800061ec <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	b76080e7          	jalr	-1162(ra) # 80005c00 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	addi	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	f4250513          	addi	a0,a0,-190 # 80009030 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	fb2080e7          	jalr	-78(ra) # 800060a8 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00026517          	auipc	a0,0x26
    80000106:	13e50513          	addi	a0,a0,318 # 80026240 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00009497          	auipc	s1,0x9
    80000128:	f0c48493          	addi	s1,s1,-244 # 80009030 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	00a080e7          	jalr	10(ra) # 80006138 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	ef450513          	addi	a0,a0,-268 # 80009030 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	0a6080e7          	jalr	166(ra) # 800061ec <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	04a080e7          	jalr	74(ra) # 8000019e <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00009517          	auipc	a0,0x9
    8000016c:	ec850513          	addi	a0,a0,-312 # 80009030 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	07c080e7          	jalr	124(ra) # 800061ec <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <getfreemem>:

uint64 getfreemem(void) {
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
    uint64 n;
    struct run *r;
    // 遍历kmem.freelist链表
    for (n = 0, r = kmem.freelist; r; r = r->next) {
    80000180:	00009797          	auipc	a5,0x9
    80000184:	ec87b783          	ld	a5,-312(a5) # 80009048 <kmem+0x18>
    80000188:	cb89                	beqz	a5,8000019a <getfreemem+0x20>
    8000018a:	4501                	li	a0,0
        ++n;
    8000018c:	0505                	addi	a0,a0,1
    for (n = 0, r = kmem.freelist; r; r = r->next) {
    8000018e:	639c                	ld	a5,0(a5)
    80000190:	fff5                	bnez	a5,8000018c <getfreemem+0x12>
    }
    return n * PGSIZE;
}
    80000192:	0532                	slli	a0,a0,0xc
    80000194:	6422                	ld	s0,8(sp)
    80000196:	0141                	addi	sp,sp,16
    80000198:	8082                	ret
    for (n = 0, r = kmem.freelist; r; r = r->next) {
    8000019a:	4501                	li	a0,0
    8000019c:	bfdd                	j	80000192 <getfreemem+0x18>

000000008000019e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001a4:	ca19                	beqz	a2,800001ba <memset+0x1c>
    800001a6:	87aa                	mv	a5,a0
    800001a8:	1602                	slli	a2,a2,0x20
    800001aa:	9201                	srli	a2,a2,0x20
    800001ac:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001b0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001b4:	0785                	addi	a5,a5,1
    800001b6:	fee79de3          	bne	a5,a4,800001b0 <memset+0x12>
  }
  return dst;
}
    800001ba:	6422                	ld	s0,8(sp)
    800001bc:	0141                	addi	sp,sp,16
    800001be:	8082                	ret

00000000800001c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001c0:	1141                	addi	sp,sp,-16
    800001c2:	e422                	sd	s0,8(sp)
    800001c4:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001c6:	ca05                	beqz	a2,800001f6 <memcmp+0x36>
    800001c8:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001cc:	1682                	slli	a3,a3,0x20
    800001ce:	9281                	srli	a3,a3,0x20
    800001d0:	0685                	addi	a3,a3,1
    800001d2:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001d4:	00054783          	lbu	a5,0(a0)
    800001d8:	0005c703          	lbu	a4,0(a1)
    800001dc:	00e79863          	bne	a5,a4,800001ec <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001e0:	0505                	addi	a0,a0,1
    800001e2:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001e4:	fed518e3          	bne	a0,a3,800001d4 <memcmp+0x14>
  }

  return 0;
    800001e8:	4501                	li	a0,0
    800001ea:	a019                	j	800001f0 <memcmp+0x30>
      return *s1 - *s2;
    800001ec:	40e7853b          	subw	a0,a5,a4
}
    800001f0:	6422                	ld	s0,8(sp)
    800001f2:	0141                	addi	sp,sp,16
    800001f4:	8082                	ret
  return 0;
    800001f6:	4501                	li	a0,0
    800001f8:	bfe5                	j	800001f0 <memcmp+0x30>

00000000800001fa <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001fa:	1141                	addi	sp,sp,-16
    800001fc:	e422                	sd	s0,8(sp)
    800001fe:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000200:	c205                	beqz	a2,80000220 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000202:	02a5e263          	bltu	a1,a0,80000226 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000206:	1602                	slli	a2,a2,0x20
    80000208:	9201                	srli	a2,a2,0x20
    8000020a:	00c587b3          	add	a5,a1,a2
{
    8000020e:	872a                	mv	a4,a0
      *d++ = *s++;
    80000210:	0585                	addi	a1,a1,1
    80000212:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd8dc1>
    80000214:	fff5c683          	lbu	a3,-1(a1)
    80000218:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000021c:	fef59ae3          	bne	a1,a5,80000210 <memmove+0x16>

  return dst;
}
    80000220:	6422                	ld	s0,8(sp)
    80000222:	0141                	addi	sp,sp,16
    80000224:	8082                	ret
  if(s < d && s + n > d){
    80000226:	02061693          	slli	a3,a2,0x20
    8000022a:	9281                	srli	a3,a3,0x20
    8000022c:	00d58733          	add	a4,a1,a3
    80000230:	fce57be3          	bgeu	a0,a4,80000206 <memmove+0xc>
    d += n;
    80000234:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000236:	fff6079b          	addiw	a5,a2,-1
    8000023a:	1782                	slli	a5,a5,0x20
    8000023c:	9381                	srli	a5,a5,0x20
    8000023e:	fff7c793          	not	a5,a5
    80000242:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000244:	177d                	addi	a4,a4,-1
    80000246:	16fd                	addi	a3,a3,-1
    80000248:	00074603          	lbu	a2,0(a4)
    8000024c:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000250:	fee79ae3          	bne	a5,a4,80000244 <memmove+0x4a>
    80000254:	b7f1                	j	80000220 <memmove+0x26>

0000000080000256 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000256:	1141                	addi	sp,sp,-16
    80000258:	e406                	sd	ra,8(sp)
    8000025a:	e022                	sd	s0,0(sp)
    8000025c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000025e:	00000097          	auipc	ra,0x0
    80000262:	f9c080e7          	jalr	-100(ra) # 800001fa <memmove>
}
    80000266:	60a2                	ld	ra,8(sp)
    80000268:	6402                	ld	s0,0(sp)
    8000026a:	0141                	addi	sp,sp,16
    8000026c:	8082                	ret

000000008000026e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000026e:	1141                	addi	sp,sp,-16
    80000270:	e422                	sd	s0,8(sp)
    80000272:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000274:	ce11                	beqz	a2,80000290 <strncmp+0x22>
    80000276:	00054783          	lbu	a5,0(a0)
    8000027a:	cf89                	beqz	a5,80000294 <strncmp+0x26>
    8000027c:	0005c703          	lbu	a4,0(a1)
    80000280:	00f71a63          	bne	a4,a5,80000294 <strncmp+0x26>
    n--, p++, q++;
    80000284:	367d                	addiw	a2,a2,-1
    80000286:	0505                	addi	a0,a0,1
    80000288:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000028a:	f675                	bnez	a2,80000276 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000028c:	4501                	li	a0,0
    8000028e:	a809                	j	800002a0 <strncmp+0x32>
    80000290:	4501                	li	a0,0
    80000292:	a039                	j	800002a0 <strncmp+0x32>
  if(n == 0)
    80000294:	ca09                	beqz	a2,800002a6 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000296:	00054503          	lbu	a0,0(a0)
    8000029a:	0005c783          	lbu	a5,0(a1)
    8000029e:	9d1d                	subw	a0,a0,a5
}
    800002a0:	6422                	ld	s0,8(sp)
    800002a2:	0141                	addi	sp,sp,16
    800002a4:	8082                	ret
    return 0;
    800002a6:	4501                	li	a0,0
    800002a8:	bfe5                	j	800002a0 <strncmp+0x32>

00000000800002aa <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002aa:	1141                	addi	sp,sp,-16
    800002ac:	e422                	sd	s0,8(sp)
    800002ae:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002b0:	872a                	mv	a4,a0
    800002b2:	8832                	mv	a6,a2
    800002b4:	367d                	addiw	a2,a2,-1
    800002b6:	01005963          	blez	a6,800002c8 <strncpy+0x1e>
    800002ba:	0705                	addi	a4,a4,1
    800002bc:	0005c783          	lbu	a5,0(a1)
    800002c0:	fef70fa3          	sb	a5,-1(a4)
    800002c4:	0585                	addi	a1,a1,1
    800002c6:	f7f5                	bnez	a5,800002b2 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002c8:	86ba                	mv	a3,a4
    800002ca:	00c05c63          	blez	a2,800002e2 <strncpy+0x38>
    *s++ = 0;
    800002ce:	0685                	addi	a3,a3,1
    800002d0:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002d4:	40d707bb          	subw	a5,a4,a3
    800002d8:	37fd                	addiw	a5,a5,-1
    800002da:	010787bb          	addw	a5,a5,a6
    800002de:	fef048e3          	bgtz	a5,800002ce <strncpy+0x24>
  return os;
}
    800002e2:	6422                	ld	s0,8(sp)
    800002e4:	0141                	addi	sp,sp,16
    800002e6:	8082                	ret

00000000800002e8 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002e8:	1141                	addi	sp,sp,-16
    800002ea:	e422                	sd	s0,8(sp)
    800002ec:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002ee:	02c05363          	blez	a2,80000314 <safestrcpy+0x2c>
    800002f2:	fff6069b          	addiw	a3,a2,-1
    800002f6:	1682                	slli	a3,a3,0x20
    800002f8:	9281                	srli	a3,a3,0x20
    800002fa:	96ae                	add	a3,a3,a1
    800002fc:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002fe:	00d58963          	beq	a1,a3,80000310 <safestrcpy+0x28>
    80000302:	0585                	addi	a1,a1,1
    80000304:	0785                	addi	a5,a5,1
    80000306:	fff5c703          	lbu	a4,-1(a1)
    8000030a:	fee78fa3          	sb	a4,-1(a5)
    8000030e:	fb65                	bnez	a4,800002fe <safestrcpy+0x16>
    ;
  *s = 0;
    80000310:	00078023          	sb	zero,0(a5)
  return os;
}
    80000314:	6422                	ld	s0,8(sp)
    80000316:	0141                	addi	sp,sp,16
    80000318:	8082                	ret

000000008000031a <strlen>:

int
strlen(const char *s)
{
    8000031a:	1141                	addi	sp,sp,-16
    8000031c:	e422                	sd	s0,8(sp)
    8000031e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000320:	00054783          	lbu	a5,0(a0)
    80000324:	cf91                	beqz	a5,80000340 <strlen+0x26>
    80000326:	0505                	addi	a0,a0,1
    80000328:	87aa                	mv	a5,a0
    8000032a:	4685                	li	a3,1
    8000032c:	9e89                	subw	a3,a3,a0
    8000032e:	00f6853b          	addw	a0,a3,a5
    80000332:	0785                	addi	a5,a5,1
    80000334:	fff7c703          	lbu	a4,-1(a5)
    80000338:	fb7d                	bnez	a4,8000032e <strlen+0x14>
    ;
  return n;
}
    8000033a:	6422                	ld	s0,8(sp)
    8000033c:	0141                	addi	sp,sp,16
    8000033e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000340:	4501                	li	a0,0
    80000342:	bfe5                	j	8000033a <strlen+0x20>

0000000080000344 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000344:	1141                	addi	sp,sp,-16
    80000346:	e406                	sd	ra,8(sp)
    80000348:	e022                	sd	s0,0(sp)
    8000034a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000034c:	00001097          	auipc	ra,0x1
    80000350:	af0080e7          	jalr	-1296(ra) # 80000e3c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000354:	00009717          	auipc	a4,0x9
    80000358:	cac70713          	addi	a4,a4,-852 # 80009000 <started>
  if(cpuid() == 0){
    8000035c:	c139                	beqz	a0,800003a2 <main+0x5e>
    while(started == 0)
    8000035e:	431c                	lw	a5,0(a4)
    80000360:	2781                	sext.w	a5,a5
    80000362:	dff5                	beqz	a5,8000035e <main+0x1a>
      ;
    __sync_synchronize();
    80000364:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000368:	00001097          	auipc	ra,0x1
    8000036c:	ad4080e7          	jalr	-1324(ra) # 80000e3c <cpuid>
    80000370:	85aa                	mv	a1,a0
    80000372:	00008517          	auipc	a0,0x8
    80000376:	cc650513          	addi	a0,a0,-826 # 80008038 <etext+0x38>
    8000037a:	00006097          	auipc	ra,0x6
    8000037e:	8d0080e7          	jalr	-1840(ra) # 80005c4a <printf>
    kvminithart();    // turn on paging
    80000382:	00000097          	auipc	ra,0x0
    80000386:	0d8080e7          	jalr	216(ra) # 8000045a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000038a:	00001097          	auipc	ra,0x1
    8000038e:	768080e7          	jalr	1896(ra) # 80001af2 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000392:	00005097          	auipc	ra,0x5
    80000396:	d9e080e7          	jalr	-610(ra) # 80005130 <plicinithart>
  }

  scheduler();        
    8000039a:	00001097          	auipc	ra,0x1
    8000039e:	fe6080e7          	jalr	-26(ra) # 80001380 <scheduler>
    consoleinit();
    800003a2:	00005097          	auipc	ra,0x5
    800003a6:	76e080e7          	jalr	1902(ra) # 80005b10 <consoleinit>
    printfinit();
    800003aa:	00006097          	auipc	ra,0x6
    800003ae:	a80080e7          	jalr	-1408(ra) # 80005e2a <printfinit>
    printf("\n");
    800003b2:	00008517          	auipc	a0,0x8
    800003b6:	c9650513          	addi	a0,a0,-874 # 80008048 <etext+0x48>
    800003ba:	00006097          	auipc	ra,0x6
    800003be:	890080e7          	jalr	-1904(ra) # 80005c4a <printf>
    printf("xv6 kernel is booting\n");
    800003c2:	00008517          	auipc	a0,0x8
    800003c6:	c5e50513          	addi	a0,a0,-930 # 80008020 <etext+0x20>
    800003ca:	00006097          	auipc	ra,0x6
    800003ce:	880080e7          	jalr	-1920(ra) # 80005c4a <printf>
    printf("\n");
    800003d2:	00008517          	auipc	a0,0x8
    800003d6:	c7650513          	addi	a0,a0,-906 # 80008048 <etext+0x48>
    800003da:	00006097          	auipc	ra,0x6
    800003de:	870080e7          	jalr	-1936(ra) # 80005c4a <printf>
    kinit();         // physical page allocator
    800003e2:	00000097          	auipc	ra,0x0
    800003e6:	cfc080e7          	jalr	-772(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003ea:	00000097          	auipc	ra,0x0
    800003ee:	322080e7          	jalr	802(ra) # 8000070c <kvminit>
    kvminithart();   // turn on paging
    800003f2:	00000097          	auipc	ra,0x0
    800003f6:	068080e7          	jalr	104(ra) # 8000045a <kvminithart>
    procinit();      // process table
    800003fa:	00001097          	auipc	ra,0x1
    800003fe:	992080e7          	jalr	-1646(ra) # 80000d8c <procinit>
    trapinit();      // trap vectors
    80000402:	00001097          	auipc	ra,0x1
    80000406:	6c8080e7          	jalr	1736(ra) # 80001aca <trapinit>
    trapinithart();  // install kernel trap vector
    8000040a:	00001097          	auipc	ra,0x1
    8000040e:	6e8080e7          	jalr	1768(ra) # 80001af2 <trapinithart>
    plicinit();      // set up interrupt controller
    80000412:	00005097          	auipc	ra,0x5
    80000416:	d08080e7          	jalr	-760(ra) # 8000511a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000041a:	00005097          	auipc	ra,0x5
    8000041e:	d16080e7          	jalr	-746(ra) # 80005130 <plicinithart>
    binit();         // buffer cache
    80000422:	00002097          	auipc	ra,0x2
    80000426:	ee0080e7          	jalr	-288(ra) # 80002302 <binit>
    iinit();         // inode table
    8000042a:	00002097          	auipc	ra,0x2
    8000042e:	56e080e7          	jalr	1390(ra) # 80002998 <iinit>
    fileinit();      // file table
    80000432:	00003097          	auipc	ra,0x3
    80000436:	520080e7          	jalr	1312(ra) # 80003952 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000043a:	00005097          	auipc	ra,0x5
    8000043e:	e16080e7          	jalr	-490(ra) # 80005250 <virtio_disk_init>
    userinit();      // first user process
    80000442:	00001097          	auipc	ra,0x1
    80000446:	cfe080e7          	jalr	-770(ra) # 80001140 <userinit>
    __sync_synchronize();
    8000044a:	0ff0000f          	fence
    started = 1;
    8000044e:	4785                	li	a5,1
    80000450:	00009717          	auipc	a4,0x9
    80000454:	baf72823          	sw	a5,-1104(a4) # 80009000 <started>
    80000458:	b789                	j	8000039a <main+0x56>

000000008000045a <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000045a:	1141                	addi	sp,sp,-16
    8000045c:	e422                	sd	s0,8(sp)
    8000045e:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000460:	00009797          	auipc	a5,0x9
    80000464:	ba87b783          	ld	a5,-1112(a5) # 80009008 <kernel_pagetable>
    80000468:	83b1                	srli	a5,a5,0xc
    8000046a:	577d                	li	a4,-1
    8000046c:	177e                	slli	a4,a4,0x3f
    8000046e:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000470:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000474:	12000073          	sfence.vma
  sfence_vma();
}
    80000478:	6422                	ld	s0,8(sp)
    8000047a:	0141                	addi	sp,sp,16
    8000047c:	8082                	ret

000000008000047e <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000047e:	7139                	addi	sp,sp,-64
    80000480:	fc06                	sd	ra,56(sp)
    80000482:	f822                	sd	s0,48(sp)
    80000484:	f426                	sd	s1,40(sp)
    80000486:	f04a                	sd	s2,32(sp)
    80000488:	ec4e                	sd	s3,24(sp)
    8000048a:	e852                	sd	s4,16(sp)
    8000048c:	e456                	sd	s5,8(sp)
    8000048e:	e05a                	sd	s6,0(sp)
    80000490:	0080                	addi	s0,sp,64
    80000492:	84aa                	mv	s1,a0
    80000494:	89ae                	mv	s3,a1
    80000496:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000498:	57fd                	li	a5,-1
    8000049a:	83e9                	srli	a5,a5,0x1a
    8000049c:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000049e:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004a0:	04b7f263          	bgeu	a5,a1,800004e4 <walk+0x66>
    panic("walk");
    800004a4:	00008517          	auipc	a0,0x8
    800004a8:	bac50513          	addi	a0,a0,-1108 # 80008050 <etext+0x50>
    800004ac:	00005097          	auipc	ra,0x5
    800004b0:	754080e7          	jalr	1876(ra) # 80005c00 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004b4:	060a8663          	beqz	s5,80000520 <walk+0xa2>
    800004b8:	00000097          	auipc	ra,0x0
    800004bc:	c62080e7          	jalr	-926(ra) # 8000011a <kalloc>
    800004c0:	84aa                	mv	s1,a0
    800004c2:	c529                	beqz	a0,8000050c <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004c4:	6605                	lui	a2,0x1
    800004c6:	4581                	li	a1,0
    800004c8:	00000097          	auipc	ra,0x0
    800004cc:	cd6080e7          	jalr	-810(ra) # 8000019e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004d0:	00c4d793          	srli	a5,s1,0xc
    800004d4:	07aa                	slli	a5,a5,0xa
    800004d6:	0017e793          	ori	a5,a5,1
    800004da:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004de:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8db7>
    800004e0:	036a0063          	beq	s4,s6,80000500 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004e4:	0149d933          	srl	s2,s3,s4
    800004e8:	1ff97913          	andi	s2,s2,511
    800004ec:	090e                	slli	s2,s2,0x3
    800004ee:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004f0:	00093483          	ld	s1,0(s2)
    800004f4:	0014f793          	andi	a5,s1,1
    800004f8:	dfd5                	beqz	a5,800004b4 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004fa:	80a9                	srli	s1,s1,0xa
    800004fc:	04b2                	slli	s1,s1,0xc
    800004fe:	b7c5                	j	800004de <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000500:	00c9d513          	srli	a0,s3,0xc
    80000504:	1ff57513          	andi	a0,a0,511
    80000508:	050e                	slli	a0,a0,0x3
    8000050a:	9526                	add	a0,a0,s1
}
    8000050c:	70e2                	ld	ra,56(sp)
    8000050e:	7442                	ld	s0,48(sp)
    80000510:	74a2                	ld	s1,40(sp)
    80000512:	7902                	ld	s2,32(sp)
    80000514:	69e2                	ld	s3,24(sp)
    80000516:	6a42                	ld	s4,16(sp)
    80000518:	6aa2                	ld	s5,8(sp)
    8000051a:	6b02                	ld	s6,0(sp)
    8000051c:	6121                	addi	sp,sp,64
    8000051e:	8082                	ret
        return 0;
    80000520:	4501                	li	a0,0
    80000522:	b7ed                	j	8000050c <walk+0x8e>

0000000080000524 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000524:	57fd                	li	a5,-1
    80000526:	83e9                	srli	a5,a5,0x1a
    80000528:	00b7f463          	bgeu	a5,a1,80000530 <walkaddr+0xc>
    return 0;
    8000052c:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000052e:	8082                	ret
{
    80000530:	1141                	addi	sp,sp,-16
    80000532:	e406                	sd	ra,8(sp)
    80000534:	e022                	sd	s0,0(sp)
    80000536:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000538:	4601                	li	a2,0
    8000053a:	00000097          	auipc	ra,0x0
    8000053e:	f44080e7          	jalr	-188(ra) # 8000047e <walk>
  if(pte == 0)
    80000542:	c105                	beqz	a0,80000562 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000544:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000546:	0117f693          	andi	a3,a5,17
    8000054a:	4745                	li	a4,17
    return 0;
    8000054c:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000054e:	00e68663          	beq	a3,a4,8000055a <walkaddr+0x36>
}
    80000552:	60a2                	ld	ra,8(sp)
    80000554:	6402                	ld	s0,0(sp)
    80000556:	0141                	addi	sp,sp,16
    80000558:	8082                	ret
  pa = PTE2PA(*pte);
    8000055a:	83a9                	srli	a5,a5,0xa
    8000055c:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000560:	bfcd                	j	80000552 <walkaddr+0x2e>
    return 0;
    80000562:	4501                	li	a0,0
    80000564:	b7fd                	j	80000552 <walkaddr+0x2e>

0000000080000566 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000566:	715d                	addi	sp,sp,-80
    80000568:	e486                	sd	ra,72(sp)
    8000056a:	e0a2                	sd	s0,64(sp)
    8000056c:	fc26                	sd	s1,56(sp)
    8000056e:	f84a                	sd	s2,48(sp)
    80000570:	f44e                	sd	s3,40(sp)
    80000572:	f052                	sd	s4,32(sp)
    80000574:	ec56                	sd	s5,24(sp)
    80000576:	e85a                	sd	s6,16(sp)
    80000578:	e45e                	sd	s7,8(sp)
    8000057a:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000057c:	c639                	beqz	a2,800005ca <mappages+0x64>
    8000057e:	8aaa                	mv	s5,a0
    80000580:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000582:	777d                	lui	a4,0xfffff
    80000584:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000588:	fff58993          	addi	s3,a1,-1
    8000058c:	99b2                	add	s3,s3,a2
    8000058e:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000592:	893e                	mv	s2,a5
    80000594:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000598:	6b85                	lui	s7,0x1
    8000059a:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000059e:	4605                	li	a2,1
    800005a0:	85ca                	mv	a1,s2
    800005a2:	8556                	mv	a0,s5
    800005a4:	00000097          	auipc	ra,0x0
    800005a8:	eda080e7          	jalr	-294(ra) # 8000047e <walk>
    800005ac:	cd1d                	beqz	a0,800005ea <mappages+0x84>
    if(*pte & PTE_V)
    800005ae:	611c                	ld	a5,0(a0)
    800005b0:	8b85                	andi	a5,a5,1
    800005b2:	e785                	bnez	a5,800005da <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005b4:	80b1                	srli	s1,s1,0xc
    800005b6:	04aa                	slli	s1,s1,0xa
    800005b8:	0164e4b3          	or	s1,s1,s6
    800005bc:	0014e493          	ori	s1,s1,1
    800005c0:	e104                	sd	s1,0(a0)
    if(a == last)
    800005c2:	05390063          	beq	s2,s3,80000602 <mappages+0x9c>
    a += PGSIZE;
    800005c6:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005c8:	bfc9                	j	8000059a <mappages+0x34>
    panic("mappages: size");
    800005ca:	00008517          	auipc	a0,0x8
    800005ce:	a8e50513          	addi	a0,a0,-1394 # 80008058 <etext+0x58>
    800005d2:	00005097          	auipc	ra,0x5
    800005d6:	62e080e7          	jalr	1582(ra) # 80005c00 <panic>
      panic("mappages: remap");
    800005da:	00008517          	auipc	a0,0x8
    800005de:	a8e50513          	addi	a0,a0,-1394 # 80008068 <etext+0x68>
    800005e2:	00005097          	auipc	ra,0x5
    800005e6:	61e080e7          	jalr	1566(ra) # 80005c00 <panic>
      return -1;
    800005ea:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005ec:	60a6                	ld	ra,72(sp)
    800005ee:	6406                	ld	s0,64(sp)
    800005f0:	74e2                	ld	s1,56(sp)
    800005f2:	7942                	ld	s2,48(sp)
    800005f4:	79a2                	ld	s3,40(sp)
    800005f6:	7a02                	ld	s4,32(sp)
    800005f8:	6ae2                	ld	s5,24(sp)
    800005fa:	6b42                	ld	s6,16(sp)
    800005fc:	6ba2                	ld	s7,8(sp)
    800005fe:	6161                	addi	sp,sp,80
    80000600:	8082                	ret
  return 0;
    80000602:	4501                	li	a0,0
    80000604:	b7e5                	j	800005ec <mappages+0x86>

0000000080000606 <kvmmap>:
{
    80000606:	1141                	addi	sp,sp,-16
    80000608:	e406                	sd	ra,8(sp)
    8000060a:	e022                	sd	s0,0(sp)
    8000060c:	0800                	addi	s0,sp,16
    8000060e:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000610:	86b2                	mv	a3,a2
    80000612:	863e                	mv	a2,a5
    80000614:	00000097          	auipc	ra,0x0
    80000618:	f52080e7          	jalr	-174(ra) # 80000566 <mappages>
    8000061c:	e509                	bnez	a0,80000626 <kvmmap+0x20>
}
    8000061e:	60a2                	ld	ra,8(sp)
    80000620:	6402                	ld	s0,0(sp)
    80000622:	0141                	addi	sp,sp,16
    80000624:	8082                	ret
    panic("kvmmap");
    80000626:	00008517          	auipc	a0,0x8
    8000062a:	a5250513          	addi	a0,a0,-1454 # 80008078 <etext+0x78>
    8000062e:	00005097          	auipc	ra,0x5
    80000632:	5d2080e7          	jalr	1490(ra) # 80005c00 <panic>

0000000080000636 <kvmmake>:
{
    80000636:	1101                	addi	sp,sp,-32
    80000638:	ec06                	sd	ra,24(sp)
    8000063a:	e822                	sd	s0,16(sp)
    8000063c:	e426                	sd	s1,8(sp)
    8000063e:	e04a                	sd	s2,0(sp)
    80000640:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000642:	00000097          	auipc	ra,0x0
    80000646:	ad8080e7          	jalr	-1320(ra) # 8000011a <kalloc>
    8000064a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000064c:	6605                	lui	a2,0x1
    8000064e:	4581                	li	a1,0
    80000650:	00000097          	auipc	ra,0x0
    80000654:	b4e080e7          	jalr	-1202(ra) # 8000019e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000658:	4719                	li	a4,6
    8000065a:	6685                	lui	a3,0x1
    8000065c:	10000637          	lui	a2,0x10000
    80000660:	100005b7          	lui	a1,0x10000
    80000664:	8526                	mv	a0,s1
    80000666:	00000097          	auipc	ra,0x0
    8000066a:	fa0080e7          	jalr	-96(ra) # 80000606 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000066e:	4719                	li	a4,6
    80000670:	6685                	lui	a3,0x1
    80000672:	10001637          	lui	a2,0x10001
    80000676:	100015b7          	lui	a1,0x10001
    8000067a:	8526                	mv	a0,s1
    8000067c:	00000097          	auipc	ra,0x0
    80000680:	f8a080e7          	jalr	-118(ra) # 80000606 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000684:	4719                	li	a4,6
    80000686:	004006b7          	lui	a3,0x400
    8000068a:	0c000637          	lui	a2,0xc000
    8000068e:	0c0005b7          	lui	a1,0xc000
    80000692:	8526                	mv	a0,s1
    80000694:	00000097          	auipc	ra,0x0
    80000698:	f72080e7          	jalr	-142(ra) # 80000606 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000069c:	00008917          	auipc	s2,0x8
    800006a0:	96490913          	addi	s2,s2,-1692 # 80008000 <etext>
    800006a4:	4729                	li	a4,10
    800006a6:	80008697          	auipc	a3,0x80008
    800006aa:	95a68693          	addi	a3,a3,-1702 # 8000 <_entry-0x7fff8000>
    800006ae:	4605                	li	a2,1
    800006b0:	067e                	slli	a2,a2,0x1f
    800006b2:	85b2                	mv	a1,a2
    800006b4:	8526                	mv	a0,s1
    800006b6:	00000097          	auipc	ra,0x0
    800006ba:	f50080e7          	jalr	-176(ra) # 80000606 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006be:	4719                	li	a4,6
    800006c0:	46c5                	li	a3,17
    800006c2:	06ee                	slli	a3,a3,0x1b
    800006c4:	412686b3          	sub	a3,a3,s2
    800006c8:	864a                	mv	a2,s2
    800006ca:	85ca                	mv	a1,s2
    800006cc:	8526                	mv	a0,s1
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	f38080e7          	jalr	-200(ra) # 80000606 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006d6:	4729                	li	a4,10
    800006d8:	6685                	lui	a3,0x1
    800006da:	00007617          	auipc	a2,0x7
    800006de:	92660613          	addi	a2,a2,-1754 # 80007000 <_trampoline>
    800006e2:	040005b7          	lui	a1,0x4000
    800006e6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006e8:	05b2                	slli	a1,a1,0xc
    800006ea:	8526                	mv	a0,s1
    800006ec:	00000097          	auipc	ra,0x0
    800006f0:	f1a080e7          	jalr	-230(ra) # 80000606 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006f4:	8526                	mv	a0,s1
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	600080e7          	jalr	1536(ra) # 80000cf6 <proc_mapstacks>
}
    800006fe:	8526                	mv	a0,s1
    80000700:	60e2                	ld	ra,24(sp)
    80000702:	6442                	ld	s0,16(sp)
    80000704:	64a2                	ld	s1,8(sp)
    80000706:	6902                	ld	s2,0(sp)
    80000708:	6105                	addi	sp,sp,32
    8000070a:	8082                	ret

000000008000070c <kvminit>:
{
    8000070c:	1141                	addi	sp,sp,-16
    8000070e:	e406                	sd	ra,8(sp)
    80000710:	e022                	sd	s0,0(sp)
    80000712:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000714:	00000097          	auipc	ra,0x0
    80000718:	f22080e7          	jalr	-222(ra) # 80000636 <kvmmake>
    8000071c:	00009797          	auipc	a5,0x9
    80000720:	8ea7b623          	sd	a0,-1812(a5) # 80009008 <kernel_pagetable>
}
    80000724:	60a2                	ld	ra,8(sp)
    80000726:	6402                	ld	s0,0(sp)
    80000728:	0141                	addi	sp,sp,16
    8000072a:	8082                	ret

000000008000072c <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000072c:	715d                	addi	sp,sp,-80
    8000072e:	e486                	sd	ra,72(sp)
    80000730:	e0a2                	sd	s0,64(sp)
    80000732:	fc26                	sd	s1,56(sp)
    80000734:	f84a                	sd	s2,48(sp)
    80000736:	f44e                	sd	s3,40(sp)
    80000738:	f052                	sd	s4,32(sp)
    8000073a:	ec56                	sd	s5,24(sp)
    8000073c:	e85a                	sd	s6,16(sp)
    8000073e:	e45e                	sd	s7,8(sp)
    80000740:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000742:	03459793          	slli	a5,a1,0x34
    80000746:	e795                	bnez	a5,80000772 <uvmunmap+0x46>
    80000748:	8a2a                	mv	s4,a0
    8000074a:	892e                	mv	s2,a1
    8000074c:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000074e:	0632                	slli	a2,a2,0xc
    80000750:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000754:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000756:	6b05                	lui	s6,0x1
    80000758:	0735e263          	bltu	a1,s3,800007bc <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000075c:	60a6                	ld	ra,72(sp)
    8000075e:	6406                	ld	s0,64(sp)
    80000760:	74e2                	ld	s1,56(sp)
    80000762:	7942                	ld	s2,48(sp)
    80000764:	79a2                	ld	s3,40(sp)
    80000766:	7a02                	ld	s4,32(sp)
    80000768:	6ae2                	ld	s5,24(sp)
    8000076a:	6b42                	ld	s6,16(sp)
    8000076c:	6ba2                	ld	s7,8(sp)
    8000076e:	6161                	addi	sp,sp,80
    80000770:	8082                	ret
    panic("uvmunmap: not aligned");
    80000772:	00008517          	auipc	a0,0x8
    80000776:	90e50513          	addi	a0,a0,-1778 # 80008080 <etext+0x80>
    8000077a:	00005097          	auipc	ra,0x5
    8000077e:	486080e7          	jalr	1158(ra) # 80005c00 <panic>
      panic("uvmunmap: walk");
    80000782:	00008517          	auipc	a0,0x8
    80000786:	91650513          	addi	a0,a0,-1770 # 80008098 <etext+0x98>
    8000078a:	00005097          	auipc	ra,0x5
    8000078e:	476080e7          	jalr	1142(ra) # 80005c00 <panic>
      panic("uvmunmap: not mapped");
    80000792:	00008517          	auipc	a0,0x8
    80000796:	91650513          	addi	a0,a0,-1770 # 800080a8 <etext+0xa8>
    8000079a:	00005097          	auipc	ra,0x5
    8000079e:	466080e7          	jalr	1126(ra) # 80005c00 <panic>
      panic("uvmunmap: not a leaf");
    800007a2:	00008517          	auipc	a0,0x8
    800007a6:	91e50513          	addi	a0,a0,-1762 # 800080c0 <etext+0xc0>
    800007aa:	00005097          	auipc	ra,0x5
    800007ae:	456080e7          	jalr	1110(ra) # 80005c00 <panic>
    *pte = 0;
    800007b2:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007b6:	995a                	add	s2,s2,s6
    800007b8:	fb3972e3          	bgeu	s2,s3,8000075c <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007bc:	4601                	li	a2,0
    800007be:	85ca                	mv	a1,s2
    800007c0:	8552                	mv	a0,s4
    800007c2:	00000097          	auipc	ra,0x0
    800007c6:	cbc080e7          	jalr	-836(ra) # 8000047e <walk>
    800007ca:	84aa                	mv	s1,a0
    800007cc:	d95d                	beqz	a0,80000782 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007ce:	6108                	ld	a0,0(a0)
    800007d0:	00157793          	andi	a5,a0,1
    800007d4:	dfdd                	beqz	a5,80000792 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007d6:	3ff57793          	andi	a5,a0,1023
    800007da:	fd7784e3          	beq	a5,s7,800007a2 <uvmunmap+0x76>
    if(do_free){
    800007de:	fc0a8ae3          	beqz	s5,800007b2 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007e2:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007e4:	0532                	slli	a0,a0,0xc
    800007e6:	00000097          	auipc	ra,0x0
    800007ea:	836080e7          	jalr	-1994(ra) # 8000001c <kfree>
    800007ee:	b7d1                	j	800007b2 <uvmunmap+0x86>

00000000800007f0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007f0:	1101                	addi	sp,sp,-32
    800007f2:	ec06                	sd	ra,24(sp)
    800007f4:	e822                	sd	s0,16(sp)
    800007f6:	e426                	sd	s1,8(sp)
    800007f8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007fa:	00000097          	auipc	ra,0x0
    800007fe:	920080e7          	jalr	-1760(ra) # 8000011a <kalloc>
    80000802:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000804:	c519                	beqz	a0,80000812 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000806:	6605                	lui	a2,0x1
    80000808:	4581                	li	a1,0
    8000080a:	00000097          	auipc	ra,0x0
    8000080e:	994080e7          	jalr	-1644(ra) # 8000019e <memset>
  return pagetable;
}
    80000812:	8526                	mv	a0,s1
    80000814:	60e2                	ld	ra,24(sp)
    80000816:	6442                	ld	s0,16(sp)
    80000818:	64a2                	ld	s1,8(sp)
    8000081a:	6105                	addi	sp,sp,32
    8000081c:	8082                	ret

000000008000081e <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000081e:	7179                	addi	sp,sp,-48
    80000820:	f406                	sd	ra,40(sp)
    80000822:	f022                	sd	s0,32(sp)
    80000824:	ec26                	sd	s1,24(sp)
    80000826:	e84a                	sd	s2,16(sp)
    80000828:	e44e                	sd	s3,8(sp)
    8000082a:	e052                	sd	s4,0(sp)
    8000082c:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000082e:	6785                	lui	a5,0x1
    80000830:	04f67863          	bgeu	a2,a5,80000880 <uvminit+0x62>
    80000834:	8a2a                	mv	s4,a0
    80000836:	89ae                	mv	s3,a1
    80000838:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000083a:	00000097          	auipc	ra,0x0
    8000083e:	8e0080e7          	jalr	-1824(ra) # 8000011a <kalloc>
    80000842:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000844:	6605                	lui	a2,0x1
    80000846:	4581                	li	a1,0
    80000848:	00000097          	auipc	ra,0x0
    8000084c:	956080e7          	jalr	-1706(ra) # 8000019e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000850:	4779                	li	a4,30
    80000852:	86ca                	mv	a3,s2
    80000854:	6605                	lui	a2,0x1
    80000856:	4581                	li	a1,0
    80000858:	8552                	mv	a0,s4
    8000085a:	00000097          	auipc	ra,0x0
    8000085e:	d0c080e7          	jalr	-756(ra) # 80000566 <mappages>
  memmove(mem, src, sz);
    80000862:	8626                	mv	a2,s1
    80000864:	85ce                	mv	a1,s3
    80000866:	854a                	mv	a0,s2
    80000868:	00000097          	auipc	ra,0x0
    8000086c:	992080e7          	jalr	-1646(ra) # 800001fa <memmove>
}
    80000870:	70a2                	ld	ra,40(sp)
    80000872:	7402                	ld	s0,32(sp)
    80000874:	64e2                	ld	s1,24(sp)
    80000876:	6942                	ld	s2,16(sp)
    80000878:	69a2                	ld	s3,8(sp)
    8000087a:	6a02                	ld	s4,0(sp)
    8000087c:	6145                	addi	sp,sp,48
    8000087e:	8082                	ret
    panic("inituvm: more than a page");
    80000880:	00008517          	auipc	a0,0x8
    80000884:	85850513          	addi	a0,a0,-1960 # 800080d8 <etext+0xd8>
    80000888:	00005097          	auipc	ra,0x5
    8000088c:	378080e7          	jalr	888(ra) # 80005c00 <panic>

0000000080000890 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000890:	1101                	addi	sp,sp,-32
    80000892:	ec06                	sd	ra,24(sp)
    80000894:	e822                	sd	s0,16(sp)
    80000896:	e426                	sd	s1,8(sp)
    80000898:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000089a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000089c:	00b67d63          	bgeu	a2,a1,800008b6 <uvmdealloc+0x26>
    800008a0:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008a2:	6785                	lui	a5,0x1
    800008a4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008a6:	00f60733          	add	a4,a2,a5
    800008aa:	76fd                	lui	a3,0xfffff
    800008ac:	8f75                	and	a4,a4,a3
    800008ae:	97ae                	add	a5,a5,a1
    800008b0:	8ff5                	and	a5,a5,a3
    800008b2:	00f76863          	bltu	a4,a5,800008c2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008b6:	8526                	mv	a0,s1
    800008b8:	60e2                	ld	ra,24(sp)
    800008ba:	6442                	ld	s0,16(sp)
    800008bc:	64a2                	ld	s1,8(sp)
    800008be:	6105                	addi	sp,sp,32
    800008c0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008c2:	8f99                	sub	a5,a5,a4
    800008c4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008c6:	4685                	li	a3,1
    800008c8:	0007861b          	sext.w	a2,a5
    800008cc:	85ba                	mv	a1,a4
    800008ce:	00000097          	auipc	ra,0x0
    800008d2:	e5e080e7          	jalr	-418(ra) # 8000072c <uvmunmap>
    800008d6:	b7c5                	j	800008b6 <uvmdealloc+0x26>

00000000800008d8 <uvmalloc>:
  if(newsz < oldsz)
    800008d8:	0ab66163          	bltu	a2,a1,8000097a <uvmalloc+0xa2>
{
    800008dc:	7139                	addi	sp,sp,-64
    800008de:	fc06                	sd	ra,56(sp)
    800008e0:	f822                	sd	s0,48(sp)
    800008e2:	f426                	sd	s1,40(sp)
    800008e4:	f04a                	sd	s2,32(sp)
    800008e6:	ec4e                	sd	s3,24(sp)
    800008e8:	e852                	sd	s4,16(sp)
    800008ea:	e456                	sd	s5,8(sp)
    800008ec:	0080                	addi	s0,sp,64
    800008ee:	8aaa                	mv	s5,a0
    800008f0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008f2:	6785                	lui	a5,0x1
    800008f4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008f6:	95be                	add	a1,a1,a5
    800008f8:	77fd                	lui	a5,0xfffff
    800008fa:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008fe:	08c9f063          	bgeu	s3,a2,8000097e <uvmalloc+0xa6>
    80000902:	894e                	mv	s2,s3
    mem = kalloc();
    80000904:	00000097          	auipc	ra,0x0
    80000908:	816080e7          	jalr	-2026(ra) # 8000011a <kalloc>
    8000090c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000090e:	c51d                	beqz	a0,8000093c <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000910:	6605                	lui	a2,0x1
    80000912:	4581                	li	a1,0
    80000914:	00000097          	auipc	ra,0x0
    80000918:	88a080e7          	jalr	-1910(ra) # 8000019e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    8000091c:	4779                	li	a4,30
    8000091e:	86a6                	mv	a3,s1
    80000920:	6605                	lui	a2,0x1
    80000922:	85ca                	mv	a1,s2
    80000924:	8556                	mv	a0,s5
    80000926:	00000097          	auipc	ra,0x0
    8000092a:	c40080e7          	jalr	-960(ra) # 80000566 <mappages>
    8000092e:	e905                	bnez	a0,8000095e <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000930:	6785                	lui	a5,0x1
    80000932:	993e                	add	s2,s2,a5
    80000934:	fd4968e3          	bltu	s2,s4,80000904 <uvmalloc+0x2c>
  return newsz;
    80000938:	8552                	mv	a0,s4
    8000093a:	a809                	j	8000094c <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000093c:	864e                	mv	a2,s3
    8000093e:	85ca                	mv	a1,s2
    80000940:	8556                	mv	a0,s5
    80000942:	00000097          	auipc	ra,0x0
    80000946:	f4e080e7          	jalr	-178(ra) # 80000890 <uvmdealloc>
      return 0;
    8000094a:	4501                	li	a0,0
}
    8000094c:	70e2                	ld	ra,56(sp)
    8000094e:	7442                	ld	s0,48(sp)
    80000950:	74a2                	ld	s1,40(sp)
    80000952:	7902                	ld	s2,32(sp)
    80000954:	69e2                	ld	s3,24(sp)
    80000956:	6a42                	ld	s4,16(sp)
    80000958:	6aa2                	ld	s5,8(sp)
    8000095a:	6121                	addi	sp,sp,64
    8000095c:	8082                	ret
      kfree(mem);
    8000095e:	8526                	mv	a0,s1
    80000960:	fffff097          	auipc	ra,0xfffff
    80000964:	6bc080e7          	jalr	1724(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000968:	864e                	mv	a2,s3
    8000096a:	85ca                	mv	a1,s2
    8000096c:	8556                	mv	a0,s5
    8000096e:	00000097          	auipc	ra,0x0
    80000972:	f22080e7          	jalr	-222(ra) # 80000890 <uvmdealloc>
      return 0;
    80000976:	4501                	li	a0,0
    80000978:	bfd1                	j	8000094c <uvmalloc+0x74>
    return oldsz;
    8000097a:	852e                	mv	a0,a1
}
    8000097c:	8082                	ret
  return newsz;
    8000097e:	8532                	mv	a0,a2
    80000980:	b7f1                	j	8000094c <uvmalloc+0x74>

0000000080000982 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000982:	7179                	addi	sp,sp,-48
    80000984:	f406                	sd	ra,40(sp)
    80000986:	f022                	sd	s0,32(sp)
    80000988:	ec26                	sd	s1,24(sp)
    8000098a:	e84a                	sd	s2,16(sp)
    8000098c:	e44e                	sd	s3,8(sp)
    8000098e:	e052                	sd	s4,0(sp)
    80000990:	1800                	addi	s0,sp,48
    80000992:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000994:	84aa                	mv	s1,a0
    80000996:	6905                	lui	s2,0x1
    80000998:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000099a:	4985                	li	s3,1
    8000099c:	a829                	j	800009b6 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000099e:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009a0:	00c79513          	slli	a0,a5,0xc
    800009a4:	00000097          	auipc	ra,0x0
    800009a8:	fde080e7          	jalr	-34(ra) # 80000982 <freewalk>
      pagetable[i] = 0;
    800009ac:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009b0:	04a1                	addi	s1,s1,8
    800009b2:	03248163          	beq	s1,s2,800009d4 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009b6:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009b8:	00f7f713          	andi	a4,a5,15
    800009bc:	ff3701e3          	beq	a4,s3,8000099e <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009c0:	8b85                	andi	a5,a5,1
    800009c2:	d7fd                	beqz	a5,800009b0 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009c4:	00007517          	auipc	a0,0x7
    800009c8:	73450513          	addi	a0,a0,1844 # 800080f8 <etext+0xf8>
    800009cc:	00005097          	auipc	ra,0x5
    800009d0:	234080e7          	jalr	564(ra) # 80005c00 <panic>
    }
  }
  kfree((void*)pagetable);
    800009d4:	8552                	mv	a0,s4
    800009d6:	fffff097          	auipc	ra,0xfffff
    800009da:	646080e7          	jalr	1606(ra) # 8000001c <kfree>
}
    800009de:	70a2                	ld	ra,40(sp)
    800009e0:	7402                	ld	s0,32(sp)
    800009e2:	64e2                	ld	s1,24(sp)
    800009e4:	6942                	ld	s2,16(sp)
    800009e6:	69a2                	ld	s3,8(sp)
    800009e8:	6a02                	ld	s4,0(sp)
    800009ea:	6145                	addi	sp,sp,48
    800009ec:	8082                	ret

00000000800009ee <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009ee:	1101                	addi	sp,sp,-32
    800009f0:	ec06                	sd	ra,24(sp)
    800009f2:	e822                	sd	s0,16(sp)
    800009f4:	e426                	sd	s1,8(sp)
    800009f6:	1000                	addi	s0,sp,32
    800009f8:	84aa                	mv	s1,a0
  if(sz > 0)
    800009fa:	e999                	bnez	a1,80000a10 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009fc:	8526                	mv	a0,s1
    800009fe:	00000097          	auipc	ra,0x0
    80000a02:	f84080e7          	jalr	-124(ra) # 80000982 <freewalk>
}
    80000a06:	60e2                	ld	ra,24(sp)
    80000a08:	6442                	ld	s0,16(sp)
    80000a0a:	64a2                	ld	s1,8(sp)
    80000a0c:	6105                	addi	sp,sp,32
    80000a0e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a10:	6785                	lui	a5,0x1
    80000a12:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a14:	95be                	add	a1,a1,a5
    80000a16:	4685                	li	a3,1
    80000a18:	00c5d613          	srli	a2,a1,0xc
    80000a1c:	4581                	li	a1,0
    80000a1e:	00000097          	auipc	ra,0x0
    80000a22:	d0e080e7          	jalr	-754(ra) # 8000072c <uvmunmap>
    80000a26:	bfd9                	j	800009fc <uvmfree+0xe>

0000000080000a28 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a28:	c679                	beqz	a2,80000af6 <uvmcopy+0xce>
{
    80000a2a:	715d                	addi	sp,sp,-80
    80000a2c:	e486                	sd	ra,72(sp)
    80000a2e:	e0a2                	sd	s0,64(sp)
    80000a30:	fc26                	sd	s1,56(sp)
    80000a32:	f84a                	sd	s2,48(sp)
    80000a34:	f44e                	sd	s3,40(sp)
    80000a36:	f052                	sd	s4,32(sp)
    80000a38:	ec56                	sd	s5,24(sp)
    80000a3a:	e85a                	sd	s6,16(sp)
    80000a3c:	e45e                	sd	s7,8(sp)
    80000a3e:	0880                	addi	s0,sp,80
    80000a40:	8b2a                	mv	s6,a0
    80000a42:	8aae                	mv	s5,a1
    80000a44:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a46:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a48:	4601                	li	a2,0
    80000a4a:	85ce                	mv	a1,s3
    80000a4c:	855a                	mv	a0,s6
    80000a4e:	00000097          	auipc	ra,0x0
    80000a52:	a30080e7          	jalr	-1488(ra) # 8000047e <walk>
    80000a56:	c531                	beqz	a0,80000aa2 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a58:	6118                	ld	a4,0(a0)
    80000a5a:	00177793          	andi	a5,a4,1
    80000a5e:	cbb1                	beqz	a5,80000ab2 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a60:	00a75593          	srli	a1,a4,0xa
    80000a64:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a68:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a6c:	fffff097          	auipc	ra,0xfffff
    80000a70:	6ae080e7          	jalr	1710(ra) # 8000011a <kalloc>
    80000a74:	892a                	mv	s2,a0
    80000a76:	c939                	beqz	a0,80000acc <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a78:	6605                	lui	a2,0x1
    80000a7a:	85de                	mv	a1,s7
    80000a7c:	fffff097          	auipc	ra,0xfffff
    80000a80:	77e080e7          	jalr	1918(ra) # 800001fa <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a84:	8726                	mv	a4,s1
    80000a86:	86ca                	mv	a3,s2
    80000a88:	6605                	lui	a2,0x1
    80000a8a:	85ce                	mv	a1,s3
    80000a8c:	8556                	mv	a0,s5
    80000a8e:	00000097          	auipc	ra,0x0
    80000a92:	ad8080e7          	jalr	-1320(ra) # 80000566 <mappages>
    80000a96:	e515                	bnez	a0,80000ac2 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a98:	6785                	lui	a5,0x1
    80000a9a:	99be                	add	s3,s3,a5
    80000a9c:	fb49e6e3          	bltu	s3,s4,80000a48 <uvmcopy+0x20>
    80000aa0:	a081                	j	80000ae0 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000aa2:	00007517          	auipc	a0,0x7
    80000aa6:	66650513          	addi	a0,a0,1638 # 80008108 <etext+0x108>
    80000aaa:	00005097          	auipc	ra,0x5
    80000aae:	156080e7          	jalr	342(ra) # 80005c00 <panic>
      panic("uvmcopy: page not present");
    80000ab2:	00007517          	auipc	a0,0x7
    80000ab6:	67650513          	addi	a0,a0,1654 # 80008128 <etext+0x128>
    80000aba:	00005097          	auipc	ra,0x5
    80000abe:	146080e7          	jalr	326(ra) # 80005c00 <panic>
      kfree(mem);
    80000ac2:	854a                	mv	a0,s2
    80000ac4:	fffff097          	auipc	ra,0xfffff
    80000ac8:	558080e7          	jalr	1368(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000acc:	4685                	li	a3,1
    80000ace:	00c9d613          	srli	a2,s3,0xc
    80000ad2:	4581                	li	a1,0
    80000ad4:	8556                	mv	a0,s5
    80000ad6:	00000097          	auipc	ra,0x0
    80000ada:	c56080e7          	jalr	-938(ra) # 8000072c <uvmunmap>
  return -1;
    80000ade:	557d                	li	a0,-1
}
    80000ae0:	60a6                	ld	ra,72(sp)
    80000ae2:	6406                	ld	s0,64(sp)
    80000ae4:	74e2                	ld	s1,56(sp)
    80000ae6:	7942                	ld	s2,48(sp)
    80000ae8:	79a2                	ld	s3,40(sp)
    80000aea:	7a02                	ld	s4,32(sp)
    80000aec:	6ae2                	ld	s5,24(sp)
    80000aee:	6b42                	ld	s6,16(sp)
    80000af0:	6ba2                	ld	s7,8(sp)
    80000af2:	6161                	addi	sp,sp,80
    80000af4:	8082                	ret
  return 0;
    80000af6:	4501                	li	a0,0
}
    80000af8:	8082                	ret

0000000080000afa <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000afa:	1141                	addi	sp,sp,-16
    80000afc:	e406                	sd	ra,8(sp)
    80000afe:	e022                	sd	s0,0(sp)
    80000b00:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b02:	4601                	li	a2,0
    80000b04:	00000097          	auipc	ra,0x0
    80000b08:	97a080e7          	jalr	-1670(ra) # 8000047e <walk>
  if(pte == 0)
    80000b0c:	c901                	beqz	a0,80000b1c <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b0e:	611c                	ld	a5,0(a0)
    80000b10:	9bbd                	andi	a5,a5,-17
    80000b12:	e11c                	sd	a5,0(a0)
}
    80000b14:	60a2                	ld	ra,8(sp)
    80000b16:	6402                	ld	s0,0(sp)
    80000b18:	0141                	addi	sp,sp,16
    80000b1a:	8082                	ret
    panic("uvmclear");
    80000b1c:	00007517          	auipc	a0,0x7
    80000b20:	62c50513          	addi	a0,a0,1580 # 80008148 <etext+0x148>
    80000b24:	00005097          	auipc	ra,0x5
    80000b28:	0dc080e7          	jalr	220(ra) # 80005c00 <panic>

0000000080000b2c <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b2c:	c6bd                	beqz	a3,80000b9a <copyout+0x6e>
{
    80000b2e:	715d                	addi	sp,sp,-80
    80000b30:	e486                	sd	ra,72(sp)
    80000b32:	e0a2                	sd	s0,64(sp)
    80000b34:	fc26                	sd	s1,56(sp)
    80000b36:	f84a                	sd	s2,48(sp)
    80000b38:	f44e                	sd	s3,40(sp)
    80000b3a:	f052                	sd	s4,32(sp)
    80000b3c:	ec56                	sd	s5,24(sp)
    80000b3e:	e85a                	sd	s6,16(sp)
    80000b40:	e45e                	sd	s7,8(sp)
    80000b42:	e062                	sd	s8,0(sp)
    80000b44:	0880                	addi	s0,sp,80
    80000b46:	8b2a                	mv	s6,a0
    80000b48:	8c2e                	mv	s8,a1
    80000b4a:	8a32                	mv	s4,a2
    80000b4c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b4e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b50:	6a85                	lui	s5,0x1
    80000b52:	a015                	j	80000b76 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b54:	9562                	add	a0,a0,s8
    80000b56:	0004861b          	sext.w	a2,s1
    80000b5a:	85d2                	mv	a1,s4
    80000b5c:	41250533          	sub	a0,a0,s2
    80000b60:	fffff097          	auipc	ra,0xfffff
    80000b64:	69a080e7          	jalr	1690(ra) # 800001fa <memmove>

    len -= n;
    80000b68:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b6c:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b6e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b72:	02098263          	beqz	s3,80000b96 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b76:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b7a:	85ca                	mv	a1,s2
    80000b7c:	855a                	mv	a0,s6
    80000b7e:	00000097          	auipc	ra,0x0
    80000b82:	9a6080e7          	jalr	-1626(ra) # 80000524 <walkaddr>
    if(pa0 == 0)
    80000b86:	cd01                	beqz	a0,80000b9e <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b88:	418904b3          	sub	s1,s2,s8
    80000b8c:	94d6                	add	s1,s1,s5
    80000b8e:	fc99f3e3          	bgeu	s3,s1,80000b54 <copyout+0x28>
    80000b92:	84ce                	mv	s1,s3
    80000b94:	b7c1                	j	80000b54 <copyout+0x28>
  }
  return 0;
    80000b96:	4501                	li	a0,0
    80000b98:	a021                	j	80000ba0 <copyout+0x74>
    80000b9a:	4501                	li	a0,0
}
    80000b9c:	8082                	ret
      return -1;
    80000b9e:	557d                	li	a0,-1
}
    80000ba0:	60a6                	ld	ra,72(sp)
    80000ba2:	6406                	ld	s0,64(sp)
    80000ba4:	74e2                	ld	s1,56(sp)
    80000ba6:	7942                	ld	s2,48(sp)
    80000ba8:	79a2                	ld	s3,40(sp)
    80000baa:	7a02                	ld	s4,32(sp)
    80000bac:	6ae2                	ld	s5,24(sp)
    80000bae:	6b42                	ld	s6,16(sp)
    80000bb0:	6ba2                	ld	s7,8(sp)
    80000bb2:	6c02                	ld	s8,0(sp)
    80000bb4:	6161                	addi	sp,sp,80
    80000bb6:	8082                	ret

0000000080000bb8 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bb8:	caa5                	beqz	a3,80000c28 <copyin+0x70>
{
    80000bba:	715d                	addi	sp,sp,-80
    80000bbc:	e486                	sd	ra,72(sp)
    80000bbe:	e0a2                	sd	s0,64(sp)
    80000bc0:	fc26                	sd	s1,56(sp)
    80000bc2:	f84a                	sd	s2,48(sp)
    80000bc4:	f44e                	sd	s3,40(sp)
    80000bc6:	f052                	sd	s4,32(sp)
    80000bc8:	ec56                	sd	s5,24(sp)
    80000bca:	e85a                	sd	s6,16(sp)
    80000bcc:	e45e                	sd	s7,8(sp)
    80000bce:	e062                	sd	s8,0(sp)
    80000bd0:	0880                	addi	s0,sp,80
    80000bd2:	8b2a                	mv	s6,a0
    80000bd4:	8a2e                	mv	s4,a1
    80000bd6:	8c32                	mv	s8,a2
    80000bd8:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bda:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bdc:	6a85                	lui	s5,0x1
    80000bde:	a01d                	j	80000c04 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000be0:	018505b3          	add	a1,a0,s8
    80000be4:	0004861b          	sext.w	a2,s1
    80000be8:	412585b3          	sub	a1,a1,s2
    80000bec:	8552                	mv	a0,s4
    80000bee:	fffff097          	auipc	ra,0xfffff
    80000bf2:	60c080e7          	jalr	1548(ra) # 800001fa <memmove>

    len -= n;
    80000bf6:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bfa:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bfc:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c00:	02098263          	beqz	s3,80000c24 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c04:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c08:	85ca                	mv	a1,s2
    80000c0a:	855a                	mv	a0,s6
    80000c0c:	00000097          	auipc	ra,0x0
    80000c10:	918080e7          	jalr	-1768(ra) # 80000524 <walkaddr>
    if(pa0 == 0)
    80000c14:	cd01                	beqz	a0,80000c2c <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c16:	418904b3          	sub	s1,s2,s8
    80000c1a:	94d6                	add	s1,s1,s5
    80000c1c:	fc99f2e3          	bgeu	s3,s1,80000be0 <copyin+0x28>
    80000c20:	84ce                	mv	s1,s3
    80000c22:	bf7d                	j	80000be0 <copyin+0x28>
  }
  return 0;
    80000c24:	4501                	li	a0,0
    80000c26:	a021                	j	80000c2e <copyin+0x76>
    80000c28:	4501                	li	a0,0
}
    80000c2a:	8082                	ret
      return -1;
    80000c2c:	557d                	li	a0,-1
}
    80000c2e:	60a6                	ld	ra,72(sp)
    80000c30:	6406                	ld	s0,64(sp)
    80000c32:	74e2                	ld	s1,56(sp)
    80000c34:	7942                	ld	s2,48(sp)
    80000c36:	79a2                	ld	s3,40(sp)
    80000c38:	7a02                	ld	s4,32(sp)
    80000c3a:	6ae2                	ld	s5,24(sp)
    80000c3c:	6b42                	ld	s6,16(sp)
    80000c3e:	6ba2                	ld	s7,8(sp)
    80000c40:	6c02                	ld	s8,0(sp)
    80000c42:	6161                	addi	sp,sp,80
    80000c44:	8082                	ret

0000000080000c46 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c46:	c2dd                	beqz	a3,80000cec <copyinstr+0xa6>
{
    80000c48:	715d                	addi	sp,sp,-80
    80000c4a:	e486                	sd	ra,72(sp)
    80000c4c:	e0a2                	sd	s0,64(sp)
    80000c4e:	fc26                	sd	s1,56(sp)
    80000c50:	f84a                	sd	s2,48(sp)
    80000c52:	f44e                	sd	s3,40(sp)
    80000c54:	f052                	sd	s4,32(sp)
    80000c56:	ec56                	sd	s5,24(sp)
    80000c58:	e85a                	sd	s6,16(sp)
    80000c5a:	e45e                	sd	s7,8(sp)
    80000c5c:	0880                	addi	s0,sp,80
    80000c5e:	8a2a                	mv	s4,a0
    80000c60:	8b2e                	mv	s6,a1
    80000c62:	8bb2                	mv	s7,a2
    80000c64:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c66:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c68:	6985                	lui	s3,0x1
    80000c6a:	a02d                	j	80000c94 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c6c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c70:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c72:	37fd                	addiw	a5,a5,-1
    80000c74:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c78:	60a6                	ld	ra,72(sp)
    80000c7a:	6406                	ld	s0,64(sp)
    80000c7c:	74e2                	ld	s1,56(sp)
    80000c7e:	7942                	ld	s2,48(sp)
    80000c80:	79a2                	ld	s3,40(sp)
    80000c82:	7a02                	ld	s4,32(sp)
    80000c84:	6ae2                	ld	s5,24(sp)
    80000c86:	6b42                	ld	s6,16(sp)
    80000c88:	6ba2                	ld	s7,8(sp)
    80000c8a:	6161                	addi	sp,sp,80
    80000c8c:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c8e:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c92:	c8a9                	beqz	s1,80000ce4 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c94:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c98:	85ca                	mv	a1,s2
    80000c9a:	8552                	mv	a0,s4
    80000c9c:	00000097          	auipc	ra,0x0
    80000ca0:	888080e7          	jalr	-1912(ra) # 80000524 <walkaddr>
    if(pa0 == 0)
    80000ca4:	c131                	beqz	a0,80000ce8 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000ca6:	417906b3          	sub	a3,s2,s7
    80000caa:	96ce                	add	a3,a3,s3
    80000cac:	00d4f363          	bgeu	s1,a3,80000cb2 <copyinstr+0x6c>
    80000cb0:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cb2:	955e                	add	a0,a0,s7
    80000cb4:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cb8:	daf9                	beqz	a3,80000c8e <copyinstr+0x48>
    80000cba:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000cbc:	41650633          	sub	a2,a0,s6
    80000cc0:	fff48593          	addi	a1,s1,-1
    80000cc4:	95da                	add	a1,a1,s6
    while(n > 0){
    80000cc6:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000cc8:	00f60733          	add	a4,a2,a5
    80000ccc:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
    80000cd0:	df51                	beqz	a4,80000c6c <copyinstr+0x26>
        *dst = *p;
    80000cd2:	00e78023          	sb	a4,0(a5)
      --max;
    80000cd6:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000cda:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cdc:	fed796e3          	bne	a5,a3,80000cc8 <copyinstr+0x82>
      dst++;
    80000ce0:	8b3e                	mv	s6,a5
    80000ce2:	b775                	j	80000c8e <copyinstr+0x48>
    80000ce4:	4781                	li	a5,0
    80000ce6:	b771                	j	80000c72 <copyinstr+0x2c>
      return -1;
    80000ce8:	557d                	li	a0,-1
    80000cea:	b779                	j	80000c78 <copyinstr+0x32>
  int got_null = 0;
    80000cec:	4781                	li	a5,0
  if(got_null){
    80000cee:	37fd                	addiw	a5,a5,-1
    80000cf0:	0007851b          	sext.w	a0,a5
}
    80000cf4:	8082                	ret

0000000080000cf6 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cf6:	7139                	addi	sp,sp,-64
    80000cf8:	fc06                	sd	ra,56(sp)
    80000cfa:	f822                	sd	s0,48(sp)
    80000cfc:	f426                	sd	s1,40(sp)
    80000cfe:	f04a                	sd	s2,32(sp)
    80000d00:	ec4e                	sd	s3,24(sp)
    80000d02:	e852                	sd	s4,16(sp)
    80000d04:	e456                	sd	s5,8(sp)
    80000d06:	e05a                	sd	s6,0(sp)
    80000d08:	0080                	addi	s0,sp,64
    80000d0a:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d0c:	00008497          	auipc	s1,0x8
    80000d10:	77448493          	addi	s1,s1,1908 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d14:	8b26                	mv	s6,s1
    80000d16:	00007a97          	auipc	s5,0x7
    80000d1a:	2eaa8a93          	addi	s5,s5,746 # 80008000 <etext>
    80000d1e:	04000937          	lui	s2,0x4000
    80000d22:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d24:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d26:	0000ea17          	auipc	s4,0xe
    80000d2a:	15aa0a13          	addi	s4,s4,346 # 8000ee80 <tickslock>
    char *pa = kalloc();
    80000d2e:	fffff097          	auipc	ra,0xfffff
    80000d32:	3ec080e7          	jalr	1004(ra) # 8000011a <kalloc>
    80000d36:	862a                	mv	a2,a0
    if(pa == 0)
    80000d38:	c131                	beqz	a0,80000d7c <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d3a:	416485b3          	sub	a1,s1,s6
    80000d3e:	858d                	srai	a1,a1,0x3
    80000d40:	000ab783          	ld	a5,0(s5)
    80000d44:	02f585b3          	mul	a1,a1,a5
    80000d48:	2585                	addiw	a1,a1,1
    80000d4a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d4e:	4719                	li	a4,6
    80000d50:	6685                	lui	a3,0x1
    80000d52:	40b905b3          	sub	a1,s2,a1
    80000d56:	854e                	mv	a0,s3
    80000d58:	00000097          	auipc	ra,0x0
    80000d5c:	8ae080e7          	jalr	-1874(ra) # 80000606 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d60:	16848493          	addi	s1,s1,360
    80000d64:	fd4495e3          	bne	s1,s4,80000d2e <proc_mapstacks+0x38>
  }
}
    80000d68:	70e2                	ld	ra,56(sp)
    80000d6a:	7442                	ld	s0,48(sp)
    80000d6c:	74a2                	ld	s1,40(sp)
    80000d6e:	7902                	ld	s2,32(sp)
    80000d70:	69e2                	ld	s3,24(sp)
    80000d72:	6a42                	ld	s4,16(sp)
    80000d74:	6aa2                	ld	s5,8(sp)
    80000d76:	6b02                	ld	s6,0(sp)
    80000d78:	6121                	addi	sp,sp,64
    80000d7a:	8082                	ret
      panic("kalloc");
    80000d7c:	00007517          	auipc	a0,0x7
    80000d80:	3dc50513          	addi	a0,a0,988 # 80008158 <etext+0x158>
    80000d84:	00005097          	auipc	ra,0x5
    80000d88:	e7c080e7          	jalr	-388(ra) # 80005c00 <panic>

0000000080000d8c <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d8c:	7139                	addi	sp,sp,-64
    80000d8e:	fc06                	sd	ra,56(sp)
    80000d90:	f822                	sd	s0,48(sp)
    80000d92:	f426                	sd	s1,40(sp)
    80000d94:	f04a                	sd	s2,32(sp)
    80000d96:	ec4e                	sd	s3,24(sp)
    80000d98:	e852                	sd	s4,16(sp)
    80000d9a:	e456                	sd	s5,8(sp)
    80000d9c:	e05a                	sd	s6,0(sp)
    80000d9e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000da0:	00007597          	auipc	a1,0x7
    80000da4:	3c058593          	addi	a1,a1,960 # 80008160 <etext+0x160>
    80000da8:	00008517          	auipc	a0,0x8
    80000dac:	2a850513          	addi	a0,a0,680 # 80009050 <pid_lock>
    80000db0:	00005097          	auipc	ra,0x5
    80000db4:	2f8080e7          	jalr	760(ra) # 800060a8 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000db8:	00007597          	auipc	a1,0x7
    80000dbc:	3b058593          	addi	a1,a1,944 # 80008168 <etext+0x168>
    80000dc0:	00008517          	auipc	a0,0x8
    80000dc4:	2a850513          	addi	a0,a0,680 # 80009068 <wait_lock>
    80000dc8:	00005097          	auipc	ra,0x5
    80000dcc:	2e0080e7          	jalr	736(ra) # 800060a8 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd0:	00008497          	auipc	s1,0x8
    80000dd4:	6b048493          	addi	s1,s1,1712 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000dd8:	00007b17          	auipc	s6,0x7
    80000ddc:	3a0b0b13          	addi	s6,s6,928 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000de0:	8aa6                	mv	s5,s1
    80000de2:	00007a17          	auipc	s4,0x7
    80000de6:	21ea0a13          	addi	s4,s4,542 # 80008000 <etext>
    80000dea:	04000937          	lui	s2,0x4000
    80000dee:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000df0:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000df2:	0000e997          	auipc	s3,0xe
    80000df6:	08e98993          	addi	s3,s3,142 # 8000ee80 <tickslock>
      initlock(&p->lock, "proc");
    80000dfa:	85da                	mv	a1,s6
    80000dfc:	8526                	mv	a0,s1
    80000dfe:	00005097          	auipc	ra,0x5
    80000e02:	2aa080e7          	jalr	682(ra) # 800060a8 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e06:	415487b3          	sub	a5,s1,s5
    80000e0a:	878d                	srai	a5,a5,0x3
    80000e0c:	000a3703          	ld	a4,0(s4)
    80000e10:	02e787b3          	mul	a5,a5,a4
    80000e14:	2785                	addiw	a5,a5,1
    80000e16:	00d7979b          	slliw	a5,a5,0xd
    80000e1a:	40f907b3          	sub	a5,s2,a5
    80000e1e:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e20:	16848493          	addi	s1,s1,360
    80000e24:	fd349be3          	bne	s1,s3,80000dfa <procinit+0x6e>
  }
}
    80000e28:	70e2                	ld	ra,56(sp)
    80000e2a:	7442                	ld	s0,48(sp)
    80000e2c:	74a2                	ld	s1,40(sp)
    80000e2e:	7902                	ld	s2,32(sp)
    80000e30:	69e2                	ld	s3,24(sp)
    80000e32:	6a42                	ld	s4,16(sp)
    80000e34:	6aa2                	ld	s5,8(sp)
    80000e36:	6b02                	ld	s6,0(sp)
    80000e38:	6121                	addi	sp,sp,64
    80000e3a:	8082                	ret

0000000080000e3c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e3c:	1141                	addi	sp,sp,-16
    80000e3e:	e422                	sd	s0,8(sp)
    80000e40:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e42:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e44:	2501                	sext.w	a0,a0
    80000e46:	6422                	ld	s0,8(sp)
    80000e48:	0141                	addi	sp,sp,16
    80000e4a:	8082                	ret

0000000080000e4c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e4c:	1141                	addi	sp,sp,-16
    80000e4e:	e422                	sd	s0,8(sp)
    80000e50:	0800                	addi	s0,sp,16
    80000e52:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e54:	2781                	sext.w	a5,a5
    80000e56:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e58:	00008517          	auipc	a0,0x8
    80000e5c:	22850513          	addi	a0,a0,552 # 80009080 <cpus>
    80000e60:	953e                	add	a0,a0,a5
    80000e62:	6422                	ld	s0,8(sp)
    80000e64:	0141                	addi	sp,sp,16
    80000e66:	8082                	ret

0000000080000e68 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e68:	1101                	addi	sp,sp,-32
    80000e6a:	ec06                	sd	ra,24(sp)
    80000e6c:	e822                	sd	s0,16(sp)
    80000e6e:	e426                	sd	s1,8(sp)
    80000e70:	1000                	addi	s0,sp,32
  push_off();
    80000e72:	00005097          	auipc	ra,0x5
    80000e76:	27a080e7          	jalr	634(ra) # 800060ec <push_off>
    80000e7a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e7c:	2781                	sext.w	a5,a5
    80000e7e:	079e                	slli	a5,a5,0x7
    80000e80:	00008717          	auipc	a4,0x8
    80000e84:	1d070713          	addi	a4,a4,464 # 80009050 <pid_lock>
    80000e88:	97ba                	add	a5,a5,a4
    80000e8a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e8c:	00005097          	auipc	ra,0x5
    80000e90:	300080e7          	jalr	768(ra) # 8000618c <pop_off>
  return p;
}
    80000e94:	8526                	mv	a0,s1
    80000e96:	60e2                	ld	ra,24(sp)
    80000e98:	6442                	ld	s0,16(sp)
    80000e9a:	64a2                	ld	s1,8(sp)
    80000e9c:	6105                	addi	sp,sp,32
    80000e9e:	8082                	ret

0000000080000ea0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ea0:	1141                	addi	sp,sp,-16
    80000ea2:	e406                	sd	ra,8(sp)
    80000ea4:	e022                	sd	s0,0(sp)
    80000ea6:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ea8:	00000097          	auipc	ra,0x0
    80000eac:	fc0080e7          	jalr	-64(ra) # 80000e68 <myproc>
    80000eb0:	00005097          	auipc	ra,0x5
    80000eb4:	33c080e7          	jalr	828(ra) # 800061ec <release>

  if (first) {
    80000eb8:	00008797          	auipc	a5,0x8
    80000ebc:	ad87a783          	lw	a5,-1320(a5) # 80008990 <first.1>
    80000ec0:	eb89                	bnez	a5,80000ed2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ec2:	00001097          	auipc	ra,0x1
    80000ec6:	c48080e7          	jalr	-952(ra) # 80001b0a <usertrapret>
}
    80000eca:	60a2                	ld	ra,8(sp)
    80000ecc:	6402                	ld	s0,0(sp)
    80000ece:	0141                	addi	sp,sp,16
    80000ed0:	8082                	ret
    first = 0;
    80000ed2:	00008797          	auipc	a5,0x8
    80000ed6:	aa07af23          	sw	zero,-1346(a5) # 80008990 <first.1>
    fsinit(ROOTDEV);
    80000eda:	4505                	li	a0,1
    80000edc:	00002097          	auipc	ra,0x2
    80000ee0:	a3c080e7          	jalr	-1476(ra) # 80002918 <fsinit>
    80000ee4:	bff9                	j	80000ec2 <forkret+0x22>

0000000080000ee6 <allocpid>:
allocpid() {
    80000ee6:	1101                	addi	sp,sp,-32
    80000ee8:	ec06                	sd	ra,24(sp)
    80000eea:	e822                	sd	s0,16(sp)
    80000eec:	e426                	sd	s1,8(sp)
    80000eee:	e04a                	sd	s2,0(sp)
    80000ef0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ef2:	00008917          	auipc	s2,0x8
    80000ef6:	15e90913          	addi	s2,s2,350 # 80009050 <pid_lock>
    80000efa:	854a                	mv	a0,s2
    80000efc:	00005097          	auipc	ra,0x5
    80000f00:	23c080e7          	jalr	572(ra) # 80006138 <acquire>
  pid = nextpid;
    80000f04:	00008797          	auipc	a5,0x8
    80000f08:	a9078793          	addi	a5,a5,-1392 # 80008994 <nextpid>
    80000f0c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f0e:	0014871b          	addiw	a4,s1,1
    80000f12:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f14:	854a                	mv	a0,s2
    80000f16:	00005097          	auipc	ra,0x5
    80000f1a:	2d6080e7          	jalr	726(ra) # 800061ec <release>
}
    80000f1e:	8526                	mv	a0,s1
    80000f20:	60e2                	ld	ra,24(sp)
    80000f22:	6442                	ld	s0,16(sp)
    80000f24:	64a2                	ld	s1,8(sp)
    80000f26:	6902                	ld	s2,0(sp)
    80000f28:	6105                	addi	sp,sp,32
    80000f2a:	8082                	ret

0000000080000f2c <proc_pagetable>:
{
    80000f2c:	1101                	addi	sp,sp,-32
    80000f2e:	ec06                	sd	ra,24(sp)
    80000f30:	e822                	sd	s0,16(sp)
    80000f32:	e426                	sd	s1,8(sp)
    80000f34:	e04a                	sd	s2,0(sp)
    80000f36:	1000                	addi	s0,sp,32
    80000f38:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f3a:	00000097          	auipc	ra,0x0
    80000f3e:	8b6080e7          	jalr	-1866(ra) # 800007f0 <uvmcreate>
    80000f42:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f44:	c121                	beqz	a0,80000f84 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f46:	4729                	li	a4,10
    80000f48:	00006697          	auipc	a3,0x6
    80000f4c:	0b868693          	addi	a3,a3,184 # 80007000 <_trampoline>
    80000f50:	6605                	lui	a2,0x1
    80000f52:	040005b7          	lui	a1,0x4000
    80000f56:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f58:	05b2                	slli	a1,a1,0xc
    80000f5a:	fffff097          	auipc	ra,0xfffff
    80000f5e:	60c080e7          	jalr	1548(ra) # 80000566 <mappages>
    80000f62:	02054863          	bltz	a0,80000f92 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f66:	4719                	li	a4,6
    80000f68:	05893683          	ld	a3,88(s2)
    80000f6c:	6605                	lui	a2,0x1
    80000f6e:	020005b7          	lui	a1,0x2000
    80000f72:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f74:	05b6                	slli	a1,a1,0xd
    80000f76:	8526                	mv	a0,s1
    80000f78:	fffff097          	auipc	ra,0xfffff
    80000f7c:	5ee080e7          	jalr	1518(ra) # 80000566 <mappages>
    80000f80:	02054163          	bltz	a0,80000fa2 <proc_pagetable+0x76>
}
    80000f84:	8526                	mv	a0,s1
    80000f86:	60e2                	ld	ra,24(sp)
    80000f88:	6442                	ld	s0,16(sp)
    80000f8a:	64a2                	ld	s1,8(sp)
    80000f8c:	6902                	ld	s2,0(sp)
    80000f8e:	6105                	addi	sp,sp,32
    80000f90:	8082                	ret
    uvmfree(pagetable, 0);
    80000f92:	4581                	li	a1,0
    80000f94:	8526                	mv	a0,s1
    80000f96:	00000097          	auipc	ra,0x0
    80000f9a:	a58080e7          	jalr	-1448(ra) # 800009ee <uvmfree>
    return 0;
    80000f9e:	4481                	li	s1,0
    80000fa0:	b7d5                	j	80000f84 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fa2:	4681                	li	a3,0
    80000fa4:	4605                	li	a2,1
    80000fa6:	040005b7          	lui	a1,0x4000
    80000faa:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fac:	05b2                	slli	a1,a1,0xc
    80000fae:	8526                	mv	a0,s1
    80000fb0:	fffff097          	auipc	ra,0xfffff
    80000fb4:	77c080e7          	jalr	1916(ra) # 8000072c <uvmunmap>
    uvmfree(pagetable, 0);
    80000fb8:	4581                	li	a1,0
    80000fba:	8526                	mv	a0,s1
    80000fbc:	00000097          	auipc	ra,0x0
    80000fc0:	a32080e7          	jalr	-1486(ra) # 800009ee <uvmfree>
    return 0;
    80000fc4:	4481                	li	s1,0
    80000fc6:	bf7d                	j	80000f84 <proc_pagetable+0x58>

0000000080000fc8 <proc_freepagetable>:
{
    80000fc8:	1101                	addi	sp,sp,-32
    80000fca:	ec06                	sd	ra,24(sp)
    80000fcc:	e822                	sd	s0,16(sp)
    80000fce:	e426                	sd	s1,8(sp)
    80000fd0:	e04a                	sd	s2,0(sp)
    80000fd2:	1000                	addi	s0,sp,32
    80000fd4:	84aa                	mv	s1,a0
    80000fd6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fd8:	4681                	li	a3,0
    80000fda:	4605                	li	a2,1
    80000fdc:	040005b7          	lui	a1,0x4000
    80000fe0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fe2:	05b2                	slli	a1,a1,0xc
    80000fe4:	fffff097          	auipc	ra,0xfffff
    80000fe8:	748080e7          	jalr	1864(ra) # 8000072c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fec:	4681                	li	a3,0
    80000fee:	4605                	li	a2,1
    80000ff0:	020005b7          	lui	a1,0x2000
    80000ff4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000ff6:	05b6                	slli	a1,a1,0xd
    80000ff8:	8526                	mv	a0,s1
    80000ffa:	fffff097          	auipc	ra,0xfffff
    80000ffe:	732080e7          	jalr	1842(ra) # 8000072c <uvmunmap>
  uvmfree(pagetable, sz);
    80001002:	85ca                	mv	a1,s2
    80001004:	8526                	mv	a0,s1
    80001006:	00000097          	auipc	ra,0x0
    8000100a:	9e8080e7          	jalr	-1560(ra) # 800009ee <uvmfree>
}
    8000100e:	60e2                	ld	ra,24(sp)
    80001010:	6442                	ld	s0,16(sp)
    80001012:	64a2                	ld	s1,8(sp)
    80001014:	6902                	ld	s2,0(sp)
    80001016:	6105                	addi	sp,sp,32
    80001018:	8082                	ret

000000008000101a <freeproc>:
{
    8000101a:	1101                	addi	sp,sp,-32
    8000101c:	ec06                	sd	ra,24(sp)
    8000101e:	e822                	sd	s0,16(sp)
    80001020:	e426                	sd	s1,8(sp)
    80001022:	1000                	addi	s0,sp,32
    80001024:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001026:	6d28                	ld	a0,88(a0)
    80001028:	c509                	beqz	a0,80001032 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000102a:	fffff097          	auipc	ra,0xfffff
    8000102e:	ff2080e7          	jalr	-14(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001032:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001036:	68a8                	ld	a0,80(s1)
    80001038:	c511                	beqz	a0,80001044 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000103a:	64ac                	ld	a1,72(s1)
    8000103c:	00000097          	auipc	ra,0x0
    80001040:	f8c080e7          	jalr	-116(ra) # 80000fc8 <proc_freepagetable>
  p->pagetable = 0;
    80001044:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001048:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000104c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001050:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001054:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001058:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000105c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001060:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001064:	0004ac23          	sw	zero,24(s1)
}
    80001068:	60e2                	ld	ra,24(sp)
    8000106a:	6442                	ld	s0,16(sp)
    8000106c:	64a2                	ld	s1,8(sp)
    8000106e:	6105                	addi	sp,sp,32
    80001070:	8082                	ret

0000000080001072 <allocproc>:
{
    80001072:	1101                	addi	sp,sp,-32
    80001074:	ec06                	sd	ra,24(sp)
    80001076:	e822                	sd	s0,16(sp)
    80001078:	e426                	sd	s1,8(sp)
    8000107a:	e04a                	sd	s2,0(sp)
    8000107c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000107e:	00008497          	auipc	s1,0x8
    80001082:	40248493          	addi	s1,s1,1026 # 80009480 <proc>
    80001086:	0000e917          	auipc	s2,0xe
    8000108a:	dfa90913          	addi	s2,s2,-518 # 8000ee80 <tickslock>
    acquire(&p->lock);
    8000108e:	8526                	mv	a0,s1
    80001090:	00005097          	auipc	ra,0x5
    80001094:	0a8080e7          	jalr	168(ra) # 80006138 <acquire>
    if(p->state == UNUSED) {
    80001098:	4c9c                	lw	a5,24(s1)
    8000109a:	cf81                	beqz	a5,800010b2 <allocproc+0x40>
      release(&p->lock);
    8000109c:	8526                	mv	a0,s1
    8000109e:	00005097          	auipc	ra,0x5
    800010a2:	14e080e7          	jalr	334(ra) # 800061ec <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010a6:	16848493          	addi	s1,s1,360
    800010aa:	ff2492e3          	bne	s1,s2,8000108e <allocproc+0x1c>
  return 0;
    800010ae:	4481                	li	s1,0
    800010b0:	a889                	j	80001102 <allocproc+0x90>
  p->pid = allocpid();
    800010b2:	00000097          	auipc	ra,0x0
    800010b6:	e34080e7          	jalr	-460(ra) # 80000ee6 <allocpid>
    800010ba:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010bc:	4785                	li	a5,1
    800010be:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010c0:	fffff097          	auipc	ra,0xfffff
    800010c4:	05a080e7          	jalr	90(ra) # 8000011a <kalloc>
    800010c8:	892a                	mv	s2,a0
    800010ca:	eca8                	sd	a0,88(s1)
    800010cc:	c131                	beqz	a0,80001110 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010ce:	8526                	mv	a0,s1
    800010d0:	00000097          	auipc	ra,0x0
    800010d4:	e5c080e7          	jalr	-420(ra) # 80000f2c <proc_pagetable>
    800010d8:	892a                	mv	s2,a0
    800010da:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010dc:	c531                	beqz	a0,80001128 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010de:	07000613          	li	a2,112
    800010e2:	4581                	li	a1,0
    800010e4:	06048513          	addi	a0,s1,96
    800010e8:	fffff097          	auipc	ra,0xfffff
    800010ec:	0b6080e7          	jalr	182(ra) # 8000019e <memset>
  p->context.ra = (uint64)forkret;
    800010f0:	00000797          	auipc	a5,0x0
    800010f4:	db078793          	addi	a5,a5,-592 # 80000ea0 <forkret>
    800010f8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010fa:	60bc                	ld	a5,64(s1)
    800010fc:	6705                	lui	a4,0x1
    800010fe:	97ba                	add	a5,a5,a4
    80001100:	f4bc                	sd	a5,104(s1)
}
    80001102:	8526                	mv	a0,s1
    80001104:	60e2                	ld	ra,24(sp)
    80001106:	6442                	ld	s0,16(sp)
    80001108:	64a2                	ld	s1,8(sp)
    8000110a:	6902                	ld	s2,0(sp)
    8000110c:	6105                	addi	sp,sp,32
    8000110e:	8082                	ret
    freeproc(p);
    80001110:	8526                	mv	a0,s1
    80001112:	00000097          	auipc	ra,0x0
    80001116:	f08080e7          	jalr	-248(ra) # 8000101a <freeproc>
    release(&p->lock);
    8000111a:	8526                	mv	a0,s1
    8000111c:	00005097          	auipc	ra,0x5
    80001120:	0d0080e7          	jalr	208(ra) # 800061ec <release>
    return 0;
    80001124:	84ca                	mv	s1,s2
    80001126:	bff1                	j	80001102 <allocproc+0x90>
    freeproc(p);
    80001128:	8526                	mv	a0,s1
    8000112a:	00000097          	auipc	ra,0x0
    8000112e:	ef0080e7          	jalr	-272(ra) # 8000101a <freeproc>
    release(&p->lock);
    80001132:	8526                	mv	a0,s1
    80001134:	00005097          	auipc	ra,0x5
    80001138:	0b8080e7          	jalr	184(ra) # 800061ec <release>
    return 0;
    8000113c:	84ca                	mv	s1,s2
    8000113e:	b7d1                	j	80001102 <allocproc+0x90>

0000000080001140 <userinit>:
{
    80001140:	1101                	addi	sp,sp,-32
    80001142:	ec06                	sd	ra,24(sp)
    80001144:	e822                	sd	s0,16(sp)
    80001146:	e426                	sd	s1,8(sp)
    80001148:	1000                	addi	s0,sp,32
  p = allocproc();
    8000114a:	00000097          	auipc	ra,0x0
    8000114e:	f28080e7          	jalr	-216(ra) # 80001072 <allocproc>
    80001152:	84aa                	mv	s1,a0
  initproc = p;
    80001154:	00008797          	auipc	a5,0x8
    80001158:	eaa7be23          	sd	a0,-324(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000115c:	03400613          	li	a2,52
    80001160:	00008597          	auipc	a1,0x8
    80001164:	84058593          	addi	a1,a1,-1984 # 800089a0 <initcode>
    80001168:	6928                	ld	a0,80(a0)
    8000116a:	fffff097          	auipc	ra,0xfffff
    8000116e:	6b4080e7          	jalr	1716(ra) # 8000081e <uvminit>
  p->sz = PGSIZE;
    80001172:	6785                	lui	a5,0x1
    80001174:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001176:	6cb8                	ld	a4,88(s1)
    80001178:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000117c:	6cb8                	ld	a4,88(s1)
    8000117e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001180:	4641                	li	a2,16
    80001182:	00007597          	auipc	a1,0x7
    80001186:	ffe58593          	addi	a1,a1,-2 # 80008180 <etext+0x180>
    8000118a:	15848513          	addi	a0,s1,344
    8000118e:	fffff097          	auipc	ra,0xfffff
    80001192:	15a080e7          	jalr	346(ra) # 800002e8 <safestrcpy>
  p->cwd = namei("/");
    80001196:	00007517          	auipc	a0,0x7
    8000119a:	ffa50513          	addi	a0,a0,-6 # 80008190 <etext+0x190>
    8000119e:	00002097          	auipc	ra,0x2
    800011a2:	1b0080e7          	jalr	432(ra) # 8000334e <namei>
    800011a6:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011aa:	478d                	li	a5,3
    800011ac:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011ae:	8526                	mv	a0,s1
    800011b0:	00005097          	auipc	ra,0x5
    800011b4:	03c080e7          	jalr	60(ra) # 800061ec <release>
}
    800011b8:	60e2                	ld	ra,24(sp)
    800011ba:	6442                	ld	s0,16(sp)
    800011bc:	64a2                	ld	s1,8(sp)
    800011be:	6105                	addi	sp,sp,32
    800011c0:	8082                	ret

00000000800011c2 <growproc>:
{
    800011c2:	1101                	addi	sp,sp,-32
    800011c4:	ec06                	sd	ra,24(sp)
    800011c6:	e822                	sd	s0,16(sp)
    800011c8:	e426                	sd	s1,8(sp)
    800011ca:	e04a                	sd	s2,0(sp)
    800011cc:	1000                	addi	s0,sp,32
    800011ce:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011d0:	00000097          	auipc	ra,0x0
    800011d4:	c98080e7          	jalr	-872(ra) # 80000e68 <myproc>
    800011d8:	892a                	mv	s2,a0
  sz = p->sz;
    800011da:	652c                	ld	a1,72(a0)
    800011dc:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800011e0:	00904f63          	bgtz	s1,800011fe <growproc+0x3c>
  } else if(n < 0){
    800011e4:	0204cd63          	bltz	s1,8000121e <growproc+0x5c>
  p->sz = sz;
    800011e8:	1782                	slli	a5,a5,0x20
    800011ea:	9381                	srli	a5,a5,0x20
    800011ec:	04f93423          	sd	a5,72(s2)
  return 0;
    800011f0:	4501                	li	a0,0
}
    800011f2:	60e2                	ld	ra,24(sp)
    800011f4:	6442                	ld	s0,16(sp)
    800011f6:	64a2                	ld	s1,8(sp)
    800011f8:	6902                	ld	s2,0(sp)
    800011fa:	6105                	addi	sp,sp,32
    800011fc:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011fe:	00f4863b          	addw	a2,s1,a5
    80001202:	1602                	slli	a2,a2,0x20
    80001204:	9201                	srli	a2,a2,0x20
    80001206:	1582                	slli	a1,a1,0x20
    80001208:	9181                	srli	a1,a1,0x20
    8000120a:	6928                	ld	a0,80(a0)
    8000120c:	fffff097          	auipc	ra,0xfffff
    80001210:	6cc080e7          	jalr	1740(ra) # 800008d8 <uvmalloc>
    80001214:	0005079b          	sext.w	a5,a0
    80001218:	fbe1                	bnez	a5,800011e8 <growproc+0x26>
      return -1;
    8000121a:	557d                	li	a0,-1
    8000121c:	bfd9                	j	800011f2 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000121e:	00f4863b          	addw	a2,s1,a5
    80001222:	1602                	slli	a2,a2,0x20
    80001224:	9201                	srli	a2,a2,0x20
    80001226:	1582                	slli	a1,a1,0x20
    80001228:	9181                	srli	a1,a1,0x20
    8000122a:	6928                	ld	a0,80(a0)
    8000122c:	fffff097          	auipc	ra,0xfffff
    80001230:	664080e7          	jalr	1636(ra) # 80000890 <uvmdealloc>
    80001234:	0005079b          	sext.w	a5,a0
    80001238:	bf45                	j	800011e8 <growproc+0x26>

000000008000123a <fork>:
{
    8000123a:	7139                	addi	sp,sp,-64
    8000123c:	fc06                	sd	ra,56(sp)
    8000123e:	f822                	sd	s0,48(sp)
    80001240:	f426                	sd	s1,40(sp)
    80001242:	f04a                	sd	s2,32(sp)
    80001244:	ec4e                	sd	s3,24(sp)
    80001246:	e852                	sd	s4,16(sp)
    80001248:	e456                	sd	s5,8(sp)
    8000124a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000124c:	00000097          	auipc	ra,0x0
    80001250:	c1c080e7          	jalr	-996(ra) # 80000e68 <myproc>
    80001254:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001256:	00000097          	auipc	ra,0x0
    8000125a:	e1c080e7          	jalr	-484(ra) # 80001072 <allocproc>
    8000125e:	10050f63          	beqz	a0,8000137c <fork+0x142>
    80001262:	89aa                	mv	s3,a0
  np->tracemask = p->tracemask;
    80001264:	034aa783          	lw	a5,52(s5)
    80001268:	d95c                	sw	a5,52(a0)
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000126a:	048ab603          	ld	a2,72(s5)
    8000126e:	692c                	ld	a1,80(a0)
    80001270:	050ab503          	ld	a0,80(s5)
    80001274:	fffff097          	auipc	ra,0xfffff
    80001278:	7b4080e7          	jalr	1972(ra) # 80000a28 <uvmcopy>
    8000127c:	04054863          	bltz	a0,800012cc <fork+0x92>
  np->sz = p->sz;
    80001280:	048ab783          	ld	a5,72(s5)
    80001284:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001288:	058ab683          	ld	a3,88(s5)
    8000128c:	87b6                	mv	a5,a3
    8000128e:	0589b703          	ld	a4,88(s3)
    80001292:	12068693          	addi	a3,a3,288
    80001296:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000129a:	6788                	ld	a0,8(a5)
    8000129c:	6b8c                	ld	a1,16(a5)
    8000129e:	6f90                	ld	a2,24(a5)
    800012a0:	01073023          	sd	a6,0(a4)
    800012a4:	e708                	sd	a0,8(a4)
    800012a6:	eb0c                	sd	a1,16(a4)
    800012a8:	ef10                	sd	a2,24(a4)
    800012aa:	02078793          	addi	a5,a5,32
    800012ae:	02070713          	addi	a4,a4,32
    800012b2:	fed792e3          	bne	a5,a3,80001296 <fork+0x5c>
  np->trapframe->a0 = 0;
    800012b6:	0589b783          	ld	a5,88(s3)
    800012ba:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012be:	0d0a8493          	addi	s1,s5,208
    800012c2:	0d098913          	addi	s2,s3,208
    800012c6:	150a8a13          	addi	s4,s5,336
    800012ca:	a00d                	j	800012ec <fork+0xb2>
    freeproc(np);
    800012cc:	854e                	mv	a0,s3
    800012ce:	00000097          	auipc	ra,0x0
    800012d2:	d4c080e7          	jalr	-692(ra) # 8000101a <freeproc>
    release(&np->lock);
    800012d6:	854e                	mv	a0,s3
    800012d8:	00005097          	auipc	ra,0x5
    800012dc:	f14080e7          	jalr	-236(ra) # 800061ec <release>
    return -1;
    800012e0:	597d                	li	s2,-1
    800012e2:	a059                	j	80001368 <fork+0x12e>
  for(i = 0; i < NOFILE; i++)
    800012e4:	04a1                	addi	s1,s1,8
    800012e6:	0921                	addi	s2,s2,8
    800012e8:	01448b63          	beq	s1,s4,800012fe <fork+0xc4>
    if(p->ofile[i])
    800012ec:	6088                	ld	a0,0(s1)
    800012ee:	d97d                	beqz	a0,800012e4 <fork+0xaa>
      np->ofile[i] = filedup(p->ofile[i]);
    800012f0:	00002097          	auipc	ra,0x2
    800012f4:	6f4080e7          	jalr	1780(ra) # 800039e4 <filedup>
    800012f8:	00a93023          	sd	a0,0(s2)
    800012fc:	b7e5                	j	800012e4 <fork+0xaa>
  np->cwd = idup(p->cwd);
    800012fe:	150ab503          	ld	a0,336(s5)
    80001302:	00002097          	auipc	ra,0x2
    80001306:	852080e7          	jalr	-1966(ra) # 80002b54 <idup>
    8000130a:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000130e:	4641                	li	a2,16
    80001310:	158a8593          	addi	a1,s5,344
    80001314:	15898513          	addi	a0,s3,344
    80001318:	fffff097          	auipc	ra,0xfffff
    8000131c:	fd0080e7          	jalr	-48(ra) # 800002e8 <safestrcpy>
  pid = np->pid;
    80001320:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80001324:	854e                	mv	a0,s3
    80001326:	00005097          	auipc	ra,0x5
    8000132a:	ec6080e7          	jalr	-314(ra) # 800061ec <release>
  acquire(&wait_lock);
    8000132e:	00008497          	auipc	s1,0x8
    80001332:	d3a48493          	addi	s1,s1,-710 # 80009068 <wait_lock>
    80001336:	8526                	mv	a0,s1
    80001338:	00005097          	auipc	ra,0x5
    8000133c:	e00080e7          	jalr	-512(ra) # 80006138 <acquire>
  np->parent = p;
    80001340:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001344:	8526                	mv	a0,s1
    80001346:	00005097          	auipc	ra,0x5
    8000134a:	ea6080e7          	jalr	-346(ra) # 800061ec <release>
  acquire(&np->lock);
    8000134e:	854e                	mv	a0,s3
    80001350:	00005097          	auipc	ra,0x5
    80001354:	de8080e7          	jalr	-536(ra) # 80006138 <acquire>
  np->state = RUNNABLE;
    80001358:	478d                	li	a5,3
    8000135a:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000135e:	854e                	mv	a0,s3
    80001360:	00005097          	auipc	ra,0x5
    80001364:	e8c080e7          	jalr	-372(ra) # 800061ec <release>
}
    80001368:	854a                	mv	a0,s2
    8000136a:	70e2                	ld	ra,56(sp)
    8000136c:	7442                	ld	s0,48(sp)
    8000136e:	74a2                	ld	s1,40(sp)
    80001370:	7902                	ld	s2,32(sp)
    80001372:	69e2                	ld	s3,24(sp)
    80001374:	6a42                	ld	s4,16(sp)
    80001376:	6aa2                	ld	s5,8(sp)
    80001378:	6121                	addi	sp,sp,64
    8000137a:	8082                	ret
    return -1;
    8000137c:	597d                	li	s2,-1
    8000137e:	b7ed                	j	80001368 <fork+0x12e>

0000000080001380 <scheduler>:
{
    80001380:	7139                	addi	sp,sp,-64
    80001382:	fc06                	sd	ra,56(sp)
    80001384:	f822                	sd	s0,48(sp)
    80001386:	f426                	sd	s1,40(sp)
    80001388:	f04a                	sd	s2,32(sp)
    8000138a:	ec4e                	sd	s3,24(sp)
    8000138c:	e852                	sd	s4,16(sp)
    8000138e:	e456                	sd	s5,8(sp)
    80001390:	e05a                	sd	s6,0(sp)
    80001392:	0080                	addi	s0,sp,64
    80001394:	8792                	mv	a5,tp
  int id = r_tp();
    80001396:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001398:	00779a93          	slli	s5,a5,0x7
    8000139c:	00008717          	auipc	a4,0x8
    800013a0:	cb470713          	addi	a4,a4,-844 # 80009050 <pid_lock>
    800013a4:	9756                	add	a4,a4,s5
    800013a6:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013aa:	00008717          	auipc	a4,0x8
    800013ae:	cde70713          	addi	a4,a4,-802 # 80009088 <cpus+0x8>
    800013b2:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013b4:	498d                	li	s3,3
        p->state = RUNNING;
    800013b6:	4b11                	li	s6,4
        c->proc = p;
    800013b8:	079e                	slli	a5,a5,0x7
    800013ba:	00008a17          	auipc	s4,0x8
    800013be:	c96a0a13          	addi	s4,s4,-874 # 80009050 <pid_lock>
    800013c2:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013c4:	0000e917          	auipc	s2,0xe
    800013c8:	abc90913          	addi	s2,s2,-1348 # 8000ee80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013cc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013d0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013d4:	10079073          	csrw	sstatus,a5
    800013d8:	00008497          	auipc	s1,0x8
    800013dc:	0a848493          	addi	s1,s1,168 # 80009480 <proc>
    800013e0:	a811                	j	800013f4 <scheduler+0x74>
      release(&p->lock);
    800013e2:	8526                	mv	a0,s1
    800013e4:	00005097          	auipc	ra,0x5
    800013e8:	e08080e7          	jalr	-504(ra) # 800061ec <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013ec:	16848493          	addi	s1,s1,360
    800013f0:	fd248ee3          	beq	s1,s2,800013cc <scheduler+0x4c>
      acquire(&p->lock);
    800013f4:	8526                	mv	a0,s1
    800013f6:	00005097          	auipc	ra,0x5
    800013fa:	d42080e7          	jalr	-702(ra) # 80006138 <acquire>
      if(p->state == RUNNABLE) {
    800013fe:	4c9c                	lw	a5,24(s1)
    80001400:	ff3791e3          	bne	a5,s3,800013e2 <scheduler+0x62>
        p->state = RUNNING;
    80001404:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001408:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000140c:	06048593          	addi	a1,s1,96
    80001410:	8556                	mv	a0,s5
    80001412:	00000097          	auipc	ra,0x0
    80001416:	64e080e7          	jalr	1614(ra) # 80001a60 <swtch>
        c->proc = 0;
    8000141a:	020a3823          	sd	zero,48(s4)
    8000141e:	b7d1                	j	800013e2 <scheduler+0x62>

0000000080001420 <sched>:
{
    80001420:	7179                	addi	sp,sp,-48
    80001422:	f406                	sd	ra,40(sp)
    80001424:	f022                	sd	s0,32(sp)
    80001426:	ec26                	sd	s1,24(sp)
    80001428:	e84a                	sd	s2,16(sp)
    8000142a:	e44e                	sd	s3,8(sp)
    8000142c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000142e:	00000097          	auipc	ra,0x0
    80001432:	a3a080e7          	jalr	-1478(ra) # 80000e68 <myproc>
    80001436:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001438:	00005097          	auipc	ra,0x5
    8000143c:	c86080e7          	jalr	-890(ra) # 800060be <holding>
    80001440:	c93d                	beqz	a0,800014b6 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001442:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001444:	2781                	sext.w	a5,a5
    80001446:	079e                	slli	a5,a5,0x7
    80001448:	00008717          	auipc	a4,0x8
    8000144c:	c0870713          	addi	a4,a4,-1016 # 80009050 <pid_lock>
    80001450:	97ba                	add	a5,a5,a4
    80001452:	0a87a703          	lw	a4,168(a5)
    80001456:	4785                	li	a5,1
    80001458:	06f71763          	bne	a4,a5,800014c6 <sched+0xa6>
  if(p->state == RUNNING)
    8000145c:	4c98                	lw	a4,24(s1)
    8000145e:	4791                	li	a5,4
    80001460:	06f70b63          	beq	a4,a5,800014d6 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001464:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001468:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000146a:	efb5                	bnez	a5,800014e6 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000146c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000146e:	00008917          	auipc	s2,0x8
    80001472:	be290913          	addi	s2,s2,-1054 # 80009050 <pid_lock>
    80001476:	2781                	sext.w	a5,a5
    80001478:	079e                	slli	a5,a5,0x7
    8000147a:	97ca                	add	a5,a5,s2
    8000147c:	0ac7a983          	lw	s3,172(a5)
    80001480:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001482:	2781                	sext.w	a5,a5
    80001484:	079e                	slli	a5,a5,0x7
    80001486:	00008597          	auipc	a1,0x8
    8000148a:	c0258593          	addi	a1,a1,-1022 # 80009088 <cpus+0x8>
    8000148e:	95be                	add	a1,a1,a5
    80001490:	06048513          	addi	a0,s1,96
    80001494:	00000097          	auipc	ra,0x0
    80001498:	5cc080e7          	jalr	1484(ra) # 80001a60 <swtch>
    8000149c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000149e:	2781                	sext.w	a5,a5
    800014a0:	079e                	slli	a5,a5,0x7
    800014a2:	993e                	add	s2,s2,a5
    800014a4:	0b392623          	sw	s3,172(s2)
}
    800014a8:	70a2                	ld	ra,40(sp)
    800014aa:	7402                	ld	s0,32(sp)
    800014ac:	64e2                	ld	s1,24(sp)
    800014ae:	6942                	ld	s2,16(sp)
    800014b0:	69a2                	ld	s3,8(sp)
    800014b2:	6145                	addi	sp,sp,48
    800014b4:	8082                	ret
    panic("sched p->lock");
    800014b6:	00007517          	auipc	a0,0x7
    800014ba:	ce250513          	addi	a0,a0,-798 # 80008198 <etext+0x198>
    800014be:	00004097          	auipc	ra,0x4
    800014c2:	742080e7          	jalr	1858(ra) # 80005c00 <panic>
    panic("sched locks");
    800014c6:	00007517          	auipc	a0,0x7
    800014ca:	ce250513          	addi	a0,a0,-798 # 800081a8 <etext+0x1a8>
    800014ce:	00004097          	auipc	ra,0x4
    800014d2:	732080e7          	jalr	1842(ra) # 80005c00 <panic>
    panic("sched running");
    800014d6:	00007517          	auipc	a0,0x7
    800014da:	ce250513          	addi	a0,a0,-798 # 800081b8 <etext+0x1b8>
    800014de:	00004097          	auipc	ra,0x4
    800014e2:	722080e7          	jalr	1826(ra) # 80005c00 <panic>
    panic("sched interruptible");
    800014e6:	00007517          	auipc	a0,0x7
    800014ea:	ce250513          	addi	a0,a0,-798 # 800081c8 <etext+0x1c8>
    800014ee:	00004097          	auipc	ra,0x4
    800014f2:	712080e7          	jalr	1810(ra) # 80005c00 <panic>

00000000800014f6 <yield>:
{
    800014f6:	1101                	addi	sp,sp,-32
    800014f8:	ec06                	sd	ra,24(sp)
    800014fa:	e822                	sd	s0,16(sp)
    800014fc:	e426                	sd	s1,8(sp)
    800014fe:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001500:	00000097          	auipc	ra,0x0
    80001504:	968080e7          	jalr	-1688(ra) # 80000e68 <myproc>
    80001508:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000150a:	00005097          	auipc	ra,0x5
    8000150e:	c2e080e7          	jalr	-978(ra) # 80006138 <acquire>
  p->state = RUNNABLE;
    80001512:	478d                	li	a5,3
    80001514:	cc9c                	sw	a5,24(s1)
  sched();
    80001516:	00000097          	auipc	ra,0x0
    8000151a:	f0a080e7          	jalr	-246(ra) # 80001420 <sched>
  release(&p->lock);
    8000151e:	8526                	mv	a0,s1
    80001520:	00005097          	auipc	ra,0x5
    80001524:	ccc080e7          	jalr	-820(ra) # 800061ec <release>
}
    80001528:	60e2                	ld	ra,24(sp)
    8000152a:	6442                	ld	s0,16(sp)
    8000152c:	64a2                	ld	s1,8(sp)
    8000152e:	6105                	addi	sp,sp,32
    80001530:	8082                	ret

0000000080001532 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001532:	7179                	addi	sp,sp,-48
    80001534:	f406                	sd	ra,40(sp)
    80001536:	f022                	sd	s0,32(sp)
    80001538:	ec26                	sd	s1,24(sp)
    8000153a:	e84a                	sd	s2,16(sp)
    8000153c:	e44e                	sd	s3,8(sp)
    8000153e:	1800                	addi	s0,sp,48
    80001540:	89aa                	mv	s3,a0
    80001542:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001544:	00000097          	auipc	ra,0x0
    80001548:	924080e7          	jalr	-1756(ra) # 80000e68 <myproc>
    8000154c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000154e:	00005097          	auipc	ra,0x5
    80001552:	bea080e7          	jalr	-1046(ra) # 80006138 <acquire>
  release(lk);
    80001556:	854a                	mv	a0,s2
    80001558:	00005097          	auipc	ra,0x5
    8000155c:	c94080e7          	jalr	-876(ra) # 800061ec <release>

  // Go to sleep.
  p->chan = chan;
    80001560:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001564:	4789                	li	a5,2
    80001566:	cc9c                	sw	a5,24(s1)

  sched();
    80001568:	00000097          	auipc	ra,0x0
    8000156c:	eb8080e7          	jalr	-328(ra) # 80001420 <sched>

  // Tidy up.
  p->chan = 0;
    80001570:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001574:	8526                	mv	a0,s1
    80001576:	00005097          	auipc	ra,0x5
    8000157a:	c76080e7          	jalr	-906(ra) # 800061ec <release>
  acquire(lk);
    8000157e:	854a                	mv	a0,s2
    80001580:	00005097          	auipc	ra,0x5
    80001584:	bb8080e7          	jalr	-1096(ra) # 80006138 <acquire>
}
    80001588:	70a2                	ld	ra,40(sp)
    8000158a:	7402                	ld	s0,32(sp)
    8000158c:	64e2                	ld	s1,24(sp)
    8000158e:	6942                	ld	s2,16(sp)
    80001590:	69a2                	ld	s3,8(sp)
    80001592:	6145                	addi	sp,sp,48
    80001594:	8082                	ret

0000000080001596 <wait>:
{
    80001596:	715d                	addi	sp,sp,-80
    80001598:	e486                	sd	ra,72(sp)
    8000159a:	e0a2                	sd	s0,64(sp)
    8000159c:	fc26                	sd	s1,56(sp)
    8000159e:	f84a                	sd	s2,48(sp)
    800015a0:	f44e                	sd	s3,40(sp)
    800015a2:	f052                	sd	s4,32(sp)
    800015a4:	ec56                	sd	s5,24(sp)
    800015a6:	e85a                	sd	s6,16(sp)
    800015a8:	e45e                	sd	s7,8(sp)
    800015aa:	e062                	sd	s8,0(sp)
    800015ac:	0880                	addi	s0,sp,80
    800015ae:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015b0:	00000097          	auipc	ra,0x0
    800015b4:	8b8080e7          	jalr	-1864(ra) # 80000e68 <myproc>
    800015b8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015ba:	00008517          	auipc	a0,0x8
    800015be:	aae50513          	addi	a0,a0,-1362 # 80009068 <wait_lock>
    800015c2:	00005097          	auipc	ra,0x5
    800015c6:	b76080e7          	jalr	-1162(ra) # 80006138 <acquire>
    havekids = 0;
    800015ca:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015cc:	4a15                	li	s4,5
        havekids = 1;
    800015ce:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015d0:	0000e997          	auipc	s3,0xe
    800015d4:	8b098993          	addi	s3,s3,-1872 # 8000ee80 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015d8:	00008c17          	auipc	s8,0x8
    800015dc:	a90c0c13          	addi	s8,s8,-1392 # 80009068 <wait_lock>
    havekids = 0;
    800015e0:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015e2:	00008497          	auipc	s1,0x8
    800015e6:	e9e48493          	addi	s1,s1,-354 # 80009480 <proc>
    800015ea:	a0bd                	j	80001658 <wait+0xc2>
          pid = np->pid;
    800015ec:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015f0:	000b0e63          	beqz	s6,8000160c <wait+0x76>
    800015f4:	4691                	li	a3,4
    800015f6:	02c48613          	addi	a2,s1,44
    800015fa:	85da                	mv	a1,s6
    800015fc:	05093503          	ld	a0,80(s2)
    80001600:	fffff097          	auipc	ra,0xfffff
    80001604:	52c080e7          	jalr	1324(ra) # 80000b2c <copyout>
    80001608:	02054563          	bltz	a0,80001632 <wait+0x9c>
          freeproc(np);
    8000160c:	8526                	mv	a0,s1
    8000160e:	00000097          	auipc	ra,0x0
    80001612:	a0c080e7          	jalr	-1524(ra) # 8000101a <freeproc>
          release(&np->lock);
    80001616:	8526                	mv	a0,s1
    80001618:	00005097          	auipc	ra,0x5
    8000161c:	bd4080e7          	jalr	-1068(ra) # 800061ec <release>
          release(&wait_lock);
    80001620:	00008517          	auipc	a0,0x8
    80001624:	a4850513          	addi	a0,a0,-1464 # 80009068 <wait_lock>
    80001628:	00005097          	auipc	ra,0x5
    8000162c:	bc4080e7          	jalr	-1084(ra) # 800061ec <release>
          return pid;
    80001630:	a09d                	j	80001696 <wait+0x100>
            release(&np->lock);
    80001632:	8526                	mv	a0,s1
    80001634:	00005097          	auipc	ra,0x5
    80001638:	bb8080e7          	jalr	-1096(ra) # 800061ec <release>
            release(&wait_lock);
    8000163c:	00008517          	auipc	a0,0x8
    80001640:	a2c50513          	addi	a0,a0,-1492 # 80009068 <wait_lock>
    80001644:	00005097          	auipc	ra,0x5
    80001648:	ba8080e7          	jalr	-1112(ra) # 800061ec <release>
            return -1;
    8000164c:	59fd                	li	s3,-1
    8000164e:	a0a1                	j	80001696 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001650:	16848493          	addi	s1,s1,360
    80001654:	03348463          	beq	s1,s3,8000167c <wait+0xe6>
      if(np->parent == p){
    80001658:	7c9c                	ld	a5,56(s1)
    8000165a:	ff279be3          	bne	a5,s2,80001650 <wait+0xba>
        acquire(&np->lock);
    8000165e:	8526                	mv	a0,s1
    80001660:	00005097          	auipc	ra,0x5
    80001664:	ad8080e7          	jalr	-1320(ra) # 80006138 <acquire>
        if(np->state == ZOMBIE){
    80001668:	4c9c                	lw	a5,24(s1)
    8000166a:	f94781e3          	beq	a5,s4,800015ec <wait+0x56>
        release(&np->lock);
    8000166e:	8526                	mv	a0,s1
    80001670:	00005097          	auipc	ra,0x5
    80001674:	b7c080e7          	jalr	-1156(ra) # 800061ec <release>
        havekids = 1;
    80001678:	8756                	mv	a4,s5
    8000167a:	bfd9                	j	80001650 <wait+0xba>
    if(!havekids || p->killed){
    8000167c:	c701                	beqz	a4,80001684 <wait+0xee>
    8000167e:	02892783          	lw	a5,40(s2)
    80001682:	c79d                	beqz	a5,800016b0 <wait+0x11a>
      release(&wait_lock);
    80001684:	00008517          	auipc	a0,0x8
    80001688:	9e450513          	addi	a0,a0,-1564 # 80009068 <wait_lock>
    8000168c:	00005097          	auipc	ra,0x5
    80001690:	b60080e7          	jalr	-1184(ra) # 800061ec <release>
      return -1;
    80001694:	59fd                	li	s3,-1
}
    80001696:	854e                	mv	a0,s3
    80001698:	60a6                	ld	ra,72(sp)
    8000169a:	6406                	ld	s0,64(sp)
    8000169c:	74e2                	ld	s1,56(sp)
    8000169e:	7942                	ld	s2,48(sp)
    800016a0:	79a2                	ld	s3,40(sp)
    800016a2:	7a02                	ld	s4,32(sp)
    800016a4:	6ae2                	ld	s5,24(sp)
    800016a6:	6b42                	ld	s6,16(sp)
    800016a8:	6ba2                	ld	s7,8(sp)
    800016aa:	6c02                	ld	s8,0(sp)
    800016ac:	6161                	addi	sp,sp,80
    800016ae:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016b0:	85e2                	mv	a1,s8
    800016b2:	854a                	mv	a0,s2
    800016b4:	00000097          	auipc	ra,0x0
    800016b8:	e7e080e7          	jalr	-386(ra) # 80001532 <sleep>
    havekids = 0;
    800016bc:	b715                	j	800015e0 <wait+0x4a>

00000000800016be <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016be:	7139                	addi	sp,sp,-64
    800016c0:	fc06                	sd	ra,56(sp)
    800016c2:	f822                	sd	s0,48(sp)
    800016c4:	f426                	sd	s1,40(sp)
    800016c6:	f04a                	sd	s2,32(sp)
    800016c8:	ec4e                	sd	s3,24(sp)
    800016ca:	e852                	sd	s4,16(sp)
    800016cc:	e456                	sd	s5,8(sp)
    800016ce:	0080                	addi	s0,sp,64
    800016d0:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016d2:	00008497          	auipc	s1,0x8
    800016d6:	dae48493          	addi	s1,s1,-594 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016da:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016dc:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016de:	0000d917          	auipc	s2,0xd
    800016e2:	7a290913          	addi	s2,s2,1954 # 8000ee80 <tickslock>
    800016e6:	a811                	j	800016fa <wakeup+0x3c>
      }
      release(&p->lock);
    800016e8:	8526                	mv	a0,s1
    800016ea:	00005097          	auipc	ra,0x5
    800016ee:	b02080e7          	jalr	-1278(ra) # 800061ec <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016f2:	16848493          	addi	s1,s1,360
    800016f6:	03248663          	beq	s1,s2,80001722 <wakeup+0x64>
    if(p != myproc()){
    800016fa:	fffff097          	auipc	ra,0xfffff
    800016fe:	76e080e7          	jalr	1902(ra) # 80000e68 <myproc>
    80001702:	fea488e3          	beq	s1,a0,800016f2 <wakeup+0x34>
      acquire(&p->lock);
    80001706:	8526                	mv	a0,s1
    80001708:	00005097          	auipc	ra,0x5
    8000170c:	a30080e7          	jalr	-1488(ra) # 80006138 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001710:	4c9c                	lw	a5,24(s1)
    80001712:	fd379be3          	bne	a5,s3,800016e8 <wakeup+0x2a>
    80001716:	709c                	ld	a5,32(s1)
    80001718:	fd4798e3          	bne	a5,s4,800016e8 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000171c:	0154ac23          	sw	s5,24(s1)
    80001720:	b7e1                	j	800016e8 <wakeup+0x2a>
    }
  }
}
    80001722:	70e2                	ld	ra,56(sp)
    80001724:	7442                	ld	s0,48(sp)
    80001726:	74a2                	ld	s1,40(sp)
    80001728:	7902                	ld	s2,32(sp)
    8000172a:	69e2                	ld	s3,24(sp)
    8000172c:	6a42                	ld	s4,16(sp)
    8000172e:	6aa2                	ld	s5,8(sp)
    80001730:	6121                	addi	sp,sp,64
    80001732:	8082                	ret

0000000080001734 <reparent>:
{
    80001734:	7179                	addi	sp,sp,-48
    80001736:	f406                	sd	ra,40(sp)
    80001738:	f022                	sd	s0,32(sp)
    8000173a:	ec26                	sd	s1,24(sp)
    8000173c:	e84a                	sd	s2,16(sp)
    8000173e:	e44e                	sd	s3,8(sp)
    80001740:	e052                	sd	s4,0(sp)
    80001742:	1800                	addi	s0,sp,48
    80001744:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001746:	00008497          	auipc	s1,0x8
    8000174a:	d3a48493          	addi	s1,s1,-710 # 80009480 <proc>
      pp->parent = initproc;
    8000174e:	00008a17          	auipc	s4,0x8
    80001752:	8c2a0a13          	addi	s4,s4,-1854 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001756:	0000d997          	auipc	s3,0xd
    8000175a:	72a98993          	addi	s3,s3,1834 # 8000ee80 <tickslock>
    8000175e:	a029                	j	80001768 <reparent+0x34>
    80001760:	16848493          	addi	s1,s1,360
    80001764:	01348d63          	beq	s1,s3,8000177e <reparent+0x4a>
    if(pp->parent == p){
    80001768:	7c9c                	ld	a5,56(s1)
    8000176a:	ff279be3          	bne	a5,s2,80001760 <reparent+0x2c>
      pp->parent = initproc;
    8000176e:	000a3503          	ld	a0,0(s4)
    80001772:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001774:	00000097          	auipc	ra,0x0
    80001778:	f4a080e7          	jalr	-182(ra) # 800016be <wakeup>
    8000177c:	b7d5                	j	80001760 <reparent+0x2c>
}
    8000177e:	70a2                	ld	ra,40(sp)
    80001780:	7402                	ld	s0,32(sp)
    80001782:	64e2                	ld	s1,24(sp)
    80001784:	6942                	ld	s2,16(sp)
    80001786:	69a2                	ld	s3,8(sp)
    80001788:	6a02                	ld	s4,0(sp)
    8000178a:	6145                	addi	sp,sp,48
    8000178c:	8082                	ret

000000008000178e <exit>:
{
    8000178e:	7179                	addi	sp,sp,-48
    80001790:	f406                	sd	ra,40(sp)
    80001792:	f022                	sd	s0,32(sp)
    80001794:	ec26                	sd	s1,24(sp)
    80001796:	e84a                	sd	s2,16(sp)
    80001798:	e44e                	sd	s3,8(sp)
    8000179a:	e052                	sd	s4,0(sp)
    8000179c:	1800                	addi	s0,sp,48
    8000179e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017a0:	fffff097          	auipc	ra,0xfffff
    800017a4:	6c8080e7          	jalr	1736(ra) # 80000e68 <myproc>
    800017a8:	89aa                	mv	s3,a0
  if(p == initproc)
    800017aa:	00008797          	auipc	a5,0x8
    800017ae:	8667b783          	ld	a5,-1946(a5) # 80009010 <initproc>
    800017b2:	0d050493          	addi	s1,a0,208
    800017b6:	15050913          	addi	s2,a0,336
    800017ba:	02a79363          	bne	a5,a0,800017e0 <exit+0x52>
    panic("init exiting");
    800017be:	00007517          	auipc	a0,0x7
    800017c2:	a2250513          	addi	a0,a0,-1502 # 800081e0 <etext+0x1e0>
    800017c6:	00004097          	auipc	ra,0x4
    800017ca:	43a080e7          	jalr	1082(ra) # 80005c00 <panic>
      fileclose(f);
    800017ce:	00002097          	auipc	ra,0x2
    800017d2:	268080e7          	jalr	616(ra) # 80003a36 <fileclose>
      p->ofile[fd] = 0;
    800017d6:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017da:	04a1                	addi	s1,s1,8
    800017dc:	01248563          	beq	s1,s2,800017e6 <exit+0x58>
    if(p->ofile[fd]){
    800017e0:	6088                	ld	a0,0(s1)
    800017e2:	f575                	bnez	a0,800017ce <exit+0x40>
    800017e4:	bfdd                	j	800017da <exit+0x4c>
  begin_op();
    800017e6:	00002097          	auipc	ra,0x2
    800017ea:	d88080e7          	jalr	-632(ra) # 8000356e <begin_op>
  iput(p->cwd);
    800017ee:	1509b503          	ld	a0,336(s3)
    800017f2:	00001097          	auipc	ra,0x1
    800017f6:	55a080e7          	jalr	1370(ra) # 80002d4c <iput>
  end_op();
    800017fa:	00002097          	auipc	ra,0x2
    800017fe:	df2080e7          	jalr	-526(ra) # 800035ec <end_op>
  p->cwd = 0;
    80001802:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001806:	00008497          	auipc	s1,0x8
    8000180a:	86248493          	addi	s1,s1,-1950 # 80009068 <wait_lock>
    8000180e:	8526                	mv	a0,s1
    80001810:	00005097          	auipc	ra,0x5
    80001814:	928080e7          	jalr	-1752(ra) # 80006138 <acquire>
  reparent(p);
    80001818:	854e                	mv	a0,s3
    8000181a:	00000097          	auipc	ra,0x0
    8000181e:	f1a080e7          	jalr	-230(ra) # 80001734 <reparent>
  wakeup(p->parent);
    80001822:	0389b503          	ld	a0,56(s3)
    80001826:	00000097          	auipc	ra,0x0
    8000182a:	e98080e7          	jalr	-360(ra) # 800016be <wakeup>
  acquire(&p->lock);
    8000182e:	854e                	mv	a0,s3
    80001830:	00005097          	auipc	ra,0x5
    80001834:	908080e7          	jalr	-1784(ra) # 80006138 <acquire>
  p->xstate = status;
    80001838:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000183c:	4795                	li	a5,5
    8000183e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001842:	8526                	mv	a0,s1
    80001844:	00005097          	auipc	ra,0x5
    80001848:	9a8080e7          	jalr	-1624(ra) # 800061ec <release>
  sched();
    8000184c:	00000097          	auipc	ra,0x0
    80001850:	bd4080e7          	jalr	-1068(ra) # 80001420 <sched>
  panic("zombie exit");
    80001854:	00007517          	auipc	a0,0x7
    80001858:	99c50513          	addi	a0,a0,-1636 # 800081f0 <etext+0x1f0>
    8000185c:	00004097          	auipc	ra,0x4
    80001860:	3a4080e7          	jalr	932(ra) # 80005c00 <panic>

0000000080001864 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001864:	7179                	addi	sp,sp,-48
    80001866:	f406                	sd	ra,40(sp)
    80001868:	f022                	sd	s0,32(sp)
    8000186a:	ec26                	sd	s1,24(sp)
    8000186c:	e84a                	sd	s2,16(sp)
    8000186e:	e44e                	sd	s3,8(sp)
    80001870:	1800                	addi	s0,sp,48
    80001872:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001874:	00008497          	auipc	s1,0x8
    80001878:	c0c48493          	addi	s1,s1,-1012 # 80009480 <proc>
    8000187c:	0000d997          	auipc	s3,0xd
    80001880:	60498993          	addi	s3,s3,1540 # 8000ee80 <tickslock>
    acquire(&p->lock);
    80001884:	8526                	mv	a0,s1
    80001886:	00005097          	auipc	ra,0x5
    8000188a:	8b2080e7          	jalr	-1870(ra) # 80006138 <acquire>
    if(p->pid == pid){
    8000188e:	589c                	lw	a5,48(s1)
    80001890:	01278d63          	beq	a5,s2,800018aa <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001894:	8526                	mv	a0,s1
    80001896:	00005097          	auipc	ra,0x5
    8000189a:	956080e7          	jalr	-1706(ra) # 800061ec <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000189e:	16848493          	addi	s1,s1,360
    800018a2:	ff3491e3          	bne	s1,s3,80001884 <kill+0x20>
  }
  return -1;
    800018a6:	557d                	li	a0,-1
    800018a8:	a829                	j	800018c2 <kill+0x5e>
      p->killed = 1;
    800018aa:	4785                	li	a5,1
    800018ac:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018ae:	4c98                	lw	a4,24(s1)
    800018b0:	4789                	li	a5,2
    800018b2:	00f70f63          	beq	a4,a5,800018d0 <kill+0x6c>
      release(&p->lock);
    800018b6:	8526                	mv	a0,s1
    800018b8:	00005097          	auipc	ra,0x5
    800018bc:	934080e7          	jalr	-1740(ra) # 800061ec <release>
      return 0;
    800018c0:	4501                	li	a0,0
}
    800018c2:	70a2                	ld	ra,40(sp)
    800018c4:	7402                	ld	s0,32(sp)
    800018c6:	64e2                	ld	s1,24(sp)
    800018c8:	6942                	ld	s2,16(sp)
    800018ca:	69a2                	ld	s3,8(sp)
    800018cc:	6145                	addi	sp,sp,48
    800018ce:	8082                	ret
        p->state = RUNNABLE;
    800018d0:	478d                	li	a5,3
    800018d2:	cc9c                	sw	a5,24(s1)
    800018d4:	b7cd                	j	800018b6 <kill+0x52>

00000000800018d6 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018d6:	7179                	addi	sp,sp,-48
    800018d8:	f406                	sd	ra,40(sp)
    800018da:	f022                	sd	s0,32(sp)
    800018dc:	ec26                	sd	s1,24(sp)
    800018de:	e84a                	sd	s2,16(sp)
    800018e0:	e44e                	sd	s3,8(sp)
    800018e2:	e052                	sd	s4,0(sp)
    800018e4:	1800                	addi	s0,sp,48
    800018e6:	84aa                	mv	s1,a0
    800018e8:	892e                	mv	s2,a1
    800018ea:	89b2                	mv	s3,a2
    800018ec:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018ee:	fffff097          	auipc	ra,0xfffff
    800018f2:	57a080e7          	jalr	1402(ra) # 80000e68 <myproc>
  if(user_dst){
    800018f6:	c08d                	beqz	s1,80001918 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018f8:	86d2                	mv	a3,s4
    800018fa:	864e                	mv	a2,s3
    800018fc:	85ca                	mv	a1,s2
    800018fe:	6928                	ld	a0,80(a0)
    80001900:	fffff097          	auipc	ra,0xfffff
    80001904:	22c080e7          	jalr	556(ra) # 80000b2c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001908:	70a2                	ld	ra,40(sp)
    8000190a:	7402                	ld	s0,32(sp)
    8000190c:	64e2                	ld	s1,24(sp)
    8000190e:	6942                	ld	s2,16(sp)
    80001910:	69a2                	ld	s3,8(sp)
    80001912:	6a02                	ld	s4,0(sp)
    80001914:	6145                	addi	sp,sp,48
    80001916:	8082                	ret
    memmove((char *)dst, src, len);
    80001918:	000a061b          	sext.w	a2,s4
    8000191c:	85ce                	mv	a1,s3
    8000191e:	854a                	mv	a0,s2
    80001920:	fffff097          	auipc	ra,0xfffff
    80001924:	8da080e7          	jalr	-1830(ra) # 800001fa <memmove>
    return 0;
    80001928:	8526                	mv	a0,s1
    8000192a:	bff9                	j	80001908 <either_copyout+0x32>

000000008000192c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000192c:	7179                	addi	sp,sp,-48
    8000192e:	f406                	sd	ra,40(sp)
    80001930:	f022                	sd	s0,32(sp)
    80001932:	ec26                	sd	s1,24(sp)
    80001934:	e84a                	sd	s2,16(sp)
    80001936:	e44e                	sd	s3,8(sp)
    80001938:	e052                	sd	s4,0(sp)
    8000193a:	1800                	addi	s0,sp,48
    8000193c:	892a                	mv	s2,a0
    8000193e:	84ae                	mv	s1,a1
    80001940:	89b2                	mv	s3,a2
    80001942:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001944:	fffff097          	auipc	ra,0xfffff
    80001948:	524080e7          	jalr	1316(ra) # 80000e68 <myproc>
  if(user_src){
    8000194c:	c08d                	beqz	s1,8000196e <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000194e:	86d2                	mv	a3,s4
    80001950:	864e                	mv	a2,s3
    80001952:	85ca                	mv	a1,s2
    80001954:	6928                	ld	a0,80(a0)
    80001956:	fffff097          	auipc	ra,0xfffff
    8000195a:	262080e7          	jalr	610(ra) # 80000bb8 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000195e:	70a2                	ld	ra,40(sp)
    80001960:	7402                	ld	s0,32(sp)
    80001962:	64e2                	ld	s1,24(sp)
    80001964:	6942                	ld	s2,16(sp)
    80001966:	69a2                	ld	s3,8(sp)
    80001968:	6a02                	ld	s4,0(sp)
    8000196a:	6145                	addi	sp,sp,48
    8000196c:	8082                	ret
    memmove(dst, (char*)src, len);
    8000196e:	000a061b          	sext.w	a2,s4
    80001972:	85ce                	mv	a1,s3
    80001974:	854a                	mv	a0,s2
    80001976:	fffff097          	auipc	ra,0xfffff
    8000197a:	884080e7          	jalr	-1916(ra) # 800001fa <memmove>
    return 0;
    8000197e:	8526                	mv	a0,s1
    80001980:	bff9                	j	8000195e <either_copyin+0x32>

0000000080001982 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001982:	715d                	addi	sp,sp,-80
    80001984:	e486                	sd	ra,72(sp)
    80001986:	e0a2                	sd	s0,64(sp)
    80001988:	fc26                	sd	s1,56(sp)
    8000198a:	f84a                	sd	s2,48(sp)
    8000198c:	f44e                	sd	s3,40(sp)
    8000198e:	f052                	sd	s4,32(sp)
    80001990:	ec56                	sd	s5,24(sp)
    80001992:	e85a                	sd	s6,16(sp)
    80001994:	e45e                	sd	s7,8(sp)
    80001996:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001998:	00006517          	auipc	a0,0x6
    8000199c:	6b050513          	addi	a0,a0,1712 # 80008048 <etext+0x48>
    800019a0:	00004097          	auipc	ra,0x4
    800019a4:	2aa080e7          	jalr	682(ra) # 80005c4a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019a8:	00008497          	auipc	s1,0x8
    800019ac:	c3048493          	addi	s1,s1,-976 # 800095d8 <proc+0x158>
    800019b0:	0000d917          	auipc	s2,0xd
    800019b4:	62890913          	addi	s2,s2,1576 # 8000efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019b8:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019ba:	00007997          	auipc	s3,0x7
    800019be:	84698993          	addi	s3,s3,-1978 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019c2:	00007a97          	auipc	s5,0x7
    800019c6:	846a8a93          	addi	s5,s5,-1978 # 80008208 <etext+0x208>
    printf("\n");
    800019ca:	00006a17          	auipc	s4,0x6
    800019ce:	67ea0a13          	addi	s4,s4,1662 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019d2:	00007b97          	auipc	s7,0x7
    800019d6:	86eb8b93          	addi	s7,s7,-1938 # 80008240 <states.0>
    800019da:	a00d                	j	800019fc <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019dc:	ed86a583          	lw	a1,-296(a3)
    800019e0:	8556                	mv	a0,s5
    800019e2:	00004097          	auipc	ra,0x4
    800019e6:	268080e7          	jalr	616(ra) # 80005c4a <printf>
    printf("\n");
    800019ea:	8552                	mv	a0,s4
    800019ec:	00004097          	auipc	ra,0x4
    800019f0:	25e080e7          	jalr	606(ra) # 80005c4a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019f4:	16848493          	addi	s1,s1,360
    800019f8:	03248263          	beq	s1,s2,80001a1c <procdump+0x9a>
    if(p->state == UNUSED)
    800019fc:	86a6                	mv	a3,s1
    800019fe:	ec04a783          	lw	a5,-320(s1)
    80001a02:	dbed                	beqz	a5,800019f4 <procdump+0x72>
      state = "???";
    80001a04:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a06:	fcfb6be3          	bltu	s6,a5,800019dc <procdump+0x5a>
    80001a0a:	02079713          	slli	a4,a5,0x20
    80001a0e:	01d75793          	srli	a5,a4,0x1d
    80001a12:	97de                	add	a5,a5,s7
    80001a14:	6390                	ld	a2,0(a5)
    80001a16:	f279                	bnez	a2,800019dc <procdump+0x5a>
      state = "???";
    80001a18:	864e                	mv	a2,s3
    80001a1a:	b7c9                	j	800019dc <procdump+0x5a>
  }
}
    80001a1c:	60a6                	ld	ra,72(sp)
    80001a1e:	6406                	ld	s0,64(sp)
    80001a20:	74e2                	ld	s1,56(sp)
    80001a22:	7942                	ld	s2,48(sp)
    80001a24:	79a2                	ld	s3,40(sp)
    80001a26:	7a02                	ld	s4,32(sp)
    80001a28:	6ae2                	ld	s5,24(sp)
    80001a2a:	6b42                	ld	s6,16(sp)
    80001a2c:	6ba2                	ld	s7,8(sp)
    80001a2e:	6161                	addi	sp,sp,80
    80001a30:	8082                	ret

0000000080001a32 <getnproc>:

uint64
getnproc(void)
{
    80001a32:	1141                	addi	sp,sp,-16
    80001a34:	e422                	sd	s0,8(sp)
    80001a36:	0800                	addi	s0,sp,16
  uint64 n = 0;
  struct proc *p;
  
  // 遍历proc数组，计算非UNUSED状态的进程数
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a38:	00008797          	auipc	a5,0x8
    80001a3c:	a4878793          	addi	a5,a5,-1464 # 80009480 <proc>
  uint64 n = 0;
    80001a40:	4501                	li	a0,0
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a42:	0000d697          	auipc	a3,0xd
    80001a46:	43e68693          	addi	a3,a3,1086 # 8000ee80 <tickslock>
    if(p->state != UNUSED)
    80001a4a:	4f98                	lw	a4,24(a5)
      n++;
    80001a4c:	00e03733          	snez	a4,a4
    80001a50:	953a                	add	a0,a0,a4
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a52:	16878793          	addi	a5,a5,360
    80001a56:	fed79ae3          	bne	a5,a3,80001a4a <getnproc+0x18>
  }
  
  return n;
}
    80001a5a:	6422                	ld	s0,8(sp)
    80001a5c:	0141                	addi	sp,sp,16
    80001a5e:	8082                	ret

0000000080001a60 <swtch>:
    80001a60:	00153023          	sd	ra,0(a0)
    80001a64:	00253423          	sd	sp,8(a0)
    80001a68:	e900                	sd	s0,16(a0)
    80001a6a:	ed04                	sd	s1,24(a0)
    80001a6c:	03253023          	sd	s2,32(a0)
    80001a70:	03353423          	sd	s3,40(a0)
    80001a74:	03453823          	sd	s4,48(a0)
    80001a78:	03553c23          	sd	s5,56(a0)
    80001a7c:	05653023          	sd	s6,64(a0)
    80001a80:	05753423          	sd	s7,72(a0)
    80001a84:	05853823          	sd	s8,80(a0)
    80001a88:	05953c23          	sd	s9,88(a0)
    80001a8c:	07a53023          	sd	s10,96(a0)
    80001a90:	07b53423          	sd	s11,104(a0)
    80001a94:	0005b083          	ld	ra,0(a1)
    80001a98:	0085b103          	ld	sp,8(a1)
    80001a9c:	6980                	ld	s0,16(a1)
    80001a9e:	6d84                	ld	s1,24(a1)
    80001aa0:	0205b903          	ld	s2,32(a1)
    80001aa4:	0285b983          	ld	s3,40(a1)
    80001aa8:	0305ba03          	ld	s4,48(a1)
    80001aac:	0385ba83          	ld	s5,56(a1)
    80001ab0:	0405bb03          	ld	s6,64(a1)
    80001ab4:	0485bb83          	ld	s7,72(a1)
    80001ab8:	0505bc03          	ld	s8,80(a1)
    80001abc:	0585bc83          	ld	s9,88(a1)
    80001ac0:	0605bd03          	ld	s10,96(a1)
    80001ac4:	0685bd83          	ld	s11,104(a1)
    80001ac8:	8082                	ret

0000000080001aca <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001aca:	1141                	addi	sp,sp,-16
    80001acc:	e406                	sd	ra,8(sp)
    80001ace:	e022                	sd	s0,0(sp)
    80001ad0:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ad2:	00006597          	auipc	a1,0x6
    80001ad6:	79e58593          	addi	a1,a1,1950 # 80008270 <states.0+0x30>
    80001ada:	0000d517          	auipc	a0,0xd
    80001ade:	3a650513          	addi	a0,a0,934 # 8000ee80 <tickslock>
    80001ae2:	00004097          	auipc	ra,0x4
    80001ae6:	5c6080e7          	jalr	1478(ra) # 800060a8 <initlock>
}
    80001aea:	60a2                	ld	ra,8(sp)
    80001aec:	6402                	ld	s0,0(sp)
    80001aee:	0141                	addi	sp,sp,16
    80001af0:	8082                	ret

0000000080001af2 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001af2:	1141                	addi	sp,sp,-16
    80001af4:	e422                	sd	s0,8(sp)
    80001af6:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001af8:	00003797          	auipc	a5,0x3
    80001afc:	56878793          	addi	a5,a5,1384 # 80005060 <kernelvec>
    80001b00:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b04:	6422                	ld	s0,8(sp)
    80001b06:	0141                	addi	sp,sp,16
    80001b08:	8082                	ret

0000000080001b0a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b0a:	1141                	addi	sp,sp,-16
    80001b0c:	e406                	sd	ra,8(sp)
    80001b0e:	e022                	sd	s0,0(sp)
    80001b10:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b12:	fffff097          	auipc	ra,0xfffff
    80001b16:	356080e7          	jalr	854(ra) # 80000e68 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b1a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b1e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b20:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b24:	00005697          	auipc	a3,0x5
    80001b28:	4dc68693          	addi	a3,a3,1244 # 80007000 <_trampoline>
    80001b2c:	00005717          	auipc	a4,0x5
    80001b30:	4d470713          	addi	a4,a4,1236 # 80007000 <_trampoline>
    80001b34:	8f15                	sub	a4,a4,a3
    80001b36:	040007b7          	lui	a5,0x4000
    80001b3a:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b3c:	07b2                	slli	a5,a5,0xc
    80001b3e:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b40:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b44:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b46:	18002673          	csrr	a2,satp
    80001b4a:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b4c:	6d30                	ld	a2,88(a0)
    80001b4e:	6138                	ld	a4,64(a0)
    80001b50:	6585                	lui	a1,0x1
    80001b52:	972e                	add	a4,a4,a1
    80001b54:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b56:	6d38                	ld	a4,88(a0)
    80001b58:	00000617          	auipc	a2,0x0
    80001b5c:	13860613          	addi	a2,a2,312 # 80001c90 <usertrap>
    80001b60:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b62:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b64:	8612                	mv	a2,tp
    80001b66:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b68:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b6c:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b70:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b74:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b78:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b7a:	6f18                	ld	a4,24(a4)
    80001b7c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b80:	692c                	ld	a1,80(a0)
    80001b82:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b84:	00005717          	auipc	a4,0x5
    80001b88:	50c70713          	addi	a4,a4,1292 # 80007090 <userret>
    80001b8c:	8f15                	sub	a4,a4,a3
    80001b8e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b90:	577d                	li	a4,-1
    80001b92:	177e                	slli	a4,a4,0x3f
    80001b94:	8dd9                	or	a1,a1,a4
    80001b96:	02000537          	lui	a0,0x2000
    80001b9a:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001b9c:	0536                	slli	a0,a0,0xd
    80001b9e:	9782                	jalr	a5
}
    80001ba0:	60a2                	ld	ra,8(sp)
    80001ba2:	6402                	ld	s0,0(sp)
    80001ba4:	0141                	addi	sp,sp,16
    80001ba6:	8082                	ret

0000000080001ba8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001ba8:	1101                	addi	sp,sp,-32
    80001baa:	ec06                	sd	ra,24(sp)
    80001bac:	e822                	sd	s0,16(sp)
    80001bae:	e426                	sd	s1,8(sp)
    80001bb0:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001bb2:	0000d497          	auipc	s1,0xd
    80001bb6:	2ce48493          	addi	s1,s1,718 # 8000ee80 <tickslock>
    80001bba:	8526                	mv	a0,s1
    80001bbc:	00004097          	auipc	ra,0x4
    80001bc0:	57c080e7          	jalr	1404(ra) # 80006138 <acquire>
  ticks++;
    80001bc4:	00007517          	auipc	a0,0x7
    80001bc8:	45450513          	addi	a0,a0,1108 # 80009018 <ticks>
    80001bcc:	411c                	lw	a5,0(a0)
    80001bce:	2785                	addiw	a5,a5,1
    80001bd0:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bd2:	00000097          	auipc	ra,0x0
    80001bd6:	aec080e7          	jalr	-1300(ra) # 800016be <wakeup>
  release(&tickslock);
    80001bda:	8526                	mv	a0,s1
    80001bdc:	00004097          	auipc	ra,0x4
    80001be0:	610080e7          	jalr	1552(ra) # 800061ec <release>
}
    80001be4:	60e2                	ld	ra,24(sp)
    80001be6:	6442                	ld	s0,16(sp)
    80001be8:	64a2                	ld	s1,8(sp)
    80001bea:	6105                	addi	sp,sp,32
    80001bec:	8082                	ret

0000000080001bee <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001bee:	1101                	addi	sp,sp,-32
    80001bf0:	ec06                	sd	ra,24(sp)
    80001bf2:	e822                	sd	s0,16(sp)
    80001bf4:	e426                	sd	s1,8(sp)
    80001bf6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bf8:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bfc:	00074d63          	bltz	a4,80001c16 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c00:	57fd                	li	a5,-1
    80001c02:	17fe                	slli	a5,a5,0x3f
    80001c04:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c06:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c08:	06f70363          	beq	a4,a5,80001c6e <devintr+0x80>
  }
}
    80001c0c:	60e2                	ld	ra,24(sp)
    80001c0e:	6442                	ld	s0,16(sp)
    80001c10:	64a2                	ld	s1,8(sp)
    80001c12:	6105                	addi	sp,sp,32
    80001c14:	8082                	ret
     (scause & 0xff) == 9){
    80001c16:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001c1a:	46a5                	li	a3,9
    80001c1c:	fed792e3          	bne	a5,a3,80001c00 <devintr+0x12>
    int irq = plic_claim();
    80001c20:	00003097          	auipc	ra,0x3
    80001c24:	548080e7          	jalr	1352(ra) # 80005168 <plic_claim>
    80001c28:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c2a:	47a9                	li	a5,10
    80001c2c:	02f50763          	beq	a0,a5,80001c5a <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c30:	4785                	li	a5,1
    80001c32:	02f50963          	beq	a0,a5,80001c64 <devintr+0x76>
    return 1;
    80001c36:	4505                	li	a0,1
    } else if(irq){
    80001c38:	d8f1                	beqz	s1,80001c0c <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c3a:	85a6                	mv	a1,s1
    80001c3c:	00006517          	auipc	a0,0x6
    80001c40:	63c50513          	addi	a0,a0,1596 # 80008278 <states.0+0x38>
    80001c44:	00004097          	auipc	ra,0x4
    80001c48:	006080e7          	jalr	6(ra) # 80005c4a <printf>
      plic_complete(irq);
    80001c4c:	8526                	mv	a0,s1
    80001c4e:	00003097          	auipc	ra,0x3
    80001c52:	53e080e7          	jalr	1342(ra) # 8000518c <plic_complete>
    return 1;
    80001c56:	4505                	li	a0,1
    80001c58:	bf55                	j	80001c0c <devintr+0x1e>
      uartintr();
    80001c5a:	00004097          	auipc	ra,0x4
    80001c5e:	3fe080e7          	jalr	1022(ra) # 80006058 <uartintr>
    80001c62:	b7ed                	j	80001c4c <devintr+0x5e>
      virtio_disk_intr();
    80001c64:	00004097          	auipc	ra,0x4
    80001c68:	9b4080e7          	jalr	-1612(ra) # 80005618 <virtio_disk_intr>
    80001c6c:	b7c5                	j	80001c4c <devintr+0x5e>
    if(cpuid() == 0){
    80001c6e:	fffff097          	auipc	ra,0xfffff
    80001c72:	1ce080e7          	jalr	462(ra) # 80000e3c <cpuid>
    80001c76:	c901                	beqz	a0,80001c86 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c78:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c7c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c7e:	14479073          	csrw	sip,a5
    return 2;
    80001c82:	4509                	li	a0,2
    80001c84:	b761                	j	80001c0c <devintr+0x1e>
      clockintr();
    80001c86:	00000097          	auipc	ra,0x0
    80001c8a:	f22080e7          	jalr	-222(ra) # 80001ba8 <clockintr>
    80001c8e:	b7ed                	j	80001c78 <devintr+0x8a>

0000000080001c90 <usertrap>:
{
    80001c90:	1101                	addi	sp,sp,-32
    80001c92:	ec06                	sd	ra,24(sp)
    80001c94:	e822                	sd	s0,16(sp)
    80001c96:	e426                	sd	s1,8(sp)
    80001c98:	e04a                	sd	s2,0(sp)
    80001c9a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c9c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001ca0:	1007f793          	andi	a5,a5,256
    80001ca4:	e3ad                	bnez	a5,80001d06 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ca6:	00003797          	auipc	a5,0x3
    80001caa:	3ba78793          	addi	a5,a5,954 # 80005060 <kernelvec>
    80001cae:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cb2:	fffff097          	auipc	ra,0xfffff
    80001cb6:	1b6080e7          	jalr	438(ra) # 80000e68 <myproc>
    80001cba:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cbc:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cbe:	14102773          	csrr	a4,sepc
    80001cc2:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cc4:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cc8:	47a1                	li	a5,8
    80001cca:	04f71c63          	bne	a4,a5,80001d22 <usertrap+0x92>
    if(p->killed)
    80001cce:	551c                	lw	a5,40(a0)
    80001cd0:	e3b9                	bnez	a5,80001d16 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001cd2:	6cb8                	ld	a4,88(s1)
    80001cd4:	6f1c                	ld	a5,24(a4)
    80001cd6:	0791                	addi	a5,a5,4
    80001cd8:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cda:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cde:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ce2:	10079073          	csrw	sstatus,a5
    syscall();
    80001ce6:	00000097          	auipc	ra,0x0
    80001cea:	2e0080e7          	jalr	736(ra) # 80001fc6 <syscall>
  if(p->killed)
    80001cee:	549c                	lw	a5,40(s1)
    80001cf0:	ebc1                	bnez	a5,80001d80 <usertrap+0xf0>
  usertrapret();
    80001cf2:	00000097          	auipc	ra,0x0
    80001cf6:	e18080e7          	jalr	-488(ra) # 80001b0a <usertrapret>
}
    80001cfa:	60e2                	ld	ra,24(sp)
    80001cfc:	6442                	ld	s0,16(sp)
    80001cfe:	64a2                	ld	s1,8(sp)
    80001d00:	6902                	ld	s2,0(sp)
    80001d02:	6105                	addi	sp,sp,32
    80001d04:	8082                	ret
    panic("usertrap: not from user mode");
    80001d06:	00006517          	auipc	a0,0x6
    80001d0a:	59250513          	addi	a0,a0,1426 # 80008298 <states.0+0x58>
    80001d0e:	00004097          	auipc	ra,0x4
    80001d12:	ef2080e7          	jalr	-270(ra) # 80005c00 <panic>
      exit(-1);
    80001d16:	557d                	li	a0,-1
    80001d18:	00000097          	auipc	ra,0x0
    80001d1c:	a76080e7          	jalr	-1418(ra) # 8000178e <exit>
    80001d20:	bf4d                	j	80001cd2 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d22:	00000097          	auipc	ra,0x0
    80001d26:	ecc080e7          	jalr	-308(ra) # 80001bee <devintr>
    80001d2a:	892a                	mv	s2,a0
    80001d2c:	c501                	beqz	a0,80001d34 <usertrap+0xa4>
  if(p->killed)
    80001d2e:	549c                	lw	a5,40(s1)
    80001d30:	c3a1                	beqz	a5,80001d70 <usertrap+0xe0>
    80001d32:	a815                	j	80001d66 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d34:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d38:	5890                	lw	a2,48(s1)
    80001d3a:	00006517          	auipc	a0,0x6
    80001d3e:	57e50513          	addi	a0,a0,1406 # 800082b8 <states.0+0x78>
    80001d42:	00004097          	auipc	ra,0x4
    80001d46:	f08080e7          	jalr	-248(ra) # 80005c4a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d4a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d4e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d52:	00006517          	auipc	a0,0x6
    80001d56:	59650513          	addi	a0,a0,1430 # 800082e8 <states.0+0xa8>
    80001d5a:	00004097          	auipc	ra,0x4
    80001d5e:	ef0080e7          	jalr	-272(ra) # 80005c4a <printf>
    p->killed = 1;
    80001d62:	4785                	li	a5,1
    80001d64:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d66:	557d                	li	a0,-1
    80001d68:	00000097          	auipc	ra,0x0
    80001d6c:	a26080e7          	jalr	-1498(ra) # 8000178e <exit>
  if(which_dev == 2)
    80001d70:	4789                	li	a5,2
    80001d72:	f8f910e3          	bne	s2,a5,80001cf2 <usertrap+0x62>
    yield();
    80001d76:	fffff097          	auipc	ra,0xfffff
    80001d7a:	780080e7          	jalr	1920(ra) # 800014f6 <yield>
    80001d7e:	bf95                	j	80001cf2 <usertrap+0x62>
  int which_dev = 0;
    80001d80:	4901                	li	s2,0
    80001d82:	b7d5                	j	80001d66 <usertrap+0xd6>

0000000080001d84 <kerneltrap>:
{
    80001d84:	7179                	addi	sp,sp,-48
    80001d86:	f406                	sd	ra,40(sp)
    80001d88:	f022                	sd	s0,32(sp)
    80001d8a:	ec26                	sd	s1,24(sp)
    80001d8c:	e84a                	sd	s2,16(sp)
    80001d8e:	e44e                	sd	s3,8(sp)
    80001d90:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d92:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d96:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d9a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001d9e:	1004f793          	andi	a5,s1,256
    80001da2:	cb85                	beqz	a5,80001dd2 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001da4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001da8:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001daa:	ef85                	bnez	a5,80001de2 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dac:	00000097          	auipc	ra,0x0
    80001db0:	e42080e7          	jalr	-446(ra) # 80001bee <devintr>
    80001db4:	cd1d                	beqz	a0,80001df2 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001db6:	4789                	li	a5,2
    80001db8:	06f50a63          	beq	a0,a5,80001e2c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dbc:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dc0:	10049073          	csrw	sstatus,s1
}
    80001dc4:	70a2                	ld	ra,40(sp)
    80001dc6:	7402                	ld	s0,32(sp)
    80001dc8:	64e2                	ld	s1,24(sp)
    80001dca:	6942                	ld	s2,16(sp)
    80001dcc:	69a2                	ld	s3,8(sp)
    80001dce:	6145                	addi	sp,sp,48
    80001dd0:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001dd2:	00006517          	auipc	a0,0x6
    80001dd6:	53650513          	addi	a0,a0,1334 # 80008308 <states.0+0xc8>
    80001dda:	00004097          	auipc	ra,0x4
    80001dde:	e26080e7          	jalr	-474(ra) # 80005c00 <panic>
    panic("kerneltrap: interrupts enabled");
    80001de2:	00006517          	auipc	a0,0x6
    80001de6:	54e50513          	addi	a0,a0,1358 # 80008330 <states.0+0xf0>
    80001dea:	00004097          	auipc	ra,0x4
    80001dee:	e16080e7          	jalr	-490(ra) # 80005c00 <panic>
    printf("scause %p\n", scause);
    80001df2:	85ce                	mv	a1,s3
    80001df4:	00006517          	auipc	a0,0x6
    80001df8:	55c50513          	addi	a0,a0,1372 # 80008350 <states.0+0x110>
    80001dfc:	00004097          	auipc	ra,0x4
    80001e00:	e4e080e7          	jalr	-434(ra) # 80005c4a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e04:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e08:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e0c:	00006517          	auipc	a0,0x6
    80001e10:	55450513          	addi	a0,a0,1364 # 80008360 <states.0+0x120>
    80001e14:	00004097          	auipc	ra,0x4
    80001e18:	e36080e7          	jalr	-458(ra) # 80005c4a <printf>
    panic("kerneltrap");
    80001e1c:	00006517          	auipc	a0,0x6
    80001e20:	55c50513          	addi	a0,a0,1372 # 80008378 <states.0+0x138>
    80001e24:	00004097          	auipc	ra,0x4
    80001e28:	ddc080e7          	jalr	-548(ra) # 80005c00 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e2c:	fffff097          	auipc	ra,0xfffff
    80001e30:	03c080e7          	jalr	60(ra) # 80000e68 <myproc>
    80001e34:	d541                	beqz	a0,80001dbc <kerneltrap+0x38>
    80001e36:	fffff097          	auipc	ra,0xfffff
    80001e3a:	032080e7          	jalr	50(ra) # 80000e68 <myproc>
    80001e3e:	4d18                	lw	a4,24(a0)
    80001e40:	4791                	li	a5,4
    80001e42:	f6f71de3          	bne	a4,a5,80001dbc <kerneltrap+0x38>
    yield();
    80001e46:	fffff097          	auipc	ra,0xfffff
    80001e4a:	6b0080e7          	jalr	1712(ra) # 800014f6 <yield>
    80001e4e:	b7bd                	j	80001dbc <kerneltrap+0x38>

0000000080001e50 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e50:	1101                	addi	sp,sp,-32
    80001e52:	ec06                	sd	ra,24(sp)
    80001e54:	e822                	sd	s0,16(sp)
    80001e56:	e426                	sd	s1,8(sp)
    80001e58:	1000                	addi	s0,sp,32
    80001e5a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e5c:	fffff097          	auipc	ra,0xfffff
    80001e60:	00c080e7          	jalr	12(ra) # 80000e68 <myproc>
  switch (n) {
    80001e64:	4795                	li	a5,5
    80001e66:	0497e163          	bltu	a5,s1,80001ea8 <argraw+0x58>
    80001e6a:	048a                	slli	s1,s1,0x2
    80001e6c:	00006717          	auipc	a4,0x6
    80001e70:	60470713          	addi	a4,a4,1540 # 80008470 <states.0+0x230>
    80001e74:	94ba                	add	s1,s1,a4
    80001e76:	409c                	lw	a5,0(s1)
    80001e78:	97ba                	add	a5,a5,a4
    80001e7a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e7c:	6d3c                	ld	a5,88(a0)
    80001e7e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e80:	60e2                	ld	ra,24(sp)
    80001e82:	6442                	ld	s0,16(sp)
    80001e84:	64a2                	ld	s1,8(sp)
    80001e86:	6105                	addi	sp,sp,32
    80001e88:	8082                	ret
    return p->trapframe->a1;
    80001e8a:	6d3c                	ld	a5,88(a0)
    80001e8c:	7fa8                	ld	a0,120(a5)
    80001e8e:	bfcd                	j	80001e80 <argraw+0x30>
    return p->trapframe->a2;
    80001e90:	6d3c                	ld	a5,88(a0)
    80001e92:	63c8                	ld	a0,128(a5)
    80001e94:	b7f5                	j	80001e80 <argraw+0x30>
    return p->trapframe->a3;
    80001e96:	6d3c                	ld	a5,88(a0)
    80001e98:	67c8                	ld	a0,136(a5)
    80001e9a:	b7dd                	j	80001e80 <argraw+0x30>
    return p->trapframe->a4;
    80001e9c:	6d3c                	ld	a5,88(a0)
    80001e9e:	6bc8                	ld	a0,144(a5)
    80001ea0:	b7c5                	j	80001e80 <argraw+0x30>
    return p->trapframe->a5;
    80001ea2:	6d3c                	ld	a5,88(a0)
    80001ea4:	6fc8                	ld	a0,152(a5)
    80001ea6:	bfe9                	j	80001e80 <argraw+0x30>
  panic("argraw");
    80001ea8:	00006517          	auipc	a0,0x6
    80001eac:	4e050513          	addi	a0,a0,1248 # 80008388 <states.0+0x148>
    80001eb0:	00004097          	auipc	ra,0x4
    80001eb4:	d50080e7          	jalr	-688(ra) # 80005c00 <panic>

0000000080001eb8 <fetchaddr>:
{
    80001eb8:	1101                	addi	sp,sp,-32
    80001eba:	ec06                	sd	ra,24(sp)
    80001ebc:	e822                	sd	s0,16(sp)
    80001ebe:	e426                	sd	s1,8(sp)
    80001ec0:	e04a                	sd	s2,0(sp)
    80001ec2:	1000                	addi	s0,sp,32
    80001ec4:	84aa                	mv	s1,a0
    80001ec6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ec8:	fffff097          	auipc	ra,0xfffff
    80001ecc:	fa0080e7          	jalr	-96(ra) # 80000e68 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001ed0:	653c                	ld	a5,72(a0)
    80001ed2:	02f4f863          	bgeu	s1,a5,80001f02 <fetchaddr+0x4a>
    80001ed6:	00848713          	addi	a4,s1,8
    80001eda:	02e7e663          	bltu	a5,a4,80001f06 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001ede:	46a1                	li	a3,8
    80001ee0:	8626                	mv	a2,s1
    80001ee2:	85ca                	mv	a1,s2
    80001ee4:	6928                	ld	a0,80(a0)
    80001ee6:	fffff097          	auipc	ra,0xfffff
    80001eea:	cd2080e7          	jalr	-814(ra) # 80000bb8 <copyin>
    80001eee:	00a03533          	snez	a0,a0
    80001ef2:	40a00533          	neg	a0,a0
}
    80001ef6:	60e2                	ld	ra,24(sp)
    80001ef8:	6442                	ld	s0,16(sp)
    80001efa:	64a2                	ld	s1,8(sp)
    80001efc:	6902                	ld	s2,0(sp)
    80001efe:	6105                	addi	sp,sp,32
    80001f00:	8082                	ret
    return -1;
    80001f02:	557d                	li	a0,-1
    80001f04:	bfcd                	j	80001ef6 <fetchaddr+0x3e>
    80001f06:	557d                	li	a0,-1
    80001f08:	b7fd                	j	80001ef6 <fetchaddr+0x3e>

0000000080001f0a <fetchstr>:
{
    80001f0a:	7179                	addi	sp,sp,-48
    80001f0c:	f406                	sd	ra,40(sp)
    80001f0e:	f022                	sd	s0,32(sp)
    80001f10:	ec26                	sd	s1,24(sp)
    80001f12:	e84a                	sd	s2,16(sp)
    80001f14:	e44e                	sd	s3,8(sp)
    80001f16:	1800                	addi	s0,sp,48
    80001f18:	892a                	mv	s2,a0
    80001f1a:	84ae                	mv	s1,a1
    80001f1c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f1e:	fffff097          	auipc	ra,0xfffff
    80001f22:	f4a080e7          	jalr	-182(ra) # 80000e68 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f26:	86ce                	mv	a3,s3
    80001f28:	864a                	mv	a2,s2
    80001f2a:	85a6                	mv	a1,s1
    80001f2c:	6928                	ld	a0,80(a0)
    80001f2e:	fffff097          	auipc	ra,0xfffff
    80001f32:	d18080e7          	jalr	-744(ra) # 80000c46 <copyinstr>
  if(err < 0)
    80001f36:	00054763          	bltz	a0,80001f44 <fetchstr+0x3a>
  return strlen(buf);
    80001f3a:	8526                	mv	a0,s1
    80001f3c:	ffffe097          	auipc	ra,0xffffe
    80001f40:	3de080e7          	jalr	990(ra) # 8000031a <strlen>
}
    80001f44:	70a2                	ld	ra,40(sp)
    80001f46:	7402                	ld	s0,32(sp)
    80001f48:	64e2                	ld	s1,24(sp)
    80001f4a:	6942                	ld	s2,16(sp)
    80001f4c:	69a2                	ld	s3,8(sp)
    80001f4e:	6145                	addi	sp,sp,48
    80001f50:	8082                	ret

0000000080001f52 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f52:	1101                	addi	sp,sp,-32
    80001f54:	ec06                	sd	ra,24(sp)
    80001f56:	e822                	sd	s0,16(sp)
    80001f58:	e426                	sd	s1,8(sp)
    80001f5a:	1000                	addi	s0,sp,32
    80001f5c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f5e:	00000097          	auipc	ra,0x0
    80001f62:	ef2080e7          	jalr	-270(ra) # 80001e50 <argraw>
    80001f66:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f68:	4501                	li	a0,0
    80001f6a:	60e2                	ld	ra,24(sp)
    80001f6c:	6442                	ld	s0,16(sp)
    80001f6e:	64a2                	ld	s1,8(sp)
    80001f70:	6105                	addi	sp,sp,32
    80001f72:	8082                	ret

0000000080001f74 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f74:	1101                	addi	sp,sp,-32
    80001f76:	ec06                	sd	ra,24(sp)
    80001f78:	e822                	sd	s0,16(sp)
    80001f7a:	e426                	sd	s1,8(sp)
    80001f7c:	1000                	addi	s0,sp,32
    80001f7e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f80:	00000097          	auipc	ra,0x0
    80001f84:	ed0080e7          	jalr	-304(ra) # 80001e50 <argraw>
    80001f88:	e088                	sd	a0,0(s1)
  return 0;
}
    80001f8a:	4501                	li	a0,0
    80001f8c:	60e2                	ld	ra,24(sp)
    80001f8e:	6442                	ld	s0,16(sp)
    80001f90:	64a2                	ld	s1,8(sp)
    80001f92:	6105                	addi	sp,sp,32
    80001f94:	8082                	ret

0000000080001f96 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001f96:	1101                	addi	sp,sp,-32
    80001f98:	ec06                	sd	ra,24(sp)
    80001f9a:	e822                	sd	s0,16(sp)
    80001f9c:	e426                	sd	s1,8(sp)
    80001f9e:	e04a                	sd	s2,0(sp)
    80001fa0:	1000                	addi	s0,sp,32
    80001fa2:	84ae                	mv	s1,a1
    80001fa4:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fa6:	00000097          	auipc	ra,0x0
    80001faa:	eaa080e7          	jalr	-342(ra) # 80001e50 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001fae:	864a                	mv	a2,s2
    80001fb0:	85a6                	mv	a1,s1
    80001fb2:	00000097          	auipc	ra,0x0
    80001fb6:	f58080e7          	jalr	-168(ra) # 80001f0a <fetchstr>
}
    80001fba:	60e2                	ld	ra,24(sp)
    80001fbc:	6442                	ld	s0,16(sp)
    80001fbe:	64a2                	ld	s1,8(sp)
    80001fc0:	6902                	ld	s2,0(sp)
    80001fc2:	6105                	addi	sp,sp,32
    80001fc4:	8082                	ret

0000000080001fc6 <syscall>:
    // 确保添加所有已实现的系统调用
};

void
syscall(void)
{
    80001fc6:	7179                	addi	sp,sp,-48
    80001fc8:	f406                	sd	ra,40(sp)
    80001fca:	f022                	sd	s0,32(sp)
    80001fcc:	ec26                	sd	s1,24(sp)
    80001fce:	e84a                	sd	s2,16(sp)
    80001fd0:	e44e                	sd	s3,8(sp)
    80001fd2:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80001fd4:	fffff097          	auipc	ra,0xfffff
    80001fd8:	e94080e7          	jalr	-364(ra) # 80000e68 <myproc>
    80001fdc:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001fde:	05853903          	ld	s2,88(a0)
    80001fe2:	0a893783          	ld	a5,168(s2)
    80001fe6:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001fea:	37fd                	addiw	a5,a5,-1
    80001fec:	4759                	li	a4,22
    80001fee:	04f76663          	bltu	a4,a5,8000203a <syscall+0x74>
    80001ff2:	00399713          	slli	a4,s3,0x3
    80001ff6:	00006797          	auipc	a5,0x6
    80001ffa:	49278793          	addi	a5,a5,1170 # 80008488 <syscalls>
    80001ffe:	97ba                	add	a5,a5,a4
    80002000:	639c                	ld	a5,0(a5)
    80002002:	cf85                	beqz	a5,8000203a <syscall+0x74>
    p->trapframe->a0 = syscalls[num]();
    80002004:	9782                	jalr	a5
    80002006:	06a93823          	sd	a0,112(s2)
    // 跟踪输出
        if ((1 << num) & p->tracemask) {
    8000200a:	58dc                	lw	a5,52(s1)
    8000200c:	4137d7bb          	sraw	a5,a5,s3
    80002010:	8b85                	andi	a5,a5,1
    80002012:	c3b9                	beqz	a5,80002058 <syscall+0x92>
            printf("%d: syscall %s -> %d\n", p->pid, syscall_names[num], p->trapframe->a0);
    80002014:	6cb8                	ld	a4,88(s1)
    80002016:	098e                	slli	s3,s3,0x3
    80002018:	00006797          	auipc	a5,0x6
    8000201c:	47078793          	addi	a5,a5,1136 # 80008488 <syscalls>
    80002020:	97ce                	add	a5,a5,s3
    80002022:	7b34                	ld	a3,112(a4)
    80002024:	63f0                	ld	a2,192(a5)
    80002026:	588c                	lw	a1,48(s1)
    80002028:	00006517          	auipc	a0,0x6
    8000202c:	36850513          	addi	a0,a0,872 # 80008390 <states.0+0x150>
    80002030:	00004097          	auipc	ra,0x4
    80002034:	c1a080e7          	jalr	-998(ra) # 80005c4a <printf>
    80002038:	a005                	j	80002058 <syscall+0x92>
}
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000203a:	86ce                	mv	a3,s3
    8000203c:	15848613          	addi	a2,s1,344
    80002040:	588c                	lw	a1,48(s1)
    80002042:	00006517          	auipc	a0,0x6
    80002046:	36650513          	addi	a0,a0,870 # 800083a8 <states.0+0x168>
    8000204a:	00004097          	auipc	ra,0x4
    8000204e:	c00080e7          	jalr	-1024(ra) # 80005c4a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002052:	6cbc                	ld	a5,88(s1)
    80002054:	577d                	li	a4,-1
    80002056:	fbb8                	sd	a4,112(a5)
  }
}
    80002058:	70a2                	ld	ra,40(sp)
    8000205a:	7402                	ld	s0,32(sp)
    8000205c:	64e2                	ld	s1,24(sp)
    8000205e:	6942                	ld	s2,16(sp)
    80002060:	69a2                	ld	s3,8(sp)
    80002062:	6145                	addi	sp,sp,48
    80002064:	8082                	ret

0000000080002066 <sys_exit>:
#include "proc.h"
#include "kernel/sysinfo.h"

uint64
sys_exit(void)
{
    80002066:	1101                	addi	sp,sp,-32
    80002068:	ec06                	sd	ra,24(sp)
    8000206a:	e822                	sd	s0,16(sp)
    8000206c:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000206e:	fec40593          	addi	a1,s0,-20
    80002072:	4501                	li	a0,0
    80002074:	00000097          	auipc	ra,0x0
    80002078:	ede080e7          	jalr	-290(ra) # 80001f52 <argint>
    return -1;
    8000207c:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000207e:	00054963          	bltz	a0,80002090 <sys_exit+0x2a>
  exit(n);
    80002082:	fec42503          	lw	a0,-20(s0)
    80002086:	fffff097          	auipc	ra,0xfffff
    8000208a:	708080e7          	jalr	1800(ra) # 8000178e <exit>
  return 0;  // not reached
    8000208e:	4781                	li	a5,0
}
    80002090:	853e                	mv	a0,a5
    80002092:	60e2                	ld	ra,24(sp)
    80002094:	6442                	ld	s0,16(sp)
    80002096:	6105                	addi	sp,sp,32
    80002098:	8082                	ret

000000008000209a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000209a:	1141                	addi	sp,sp,-16
    8000209c:	e406                	sd	ra,8(sp)
    8000209e:	e022                	sd	s0,0(sp)
    800020a0:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020a2:	fffff097          	auipc	ra,0xfffff
    800020a6:	dc6080e7          	jalr	-570(ra) # 80000e68 <myproc>
}
    800020aa:	5908                	lw	a0,48(a0)
    800020ac:	60a2                	ld	ra,8(sp)
    800020ae:	6402                	ld	s0,0(sp)
    800020b0:	0141                	addi	sp,sp,16
    800020b2:	8082                	ret

00000000800020b4 <sys_fork>:

uint64
sys_fork(void)
{
    800020b4:	1141                	addi	sp,sp,-16
    800020b6:	e406                	sd	ra,8(sp)
    800020b8:	e022                	sd	s0,0(sp)
    800020ba:	0800                	addi	s0,sp,16
  return fork();
    800020bc:	fffff097          	auipc	ra,0xfffff
    800020c0:	17e080e7          	jalr	382(ra) # 8000123a <fork>
}
    800020c4:	60a2                	ld	ra,8(sp)
    800020c6:	6402                	ld	s0,0(sp)
    800020c8:	0141                	addi	sp,sp,16
    800020ca:	8082                	ret

00000000800020cc <sys_wait>:

uint64
sys_wait(void)
{
    800020cc:	1101                	addi	sp,sp,-32
    800020ce:	ec06                	sd	ra,24(sp)
    800020d0:	e822                	sd	s0,16(sp)
    800020d2:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800020d4:	fe840593          	addi	a1,s0,-24
    800020d8:	4501                	li	a0,0
    800020da:	00000097          	auipc	ra,0x0
    800020de:	e9a080e7          	jalr	-358(ra) # 80001f74 <argaddr>
    800020e2:	87aa                	mv	a5,a0
    return -1;
    800020e4:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800020e6:	0007c863          	bltz	a5,800020f6 <sys_wait+0x2a>
  return wait(p);
    800020ea:	fe843503          	ld	a0,-24(s0)
    800020ee:	fffff097          	auipc	ra,0xfffff
    800020f2:	4a8080e7          	jalr	1192(ra) # 80001596 <wait>
}
    800020f6:	60e2                	ld	ra,24(sp)
    800020f8:	6442                	ld	s0,16(sp)
    800020fa:	6105                	addi	sp,sp,32
    800020fc:	8082                	ret

00000000800020fe <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020fe:	7179                	addi	sp,sp,-48
    80002100:	f406                	sd	ra,40(sp)
    80002102:	f022                	sd	s0,32(sp)
    80002104:	ec26                	sd	s1,24(sp)
    80002106:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002108:	fdc40593          	addi	a1,s0,-36
    8000210c:	4501                	li	a0,0
    8000210e:	00000097          	auipc	ra,0x0
    80002112:	e44080e7          	jalr	-444(ra) # 80001f52 <argint>
    80002116:	87aa                	mv	a5,a0
    return -1;
    80002118:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000211a:	0207c063          	bltz	a5,8000213a <sys_sbrk+0x3c>
  addr = myproc()->sz;
    8000211e:	fffff097          	auipc	ra,0xfffff
    80002122:	d4a080e7          	jalr	-694(ra) # 80000e68 <myproc>
    80002126:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002128:	fdc42503          	lw	a0,-36(s0)
    8000212c:	fffff097          	auipc	ra,0xfffff
    80002130:	096080e7          	jalr	150(ra) # 800011c2 <growproc>
    80002134:	00054863          	bltz	a0,80002144 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002138:	8526                	mv	a0,s1
}
    8000213a:	70a2                	ld	ra,40(sp)
    8000213c:	7402                	ld	s0,32(sp)
    8000213e:	64e2                	ld	s1,24(sp)
    80002140:	6145                	addi	sp,sp,48
    80002142:	8082                	ret
    return -1;
    80002144:	557d                	li	a0,-1
    80002146:	bfd5                	j	8000213a <sys_sbrk+0x3c>

0000000080002148 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002148:	7139                	addi	sp,sp,-64
    8000214a:	fc06                	sd	ra,56(sp)
    8000214c:	f822                	sd	s0,48(sp)
    8000214e:	f426                	sd	s1,40(sp)
    80002150:	f04a                	sd	s2,32(sp)
    80002152:	ec4e                	sd	s3,24(sp)
    80002154:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002156:	fcc40593          	addi	a1,s0,-52
    8000215a:	4501                	li	a0,0
    8000215c:	00000097          	auipc	ra,0x0
    80002160:	df6080e7          	jalr	-522(ra) # 80001f52 <argint>
    return -1;
    80002164:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002166:	06054563          	bltz	a0,800021d0 <sys_sleep+0x88>
  acquire(&tickslock);
    8000216a:	0000d517          	auipc	a0,0xd
    8000216e:	d1650513          	addi	a0,a0,-746 # 8000ee80 <tickslock>
    80002172:	00004097          	auipc	ra,0x4
    80002176:	fc6080e7          	jalr	-58(ra) # 80006138 <acquire>
  ticks0 = ticks;
    8000217a:	00007917          	auipc	s2,0x7
    8000217e:	e9e92903          	lw	s2,-354(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002182:	fcc42783          	lw	a5,-52(s0)
    80002186:	cf85                	beqz	a5,800021be <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002188:	0000d997          	auipc	s3,0xd
    8000218c:	cf898993          	addi	s3,s3,-776 # 8000ee80 <tickslock>
    80002190:	00007497          	auipc	s1,0x7
    80002194:	e8848493          	addi	s1,s1,-376 # 80009018 <ticks>
    if(myproc()->killed){
    80002198:	fffff097          	auipc	ra,0xfffff
    8000219c:	cd0080e7          	jalr	-816(ra) # 80000e68 <myproc>
    800021a0:	551c                	lw	a5,40(a0)
    800021a2:	ef9d                	bnez	a5,800021e0 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800021a4:	85ce                	mv	a1,s3
    800021a6:	8526                	mv	a0,s1
    800021a8:	fffff097          	auipc	ra,0xfffff
    800021ac:	38a080e7          	jalr	906(ra) # 80001532 <sleep>
  while(ticks - ticks0 < n){
    800021b0:	409c                	lw	a5,0(s1)
    800021b2:	412787bb          	subw	a5,a5,s2
    800021b6:	fcc42703          	lw	a4,-52(s0)
    800021ba:	fce7efe3          	bltu	a5,a4,80002198 <sys_sleep+0x50>
  }
  release(&tickslock);
    800021be:	0000d517          	auipc	a0,0xd
    800021c2:	cc250513          	addi	a0,a0,-830 # 8000ee80 <tickslock>
    800021c6:	00004097          	auipc	ra,0x4
    800021ca:	026080e7          	jalr	38(ra) # 800061ec <release>
  return 0;
    800021ce:	4781                	li	a5,0
}
    800021d0:	853e                	mv	a0,a5
    800021d2:	70e2                	ld	ra,56(sp)
    800021d4:	7442                	ld	s0,48(sp)
    800021d6:	74a2                	ld	s1,40(sp)
    800021d8:	7902                	ld	s2,32(sp)
    800021da:	69e2                	ld	s3,24(sp)
    800021dc:	6121                	addi	sp,sp,64
    800021de:	8082                	ret
      release(&tickslock);
    800021e0:	0000d517          	auipc	a0,0xd
    800021e4:	ca050513          	addi	a0,a0,-864 # 8000ee80 <tickslock>
    800021e8:	00004097          	auipc	ra,0x4
    800021ec:	004080e7          	jalr	4(ra) # 800061ec <release>
      return -1;
    800021f0:	57fd                	li	a5,-1
    800021f2:	bff9                	j	800021d0 <sys_sleep+0x88>

00000000800021f4 <sys_kill>:

uint64
sys_kill(void)
{
    800021f4:	1101                	addi	sp,sp,-32
    800021f6:	ec06                	sd	ra,24(sp)
    800021f8:	e822                	sd	s0,16(sp)
    800021fa:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800021fc:	fec40593          	addi	a1,s0,-20
    80002200:	4501                	li	a0,0
    80002202:	00000097          	auipc	ra,0x0
    80002206:	d50080e7          	jalr	-688(ra) # 80001f52 <argint>
    8000220a:	87aa                	mv	a5,a0
    return -1;
    8000220c:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000220e:	0007c863          	bltz	a5,8000221e <sys_kill+0x2a>
  return kill(pid);
    80002212:	fec42503          	lw	a0,-20(s0)
    80002216:	fffff097          	auipc	ra,0xfffff
    8000221a:	64e080e7          	jalr	1614(ra) # 80001864 <kill>
}
    8000221e:	60e2                	ld	ra,24(sp)
    80002220:	6442                	ld	s0,16(sp)
    80002222:	6105                	addi	sp,sp,32
    80002224:	8082                	ret

0000000080002226 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002226:	1101                	addi	sp,sp,-32
    80002228:	ec06                	sd	ra,24(sp)
    8000222a:	e822                	sd	s0,16(sp)
    8000222c:	e426                	sd	s1,8(sp)
    8000222e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002230:	0000d517          	auipc	a0,0xd
    80002234:	c5050513          	addi	a0,a0,-944 # 8000ee80 <tickslock>
    80002238:	00004097          	auipc	ra,0x4
    8000223c:	f00080e7          	jalr	-256(ra) # 80006138 <acquire>
  xticks = ticks;
    80002240:	00007497          	auipc	s1,0x7
    80002244:	dd84a483          	lw	s1,-552(s1) # 80009018 <ticks>
  release(&tickslock);
    80002248:	0000d517          	auipc	a0,0xd
    8000224c:	c3850513          	addi	a0,a0,-968 # 8000ee80 <tickslock>
    80002250:	00004097          	auipc	ra,0x4
    80002254:	f9c080e7          	jalr	-100(ra) # 800061ec <release>
  return xticks;
}
    80002258:	02049513          	slli	a0,s1,0x20
    8000225c:	9101                	srli	a0,a0,0x20
    8000225e:	60e2                	ld	ra,24(sp)
    80002260:	6442                	ld	s0,16(sp)
    80002262:	64a2                	ld	s1,8(sp)
    80002264:	6105                	addi	sp,sp,32
    80002266:	8082                	ret

0000000080002268 <sys_trace>:

uint64 sys_trace(void) {
    80002268:	1101                	addi	sp,sp,-32
    8000226a:	ec06                	sd	ra,24(sp)
    8000226c:	e822                	sd	s0,16(sp)
    8000226e:	1000                	addi	s0,sp,32
    int mask;
    // 获取整数类型的系统调用参数
    if (argint(0, &mask) < 0) {
    80002270:	fec40593          	addi	a1,s0,-20
    80002274:	4501                	li	a0,0
    80002276:	00000097          	auipc	ra,0x0
    8000227a:	cdc080e7          	jalr	-804(ra) # 80001f52 <argint>
        return -1;
    8000227e:	57fd                	li	a5,-1
    if (argint(0, &mask) < 0) {
    80002280:	00054a63          	bltz	a0,80002294 <sys_trace+0x2c>
    }
    // 存入proc 结构体的 mask 变量中
    myproc()->tracemask = mask;
    80002284:	fffff097          	auipc	ra,0xfffff
    80002288:	be4080e7          	jalr	-1052(ra) # 80000e68 <myproc>
    8000228c:	fec42783          	lw	a5,-20(s0)
    80002290:	d95c                	sw	a5,52(a0)
    return 0;
    80002292:	4781                	li	a5,0
}
    80002294:	853e                	mv	a0,a5
    80002296:	60e2                	ld	ra,24(sp)
    80002298:	6442                	ld	s0,16(sp)
    8000229a:	6105                	addi	sp,sp,32
    8000229c:	8082                	ret

000000008000229e <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    8000229e:	7139                	addi	sp,sp,-64
    800022a0:	fc06                	sd	ra,56(sp)
    800022a2:	f822                	sd	s0,48(sp)
    800022a4:	f426                	sd	s1,40(sp)
    800022a6:	0080                	addi	s0,sp,64
  uint64 addr;
  struct sysinfo info;
  struct proc *p = myproc();
    800022a8:	fffff097          	auipc	ra,0xfffff
    800022ac:	bc0080e7          	jalr	-1088(ra) # 80000e68 <myproc>
    800022b0:	84aa                	mv	s1,a0
  
  // 获取用户空间传入的指针
  if(argaddr(0, &addr) < 0)
    800022b2:	fd840593          	addi	a1,s0,-40
    800022b6:	4501                	li	a0,0
    800022b8:	00000097          	auipc	ra,0x0
    800022bc:	cbc080e7          	jalr	-836(ra) # 80001f74 <argaddr>
    return -1;
    800022c0:	57fd                	li	a5,-1
  if(argaddr(0, &addr) < 0)
    800022c2:	02054a63          	bltz	a0,800022f6 <sys_sysinfo+0x58>
  
  // 收集系统信息
  info.freemem = getfreemem();
    800022c6:	ffffe097          	auipc	ra,0xffffe
    800022ca:	eb4080e7          	jalr	-332(ra) # 8000017a <getfreemem>
    800022ce:	fca43423          	sd	a0,-56(s0)
  info.nproc = getnproc();
    800022d2:	fffff097          	auipc	ra,0xfffff
    800022d6:	760080e7          	jalr	1888(ra) # 80001a32 <getnproc>
    800022da:	fca43823          	sd	a0,-48(s0)
  
  // 将结构体复制回用户空间
  if(copyout(p->pagetable, addr, (char *)&info, sizeof(info)) < 0)
    800022de:	46c1                	li	a3,16
    800022e0:	fc840613          	addi	a2,s0,-56
    800022e4:	fd843583          	ld	a1,-40(s0)
    800022e8:	68a8                	ld	a0,80(s1)
    800022ea:	fffff097          	auipc	ra,0xfffff
    800022ee:	842080e7          	jalr	-1982(ra) # 80000b2c <copyout>
    800022f2:	43f55793          	srai	a5,a0,0x3f
    return -1;
    
  return 0;
    800022f6:	853e                	mv	a0,a5
    800022f8:	70e2                	ld	ra,56(sp)
    800022fa:	7442                	ld	s0,48(sp)
    800022fc:	74a2                	ld	s1,40(sp)
    800022fe:	6121                	addi	sp,sp,64
    80002300:	8082                	ret

0000000080002302 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002302:	7179                	addi	sp,sp,-48
    80002304:	f406                	sd	ra,40(sp)
    80002306:	f022                	sd	s0,32(sp)
    80002308:	ec26                	sd	s1,24(sp)
    8000230a:	e84a                	sd	s2,16(sp)
    8000230c:	e44e                	sd	s3,8(sp)
    8000230e:	e052                	sd	s4,0(sp)
    80002310:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002312:	00006597          	auipc	a1,0x6
    80002316:	2ee58593          	addi	a1,a1,750 # 80008600 <syscall_names+0xb8>
    8000231a:	0000d517          	auipc	a0,0xd
    8000231e:	b7e50513          	addi	a0,a0,-1154 # 8000ee98 <bcache>
    80002322:	00004097          	auipc	ra,0x4
    80002326:	d86080e7          	jalr	-634(ra) # 800060a8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000232a:	00015797          	auipc	a5,0x15
    8000232e:	b6e78793          	addi	a5,a5,-1170 # 80016e98 <bcache+0x8000>
    80002332:	00015717          	auipc	a4,0x15
    80002336:	dce70713          	addi	a4,a4,-562 # 80017100 <bcache+0x8268>
    8000233a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000233e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002342:	0000d497          	auipc	s1,0xd
    80002346:	b6e48493          	addi	s1,s1,-1170 # 8000eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    8000234a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000234c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000234e:	00006a17          	auipc	s4,0x6
    80002352:	2baa0a13          	addi	s4,s4,698 # 80008608 <syscall_names+0xc0>
    b->next = bcache.head.next;
    80002356:	2b893783          	ld	a5,696(s2)
    8000235a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000235c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002360:	85d2                	mv	a1,s4
    80002362:	01048513          	addi	a0,s1,16
    80002366:	00001097          	auipc	ra,0x1
    8000236a:	4c2080e7          	jalr	1218(ra) # 80003828 <initsleeplock>
    bcache.head.next->prev = b;
    8000236e:	2b893783          	ld	a5,696(s2)
    80002372:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002374:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002378:	45848493          	addi	s1,s1,1112
    8000237c:	fd349de3          	bne	s1,s3,80002356 <binit+0x54>
  }
}
    80002380:	70a2                	ld	ra,40(sp)
    80002382:	7402                	ld	s0,32(sp)
    80002384:	64e2                	ld	s1,24(sp)
    80002386:	6942                	ld	s2,16(sp)
    80002388:	69a2                	ld	s3,8(sp)
    8000238a:	6a02                	ld	s4,0(sp)
    8000238c:	6145                	addi	sp,sp,48
    8000238e:	8082                	ret

0000000080002390 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002390:	7179                	addi	sp,sp,-48
    80002392:	f406                	sd	ra,40(sp)
    80002394:	f022                	sd	s0,32(sp)
    80002396:	ec26                	sd	s1,24(sp)
    80002398:	e84a                	sd	s2,16(sp)
    8000239a:	e44e                	sd	s3,8(sp)
    8000239c:	1800                	addi	s0,sp,48
    8000239e:	892a                	mv	s2,a0
    800023a0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800023a2:	0000d517          	auipc	a0,0xd
    800023a6:	af650513          	addi	a0,a0,-1290 # 8000ee98 <bcache>
    800023aa:	00004097          	auipc	ra,0x4
    800023ae:	d8e080e7          	jalr	-626(ra) # 80006138 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023b2:	00015497          	auipc	s1,0x15
    800023b6:	d9e4b483          	ld	s1,-610(s1) # 80017150 <bcache+0x82b8>
    800023ba:	00015797          	auipc	a5,0x15
    800023be:	d4678793          	addi	a5,a5,-698 # 80017100 <bcache+0x8268>
    800023c2:	02f48f63          	beq	s1,a5,80002400 <bread+0x70>
    800023c6:	873e                	mv	a4,a5
    800023c8:	a021                	j	800023d0 <bread+0x40>
    800023ca:	68a4                	ld	s1,80(s1)
    800023cc:	02e48a63          	beq	s1,a4,80002400 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023d0:	449c                	lw	a5,8(s1)
    800023d2:	ff279ce3          	bne	a5,s2,800023ca <bread+0x3a>
    800023d6:	44dc                	lw	a5,12(s1)
    800023d8:	ff3799e3          	bne	a5,s3,800023ca <bread+0x3a>
      b->refcnt++;
    800023dc:	40bc                	lw	a5,64(s1)
    800023de:	2785                	addiw	a5,a5,1
    800023e0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023e2:	0000d517          	auipc	a0,0xd
    800023e6:	ab650513          	addi	a0,a0,-1354 # 8000ee98 <bcache>
    800023ea:	00004097          	auipc	ra,0x4
    800023ee:	e02080e7          	jalr	-510(ra) # 800061ec <release>
      acquiresleep(&b->lock);
    800023f2:	01048513          	addi	a0,s1,16
    800023f6:	00001097          	auipc	ra,0x1
    800023fa:	46c080e7          	jalr	1132(ra) # 80003862 <acquiresleep>
      return b;
    800023fe:	a8b9                	j	8000245c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002400:	00015497          	auipc	s1,0x15
    80002404:	d484b483          	ld	s1,-696(s1) # 80017148 <bcache+0x82b0>
    80002408:	00015797          	auipc	a5,0x15
    8000240c:	cf878793          	addi	a5,a5,-776 # 80017100 <bcache+0x8268>
    80002410:	00f48863          	beq	s1,a5,80002420 <bread+0x90>
    80002414:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002416:	40bc                	lw	a5,64(s1)
    80002418:	cf81                	beqz	a5,80002430 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000241a:	64a4                	ld	s1,72(s1)
    8000241c:	fee49de3          	bne	s1,a4,80002416 <bread+0x86>
  panic("bget: no buffers");
    80002420:	00006517          	auipc	a0,0x6
    80002424:	1f050513          	addi	a0,a0,496 # 80008610 <syscall_names+0xc8>
    80002428:	00003097          	auipc	ra,0x3
    8000242c:	7d8080e7          	jalr	2008(ra) # 80005c00 <panic>
      b->dev = dev;
    80002430:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002434:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002438:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000243c:	4785                	li	a5,1
    8000243e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002440:	0000d517          	auipc	a0,0xd
    80002444:	a5850513          	addi	a0,a0,-1448 # 8000ee98 <bcache>
    80002448:	00004097          	auipc	ra,0x4
    8000244c:	da4080e7          	jalr	-604(ra) # 800061ec <release>
      acquiresleep(&b->lock);
    80002450:	01048513          	addi	a0,s1,16
    80002454:	00001097          	auipc	ra,0x1
    80002458:	40e080e7          	jalr	1038(ra) # 80003862 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000245c:	409c                	lw	a5,0(s1)
    8000245e:	cb89                	beqz	a5,80002470 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002460:	8526                	mv	a0,s1
    80002462:	70a2                	ld	ra,40(sp)
    80002464:	7402                	ld	s0,32(sp)
    80002466:	64e2                	ld	s1,24(sp)
    80002468:	6942                	ld	s2,16(sp)
    8000246a:	69a2                	ld	s3,8(sp)
    8000246c:	6145                	addi	sp,sp,48
    8000246e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002470:	4581                	li	a1,0
    80002472:	8526                	mv	a0,s1
    80002474:	00003097          	auipc	ra,0x3
    80002478:	f1e080e7          	jalr	-226(ra) # 80005392 <virtio_disk_rw>
    b->valid = 1;
    8000247c:	4785                	li	a5,1
    8000247e:	c09c                	sw	a5,0(s1)
  return b;
    80002480:	b7c5                	j	80002460 <bread+0xd0>

0000000080002482 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002482:	1101                	addi	sp,sp,-32
    80002484:	ec06                	sd	ra,24(sp)
    80002486:	e822                	sd	s0,16(sp)
    80002488:	e426                	sd	s1,8(sp)
    8000248a:	1000                	addi	s0,sp,32
    8000248c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000248e:	0541                	addi	a0,a0,16
    80002490:	00001097          	auipc	ra,0x1
    80002494:	46c080e7          	jalr	1132(ra) # 800038fc <holdingsleep>
    80002498:	cd01                	beqz	a0,800024b0 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000249a:	4585                	li	a1,1
    8000249c:	8526                	mv	a0,s1
    8000249e:	00003097          	auipc	ra,0x3
    800024a2:	ef4080e7          	jalr	-268(ra) # 80005392 <virtio_disk_rw>
}
    800024a6:	60e2                	ld	ra,24(sp)
    800024a8:	6442                	ld	s0,16(sp)
    800024aa:	64a2                	ld	s1,8(sp)
    800024ac:	6105                	addi	sp,sp,32
    800024ae:	8082                	ret
    panic("bwrite");
    800024b0:	00006517          	auipc	a0,0x6
    800024b4:	17850513          	addi	a0,a0,376 # 80008628 <syscall_names+0xe0>
    800024b8:	00003097          	auipc	ra,0x3
    800024bc:	748080e7          	jalr	1864(ra) # 80005c00 <panic>

00000000800024c0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024c0:	1101                	addi	sp,sp,-32
    800024c2:	ec06                	sd	ra,24(sp)
    800024c4:	e822                	sd	s0,16(sp)
    800024c6:	e426                	sd	s1,8(sp)
    800024c8:	e04a                	sd	s2,0(sp)
    800024ca:	1000                	addi	s0,sp,32
    800024cc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024ce:	01050913          	addi	s2,a0,16
    800024d2:	854a                	mv	a0,s2
    800024d4:	00001097          	auipc	ra,0x1
    800024d8:	428080e7          	jalr	1064(ra) # 800038fc <holdingsleep>
    800024dc:	c92d                	beqz	a0,8000254e <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800024de:	854a                	mv	a0,s2
    800024e0:	00001097          	auipc	ra,0x1
    800024e4:	3d8080e7          	jalr	984(ra) # 800038b8 <releasesleep>

  acquire(&bcache.lock);
    800024e8:	0000d517          	auipc	a0,0xd
    800024ec:	9b050513          	addi	a0,a0,-1616 # 8000ee98 <bcache>
    800024f0:	00004097          	auipc	ra,0x4
    800024f4:	c48080e7          	jalr	-952(ra) # 80006138 <acquire>
  b->refcnt--;
    800024f8:	40bc                	lw	a5,64(s1)
    800024fa:	37fd                	addiw	a5,a5,-1
    800024fc:	0007871b          	sext.w	a4,a5
    80002500:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002502:	eb05                	bnez	a4,80002532 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002504:	68bc                	ld	a5,80(s1)
    80002506:	64b8                	ld	a4,72(s1)
    80002508:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000250a:	64bc                	ld	a5,72(s1)
    8000250c:	68b8                	ld	a4,80(s1)
    8000250e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002510:	00015797          	auipc	a5,0x15
    80002514:	98878793          	addi	a5,a5,-1656 # 80016e98 <bcache+0x8000>
    80002518:	2b87b703          	ld	a4,696(a5)
    8000251c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000251e:	00015717          	auipc	a4,0x15
    80002522:	be270713          	addi	a4,a4,-1054 # 80017100 <bcache+0x8268>
    80002526:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002528:	2b87b703          	ld	a4,696(a5)
    8000252c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000252e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002532:	0000d517          	auipc	a0,0xd
    80002536:	96650513          	addi	a0,a0,-1690 # 8000ee98 <bcache>
    8000253a:	00004097          	auipc	ra,0x4
    8000253e:	cb2080e7          	jalr	-846(ra) # 800061ec <release>
}
    80002542:	60e2                	ld	ra,24(sp)
    80002544:	6442                	ld	s0,16(sp)
    80002546:	64a2                	ld	s1,8(sp)
    80002548:	6902                	ld	s2,0(sp)
    8000254a:	6105                	addi	sp,sp,32
    8000254c:	8082                	ret
    panic("brelse");
    8000254e:	00006517          	auipc	a0,0x6
    80002552:	0e250513          	addi	a0,a0,226 # 80008630 <syscall_names+0xe8>
    80002556:	00003097          	auipc	ra,0x3
    8000255a:	6aa080e7          	jalr	1706(ra) # 80005c00 <panic>

000000008000255e <bpin>:

void
bpin(struct buf *b) {
    8000255e:	1101                	addi	sp,sp,-32
    80002560:	ec06                	sd	ra,24(sp)
    80002562:	e822                	sd	s0,16(sp)
    80002564:	e426                	sd	s1,8(sp)
    80002566:	1000                	addi	s0,sp,32
    80002568:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000256a:	0000d517          	auipc	a0,0xd
    8000256e:	92e50513          	addi	a0,a0,-1746 # 8000ee98 <bcache>
    80002572:	00004097          	auipc	ra,0x4
    80002576:	bc6080e7          	jalr	-1082(ra) # 80006138 <acquire>
  b->refcnt++;
    8000257a:	40bc                	lw	a5,64(s1)
    8000257c:	2785                	addiw	a5,a5,1
    8000257e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002580:	0000d517          	auipc	a0,0xd
    80002584:	91850513          	addi	a0,a0,-1768 # 8000ee98 <bcache>
    80002588:	00004097          	auipc	ra,0x4
    8000258c:	c64080e7          	jalr	-924(ra) # 800061ec <release>
}
    80002590:	60e2                	ld	ra,24(sp)
    80002592:	6442                	ld	s0,16(sp)
    80002594:	64a2                	ld	s1,8(sp)
    80002596:	6105                	addi	sp,sp,32
    80002598:	8082                	ret

000000008000259a <bunpin>:

void
bunpin(struct buf *b) {
    8000259a:	1101                	addi	sp,sp,-32
    8000259c:	ec06                	sd	ra,24(sp)
    8000259e:	e822                	sd	s0,16(sp)
    800025a0:	e426                	sd	s1,8(sp)
    800025a2:	1000                	addi	s0,sp,32
    800025a4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025a6:	0000d517          	auipc	a0,0xd
    800025aa:	8f250513          	addi	a0,a0,-1806 # 8000ee98 <bcache>
    800025ae:	00004097          	auipc	ra,0x4
    800025b2:	b8a080e7          	jalr	-1142(ra) # 80006138 <acquire>
  b->refcnt--;
    800025b6:	40bc                	lw	a5,64(s1)
    800025b8:	37fd                	addiw	a5,a5,-1
    800025ba:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025bc:	0000d517          	auipc	a0,0xd
    800025c0:	8dc50513          	addi	a0,a0,-1828 # 8000ee98 <bcache>
    800025c4:	00004097          	auipc	ra,0x4
    800025c8:	c28080e7          	jalr	-984(ra) # 800061ec <release>
}
    800025cc:	60e2                	ld	ra,24(sp)
    800025ce:	6442                	ld	s0,16(sp)
    800025d0:	64a2                	ld	s1,8(sp)
    800025d2:	6105                	addi	sp,sp,32
    800025d4:	8082                	ret

00000000800025d6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800025d6:	1101                	addi	sp,sp,-32
    800025d8:	ec06                	sd	ra,24(sp)
    800025da:	e822                	sd	s0,16(sp)
    800025dc:	e426                	sd	s1,8(sp)
    800025de:	e04a                	sd	s2,0(sp)
    800025e0:	1000                	addi	s0,sp,32
    800025e2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800025e4:	00d5d59b          	srliw	a1,a1,0xd
    800025e8:	00015797          	auipc	a5,0x15
    800025ec:	f8c7a783          	lw	a5,-116(a5) # 80017574 <sb+0x1c>
    800025f0:	9dbd                	addw	a1,a1,a5
    800025f2:	00000097          	auipc	ra,0x0
    800025f6:	d9e080e7          	jalr	-610(ra) # 80002390 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800025fa:	0074f713          	andi	a4,s1,7
    800025fe:	4785                	li	a5,1
    80002600:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002604:	14ce                	slli	s1,s1,0x33
    80002606:	90d9                	srli	s1,s1,0x36
    80002608:	00950733          	add	a4,a0,s1
    8000260c:	05874703          	lbu	a4,88(a4)
    80002610:	00e7f6b3          	and	a3,a5,a4
    80002614:	c69d                	beqz	a3,80002642 <bfree+0x6c>
    80002616:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002618:	94aa                	add	s1,s1,a0
    8000261a:	fff7c793          	not	a5,a5
    8000261e:	8f7d                	and	a4,a4,a5
    80002620:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002624:	00001097          	auipc	ra,0x1
    80002628:	120080e7          	jalr	288(ra) # 80003744 <log_write>
  brelse(bp);
    8000262c:	854a                	mv	a0,s2
    8000262e:	00000097          	auipc	ra,0x0
    80002632:	e92080e7          	jalr	-366(ra) # 800024c0 <brelse>
}
    80002636:	60e2                	ld	ra,24(sp)
    80002638:	6442                	ld	s0,16(sp)
    8000263a:	64a2                	ld	s1,8(sp)
    8000263c:	6902                	ld	s2,0(sp)
    8000263e:	6105                	addi	sp,sp,32
    80002640:	8082                	ret
    panic("freeing free block");
    80002642:	00006517          	auipc	a0,0x6
    80002646:	ff650513          	addi	a0,a0,-10 # 80008638 <syscall_names+0xf0>
    8000264a:	00003097          	auipc	ra,0x3
    8000264e:	5b6080e7          	jalr	1462(ra) # 80005c00 <panic>

0000000080002652 <balloc>:
{
    80002652:	711d                	addi	sp,sp,-96
    80002654:	ec86                	sd	ra,88(sp)
    80002656:	e8a2                	sd	s0,80(sp)
    80002658:	e4a6                	sd	s1,72(sp)
    8000265a:	e0ca                	sd	s2,64(sp)
    8000265c:	fc4e                	sd	s3,56(sp)
    8000265e:	f852                	sd	s4,48(sp)
    80002660:	f456                	sd	s5,40(sp)
    80002662:	f05a                	sd	s6,32(sp)
    80002664:	ec5e                	sd	s7,24(sp)
    80002666:	e862                	sd	s8,16(sp)
    80002668:	e466                	sd	s9,8(sp)
    8000266a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000266c:	00015797          	auipc	a5,0x15
    80002670:	ef07a783          	lw	a5,-272(a5) # 8001755c <sb+0x4>
    80002674:	cbc1                	beqz	a5,80002704 <balloc+0xb2>
    80002676:	8baa                	mv	s7,a0
    80002678:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000267a:	00015b17          	auipc	s6,0x15
    8000267e:	edeb0b13          	addi	s6,s6,-290 # 80017558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002682:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002684:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002686:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002688:	6c89                	lui	s9,0x2
    8000268a:	a831                	j	800026a6 <balloc+0x54>
    brelse(bp);
    8000268c:	854a                	mv	a0,s2
    8000268e:	00000097          	auipc	ra,0x0
    80002692:	e32080e7          	jalr	-462(ra) # 800024c0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002696:	015c87bb          	addw	a5,s9,s5
    8000269a:	00078a9b          	sext.w	s5,a5
    8000269e:	004b2703          	lw	a4,4(s6)
    800026a2:	06eaf163          	bgeu	s5,a4,80002704 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    800026a6:	41fad79b          	sraiw	a5,s5,0x1f
    800026aa:	0137d79b          	srliw	a5,a5,0x13
    800026ae:	015787bb          	addw	a5,a5,s5
    800026b2:	40d7d79b          	sraiw	a5,a5,0xd
    800026b6:	01cb2583          	lw	a1,28(s6)
    800026ba:	9dbd                	addw	a1,a1,a5
    800026bc:	855e                	mv	a0,s7
    800026be:	00000097          	auipc	ra,0x0
    800026c2:	cd2080e7          	jalr	-814(ra) # 80002390 <bread>
    800026c6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026c8:	004b2503          	lw	a0,4(s6)
    800026cc:	000a849b          	sext.w	s1,s5
    800026d0:	8762                	mv	a4,s8
    800026d2:	faa4fde3          	bgeu	s1,a0,8000268c <balloc+0x3a>
      m = 1 << (bi % 8);
    800026d6:	00777693          	andi	a3,a4,7
    800026da:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800026de:	41f7579b          	sraiw	a5,a4,0x1f
    800026e2:	01d7d79b          	srliw	a5,a5,0x1d
    800026e6:	9fb9                	addw	a5,a5,a4
    800026e8:	4037d79b          	sraiw	a5,a5,0x3
    800026ec:	00f90633          	add	a2,s2,a5
    800026f0:	05864603          	lbu	a2,88(a2)
    800026f4:	00c6f5b3          	and	a1,a3,a2
    800026f8:	cd91                	beqz	a1,80002714 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026fa:	2705                	addiw	a4,a4,1
    800026fc:	2485                	addiw	s1,s1,1
    800026fe:	fd471ae3          	bne	a4,s4,800026d2 <balloc+0x80>
    80002702:	b769                	j	8000268c <balloc+0x3a>
  panic("balloc: out of blocks");
    80002704:	00006517          	auipc	a0,0x6
    80002708:	f4c50513          	addi	a0,a0,-180 # 80008650 <syscall_names+0x108>
    8000270c:	00003097          	auipc	ra,0x3
    80002710:	4f4080e7          	jalr	1268(ra) # 80005c00 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002714:	97ca                	add	a5,a5,s2
    80002716:	8e55                	or	a2,a2,a3
    80002718:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000271c:	854a                	mv	a0,s2
    8000271e:	00001097          	auipc	ra,0x1
    80002722:	026080e7          	jalr	38(ra) # 80003744 <log_write>
        brelse(bp);
    80002726:	854a                	mv	a0,s2
    80002728:	00000097          	auipc	ra,0x0
    8000272c:	d98080e7          	jalr	-616(ra) # 800024c0 <brelse>
  bp = bread(dev, bno);
    80002730:	85a6                	mv	a1,s1
    80002732:	855e                	mv	a0,s7
    80002734:	00000097          	auipc	ra,0x0
    80002738:	c5c080e7          	jalr	-932(ra) # 80002390 <bread>
    8000273c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000273e:	40000613          	li	a2,1024
    80002742:	4581                	li	a1,0
    80002744:	05850513          	addi	a0,a0,88
    80002748:	ffffe097          	auipc	ra,0xffffe
    8000274c:	a56080e7          	jalr	-1450(ra) # 8000019e <memset>
  log_write(bp);
    80002750:	854a                	mv	a0,s2
    80002752:	00001097          	auipc	ra,0x1
    80002756:	ff2080e7          	jalr	-14(ra) # 80003744 <log_write>
  brelse(bp);
    8000275a:	854a                	mv	a0,s2
    8000275c:	00000097          	auipc	ra,0x0
    80002760:	d64080e7          	jalr	-668(ra) # 800024c0 <brelse>
}
    80002764:	8526                	mv	a0,s1
    80002766:	60e6                	ld	ra,88(sp)
    80002768:	6446                	ld	s0,80(sp)
    8000276a:	64a6                	ld	s1,72(sp)
    8000276c:	6906                	ld	s2,64(sp)
    8000276e:	79e2                	ld	s3,56(sp)
    80002770:	7a42                	ld	s4,48(sp)
    80002772:	7aa2                	ld	s5,40(sp)
    80002774:	7b02                	ld	s6,32(sp)
    80002776:	6be2                	ld	s7,24(sp)
    80002778:	6c42                	ld	s8,16(sp)
    8000277a:	6ca2                	ld	s9,8(sp)
    8000277c:	6125                	addi	sp,sp,96
    8000277e:	8082                	ret

0000000080002780 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002780:	7179                	addi	sp,sp,-48
    80002782:	f406                	sd	ra,40(sp)
    80002784:	f022                	sd	s0,32(sp)
    80002786:	ec26                	sd	s1,24(sp)
    80002788:	e84a                	sd	s2,16(sp)
    8000278a:	e44e                	sd	s3,8(sp)
    8000278c:	e052                	sd	s4,0(sp)
    8000278e:	1800                	addi	s0,sp,48
    80002790:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002792:	47ad                	li	a5,11
    80002794:	04b7fe63          	bgeu	a5,a1,800027f0 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002798:	ff45849b          	addiw	s1,a1,-12
    8000279c:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027a0:	0ff00793          	li	a5,255
    800027a4:	0ae7e463          	bltu	a5,a4,8000284c <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800027a8:	08052583          	lw	a1,128(a0)
    800027ac:	c5b5                	beqz	a1,80002818 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800027ae:	00092503          	lw	a0,0(s2)
    800027b2:	00000097          	auipc	ra,0x0
    800027b6:	bde080e7          	jalr	-1058(ra) # 80002390 <bread>
    800027ba:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800027bc:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800027c0:	02049713          	slli	a4,s1,0x20
    800027c4:	01e75593          	srli	a1,a4,0x1e
    800027c8:	00b784b3          	add	s1,a5,a1
    800027cc:	0004a983          	lw	s3,0(s1)
    800027d0:	04098e63          	beqz	s3,8000282c <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800027d4:	8552                	mv	a0,s4
    800027d6:	00000097          	auipc	ra,0x0
    800027da:	cea080e7          	jalr	-790(ra) # 800024c0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800027de:	854e                	mv	a0,s3
    800027e0:	70a2                	ld	ra,40(sp)
    800027e2:	7402                	ld	s0,32(sp)
    800027e4:	64e2                	ld	s1,24(sp)
    800027e6:	6942                	ld	s2,16(sp)
    800027e8:	69a2                	ld	s3,8(sp)
    800027ea:	6a02                	ld	s4,0(sp)
    800027ec:	6145                	addi	sp,sp,48
    800027ee:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800027f0:	02059793          	slli	a5,a1,0x20
    800027f4:	01e7d593          	srli	a1,a5,0x1e
    800027f8:	00b504b3          	add	s1,a0,a1
    800027fc:	0504a983          	lw	s3,80(s1)
    80002800:	fc099fe3          	bnez	s3,800027de <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002804:	4108                	lw	a0,0(a0)
    80002806:	00000097          	auipc	ra,0x0
    8000280a:	e4c080e7          	jalr	-436(ra) # 80002652 <balloc>
    8000280e:	0005099b          	sext.w	s3,a0
    80002812:	0534a823          	sw	s3,80(s1)
    80002816:	b7e1                	j	800027de <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002818:	4108                	lw	a0,0(a0)
    8000281a:	00000097          	auipc	ra,0x0
    8000281e:	e38080e7          	jalr	-456(ra) # 80002652 <balloc>
    80002822:	0005059b          	sext.w	a1,a0
    80002826:	08b92023          	sw	a1,128(s2)
    8000282a:	b751                	j	800027ae <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000282c:	00092503          	lw	a0,0(s2)
    80002830:	00000097          	auipc	ra,0x0
    80002834:	e22080e7          	jalr	-478(ra) # 80002652 <balloc>
    80002838:	0005099b          	sext.w	s3,a0
    8000283c:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002840:	8552                	mv	a0,s4
    80002842:	00001097          	auipc	ra,0x1
    80002846:	f02080e7          	jalr	-254(ra) # 80003744 <log_write>
    8000284a:	b769                	j	800027d4 <bmap+0x54>
  panic("bmap: out of range");
    8000284c:	00006517          	auipc	a0,0x6
    80002850:	e1c50513          	addi	a0,a0,-484 # 80008668 <syscall_names+0x120>
    80002854:	00003097          	auipc	ra,0x3
    80002858:	3ac080e7          	jalr	940(ra) # 80005c00 <panic>

000000008000285c <iget>:
{
    8000285c:	7179                	addi	sp,sp,-48
    8000285e:	f406                	sd	ra,40(sp)
    80002860:	f022                	sd	s0,32(sp)
    80002862:	ec26                	sd	s1,24(sp)
    80002864:	e84a                	sd	s2,16(sp)
    80002866:	e44e                	sd	s3,8(sp)
    80002868:	e052                	sd	s4,0(sp)
    8000286a:	1800                	addi	s0,sp,48
    8000286c:	89aa                	mv	s3,a0
    8000286e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002870:	00015517          	auipc	a0,0x15
    80002874:	d0850513          	addi	a0,a0,-760 # 80017578 <itable>
    80002878:	00004097          	auipc	ra,0x4
    8000287c:	8c0080e7          	jalr	-1856(ra) # 80006138 <acquire>
  empty = 0;
    80002880:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002882:	00015497          	auipc	s1,0x15
    80002886:	d0e48493          	addi	s1,s1,-754 # 80017590 <itable+0x18>
    8000288a:	00016697          	auipc	a3,0x16
    8000288e:	79668693          	addi	a3,a3,1942 # 80019020 <log>
    80002892:	a039                	j	800028a0 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002894:	02090b63          	beqz	s2,800028ca <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002898:	08848493          	addi	s1,s1,136
    8000289c:	02d48a63          	beq	s1,a3,800028d0 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028a0:	449c                	lw	a5,8(s1)
    800028a2:	fef059e3          	blez	a5,80002894 <iget+0x38>
    800028a6:	4098                	lw	a4,0(s1)
    800028a8:	ff3716e3          	bne	a4,s3,80002894 <iget+0x38>
    800028ac:	40d8                	lw	a4,4(s1)
    800028ae:	ff4713e3          	bne	a4,s4,80002894 <iget+0x38>
      ip->ref++;
    800028b2:	2785                	addiw	a5,a5,1
    800028b4:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028b6:	00015517          	auipc	a0,0x15
    800028ba:	cc250513          	addi	a0,a0,-830 # 80017578 <itable>
    800028be:	00004097          	auipc	ra,0x4
    800028c2:	92e080e7          	jalr	-1746(ra) # 800061ec <release>
      return ip;
    800028c6:	8926                	mv	s2,s1
    800028c8:	a03d                	j	800028f6 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028ca:	f7f9                	bnez	a5,80002898 <iget+0x3c>
    800028cc:	8926                	mv	s2,s1
    800028ce:	b7e9                	j	80002898 <iget+0x3c>
  if(empty == 0)
    800028d0:	02090c63          	beqz	s2,80002908 <iget+0xac>
  ip->dev = dev;
    800028d4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800028d8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800028dc:	4785                	li	a5,1
    800028de:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800028e2:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800028e6:	00015517          	auipc	a0,0x15
    800028ea:	c9250513          	addi	a0,a0,-878 # 80017578 <itable>
    800028ee:	00004097          	auipc	ra,0x4
    800028f2:	8fe080e7          	jalr	-1794(ra) # 800061ec <release>
}
    800028f6:	854a                	mv	a0,s2
    800028f8:	70a2                	ld	ra,40(sp)
    800028fa:	7402                	ld	s0,32(sp)
    800028fc:	64e2                	ld	s1,24(sp)
    800028fe:	6942                	ld	s2,16(sp)
    80002900:	69a2                	ld	s3,8(sp)
    80002902:	6a02                	ld	s4,0(sp)
    80002904:	6145                	addi	sp,sp,48
    80002906:	8082                	ret
    panic("iget: no inodes");
    80002908:	00006517          	auipc	a0,0x6
    8000290c:	d7850513          	addi	a0,a0,-648 # 80008680 <syscall_names+0x138>
    80002910:	00003097          	auipc	ra,0x3
    80002914:	2f0080e7          	jalr	752(ra) # 80005c00 <panic>

0000000080002918 <fsinit>:
fsinit(int dev) {
    80002918:	7179                	addi	sp,sp,-48
    8000291a:	f406                	sd	ra,40(sp)
    8000291c:	f022                	sd	s0,32(sp)
    8000291e:	ec26                	sd	s1,24(sp)
    80002920:	e84a                	sd	s2,16(sp)
    80002922:	e44e                	sd	s3,8(sp)
    80002924:	1800                	addi	s0,sp,48
    80002926:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002928:	4585                	li	a1,1
    8000292a:	00000097          	auipc	ra,0x0
    8000292e:	a66080e7          	jalr	-1434(ra) # 80002390 <bread>
    80002932:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002934:	00015997          	auipc	s3,0x15
    80002938:	c2498993          	addi	s3,s3,-988 # 80017558 <sb>
    8000293c:	02000613          	li	a2,32
    80002940:	05850593          	addi	a1,a0,88
    80002944:	854e                	mv	a0,s3
    80002946:	ffffe097          	auipc	ra,0xffffe
    8000294a:	8b4080e7          	jalr	-1868(ra) # 800001fa <memmove>
  brelse(bp);
    8000294e:	8526                	mv	a0,s1
    80002950:	00000097          	auipc	ra,0x0
    80002954:	b70080e7          	jalr	-1168(ra) # 800024c0 <brelse>
  if(sb.magic != FSMAGIC)
    80002958:	0009a703          	lw	a4,0(s3)
    8000295c:	102037b7          	lui	a5,0x10203
    80002960:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002964:	02f71263          	bne	a4,a5,80002988 <fsinit+0x70>
  initlog(dev, &sb);
    80002968:	00015597          	auipc	a1,0x15
    8000296c:	bf058593          	addi	a1,a1,-1040 # 80017558 <sb>
    80002970:	854a                	mv	a0,s2
    80002972:	00001097          	auipc	ra,0x1
    80002976:	b56080e7          	jalr	-1194(ra) # 800034c8 <initlog>
}
    8000297a:	70a2                	ld	ra,40(sp)
    8000297c:	7402                	ld	s0,32(sp)
    8000297e:	64e2                	ld	s1,24(sp)
    80002980:	6942                	ld	s2,16(sp)
    80002982:	69a2                	ld	s3,8(sp)
    80002984:	6145                	addi	sp,sp,48
    80002986:	8082                	ret
    panic("invalid file system");
    80002988:	00006517          	auipc	a0,0x6
    8000298c:	d0850513          	addi	a0,a0,-760 # 80008690 <syscall_names+0x148>
    80002990:	00003097          	auipc	ra,0x3
    80002994:	270080e7          	jalr	624(ra) # 80005c00 <panic>

0000000080002998 <iinit>:
{
    80002998:	7179                	addi	sp,sp,-48
    8000299a:	f406                	sd	ra,40(sp)
    8000299c:	f022                	sd	s0,32(sp)
    8000299e:	ec26                	sd	s1,24(sp)
    800029a0:	e84a                	sd	s2,16(sp)
    800029a2:	e44e                	sd	s3,8(sp)
    800029a4:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029a6:	00006597          	auipc	a1,0x6
    800029aa:	d0258593          	addi	a1,a1,-766 # 800086a8 <syscall_names+0x160>
    800029ae:	00015517          	auipc	a0,0x15
    800029b2:	bca50513          	addi	a0,a0,-1078 # 80017578 <itable>
    800029b6:	00003097          	auipc	ra,0x3
    800029ba:	6f2080e7          	jalr	1778(ra) # 800060a8 <initlock>
  for(i = 0; i < NINODE; i++) {
    800029be:	00015497          	auipc	s1,0x15
    800029c2:	be248493          	addi	s1,s1,-1054 # 800175a0 <itable+0x28>
    800029c6:	00016997          	auipc	s3,0x16
    800029ca:	66a98993          	addi	s3,s3,1642 # 80019030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029ce:	00006917          	auipc	s2,0x6
    800029d2:	ce290913          	addi	s2,s2,-798 # 800086b0 <syscall_names+0x168>
    800029d6:	85ca                	mv	a1,s2
    800029d8:	8526                	mv	a0,s1
    800029da:	00001097          	auipc	ra,0x1
    800029de:	e4e080e7          	jalr	-434(ra) # 80003828 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800029e2:	08848493          	addi	s1,s1,136
    800029e6:	ff3498e3          	bne	s1,s3,800029d6 <iinit+0x3e>
}
    800029ea:	70a2                	ld	ra,40(sp)
    800029ec:	7402                	ld	s0,32(sp)
    800029ee:	64e2                	ld	s1,24(sp)
    800029f0:	6942                	ld	s2,16(sp)
    800029f2:	69a2                	ld	s3,8(sp)
    800029f4:	6145                	addi	sp,sp,48
    800029f6:	8082                	ret

00000000800029f8 <ialloc>:
{
    800029f8:	715d                	addi	sp,sp,-80
    800029fa:	e486                	sd	ra,72(sp)
    800029fc:	e0a2                	sd	s0,64(sp)
    800029fe:	fc26                	sd	s1,56(sp)
    80002a00:	f84a                	sd	s2,48(sp)
    80002a02:	f44e                	sd	s3,40(sp)
    80002a04:	f052                	sd	s4,32(sp)
    80002a06:	ec56                	sd	s5,24(sp)
    80002a08:	e85a                	sd	s6,16(sp)
    80002a0a:	e45e                	sd	s7,8(sp)
    80002a0c:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a0e:	00015717          	auipc	a4,0x15
    80002a12:	b5672703          	lw	a4,-1194(a4) # 80017564 <sb+0xc>
    80002a16:	4785                	li	a5,1
    80002a18:	04e7fa63          	bgeu	a5,a4,80002a6c <ialloc+0x74>
    80002a1c:	8aaa                	mv	s5,a0
    80002a1e:	8bae                	mv	s7,a1
    80002a20:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a22:	00015a17          	auipc	s4,0x15
    80002a26:	b36a0a13          	addi	s4,s4,-1226 # 80017558 <sb>
    80002a2a:	00048b1b          	sext.w	s6,s1
    80002a2e:	0044d593          	srli	a1,s1,0x4
    80002a32:	018a2783          	lw	a5,24(s4)
    80002a36:	9dbd                	addw	a1,a1,a5
    80002a38:	8556                	mv	a0,s5
    80002a3a:	00000097          	auipc	ra,0x0
    80002a3e:	956080e7          	jalr	-1706(ra) # 80002390 <bread>
    80002a42:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a44:	05850993          	addi	s3,a0,88
    80002a48:	00f4f793          	andi	a5,s1,15
    80002a4c:	079a                	slli	a5,a5,0x6
    80002a4e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a50:	00099783          	lh	a5,0(s3)
    80002a54:	c785                	beqz	a5,80002a7c <ialloc+0x84>
    brelse(bp);
    80002a56:	00000097          	auipc	ra,0x0
    80002a5a:	a6a080e7          	jalr	-1430(ra) # 800024c0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a5e:	0485                	addi	s1,s1,1
    80002a60:	00ca2703          	lw	a4,12(s4)
    80002a64:	0004879b          	sext.w	a5,s1
    80002a68:	fce7e1e3          	bltu	a5,a4,80002a2a <ialloc+0x32>
  panic("ialloc: no inodes");
    80002a6c:	00006517          	auipc	a0,0x6
    80002a70:	c4c50513          	addi	a0,a0,-948 # 800086b8 <syscall_names+0x170>
    80002a74:	00003097          	auipc	ra,0x3
    80002a78:	18c080e7          	jalr	396(ra) # 80005c00 <panic>
      memset(dip, 0, sizeof(*dip));
    80002a7c:	04000613          	li	a2,64
    80002a80:	4581                	li	a1,0
    80002a82:	854e                	mv	a0,s3
    80002a84:	ffffd097          	auipc	ra,0xffffd
    80002a88:	71a080e7          	jalr	1818(ra) # 8000019e <memset>
      dip->type = type;
    80002a8c:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a90:	854a                	mv	a0,s2
    80002a92:	00001097          	auipc	ra,0x1
    80002a96:	cb2080e7          	jalr	-846(ra) # 80003744 <log_write>
      brelse(bp);
    80002a9a:	854a                	mv	a0,s2
    80002a9c:	00000097          	auipc	ra,0x0
    80002aa0:	a24080e7          	jalr	-1500(ra) # 800024c0 <brelse>
      return iget(dev, inum);
    80002aa4:	85da                	mv	a1,s6
    80002aa6:	8556                	mv	a0,s5
    80002aa8:	00000097          	auipc	ra,0x0
    80002aac:	db4080e7          	jalr	-588(ra) # 8000285c <iget>
}
    80002ab0:	60a6                	ld	ra,72(sp)
    80002ab2:	6406                	ld	s0,64(sp)
    80002ab4:	74e2                	ld	s1,56(sp)
    80002ab6:	7942                	ld	s2,48(sp)
    80002ab8:	79a2                	ld	s3,40(sp)
    80002aba:	7a02                	ld	s4,32(sp)
    80002abc:	6ae2                	ld	s5,24(sp)
    80002abe:	6b42                	ld	s6,16(sp)
    80002ac0:	6ba2                	ld	s7,8(sp)
    80002ac2:	6161                	addi	sp,sp,80
    80002ac4:	8082                	ret

0000000080002ac6 <iupdate>:
{
    80002ac6:	1101                	addi	sp,sp,-32
    80002ac8:	ec06                	sd	ra,24(sp)
    80002aca:	e822                	sd	s0,16(sp)
    80002acc:	e426                	sd	s1,8(sp)
    80002ace:	e04a                	sd	s2,0(sp)
    80002ad0:	1000                	addi	s0,sp,32
    80002ad2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ad4:	415c                	lw	a5,4(a0)
    80002ad6:	0047d79b          	srliw	a5,a5,0x4
    80002ada:	00015597          	auipc	a1,0x15
    80002ade:	a965a583          	lw	a1,-1386(a1) # 80017570 <sb+0x18>
    80002ae2:	9dbd                	addw	a1,a1,a5
    80002ae4:	4108                	lw	a0,0(a0)
    80002ae6:	00000097          	auipc	ra,0x0
    80002aea:	8aa080e7          	jalr	-1878(ra) # 80002390 <bread>
    80002aee:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002af0:	05850793          	addi	a5,a0,88
    80002af4:	40d8                	lw	a4,4(s1)
    80002af6:	8b3d                	andi	a4,a4,15
    80002af8:	071a                	slli	a4,a4,0x6
    80002afa:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002afc:	04449703          	lh	a4,68(s1)
    80002b00:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b04:	04649703          	lh	a4,70(s1)
    80002b08:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b0c:	04849703          	lh	a4,72(s1)
    80002b10:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b14:	04a49703          	lh	a4,74(s1)
    80002b18:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b1c:	44f8                	lw	a4,76(s1)
    80002b1e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b20:	03400613          	li	a2,52
    80002b24:	05048593          	addi	a1,s1,80
    80002b28:	00c78513          	addi	a0,a5,12
    80002b2c:	ffffd097          	auipc	ra,0xffffd
    80002b30:	6ce080e7          	jalr	1742(ra) # 800001fa <memmove>
  log_write(bp);
    80002b34:	854a                	mv	a0,s2
    80002b36:	00001097          	auipc	ra,0x1
    80002b3a:	c0e080e7          	jalr	-1010(ra) # 80003744 <log_write>
  brelse(bp);
    80002b3e:	854a                	mv	a0,s2
    80002b40:	00000097          	auipc	ra,0x0
    80002b44:	980080e7          	jalr	-1664(ra) # 800024c0 <brelse>
}
    80002b48:	60e2                	ld	ra,24(sp)
    80002b4a:	6442                	ld	s0,16(sp)
    80002b4c:	64a2                	ld	s1,8(sp)
    80002b4e:	6902                	ld	s2,0(sp)
    80002b50:	6105                	addi	sp,sp,32
    80002b52:	8082                	ret

0000000080002b54 <idup>:
{
    80002b54:	1101                	addi	sp,sp,-32
    80002b56:	ec06                	sd	ra,24(sp)
    80002b58:	e822                	sd	s0,16(sp)
    80002b5a:	e426                	sd	s1,8(sp)
    80002b5c:	1000                	addi	s0,sp,32
    80002b5e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b60:	00015517          	auipc	a0,0x15
    80002b64:	a1850513          	addi	a0,a0,-1512 # 80017578 <itable>
    80002b68:	00003097          	auipc	ra,0x3
    80002b6c:	5d0080e7          	jalr	1488(ra) # 80006138 <acquire>
  ip->ref++;
    80002b70:	449c                	lw	a5,8(s1)
    80002b72:	2785                	addiw	a5,a5,1
    80002b74:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b76:	00015517          	auipc	a0,0x15
    80002b7a:	a0250513          	addi	a0,a0,-1534 # 80017578 <itable>
    80002b7e:	00003097          	auipc	ra,0x3
    80002b82:	66e080e7          	jalr	1646(ra) # 800061ec <release>
}
    80002b86:	8526                	mv	a0,s1
    80002b88:	60e2                	ld	ra,24(sp)
    80002b8a:	6442                	ld	s0,16(sp)
    80002b8c:	64a2                	ld	s1,8(sp)
    80002b8e:	6105                	addi	sp,sp,32
    80002b90:	8082                	ret

0000000080002b92 <ilock>:
{
    80002b92:	1101                	addi	sp,sp,-32
    80002b94:	ec06                	sd	ra,24(sp)
    80002b96:	e822                	sd	s0,16(sp)
    80002b98:	e426                	sd	s1,8(sp)
    80002b9a:	e04a                	sd	s2,0(sp)
    80002b9c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b9e:	c115                	beqz	a0,80002bc2 <ilock+0x30>
    80002ba0:	84aa                	mv	s1,a0
    80002ba2:	451c                	lw	a5,8(a0)
    80002ba4:	00f05f63          	blez	a5,80002bc2 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002ba8:	0541                	addi	a0,a0,16
    80002baa:	00001097          	auipc	ra,0x1
    80002bae:	cb8080e7          	jalr	-840(ra) # 80003862 <acquiresleep>
  if(ip->valid == 0){
    80002bb2:	40bc                	lw	a5,64(s1)
    80002bb4:	cf99                	beqz	a5,80002bd2 <ilock+0x40>
}
    80002bb6:	60e2                	ld	ra,24(sp)
    80002bb8:	6442                	ld	s0,16(sp)
    80002bba:	64a2                	ld	s1,8(sp)
    80002bbc:	6902                	ld	s2,0(sp)
    80002bbe:	6105                	addi	sp,sp,32
    80002bc0:	8082                	ret
    panic("ilock");
    80002bc2:	00006517          	auipc	a0,0x6
    80002bc6:	b0e50513          	addi	a0,a0,-1266 # 800086d0 <syscall_names+0x188>
    80002bca:	00003097          	auipc	ra,0x3
    80002bce:	036080e7          	jalr	54(ra) # 80005c00 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bd2:	40dc                	lw	a5,4(s1)
    80002bd4:	0047d79b          	srliw	a5,a5,0x4
    80002bd8:	00015597          	auipc	a1,0x15
    80002bdc:	9985a583          	lw	a1,-1640(a1) # 80017570 <sb+0x18>
    80002be0:	9dbd                	addw	a1,a1,a5
    80002be2:	4088                	lw	a0,0(s1)
    80002be4:	fffff097          	auipc	ra,0xfffff
    80002be8:	7ac080e7          	jalr	1964(ra) # 80002390 <bread>
    80002bec:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bee:	05850593          	addi	a1,a0,88
    80002bf2:	40dc                	lw	a5,4(s1)
    80002bf4:	8bbd                	andi	a5,a5,15
    80002bf6:	079a                	slli	a5,a5,0x6
    80002bf8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002bfa:	00059783          	lh	a5,0(a1)
    80002bfe:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c02:	00259783          	lh	a5,2(a1)
    80002c06:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c0a:	00459783          	lh	a5,4(a1)
    80002c0e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c12:	00659783          	lh	a5,6(a1)
    80002c16:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c1a:	459c                	lw	a5,8(a1)
    80002c1c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c1e:	03400613          	li	a2,52
    80002c22:	05b1                	addi	a1,a1,12
    80002c24:	05048513          	addi	a0,s1,80
    80002c28:	ffffd097          	auipc	ra,0xffffd
    80002c2c:	5d2080e7          	jalr	1490(ra) # 800001fa <memmove>
    brelse(bp);
    80002c30:	854a                	mv	a0,s2
    80002c32:	00000097          	auipc	ra,0x0
    80002c36:	88e080e7          	jalr	-1906(ra) # 800024c0 <brelse>
    ip->valid = 1;
    80002c3a:	4785                	li	a5,1
    80002c3c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c3e:	04449783          	lh	a5,68(s1)
    80002c42:	fbb5                	bnez	a5,80002bb6 <ilock+0x24>
      panic("ilock: no type");
    80002c44:	00006517          	auipc	a0,0x6
    80002c48:	a9450513          	addi	a0,a0,-1388 # 800086d8 <syscall_names+0x190>
    80002c4c:	00003097          	auipc	ra,0x3
    80002c50:	fb4080e7          	jalr	-76(ra) # 80005c00 <panic>

0000000080002c54 <iunlock>:
{
    80002c54:	1101                	addi	sp,sp,-32
    80002c56:	ec06                	sd	ra,24(sp)
    80002c58:	e822                	sd	s0,16(sp)
    80002c5a:	e426                	sd	s1,8(sp)
    80002c5c:	e04a                	sd	s2,0(sp)
    80002c5e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c60:	c905                	beqz	a0,80002c90 <iunlock+0x3c>
    80002c62:	84aa                	mv	s1,a0
    80002c64:	01050913          	addi	s2,a0,16
    80002c68:	854a                	mv	a0,s2
    80002c6a:	00001097          	auipc	ra,0x1
    80002c6e:	c92080e7          	jalr	-878(ra) # 800038fc <holdingsleep>
    80002c72:	cd19                	beqz	a0,80002c90 <iunlock+0x3c>
    80002c74:	449c                	lw	a5,8(s1)
    80002c76:	00f05d63          	blez	a5,80002c90 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c7a:	854a                	mv	a0,s2
    80002c7c:	00001097          	auipc	ra,0x1
    80002c80:	c3c080e7          	jalr	-964(ra) # 800038b8 <releasesleep>
}
    80002c84:	60e2                	ld	ra,24(sp)
    80002c86:	6442                	ld	s0,16(sp)
    80002c88:	64a2                	ld	s1,8(sp)
    80002c8a:	6902                	ld	s2,0(sp)
    80002c8c:	6105                	addi	sp,sp,32
    80002c8e:	8082                	ret
    panic("iunlock");
    80002c90:	00006517          	auipc	a0,0x6
    80002c94:	a5850513          	addi	a0,a0,-1448 # 800086e8 <syscall_names+0x1a0>
    80002c98:	00003097          	auipc	ra,0x3
    80002c9c:	f68080e7          	jalr	-152(ra) # 80005c00 <panic>

0000000080002ca0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002ca0:	7179                	addi	sp,sp,-48
    80002ca2:	f406                	sd	ra,40(sp)
    80002ca4:	f022                	sd	s0,32(sp)
    80002ca6:	ec26                	sd	s1,24(sp)
    80002ca8:	e84a                	sd	s2,16(sp)
    80002caa:	e44e                	sd	s3,8(sp)
    80002cac:	e052                	sd	s4,0(sp)
    80002cae:	1800                	addi	s0,sp,48
    80002cb0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002cb2:	05050493          	addi	s1,a0,80
    80002cb6:	08050913          	addi	s2,a0,128
    80002cba:	a021                	j	80002cc2 <itrunc+0x22>
    80002cbc:	0491                	addi	s1,s1,4
    80002cbe:	01248d63          	beq	s1,s2,80002cd8 <itrunc+0x38>
    if(ip->addrs[i]){
    80002cc2:	408c                	lw	a1,0(s1)
    80002cc4:	dde5                	beqz	a1,80002cbc <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002cc6:	0009a503          	lw	a0,0(s3)
    80002cca:	00000097          	auipc	ra,0x0
    80002cce:	90c080e7          	jalr	-1780(ra) # 800025d6 <bfree>
      ip->addrs[i] = 0;
    80002cd2:	0004a023          	sw	zero,0(s1)
    80002cd6:	b7dd                	j	80002cbc <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002cd8:	0809a583          	lw	a1,128(s3)
    80002cdc:	e185                	bnez	a1,80002cfc <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002cde:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002ce2:	854e                	mv	a0,s3
    80002ce4:	00000097          	auipc	ra,0x0
    80002ce8:	de2080e7          	jalr	-542(ra) # 80002ac6 <iupdate>
}
    80002cec:	70a2                	ld	ra,40(sp)
    80002cee:	7402                	ld	s0,32(sp)
    80002cf0:	64e2                	ld	s1,24(sp)
    80002cf2:	6942                	ld	s2,16(sp)
    80002cf4:	69a2                	ld	s3,8(sp)
    80002cf6:	6a02                	ld	s4,0(sp)
    80002cf8:	6145                	addi	sp,sp,48
    80002cfa:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002cfc:	0009a503          	lw	a0,0(s3)
    80002d00:	fffff097          	auipc	ra,0xfffff
    80002d04:	690080e7          	jalr	1680(ra) # 80002390 <bread>
    80002d08:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d0a:	05850493          	addi	s1,a0,88
    80002d0e:	45850913          	addi	s2,a0,1112
    80002d12:	a021                	j	80002d1a <itrunc+0x7a>
    80002d14:	0491                	addi	s1,s1,4
    80002d16:	01248b63          	beq	s1,s2,80002d2c <itrunc+0x8c>
      if(a[j])
    80002d1a:	408c                	lw	a1,0(s1)
    80002d1c:	dde5                	beqz	a1,80002d14 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002d1e:	0009a503          	lw	a0,0(s3)
    80002d22:	00000097          	auipc	ra,0x0
    80002d26:	8b4080e7          	jalr	-1868(ra) # 800025d6 <bfree>
    80002d2a:	b7ed                	j	80002d14 <itrunc+0x74>
    brelse(bp);
    80002d2c:	8552                	mv	a0,s4
    80002d2e:	fffff097          	auipc	ra,0xfffff
    80002d32:	792080e7          	jalr	1938(ra) # 800024c0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d36:	0809a583          	lw	a1,128(s3)
    80002d3a:	0009a503          	lw	a0,0(s3)
    80002d3e:	00000097          	auipc	ra,0x0
    80002d42:	898080e7          	jalr	-1896(ra) # 800025d6 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d46:	0809a023          	sw	zero,128(s3)
    80002d4a:	bf51                	j	80002cde <itrunc+0x3e>

0000000080002d4c <iput>:
{
    80002d4c:	1101                	addi	sp,sp,-32
    80002d4e:	ec06                	sd	ra,24(sp)
    80002d50:	e822                	sd	s0,16(sp)
    80002d52:	e426                	sd	s1,8(sp)
    80002d54:	e04a                	sd	s2,0(sp)
    80002d56:	1000                	addi	s0,sp,32
    80002d58:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d5a:	00015517          	auipc	a0,0x15
    80002d5e:	81e50513          	addi	a0,a0,-2018 # 80017578 <itable>
    80002d62:	00003097          	auipc	ra,0x3
    80002d66:	3d6080e7          	jalr	982(ra) # 80006138 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d6a:	4498                	lw	a4,8(s1)
    80002d6c:	4785                	li	a5,1
    80002d6e:	02f70363          	beq	a4,a5,80002d94 <iput+0x48>
  ip->ref--;
    80002d72:	449c                	lw	a5,8(s1)
    80002d74:	37fd                	addiw	a5,a5,-1
    80002d76:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d78:	00015517          	auipc	a0,0x15
    80002d7c:	80050513          	addi	a0,a0,-2048 # 80017578 <itable>
    80002d80:	00003097          	auipc	ra,0x3
    80002d84:	46c080e7          	jalr	1132(ra) # 800061ec <release>
}
    80002d88:	60e2                	ld	ra,24(sp)
    80002d8a:	6442                	ld	s0,16(sp)
    80002d8c:	64a2                	ld	s1,8(sp)
    80002d8e:	6902                	ld	s2,0(sp)
    80002d90:	6105                	addi	sp,sp,32
    80002d92:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d94:	40bc                	lw	a5,64(s1)
    80002d96:	dff1                	beqz	a5,80002d72 <iput+0x26>
    80002d98:	04a49783          	lh	a5,74(s1)
    80002d9c:	fbf9                	bnez	a5,80002d72 <iput+0x26>
    acquiresleep(&ip->lock);
    80002d9e:	01048913          	addi	s2,s1,16
    80002da2:	854a                	mv	a0,s2
    80002da4:	00001097          	auipc	ra,0x1
    80002da8:	abe080e7          	jalr	-1346(ra) # 80003862 <acquiresleep>
    release(&itable.lock);
    80002dac:	00014517          	auipc	a0,0x14
    80002db0:	7cc50513          	addi	a0,a0,1996 # 80017578 <itable>
    80002db4:	00003097          	auipc	ra,0x3
    80002db8:	438080e7          	jalr	1080(ra) # 800061ec <release>
    itrunc(ip);
    80002dbc:	8526                	mv	a0,s1
    80002dbe:	00000097          	auipc	ra,0x0
    80002dc2:	ee2080e7          	jalr	-286(ra) # 80002ca0 <itrunc>
    ip->type = 0;
    80002dc6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002dca:	8526                	mv	a0,s1
    80002dcc:	00000097          	auipc	ra,0x0
    80002dd0:	cfa080e7          	jalr	-774(ra) # 80002ac6 <iupdate>
    ip->valid = 0;
    80002dd4:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002dd8:	854a                	mv	a0,s2
    80002dda:	00001097          	auipc	ra,0x1
    80002dde:	ade080e7          	jalr	-1314(ra) # 800038b8 <releasesleep>
    acquire(&itable.lock);
    80002de2:	00014517          	auipc	a0,0x14
    80002de6:	79650513          	addi	a0,a0,1942 # 80017578 <itable>
    80002dea:	00003097          	auipc	ra,0x3
    80002dee:	34e080e7          	jalr	846(ra) # 80006138 <acquire>
    80002df2:	b741                	j	80002d72 <iput+0x26>

0000000080002df4 <iunlockput>:
{
    80002df4:	1101                	addi	sp,sp,-32
    80002df6:	ec06                	sd	ra,24(sp)
    80002df8:	e822                	sd	s0,16(sp)
    80002dfa:	e426                	sd	s1,8(sp)
    80002dfc:	1000                	addi	s0,sp,32
    80002dfe:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e00:	00000097          	auipc	ra,0x0
    80002e04:	e54080e7          	jalr	-428(ra) # 80002c54 <iunlock>
  iput(ip);
    80002e08:	8526                	mv	a0,s1
    80002e0a:	00000097          	auipc	ra,0x0
    80002e0e:	f42080e7          	jalr	-190(ra) # 80002d4c <iput>
}
    80002e12:	60e2                	ld	ra,24(sp)
    80002e14:	6442                	ld	s0,16(sp)
    80002e16:	64a2                	ld	s1,8(sp)
    80002e18:	6105                	addi	sp,sp,32
    80002e1a:	8082                	ret

0000000080002e1c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e1c:	1141                	addi	sp,sp,-16
    80002e1e:	e422                	sd	s0,8(sp)
    80002e20:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e22:	411c                	lw	a5,0(a0)
    80002e24:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e26:	415c                	lw	a5,4(a0)
    80002e28:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e2a:	04451783          	lh	a5,68(a0)
    80002e2e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e32:	04a51783          	lh	a5,74(a0)
    80002e36:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e3a:	04c56783          	lwu	a5,76(a0)
    80002e3e:	e99c                	sd	a5,16(a1)
}
    80002e40:	6422                	ld	s0,8(sp)
    80002e42:	0141                	addi	sp,sp,16
    80002e44:	8082                	ret

0000000080002e46 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e46:	457c                	lw	a5,76(a0)
    80002e48:	0ed7e963          	bltu	a5,a3,80002f3a <readi+0xf4>
{
    80002e4c:	7159                	addi	sp,sp,-112
    80002e4e:	f486                	sd	ra,104(sp)
    80002e50:	f0a2                	sd	s0,96(sp)
    80002e52:	eca6                	sd	s1,88(sp)
    80002e54:	e8ca                	sd	s2,80(sp)
    80002e56:	e4ce                	sd	s3,72(sp)
    80002e58:	e0d2                	sd	s4,64(sp)
    80002e5a:	fc56                	sd	s5,56(sp)
    80002e5c:	f85a                	sd	s6,48(sp)
    80002e5e:	f45e                	sd	s7,40(sp)
    80002e60:	f062                	sd	s8,32(sp)
    80002e62:	ec66                	sd	s9,24(sp)
    80002e64:	e86a                	sd	s10,16(sp)
    80002e66:	e46e                	sd	s11,8(sp)
    80002e68:	1880                	addi	s0,sp,112
    80002e6a:	8baa                	mv	s7,a0
    80002e6c:	8c2e                	mv	s8,a1
    80002e6e:	8ab2                	mv	s5,a2
    80002e70:	84b6                	mv	s1,a3
    80002e72:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002e74:	9f35                	addw	a4,a4,a3
    return 0;
    80002e76:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e78:	0ad76063          	bltu	a4,a3,80002f18 <readi+0xd2>
  if(off + n > ip->size)
    80002e7c:	00e7f463          	bgeu	a5,a4,80002e84 <readi+0x3e>
    n = ip->size - off;
    80002e80:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e84:	0a0b0963          	beqz	s6,80002f36 <readi+0xf0>
    80002e88:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e8a:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e8e:	5cfd                	li	s9,-1
    80002e90:	a82d                	j	80002eca <readi+0x84>
    80002e92:	020a1d93          	slli	s11,s4,0x20
    80002e96:	020ddd93          	srli	s11,s11,0x20
    80002e9a:	05890613          	addi	a2,s2,88
    80002e9e:	86ee                	mv	a3,s11
    80002ea0:	963a                	add	a2,a2,a4
    80002ea2:	85d6                	mv	a1,s5
    80002ea4:	8562                	mv	a0,s8
    80002ea6:	fffff097          	auipc	ra,0xfffff
    80002eaa:	a30080e7          	jalr	-1488(ra) # 800018d6 <either_copyout>
    80002eae:	05950d63          	beq	a0,s9,80002f08 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002eb2:	854a                	mv	a0,s2
    80002eb4:	fffff097          	auipc	ra,0xfffff
    80002eb8:	60c080e7          	jalr	1548(ra) # 800024c0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ebc:	013a09bb          	addw	s3,s4,s3
    80002ec0:	009a04bb          	addw	s1,s4,s1
    80002ec4:	9aee                	add	s5,s5,s11
    80002ec6:	0569f763          	bgeu	s3,s6,80002f14 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002eca:	000ba903          	lw	s2,0(s7)
    80002ece:	00a4d59b          	srliw	a1,s1,0xa
    80002ed2:	855e                	mv	a0,s7
    80002ed4:	00000097          	auipc	ra,0x0
    80002ed8:	8ac080e7          	jalr	-1876(ra) # 80002780 <bmap>
    80002edc:	0005059b          	sext.w	a1,a0
    80002ee0:	854a                	mv	a0,s2
    80002ee2:	fffff097          	auipc	ra,0xfffff
    80002ee6:	4ae080e7          	jalr	1198(ra) # 80002390 <bread>
    80002eea:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002eec:	3ff4f713          	andi	a4,s1,1023
    80002ef0:	40ed07bb          	subw	a5,s10,a4
    80002ef4:	413b06bb          	subw	a3,s6,s3
    80002ef8:	8a3e                	mv	s4,a5
    80002efa:	2781                	sext.w	a5,a5
    80002efc:	0006861b          	sext.w	a2,a3
    80002f00:	f8f679e3          	bgeu	a2,a5,80002e92 <readi+0x4c>
    80002f04:	8a36                	mv	s4,a3
    80002f06:	b771                	j	80002e92 <readi+0x4c>
      brelse(bp);
    80002f08:	854a                	mv	a0,s2
    80002f0a:	fffff097          	auipc	ra,0xfffff
    80002f0e:	5b6080e7          	jalr	1462(ra) # 800024c0 <brelse>
      tot = -1;
    80002f12:	59fd                	li	s3,-1
  }
  return tot;
    80002f14:	0009851b          	sext.w	a0,s3
}
    80002f18:	70a6                	ld	ra,104(sp)
    80002f1a:	7406                	ld	s0,96(sp)
    80002f1c:	64e6                	ld	s1,88(sp)
    80002f1e:	6946                	ld	s2,80(sp)
    80002f20:	69a6                	ld	s3,72(sp)
    80002f22:	6a06                	ld	s4,64(sp)
    80002f24:	7ae2                	ld	s5,56(sp)
    80002f26:	7b42                	ld	s6,48(sp)
    80002f28:	7ba2                	ld	s7,40(sp)
    80002f2a:	7c02                	ld	s8,32(sp)
    80002f2c:	6ce2                	ld	s9,24(sp)
    80002f2e:	6d42                	ld	s10,16(sp)
    80002f30:	6da2                	ld	s11,8(sp)
    80002f32:	6165                	addi	sp,sp,112
    80002f34:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f36:	89da                	mv	s3,s6
    80002f38:	bff1                	j	80002f14 <readi+0xce>
    return 0;
    80002f3a:	4501                	li	a0,0
}
    80002f3c:	8082                	ret

0000000080002f3e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f3e:	457c                	lw	a5,76(a0)
    80002f40:	10d7e863          	bltu	a5,a3,80003050 <writei+0x112>
{
    80002f44:	7159                	addi	sp,sp,-112
    80002f46:	f486                	sd	ra,104(sp)
    80002f48:	f0a2                	sd	s0,96(sp)
    80002f4a:	eca6                	sd	s1,88(sp)
    80002f4c:	e8ca                	sd	s2,80(sp)
    80002f4e:	e4ce                	sd	s3,72(sp)
    80002f50:	e0d2                	sd	s4,64(sp)
    80002f52:	fc56                	sd	s5,56(sp)
    80002f54:	f85a                	sd	s6,48(sp)
    80002f56:	f45e                	sd	s7,40(sp)
    80002f58:	f062                	sd	s8,32(sp)
    80002f5a:	ec66                	sd	s9,24(sp)
    80002f5c:	e86a                	sd	s10,16(sp)
    80002f5e:	e46e                	sd	s11,8(sp)
    80002f60:	1880                	addi	s0,sp,112
    80002f62:	8b2a                	mv	s6,a0
    80002f64:	8c2e                	mv	s8,a1
    80002f66:	8ab2                	mv	s5,a2
    80002f68:	8936                	mv	s2,a3
    80002f6a:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002f6c:	00e687bb          	addw	a5,a3,a4
    80002f70:	0ed7e263          	bltu	a5,a3,80003054 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f74:	00043737          	lui	a4,0x43
    80002f78:	0ef76063          	bltu	a4,a5,80003058 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f7c:	0c0b8863          	beqz	s7,8000304c <writei+0x10e>
    80002f80:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f82:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f86:	5cfd                	li	s9,-1
    80002f88:	a091                	j	80002fcc <writei+0x8e>
    80002f8a:	02099d93          	slli	s11,s3,0x20
    80002f8e:	020ddd93          	srli	s11,s11,0x20
    80002f92:	05848513          	addi	a0,s1,88
    80002f96:	86ee                	mv	a3,s11
    80002f98:	8656                	mv	a2,s5
    80002f9a:	85e2                	mv	a1,s8
    80002f9c:	953a                	add	a0,a0,a4
    80002f9e:	fffff097          	auipc	ra,0xfffff
    80002fa2:	98e080e7          	jalr	-1650(ra) # 8000192c <either_copyin>
    80002fa6:	07950263          	beq	a0,s9,8000300a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002faa:	8526                	mv	a0,s1
    80002fac:	00000097          	auipc	ra,0x0
    80002fb0:	798080e7          	jalr	1944(ra) # 80003744 <log_write>
    brelse(bp);
    80002fb4:	8526                	mv	a0,s1
    80002fb6:	fffff097          	auipc	ra,0xfffff
    80002fba:	50a080e7          	jalr	1290(ra) # 800024c0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fbe:	01498a3b          	addw	s4,s3,s4
    80002fc2:	0129893b          	addw	s2,s3,s2
    80002fc6:	9aee                	add	s5,s5,s11
    80002fc8:	057a7663          	bgeu	s4,s7,80003014 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002fcc:	000b2483          	lw	s1,0(s6)
    80002fd0:	00a9559b          	srliw	a1,s2,0xa
    80002fd4:	855a                	mv	a0,s6
    80002fd6:	fffff097          	auipc	ra,0xfffff
    80002fda:	7aa080e7          	jalr	1962(ra) # 80002780 <bmap>
    80002fde:	0005059b          	sext.w	a1,a0
    80002fe2:	8526                	mv	a0,s1
    80002fe4:	fffff097          	auipc	ra,0xfffff
    80002fe8:	3ac080e7          	jalr	940(ra) # 80002390 <bread>
    80002fec:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fee:	3ff97713          	andi	a4,s2,1023
    80002ff2:	40ed07bb          	subw	a5,s10,a4
    80002ff6:	414b86bb          	subw	a3,s7,s4
    80002ffa:	89be                	mv	s3,a5
    80002ffc:	2781                	sext.w	a5,a5
    80002ffe:	0006861b          	sext.w	a2,a3
    80003002:	f8f674e3          	bgeu	a2,a5,80002f8a <writei+0x4c>
    80003006:	89b6                	mv	s3,a3
    80003008:	b749                	j	80002f8a <writei+0x4c>
      brelse(bp);
    8000300a:	8526                	mv	a0,s1
    8000300c:	fffff097          	auipc	ra,0xfffff
    80003010:	4b4080e7          	jalr	1204(ra) # 800024c0 <brelse>
  }

  if(off > ip->size)
    80003014:	04cb2783          	lw	a5,76(s6)
    80003018:	0127f463          	bgeu	a5,s2,80003020 <writei+0xe2>
    ip->size = off;
    8000301c:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003020:	855a                	mv	a0,s6
    80003022:	00000097          	auipc	ra,0x0
    80003026:	aa4080e7          	jalr	-1372(ra) # 80002ac6 <iupdate>

  return tot;
    8000302a:	000a051b          	sext.w	a0,s4
}
    8000302e:	70a6                	ld	ra,104(sp)
    80003030:	7406                	ld	s0,96(sp)
    80003032:	64e6                	ld	s1,88(sp)
    80003034:	6946                	ld	s2,80(sp)
    80003036:	69a6                	ld	s3,72(sp)
    80003038:	6a06                	ld	s4,64(sp)
    8000303a:	7ae2                	ld	s5,56(sp)
    8000303c:	7b42                	ld	s6,48(sp)
    8000303e:	7ba2                	ld	s7,40(sp)
    80003040:	7c02                	ld	s8,32(sp)
    80003042:	6ce2                	ld	s9,24(sp)
    80003044:	6d42                	ld	s10,16(sp)
    80003046:	6da2                	ld	s11,8(sp)
    80003048:	6165                	addi	sp,sp,112
    8000304a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000304c:	8a5e                	mv	s4,s7
    8000304e:	bfc9                	j	80003020 <writei+0xe2>
    return -1;
    80003050:	557d                	li	a0,-1
}
    80003052:	8082                	ret
    return -1;
    80003054:	557d                	li	a0,-1
    80003056:	bfe1                	j	8000302e <writei+0xf0>
    return -1;
    80003058:	557d                	li	a0,-1
    8000305a:	bfd1                	j	8000302e <writei+0xf0>

000000008000305c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000305c:	1141                	addi	sp,sp,-16
    8000305e:	e406                	sd	ra,8(sp)
    80003060:	e022                	sd	s0,0(sp)
    80003062:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003064:	4639                	li	a2,14
    80003066:	ffffd097          	auipc	ra,0xffffd
    8000306a:	208080e7          	jalr	520(ra) # 8000026e <strncmp>
}
    8000306e:	60a2                	ld	ra,8(sp)
    80003070:	6402                	ld	s0,0(sp)
    80003072:	0141                	addi	sp,sp,16
    80003074:	8082                	ret

0000000080003076 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003076:	7139                	addi	sp,sp,-64
    80003078:	fc06                	sd	ra,56(sp)
    8000307a:	f822                	sd	s0,48(sp)
    8000307c:	f426                	sd	s1,40(sp)
    8000307e:	f04a                	sd	s2,32(sp)
    80003080:	ec4e                	sd	s3,24(sp)
    80003082:	e852                	sd	s4,16(sp)
    80003084:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003086:	04451703          	lh	a4,68(a0)
    8000308a:	4785                	li	a5,1
    8000308c:	00f71a63          	bne	a4,a5,800030a0 <dirlookup+0x2a>
    80003090:	892a                	mv	s2,a0
    80003092:	89ae                	mv	s3,a1
    80003094:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003096:	457c                	lw	a5,76(a0)
    80003098:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000309a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000309c:	e79d                	bnez	a5,800030ca <dirlookup+0x54>
    8000309e:	a8a5                	j	80003116 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030a0:	00005517          	auipc	a0,0x5
    800030a4:	65050513          	addi	a0,a0,1616 # 800086f0 <syscall_names+0x1a8>
    800030a8:	00003097          	auipc	ra,0x3
    800030ac:	b58080e7          	jalr	-1192(ra) # 80005c00 <panic>
      panic("dirlookup read");
    800030b0:	00005517          	auipc	a0,0x5
    800030b4:	65850513          	addi	a0,a0,1624 # 80008708 <syscall_names+0x1c0>
    800030b8:	00003097          	auipc	ra,0x3
    800030bc:	b48080e7          	jalr	-1208(ra) # 80005c00 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030c0:	24c1                	addiw	s1,s1,16
    800030c2:	04c92783          	lw	a5,76(s2)
    800030c6:	04f4f763          	bgeu	s1,a5,80003114 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030ca:	4741                	li	a4,16
    800030cc:	86a6                	mv	a3,s1
    800030ce:	fc040613          	addi	a2,s0,-64
    800030d2:	4581                	li	a1,0
    800030d4:	854a                	mv	a0,s2
    800030d6:	00000097          	auipc	ra,0x0
    800030da:	d70080e7          	jalr	-656(ra) # 80002e46 <readi>
    800030de:	47c1                	li	a5,16
    800030e0:	fcf518e3          	bne	a0,a5,800030b0 <dirlookup+0x3a>
    if(de.inum == 0)
    800030e4:	fc045783          	lhu	a5,-64(s0)
    800030e8:	dfe1                	beqz	a5,800030c0 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800030ea:	fc240593          	addi	a1,s0,-62
    800030ee:	854e                	mv	a0,s3
    800030f0:	00000097          	auipc	ra,0x0
    800030f4:	f6c080e7          	jalr	-148(ra) # 8000305c <namecmp>
    800030f8:	f561                	bnez	a0,800030c0 <dirlookup+0x4a>
      if(poff)
    800030fa:	000a0463          	beqz	s4,80003102 <dirlookup+0x8c>
        *poff = off;
    800030fe:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003102:	fc045583          	lhu	a1,-64(s0)
    80003106:	00092503          	lw	a0,0(s2)
    8000310a:	fffff097          	auipc	ra,0xfffff
    8000310e:	752080e7          	jalr	1874(ra) # 8000285c <iget>
    80003112:	a011                	j	80003116 <dirlookup+0xa0>
  return 0;
    80003114:	4501                	li	a0,0
}
    80003116:	70e2                	ld	ra,56(sp)
    80003118:	7442                	ld	s0,48(sp)
    8000311a:	74a2                	ld	s1,40(sp)
    8000311c:	7902                	ld	s2,32(sp)
    8000311e:	69e2                	ld	s3,24(sp)
    80003120:	6a42                	ld	s4,16(sp)
    80003122:	6121                	addi	sp,sp,64
    80003124:	8082                	ret

0000000080003126 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003126:	711d                	addi	sp,sp,-96
    80003128:	ec86                	sd	ra,88(sp)
    8000312a:	e8a2                	sd	s0,80(sp)
    8000312c:	e4a6                	sd	s1,72(sp)
    8000312e:	e0ca                	sd	s2,64(sp)
    80003130:	fc4e                	sd	s3,56(sp)
    80003132:	f852                	sd	s4,48(sp)
    80003134:	f456                	sd	s5,40(sp)
    80003136:	f05a                	sd	s6,32(sp)
    80003138:	ec5e                	sd	s7,24(sp)
    8000313a:	e862                	sd	s8,16(sp)
    8000313c:	e466                	sd	s9,8(sp)
    8000313e:	e06a                	sd	s10,0(sp)
    80003140:	1080                	addi	s0,sp,96
    80003142:	84aa                	mv	s1,a0
    80003144:	8b2e                	mv	s6,a1
    80003146:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003148:	00054703          	lbu	a4,0(a0)
    8000314c:	02f00793          	li	a5,47
    80003150:	02f70363          	beq	a4,a5,80003176 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003154:	ffffe097          	auipc	ra,0xffffe
    80003158:	d14080e7          	jalr	-748(ra) # 80000e68 <myproc>
    8000315c:	15053503          	ld	a0,336(a0)
    80003160:	00000097          	auipc	ra,0x0
    80003164:	9f4080e7          	jalr	-1548(ra) # 80002b54 <idup>
    80003168:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000316a:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000316e:	4cb5                	li	s9,13
  len = path - s;
    80003170:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003172:	4c05                	li	s8,1
    80003174:	a87d                	j	80003232 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003176:	4585                	li	a1,1
    80003178:	4505                	li	a0,1
    8000317a:	fffff097          	auipc	ra,0xfffff
    8000317e:	6e2080e7          	jalr	1762(ra) # 8000285c <iget>
    80003182:	8a2a                	mv	s4,a0
    80003184:	b7dd                	j	8000316a <namex+0x44>
      iunlockput(ip);
    80003186:	8552                	mv	a0,s4
    80003188:	00000097          	auipc	ra,0x0
    8000318c:	c6c080e7          	jalr	-916(ra) # 80002df4 <iunlockput>
      return 0;
    80003190:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003192:	8552                	mv	a0,s4
    80003194:	60e6                	ld	ra,88(sp)
    80003196:	6446                	ld	s0,80(sp)
    80003198:	64a6                	ld	s1,72(sp)
    8000319a:	6906                	ld	s2,64(sp)
    8000319c:	79e2                	ld	s3,56(sp)
    8000319e:	7a42                	ld	s4,48(sp)
    800031a0:	7aa2                	ld	s5,40(sp)
    800031a2:	7b02                	ld	s6,32(sp)
    800031a4:	6be2                	ld	s7,24(sp)
    800031a6:	6c42                	ld	s8,16(sp)
    800031a8:	6ca2                	ld	s9,8(sp)
    800031aa:	6d02                	ld	s10,0(sp)
    800031ac:	6125                	addi	sp,sp,96
    800031ae:	8082                	ret
      iunlock(ip);
    800031b0:	8552                	mv	a0,s4
    800031b2:	00000097          	auipc	ra,0x0
    800031b6:	aa2080e7          	jalr	-1374(ra) # 80002c54 <iunlock>
      return ip;
    800031ba:	bfe1                	j	80003192 <namex+0x6c>
      iunlockput(ip);
    800031bc:	8552                	mv	a0,s4
    800031be:	00000097          	auipc	ra,0x0
    800031c2:	c36080e7          	jalr	-970(ra) # 80002df4 <iunlockput>
      return 0;
    800031c6:	8a4e                	mv	s4,s3
    800031c8:	b7e9                	j	80003192 <namex+0x6c>
  len = path - s;
    800031ca:	40998633          	sub	a2,s3,s1
    800031ce:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800031d2:	09acd863          	bge	s9,s10,80003262 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800031d6:	4639                	li	a2,14
    800031d8:	85a6                	mv	a1,s1
    800031da:	8556                	mv	a0,s5
    800031dc:	ffffd097          	auipc	ra,0xffffd
    800031e0:	01e080e7          	jalr	30(ra) # 800001fa <memmove>
    800031e4:	84ce                	mv	s1,s3
  while(*path == '/')
    800031e6:	0004c783          	lbu	a5,0(s1)
    800031ea:	01279763          	bne	a5,s2,800031f8 <namex+0xd2>
    path++;
    800031ee:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031f0:	0004c783          	lbu	a5,0(s1)
    800031f4:	ff278de3          	beq	a5,s2,800031ee <namex+0xc8>
    ilock(ip);
    800031f8:	8552                	mv	a0,s4
    800031fa:	00000097          	auipc	ra,0x0
    800031fe:	998080e7          	jalr	-1640(ra) # 80002b92 <ilock>
    if(ip->type != T_DIR){
    80003202:	044a1783          	lh	a5,68(s4)
    80003206:	f98790e3          	bne	a5,s8,80003186 <namex+0x60>
    if(nameiparent && *path == '\0'){
    8000320a:	000b0563          	beqz	s6,80003214 <namex+0xee>
    8000320e:	0004c783          	lbu	a5,0(s1)
    80003212:	dfd9                	beqz	a5,800031b0 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003214:	865e                	mv	a2,s7
    80003216:	85d6                	mv	a1,s5
    80003218:	8552                	mv	a0,s4
    8000321a:	00000097          	auipc	ra,0x0
    8000321e:	e5c080e7          	jalr	-420(ra) # 80003076 <dirlookup>
    80003222:	89aa                	mv	s3,a0
    80003224:	dd41                	beqz	a0,800031bc <namex+0x96>
    iunlockput(ip);
    80003226:	8552                	mv	a0,s4
    80003228:	00000097          	auipc	ra,0x0
    8000322c:	bcc080e7          	jalr	-1076(ra) # 80002df4 <iunlockput>
    ip = next;
    80003230:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003232:	0004c783          	lbu	a5,0(s1)
    80003236:	01279763          	bne	a5,s2,80003244 <namex+0x11e>
    path++;
    8000323a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000323c:	0004c783          	lbu	a5,0(s1)
    80003240:	ff278de3          	beq	a5,s2,8000323a <namex+0x114>
  if(*path == 0)
    80003244:	cb9d                	beqz	a5,8000327a <namex+0x154>
  while(*path != '/' && *path != 0)
    80003246:	0004c783          	lbu	a5,0(s1)
    8000324a:	89a6                	mv	s3,s1
  len = path - s;
    8000324c:	8d5e                	mv	s10,s7
    8000324e:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003250:	01278963          	beq	a5,s2,80003262 <namex+0x13c>
    80003254:	dbbd                	beqz	a5,800031ca <namex+0xa4>
    path++;
    80003256:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003258:	0009c783          	lbu	a5,0(s3)
    8000325c:	ff279ce3          	bne	a5,s2,80003254 <namex+0x12e>
    80003260:	b7ad                	j	800031ca <namex+0xa4>
    memmove(name, s, len);
    80003262:	2601                	sext.w	a2,a2
    80003264:	85a6                	mv	a1,s1
    80003266:	8556                	mv	a0,s5
    80003268:	ffffd097          	auipc	ra,0xffffd
    8000326c:	f92080e7          	jalr	-110(ra) # 800001fa <memmove>
    name[len] = 0;
    80003270:	9d56                	add	s10,s10,s5
    80003272:	000d0023          	sb	zero,0(s10)
    80003276:	84ce                	mv	s1,s3
    80003278:	b7bd                	j	800031e6 <namex+0xc0>
  if(nameiparent){
    8000327a:	f00b0ce3          	beqz	s6,80003192 <namex+0x6c>
    iput(ip);
    8000327e:	8552                	mv	a0,s4
    80003280:	00000097          	auipc	ra,0x0
    80003284:	acc080e7          	jalr	-1332(ra) # 80002d4c <iput>
    return 0;
    80003288:	4a01                	li	s4,0
    8000328a:	b721                	j	80003192 <namex+0x6c>

000000008000328c <dirlink>:
{
    8000328c:	7139                	addi	sp,sp,-64
    8000328e:	fc06                	sd	ra,56(sp)
    80003290:	f822                	sd	s0,48(sp)
    80003292:	f426                	sd	s1,40(sp)
    80003294:	f04a                	sd	s2,32(sp)
    80003296:	ec4e                	sd	s3,24(sp)
    80003298:	e852                	sd	s4,16(sp)
    8000329a:	0080                	addi	s0,sp,64
    8000329c:	892a                	mv	s2,a0
    8000329e:	8a2e                	mv	s4,a1
    800032a0:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032a2:	4601                	li	a2,0
    800032a4:	00000097          	auipc	ra,0x0
    800032a8:	dd2080e7          	jalr	-558(ra) # 80003076 <dirlookup>
    800032ac:	e93d                	bnez	a0,80003322 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032ae:	04c92483          	lw	s1,76(s2)
    800032b2:	c49d                	beqz	s1,800032e0 <dirlink+0x54>
    800032b4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032b6:	4741                	li	a4,16
    800032b8:	86a6                	mv	a3,s1
    800032ba:	fc040613          	addi	a2,s0,-64
    800032be:	4581                	li	a1,0
    800032c0:	854a                	mv	a0,s2
    800032c2:	00000097          	auipc	ra,0x0
    800032c6:	b84080e7          	jalr	-1148(ra) # 80002e46 <readi>
    800032ca:	47c1                	li	a5,16
    800032cc:	06f51163          	bne	a0,a5,8000332e <dirlink+0xa2>
    if(de.inum == 0)
    800032d0:	fc045783          	lhu	a5,-64(s0)
    800032d4:	c791                	beqz	a5,800032e0 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032d6:	24c1                	addiw	s1,s1,16
    800032d8:	04c92783          	lw	a5,76(s2)
    800032dc:	fcf4ede3          	bltu	s1,a5,800032b6 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800032e0:	4639                	li	a2,14
    800032e2:	85d2                	mv	a1,s4
    800032e4:	fc240513          	addi	a0,s0,-62
    800032e8:	ffffd097          	auipc	ra,0xffffd
    800032ec:	fc2080e7          	jalr	-62(ra) # 800002aa <strncpy>
  de.inum = inum;
    800032f0:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032f4:	4741                	li	a4,16
    800032f6:	86a6                	mv	a3,s1
    800032f8:	fc040613          	addi	a2,s0,-64
    800032fc:	4581                	li	a1,0
    800032fe:	854a                	mv	a0,s2
    80003300:	00000097          	auipc	ra,0x0
    80003304:	c3e080e7          	jalr	-962(ra) # 80002f3e <writei>
    80003308:	872a                	mv	a4,a0
    8000330a:	47c1                	li	a5,16
  return 0;
    8000330c:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000330e:	02f71863          	bne	a4,a5,8000333e <dirlink+0xb2>
}
    80003312:	70e2                	ld	ra,56(sp)
    80003314:	7442                	ld	s0,48(sp)
    80003316:	74a2                	ld	s1,40(sp)
    80003318:	7902                	ld	s2,32(sp)
    8000331a:	69e2                	ld	s3,24(sp)
    8000331c:	6a42                	ld	s4,16(sp)
    8000331e:	6121                	addi	sp,sp,64
    80003320:	8082                	ret
    iput(ip);
    80003322:	00000097          	auipc	ra,0x0
    80003326:	a2a080e7          	jalr	-1494(ra) # 80002d4c <iput>
    return -1;
    8000332a:	557d                	li	a0,-1
    8000332c:	b7dd                	j	80003312 <dirlink+0x86>
      panic("dirlink read");
    8000332e:	00005517          	auipc	a0,0x5
    80003332:	3ea50513          	addi	a0,a0,1002 # 80008718 <syscall_names+0x1d0>
    80003336:	00003097          	auipc	ra,0x3
    8000333a:	8ca080e7          	jalr	-1846(ra) # 80005c00 <panic>
    panic("dirlink");
    8000333e:	00005517          	auipc	a0,0x5
    80003342:	4e250513          	addi	a0,a0,1250 # 80008820 <syscall_names+0x2d8>
    80003346:	00003097          	auipc	ra,0x3
    8000334a:	8ba080e7          	jalr	-1862(ra) # 80005c00 <panic>

000000008000334e <namei>:

struct inode*
namei(char *path)
{
    8000334e:	1101                	addi	sp,sp,-32
    80003350:	ec06                	sd	ra,24(sp)
    80003352:	e822                	sd	s0,16(sp)
    80003354:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003356:	fe040613          	addi	a2,s0,-32
    8000335a:	4581                	li	a1,0
    8000335c:	00000097          	auipc	ra,0x0
    80003360:	dca080e7          	jalr	-566(ra) # 80003126 <namex>
}
    80003364:	60e2                	ld	ra,24(sp)
    80003366:	6442                	ld	s0,16(sp)
    80003368:	6105                	addi	sp,sp,32
    8000336a:	8082                	ret

000000008000336c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000336c:	1141                	addi	sp,sp,-16
    8000336e:	e406                	sd	ra,8(sp)
    80003370:	e022                	sd	s0,0(sp)
    80003372:	0800                	addi	s0,sp,16
    80003374:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003376:	4585                	li	a1,1
    80003378:	00000097          	auipc	ra,0x0
    8000337c:	dae080e7          	jalr	-594(ra) # 80003126 <namex>
}
    80003380:	60a2                	ld	ra,8(sp)
    80003382:	6402                	ld	s0,0(sp)
    80003384:	0141                	addi	sp,sp,16
    80003386:	8082                	ret

0000000080003388 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003388:	1101                	addi	sp,sp,-32
    8000338a:	ec06                	sd	ra,24(sp)
    8000338c:	e822                	sd	s0,16(sp)
    8000338e:	e426                	sd	s1,8(sp)
    80003390:	e04a                	sd	s2,0(sp)
    80003392:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003394:	00016917          	auipc	s2,0x16
    80003398:	c8c90913          	addi	s2,s2,-884 # 80019020 <log>
    8000339c:	01892583          	lw	a1,24(s2)
    800033a0:	02892503          	lw	a0,40(s2)
    800033a4:	fffff097          	auipc	ra,0xfffff
    800033a8:	fec080e7          	jalr	-20(ra) # 80002390 <bread>
    800033ac:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033ae:	02c92683          	lw	a3,44(s2)
    800033b2:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033b4:	02d05863          	blez	a3,800033e4 <write_head+0x5c>
    800033b8:	00016797          	auipc	a5,0x16
    800033bc:	c9878793          	addi	a5,a5,-872 # 80019050 <log+0x30>
    800033c0:	05c50713          	addi	a4,a0,92
    800033c4:	36fd                	addiw	a3,a3,-1
    800033c6:	02069613          	slli	a2,a3,0x20
    800033ca:	01e65693          	srli	a3,a2,0x1e
    800033ce:	00016617          	auipc	a2,0x16
    800033d2:	c8660613          	addi	a2,a2,-890 # 80019054 <log+0x34>
    800033d6:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800033d8:	4390                	lw	a2,0(a5)
    800033da:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800033dc:	0791                	addi	a5,a5,4
    800033de:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    800033e0:	fed79ce3          	bne	a5,a3,800033d8 <write_head+0x50>
  }
  bwrite(buf);
    800033e4:	8526                	mv	a0,s1
    800033e6:	fffff097          	auipc	ra,0xfffff
    800033ea:	09c080e7          	jalr	156(ra) # 80002482 <bwrite>
  brelse(buf);
    800033ee:	8526                	mv	a0,s1
    800033f0:	fffff097          	auipc	ra,0xfffff
    800033f4:	0d0080e7          	jalr	208(ra) # 800024c0 <brelse>
}
    800033f8:	60e2                	ld	ra,24(sp)
    800033fa:	6442                	ld	s0,16(sp)
    800033fc:	64a2                	ld	s1,8(sp)
    800033fe:	6902                	ld	s2,0(sp)
    80003400:	6105                	addi	sp,sp,32
    80003402:	8082                	ret

0000000080003404 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003404:	00016797          	auipc	a5,0x16
    80003408:	c487a783          	lw	a5,-952(a5) # 8001904c <log+0x2c>
    8000340c:	0af05d63          	blez	a5,800034c6 <install_trans+0xc2>
{
    80003410:	7139                	addi	sp,sp,-64
    80003412:	fc06                	sd	ra,56(sp)
    80003414:	f822                	sd	s0,48(sp)
    80003416:	f426                	sd	s1,40(sp)
    80003418:	f04a                	sd	s2,32(sp)
    8000341a:	ec4e                	sd	s3,24(sp)
    8000341c:	e852                	sd	s4,16(sp)
    8000341e:	e456                	sd	s5,8(sp)
    80003420:	e05a                	sd	s6,0(sp)
    80003422:	0080                	addi	s0,sp,64
    80003424:	8b2a                	mv	s6,a0
    80003426:	00016a97          	auipc	s5,0x16
    8000342a:	c2aa8a93          	addi	s5,s5,-982 # 80019050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000342e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003430:	00016997          	auipc	s3,0x16
    80003434:	bf098993          	addi	s3,s3,-1040 # 80019020 <log>
    80003438:	a00d                	j	8000345a <install_trans+0x56>
    brelse(lbuf);
    8000343a:	854a                	mv	a0,s2
    8000343c:	fffff097          	auipc	ra,0xfffff
    80003440:	084080e7          	jalr	132(ra) # 800024c0 <brelse>
    brelse(dbuf);
    80003444:	8526                	mv	a0,s1
    80003446:	fffff097          	auipc	ra,0xfffff
    8000344a:	07a080e7          	jalr	122(ra) # 800024c0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000344e:	2a05                	addiw	s4,s4,1
    80003450:	0a91                	addi	s5,s5,4
    80003452:	02c9a783          	lw	a5,44(s3)
    80003456:	04fa5e63          	bge	s4,a5,800034b2 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000345a:	0189a583          	lw	a1,24(s3)
    8000345e:	014585bb          	addw	a1,a1,s4
    80003462:	2585                	addiw	a1,a1,1
    80003464:	0289a503          	lw	a0,40(s3)
    80003468:	fffff097          	auipc	ra,0xfffff
    8000346c:	f28080e7          	jalr	-216(ra) # 80002390 <bread>
    80003470:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003472:	000aa583          	lw	a1,0(s5)
    80003476:	0289a503          	lw	a0,40(s3)
    8000347a:	fffff097          	auipc	ra,0xfffff
    8000347e:	f16080e7          	jalr	-234(ra) # 80002390 <bread>
    80003482:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003484:	40000613          	li	a2,1024
    80003488:	05890593          	addi	a1,s2,88
    8000348c:	05850513          	addi	a0,a0,88
    80003490:	ffffd097          	auipc	ra,0xffffd
    80003494:	d6a080e7          	jalr	-662(ra) # 800001fa <memmove>
    bwrite(dbuf);  // write dst to disk
    80003498:	8526                	mv	a0,s1
    8000349a:	fffff097          	auipc	ra,0xfffff
    8000349e:	fe8080e7          	jalr	-24(ra) # 80002482 <bwrite>
    if(recovering == 0)
    800034a2:	f80b1ce3          	bnez	s6,8000343a <install_trans+0x36>
      bunpin(dbuf);
    800034a6:	8526                	mv	a0,s1
    800034a8:	fffff097          	auipc	ra,0xfffff
    800034ac:	0f2080e7          	jalr	242(ra) # 8000259a <bunpin>
    800034b0:	b769                	j	8000343a <install_trans+0x36>
}
    800034b2:	70e2                	ld	ra,56(sp)
    800034b4:	7442                	ld	s0,48(sp)
    800034b6:	74a2                	ld	s1,40(sp)
    800034b8:	7902                	ld	s2,32(sp)
    800034ba:	69e2                	ld	s3,24(sp)
    800034bc:	6a42                	ld	s4,16(sp)
    800034be:	6aa2                	ld	s5,8(sp)
    800034c0:	6b02                	ld	s6,0(sp)
    800034c2:	6121                	addi	sp,sp,64
    800034c4:	8082                	ret
    800034c6:	8082                	ret

00000000800034c8 <initlog>:
{
    800034c8:	7179                	addi	sp,sp,-48
    800034ca:	f406                	sd	ra,40(sp)
    800034cc:	f022                	sd	s0,32(sp)
    800034ce:	ec26                	sd	s1,24(sp)
    800034d0:	e84a                	sd	s2,16(sp)
    800034d2:	e44e                	sd	s3,8(sp)
    800034d4:	1800                	addi	s0,sp,48
    800034d6:	892a                	mv	s2,a0
    800034d8:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800034da:	00016497          	auipc	s1,0x16
    800034de:	b4648493          	addi	s1,s1,-1210 # 80019020 <log>
    800034e2:	00005597          	auipc	a1,0x5
    800034e6:	24658593          	addi	a1,a1,582 # 80008728 <syscall_names+0x1e0>
    800034ea:	8526                	mv	a0,s1
    800034ec:	00003097          	auipc	ra,0x3
    800034f0:	bbc080e7          	jalr	-1092(ra) # 800060a8 <initlock>
  log.start = sb->logstart;
    800034f4:	0149a583          	lw	a1,20(s3)
    800034f8:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800034fa:	0109a783          	lw	a5,16(s3)
    800034fe:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003500:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003504:	854a                	mv	a0,s2
    80003506:	fffff097          	auipc	ra,0xfffff
    8000350a:	e8a080e7          	jalr	-374(ra) # 80002390 <bread>
  log.lh.n = lh->n;
    8000350e:	4d34                	lw	a3,88(a0)
    80003510:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003512:	02d05663          	blez	a3,8000353e <initlog+0x76>
    80003516:	05c50793          	addi	a5,a0,92
    8000351a:	00016717          	auipc	a4,0x16
    8000351e:	b3670713          	addi	a4,a4,-1226 # 80019050 <log+0x30>
    80003522:	36fd                	addiw	a3,a3,-1
    80003524:	02069613          	slli	a2,a3,0x20
    80003528:	01e65693          	srli	a3,a2,0x1e
    8000352c:	06050613          	addi	a2,a0,96
    80003530:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003532:	4390                	lw	a2,0(a5)
    80003534:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003536:	0791                	addi	a5,a5,4
    80003538:	0711                	addi	a4,a4,4
    8000353a:	fed79ce3          	bne	a5,a3,80003532 <initlog+0x6a>
  brelse(buf);
    8000353e:	fffff097          	auipc	ra,0xfffff
    80003542:	f82080e7          	jalr	-126(ra) # 800024c0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003546:	4505                	li	a0,1
    80003548:	00000097          	auipc	ra,0x0
    8000354c:	ebc080e7          	jalr	-324(ra) # 80003404 <install_trans>
  log.lh.n = 0;
    80003550:	00016797          	auipc	a5,0x16
    80003554:	ae07ae23          	sw	zero,-1284(a5) # 8001904c <log+0x2c>
  write_head(); // clear the log
    80003558:	00000097          	auipc	ra,0x0
    8000355c:	e30080e7          	jalr	-464(ra) # 80003388 <write_head>
}
    80003560:	70a2                	ld	ra,40(sp)
    80003562:	7402                	ld	s0,32(sp)
    80003564:	64e2                	ld	s1,24(sp)
    80003566:	6942                	ld	s2,16(sp)
    80003568:	69a2                	ld	s3,8(sp)
    8000356a:	6145                	addi	sp,sp,48
    8000356c:	8082                	ret

000000008000356e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000356e:	1101                	addi	sp,sp,-32
    80003570:	ec06                	sd	ra,24(sp)
    80003572:	e822                	sd	s0,16(sp)
    80003574:	e426                	sd	s1,8(sp)
    80003576:	e04a                	sd	s2,0(sp)
    80003578:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000357a:	00016517          	auipc	a0,0x16
    8000357e:	aa650513          	addi	a0,a0,-1370 # 80019020 <log>
    80003582:	00003097          	auipc	ra,0x3
    80003586:	bb6080e7          	jalr	-1098(ra) # 80006138 <acquire>
  while(1){
    if(log.committing){
    8000358a:	00016497          	auipc	s1,0x16
    8000358e:	a9648493          	addi	s1,s1,-1386 # 80019020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003592:	4979                	li	s2,30
    80003594:	a039                	j	800035a2 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003596:	85a6                	mv	a1,s1
    80003598:	8526                	mv	a0,s1
    8000359a:	ffffe097          	auipc	ra,0xffffe
    8000359e:	f98080e7          	jalr	-104(ra) # 80001532 <sleep>
    if(log.committing){
    800035a2:	50dc                	lw	a5,36(s1)
    800035a4:	fbed                	bnez	a5,80003596 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035a6:	5098                	lw	a4,32(s1)
    800035a8:	2705                	addiw	a4,a4,1
    800035aa:	0007069b          	sext.w	a3,a4
    800035ae:	0027179b          	slliw	a5,a4,0x2
    800035b2:	9fb9                	addw	a5,a5,a4
    800035b4:	0017979b          	slliw	a5,a5,0x1
    800035b8:	54d8                	lw	a4,44(s1)
    800035ba:	9fb9                	addw	a5,a5,a4
    800035bc:	00f95963          	bge	s2,a5,800035ce <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035c0:	85a6                	mv	a1,s1
    800035c2:	8526                	mv	a0,s1
    800035c4:	ffffe097          	auipc	ra,0xffffe
    800035c8:	f6e080e7          	jalr	-146(ra) # 80001532 <sleep>
    800035cc:	bfd9                	j	800035a2 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035ce:	00016517          	auipc	a0,0x16
    800035d2:	a5250513          	addi	a0,a0,-1454 # 80019020 <log>
    800035d6:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800035d8:	00003097          	auipc	ra,0x3
    800035dc:	c14080e7          	jalr	-1004(ra) # 800061ec <release>
      break;
    }
  }
}
    800035e0:	60e2                	ld	ra,24(sp)
    800035e2:	6442                	ld	s0,16(sp)
    800035e4:	64a2                	ld	s1,8(sp)
    800035e6:	6902                	ld	s2,0(sp)
    800035e8:	6105                	addi	sp,sp,32
    800035ea:	8082                	ret

00000000800035ec <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800035ec:	7139                	addi	sp,sp,-64
    800035ee:	fc06                	sd	ra,56(sp)
    800035f0:	f822                	sd	s0,48(sp)
    800035f2:	f426                	sd	s1,40(sp)
    800035f4:	f04a                	sd	s2,32(sp)
    800035f6:	ec4e                	sd	s3,24(sp)
    800035f8:	e852                	sd	s4,16(sp)
    800035fa:	e456                	sd	s5,8(sp)
    800035fc:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800035fe:	00016497          	auipc	s1,0x16
    80003602:	a2248493          	addi	s1,s1,-1502 # 80019020 <log>
    80003606:	8526                	mv	a0,s1
    80003608:	00003097          	auipc	ra,0x3
    8000360c:	b30080e7          	jalr	-1232(ra) # 80006138 <acquire>
  log.outstanding -= 1;
    80003610:	509c                	lw	a5,32(s1)
    80003612:	37fd                	addiw	a5,a5,-1
    80003614:	0007891b          	sext.w	s2,a5
    80003618:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000361a:	50dc                	lw	a5,36(s1)
    8000361c:	e7b9                	bnez	a5,8000366a <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000361e:	04091e63          	bnez	s2,8000367a <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003622:	00016497          	auipc	s1,0x16
    80003626:	9fe48493          	addi	s1,s1,-1538 # 80019020 <log>
    8000362a:	4785                	li	a5,1
    8000362c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000362e:	8526                	mv	a0,s1
    80003630:	00003097          	auipc	ra,0x3
    80003634:	bbc080e7          	jalr	-1092(ra) # 800061ec <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003638:	54dc                	lw	a5,44(s1)
    8000363a:	06f04763          	bgtz	a5,800036a8 <end_op+0xbc>
    acquire(&log.lock);
    8000363e:	00016497          	auipc	s1,0x16
    80003642:	9e248493          	addi	s1,s1,-1566 # 80019020 <log>
    80003646:	8526                	mv	a0,s1
    80003648:	00003097          	auipc	ra,0x3
    8000364c:	af0080e7          	jalr	-1296(ra) # 80006138 <acquire>
    log.committing = 0;
    80003650:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003654:	8526                	mv	a0,s1
    80003656:	ffffe097          	auipc	ra,0xffffe
    8000365a:	068080e7          	jalr	104(ra) # 800016be <wakeup>
    release(&log.lock);
    8000365e:	8526                	mv	a0,s1
    80003660:	00003097          	auipc	ra,0x3
    80003664:	b8c080e7          	jalr	-1140(ra) # 800061ec <release>
}
    80003668:	a03d                	j	80003696 <end_op+0xaa>
    panic("log.committing");
    8000366a:	00005517          	auipc	a0,0x5
    8000366e:	0c650513          	addi	a0,a0,198 # 80008730 <syscall_names+0x1e8>
    80003672:	00002097          	auipc	ra,0x2
    80003676:	58e080e7          	jalr	1422(ra) # 80005c00 <panic>
    wakeup(&log);
    8000367a:	00016497          	auipc	s1,0x16
    8000367e:	9a648493          	addi	s1,s1,-1626 # 80019020 <log>
    80003682:	8526                	mv	a0,s1
    80003684:	ffffe097          	auipc	ra,0xffffe
    80003688:	03a080e7          	jalr	58(ra) # 800016be <wakeup>
  release(&log.lock);
    8000368c:	8526                	mv	a0,s1
    8000368e:	00003097          	auipc	ra,0x3
    80003692:	b5e080e7          	jalr	-1186(ra) # 800061ec <release>
}
    80003696:	70e2                	ld	ra,56(sp)
    80003698:	7442                	ld	s0,48(sp)
    8000369a:	74a2                	ld	s1,40(sp)
    8000369c:	7902                	ld	s2,32(sp)
    8000369e:	69e2                	ld	s3,24(sp)
    800036a0:	6a42                	ld	s4,16(sp)
    800036a2:	6aa2                	ld	s5,8(sp)
    800036a4:	6121                	addi	sp,sp,64
    800036a6:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800036a8:	00016a97          	auipc	s5,0x16
    800036ac:	9a8a8a93          	addi	s5,s5,-1624 # 80019050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036b0:	00016a17          	auipc	s4,0x16
    800036b4:	970a0a13          	addi	s4,s4,-1680 # 80019020 <log>
    800036b8:	018a2583          	lw	a1,24(s4)
    800036bc:	012585bb          	addw	a1,a1,s2
    800036c0:	2585                	addiw	a1,a1,1
    800036c2:	028a2503          	lw	a0,40(s4)
    800036c6:	fffff097          	auipc	ra,0xfffff
    800036ca:	cca080e7          	jalr	-822(ra) # 80002390 <bread>
    800036ce:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036d0:	000aa583          	lw	a1,0(s5)
    800036d4:	028a2503          	lw	a0,40(s4)
    800036d8:	fffff097          	auipc	ra,0xfffff
    800036dc:	cb8080e7          	jalr	-840(ra) # 80002390 <bread>
    800036e0:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800036e2:	40000613          	li	a2,1024
    800036e6:	05850593          	addi	a1,a0,88
    800036ea:	05848513          	addi	a0,s1,88
    800036ee:	ffffd097          	auipc	ra,0xffffd
    800036f2:	b0c080e7          	jalr	-1268(ra) # 800001fa <memmove>
    bwrite(to);  // write the log
    800036f6:	8526                	mv	a0,s1
    800036f8:	fffff097          	auipc	ra,0xfffff
    800036fc:	d8a080e7          	jalr	-630(ra) # 80002482 <bwrite>
    brelse(from);
    80003700:	854e                	mv	a0,s3
    80003702:	fffff097          	auipc	ra,0xfffff
    80003706:	dbe080e7          	jalr	-578(ra) # 800024c0 <brelse>
    brelse(to);
    8000370a:	8526                	mv	a0,s1
    8000370c:	fffff097          	auipc	ra,0xfffff
    80003710:	db4080e7          	jalr	-588(ra) # 800024c0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003714:	2905                	addiw	s2,s2,1
    80003716:	0a91                	addi	s5,s5,4
    80003718:	02ca2783          	lw	a5,44(s4)
    8000371c:	f8f94ee3          	blt	s2,a5,800036b8 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003720:	00000097          	auipc	ra,0x0
    80003724:	c68080e7          	jalr	-920(ra) # 80003388 <write_head>
    install_trans(0); // Now install writes to home locations
    80003728:	4501                	li	a0,0
    8000372a:	00000097          	auipc	ra,0x0
    8000372e:	cda080e7          	jalr	-806(ra) # 80003404 <install_trans>
    log.lh.n = 0;
    80003732:	00016797          	auipc	a5,0x16
    80003736:	9007ad23          	sw	zero,-1766(a5) # 8001904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000373a:	00000097          	auipc	ra,0x0
    8000373e:	c4e080e7          	jalr	-946(ra) # 80003388 <write_head>
    80003742:	bdf5                	j	8000363e <end_op+0x52>

0000000080003744 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003744:	1101                	addi	sp,sp,-32
    80003746:	ec06                	sd	ra,24(sp)
    80003748:	e822                	sd	s0,16(sp)
    8000374a:	e426                	sd	s1,8(sp)
    8000374c:	e04a                	sd	s2,0(sp)
    8000374e:	1000                	addi	s0,sp,32
    80003750:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003752:	00016917          	auipc	s2,0x16
    80003756:	8ce90913          	addi	s2,s2,-1842 # 80019020 <log>
    8000375a:	854a                	mv	a0,s2
    8000375c:	00003097          	auipc	ra,0x3
    80003760:	9dc080e7          	jalr	-1572(ra) # 80006138 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003764:	02c92603          	lw	a2,44(s2)
    80003768:	47f5                	li	a5,29
    8000376a:	06c7c563          	blt	a5,a2,800037d4 <log_write+0x90>
    8000376e:	00016797          	auipc	a5,0x16
    80003772:	8ce7a783          	lw	a5,-1842(a5) # 8001903c <log+0x1c>
    80003776:	37fd                	addiw	a5,a5,-1
    80003778:	04f65e63          	bge	a2,a5,800037d4 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000377c:	00016797          	auipc	a5,0x16
    80003780:	8c47a783          	lw	a5,-1852(a5) # 80019040 <log+0x20>
    80003784:	06f05063          	blez	a5,800037e4 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003788:	4781                	li	a5,0
    8000378a:	06c05563          	blez	a2,800037f4 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000378e:	44cc                	lw	a1,12(s1)
    80003790:	00016717          	auipc	a4,0x16
    80003794:	8c070713          	addi	a4,a4,-1856 # 80019050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003798:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000379a:	4314                	lw	a3,0(a4)
    8000379c:	04b68c63          	beq	a3,a1,800037f4 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037a0:	2785                	addiw	a5,a5,1
    800037a2:	0711                	addi	a4,a4,4
    800037a4:	fef61be3          	bne	a2,a5,8000379a <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037a8:	0621                	addi	a2,a2,8
    800037aa:	060a                	slli	a2,a2,0x2
    800037ac:	00016797          	auipc	a5,0x16
    800037b0:	87478793          	addi	a5,a5,-1932 # 80019020 <log>
    800037b4:	97b2                	add	a5,a5,a2
    800037b6:	44d8                	lw	a4,12(s1)
    800037b8:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037ba:	8526                	mv	a0,s1
    800037bc:	fffff097          	auipc	ra,0xfffff
    800037c0:	da2080e7          	jalr	-606(ra) # 8000255e <bpin>
    log.lh.n++;
    800037c4:	00016717          	auipc	a4,0x16
    800037c8:	85c70713          	addi	a4,a4,-1956 # 80019020 <log>
    800037cc:	575c                	lw	a5,44(a4)
    800037ce:	2785                	addiw	a5,a5,1
    800037d0:	d75c                	sw	a5,44(a4)
    800037d2:	a82d                	j	8000380c <log_write+0xc8>
    panic("too big a transaction");
    800037d4:	00005517          	auipc	a0,0x5
    800037d8:	f6c50513          	addi	a0,a0,-148 # 80008740 <syscall_names+0x1f8>
    800037dc:	00002097          	auipc	ra,0x2
    800037e0:	424080e7          	jalr	1060(ra) # 80005c00 <panic>
    panic("log_write outside of trans");
    800037e4:	00005517          	auipc	a0,0x5
    800037e8:	f7450513          	addi	a0,a0,-140 # 80008758 <syscall_names+0x210>
    800037ec:	00002097          	auipc	ra,0x2
    800037f0:	414080e7          	jalr	1044(ra) # 80005c00 <panic>
  log.lh.block[i] = b->blockno;
    800037f4:	00878693          	addi	a3,a5,8
    800037f8:	068a                	slli	a3,a3,0x2
    800037fa:	00016717          	auipc	a4,0x16
    800037fe:	82670713          	addi	a4,a4,-2010 # 80019020 <log>
    80003802:	9736                	add	a4,a4,a3
    80003804:	44d4                	lw	a3,12(s1)
    80003806:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003808:	faf609e3          	beq	a2,a5,800037ba <log_write+0x76>
  }
  release(&log.lock);
    8000380c:	00016517          	auipc	a0,0x16
    80003810:	81450513          	addi	a0,a0,-2028 # 80019020 <log>
    80003814:	00003097          	auipc	ra,0x3
    80003818:	9d8080e7          	jalr	-1576(ra) # 800061ec <release>
}
    8000381c:	60e2                	ld	ra,24(sp)
    8000381e:	6442                	ld	s0,16(sp)
    80003820:	64a2                	ld	s1,8(sp)
    80003822:	6902                	ld	s2,0(sp)
    80003824:	6105                	addi	sp,sp,32
    80003826:	8082                	ret

0000000080003828 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003828:	1101                	addi	sp,sp,-32
    8000382a:	ec06                	sd	ra,24(sp)
    8000382c:	e822                	sd	s0,16(sp)
    8000382e:	e426                	sd	s1,8(sp)
    80003830:	e04a                	sd	s2,0(sp)
    80003832:	1000                	addi	s0,sp,32
    80003834:	84aa                	mv	s1,a0
    80003836:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003838:	00005597          	auipc	a1,0x5
    8000383c:	f4058593          	addi	a1,a1,-192 # 80008778 <syscall_names+0x230>
    80003840:	0521                	addi	a0,a0,8
    80003842:	00003097          	auipc	ra,0x3
    80003846:	866080e7          	jalr	-1946(ra) # 800060a8 <initlock>
  lk->name = name;
    8000384a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000384e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003852:	0204a423          	sw	zero,40(s1)
}
    80003856:	60e2                	ld	ra,24(sp)
    80003858:	6442                	ld	s0,16(sp)
    8000385a:	64a2                	ld	s1,8(sp)
    8000385c:	6902                	ld	s2,0(sp)
    8000385e:	6105                	addi	sp,sp,32
    80003860:	8082                	ret

0000000080003862 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003862:	1101                	addi	sp,sp,-32
    80003864:	ec06                	sd	ra,24(sp)
    80003866:	e822                	sd	s0,16(sp)
    80003868:	e426                	sd	s1,8(sp)
    8000386a:	e04a                	sd	s2,0(sp)
    8000386c:	1000                	addi	s0,sp,32
    8000386e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003870:	00850913          	addi	s2,a0,8
    80003874:	854a                	mv	a0,s2
    80003876:	00003097          	auipc	ra,0x3
    8000387a:	8c2080e7          	jalr	-1854(ra) # 80006138 <acquire>
  while (lk->locked) {
    8000387e:	409c                	lw	a5,0(s1)
    80003880:	cb89                	beqz	a5,80003892 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003882:	85ca                	mv	a1,s2
    80003884:	8526                	mv	a0,s1
    80003886:	ffffe097          	auipc	ra,0xffffe
    8000388a:	cac080e7          	jalr	-852(ra) # 80001532 <sleep>
  while (lk->locked) {
    8000388e:	409c                	lw	a5,0(s1)
    80003890:	fbed                	bnez	a5,80003882 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003892:	4785                	li	a5,1
    80003894:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003896:	ffffd097          	auipc	ra,0xffffd
    8000389a:	5d2080e7          	jalr	1490(ra) # 80000e68 <myproc>
    8000389e:	591c                	lw	a5,48(a0)
    800038a0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038a2:	854a                	mv	a0,s2
    800038a4:	00003097          	auipc	ra,0x3
    800038a8:	948080e7          	jalr	-1720(ra) # 800061ec <release>
}
    800038ac:	60e2                	ld	ra,24(sp)
    800038ae:	6442                	ld	s0,16(sp)
    800038b0:	64a2                	ld	s1,8(sp)
    800038b2:	6902                	ld	s2,0(sp)
    800038b4:	6105                	addi	sp,sp,32
    800038b6:	8082                	ret

00000000800038b8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038b8:	1101                	addi	sp,sp,-32
    800038ba:	ec06                	sd	ra,24(sp)
    800038bc:	e822                	sd	s0,16(sp)
    800038be:	e426                	sd	s1,8(sp)
    800038c0:	e04a                	sd	s2,0(sp)
    800038c2:	1000                	addi	s0,sp,32
    800038c4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038c6:	00850913          	addi	s2,a0,8
    800038ca:	854a                	mv	a0,s2
    800038cc:	00003097          	auipc	ra,0x3
    800038d0:	86c080e7          	jalr	-1940(ra) # 80006138 <acquire>
  lk->locked = 0;
    800038d4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038d8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800038dc:	8526                	mv	a0,s1
    800038de:	ffffe097          	auipc	ra,0xffffe
    800038e2:	de0080e7          	jalr	-544(ra) # 800016be <wakeup>
  release(&lk->lk);
    800038e6:	854a                	mv	a0,s2
    800038e8:	00003097          	auipc	ra,0x3
    800038ec:	904080e7          	jalr	-1788(ra) # 800061ec <release>
}
    800038f0:	60e2                	ld	ra,24(sp)
    800038f2:	6442                	ld	s0,16(sp)
    800038f4:	64a2                	ld	s1,8(sp)
    800038f6:	6902                	ld	s2,0(sp)
    800038f8:	6105                	addi	sp,sp,32
    800038fa:	8082                	ret

00000000800038fc <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800038fc:	7179                	addi	sp,sp,-48
    800038fe:	f406                	sd	ra,40(sp)
    80003900:	f022                	sd	s0,32(sp)
    80003902:	ec26                	sd	s1,24(sp)
    80003904:	e84a                	sd	s2,16(sp)
    80003906:	e44e                	sd	s3,8(sp)
    80003908:	1800                	addi	s0,sp,48
    8000390a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000390c:	00850913          	addi	s2,a0,8
    80003910:	854a                	mv	a0,s2
    80003912:	00003097          	auipc	ra,0x3
    80003916:	826080e7          	jalr	-2010(ra) # 80006138 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000391a:	409c                	lw	a5,0(s1)
    8000391c:	ef99                	bnez	a5,8000393a <holdingsleep+0x3e>
    8000391e:	4481                	li	s1,0
  release(&lk->lk);
    80003920:	854a                	mv	a0,s2
    80003922:	00003097          	auipc	ra,0x3
    80003926:	8ca080e7          	jalr	-1846(ra) # 800061ec <release>
  return r;
}
    8000392a:	8526                	mv	a0,s1
    8000392c:	70a2                	ld	ra,40(sp)
    8000392e:	7402                	ld	s0,32(sp)
    80003930:	64e2                	ld	s1,24(sp)
    80003932:	6942                	ld	s2,16(sp)
    80003934:	69a2                	ld	s3,8(sp)
    80003936:	6145                	addi	sp,sp,48
    80003938:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000393a:	0284a983          	lw	s3,40(s1)
    8000393e:	ffffd097          	auipc	ra,0xffffd
    80003942:	52a080e7          	jalr	1322(ra) # 80000e68 <myproc>
    80003946:	5904                	lw	s1,48(a0)
    80003948:	413484b3          	sub	s1,s1,s3
    8000394c:	0014b493          	seqz	s1,s1
    80003950:	bfc1                	j	80003920 <holdingsleep+0x24>

0000000080003952 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003952:	1141                	addi	sp,sp,-16
    80003954:	e406                	sd	ra,8(sp)
    80003956:	e022                	sd	s0,0(sp)
    80003958:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000395a:	00005597          	auipc	a1,0x5
    8000395e:	e2e58593          	addi	a1,a1,-466 # 80008788 <syscall_names+0x240>
    80003962:	00016517          	auipc	a0,0x16
    80003966:	80650513          	addi	a0,a0,-2042 # 80019168 <ftable>
    8000396a:	00002097          	auipc	ra,0x2
    8000396e:	73e080e7          	jalr	1854(ra) # 800060a8 <initlock>
}
    80003972:	60a2                	ld	ra,8(sp)
    80003974:	6402                	ld	s0,0(sp)
    80003976:	0141                	addi	sp,sp,16
    80003978:	8082                	ret

000000008000397a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000397a:	1101                	addi	sp,sp,-32
    8000397c:	ec06                	sd	ra,24(sp)
    8000397e:	e822                	sd	s0,16(sp)
    80003980:	e426                	sd	s1,8(sp)
    80003982:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003984:	00015517          	auipc	a0,0x15
    80003988:	7e450513          	addi	a0,a0,2020 # 80019168 <ftable>
    8000398c:	00002097          	auipc	ra,0x2
    80003990:	7ac080e7          	jalr	1964(ra) # 80006138 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003994:	00015497          	auipc	s1,0x15
    80003998:	7ec48493          	addi	s1,s1,2028 # 80019180 <ftable+0x18>
    8000399c:	00016717          	auipc	a4,0x16
    800039a0:	78470713          	addi	a4,a4,1924 # 8001a120 <ftable+0xfb8>
    if(f->ref == 0){
    800039a4:	40dc                	lw	a5,4(s1)
    800039a6:	cf99                	beqz	a5,800039c4 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039a8:	02848493          	addi	s1,s1,40
    800039ac:	fee49ce3          	bne	s1,a4,800039a4 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039b0:	00015517          	auipc	a0,0x15
    800039b4:	7b850513          	addi	a0,a0,1976 # 80019168 <ftable>
    800039b8:	00003097          	auipc	ra,0x3
    800039bc:	834080e7          	jalr	-1996(ra) # 800061ec <release>
  return 0;
    800039c0:	4481                	li	s1,0
    800039c2:	a819                	j	800039d8 <filealloc+0x5e>
      f->ref = 1;
    800039c4:	4785                	li	a5,1
    800039c6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039c8:	00015517          	auipc	a0,0x15
    800039cc:	7a050513          	addi	a0,a0,1952 # 80019168 <ftable>
    800039d0:	00003097          	auipc	ra,0x3
    800039d4:	81c080e7          	jalr	-2020(ra) # 800061ec <release>
}
    800039d8:	8526                	mv	a0,s1
    800039da:	60e2                	ld	ra,24(sp)
    800039dc:	6442                	ld	s0,16(sp)
    800039de:	64a2                	ld	s1,8(sp)
    800039e0:	6105                	addi	sp,sp,32
    800039e2:	8082                	ret

00000000800039e4 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800039e4:	1101                	addi	sp,sp,-32
    800039e6:	ec06                	sd	ra,24(sp)
    800039e8:	e822                	sd	s0,16(sp)
    800039ea:	e426                	sd	s1,8(sp)
    800039ec:	1000                	addi	s0,sp,32
    800039ee:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800039f0:	00015517          	auipc	a0,0x15
    800039f4:	77850513          	addi	a0,a0,1912 # 80019168 <ftable>
    800039f8:	00002097          	auipc	ra,0x2
    800039fc:	740080e7          	jalr	1856(ra) # 80006138 <acquire>
  if(f->ref < 1)
    80003a00:	40dc                	lw	a5,4(s1)
    80003a02:	02f05263          	blez	a5,80003a26 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a06:	2785                	addiw	a5,a5,1
    80003a08:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a0a:	00015517          	auipc	a0,0x15
    80003a0e:	75e50513          	addi	a0,a0,1886 # 80019168 <ftable>
    80003a12:	00002097          	auipc	ra,0x2
    80003a16:	7da080e7          	jalr	2010(ra) # 800061ec <release>
  return f;
}
    80003a1a:	8526                	mv	a0,s1
    80003a1c:	60e2                	ld	ra,24(sp)
    80003a1e:	6442                	ld	s0,16(sp)
    80003a20:	64a2                	ld	s1,8(sp)
    80003a22:	6105                	addi	sp,sp,32
    80003a24:	8082                	ret
    panic("filedup");
    80003a26:	00005517          	auipc	a0,0x5
    80003a2a:	d6a50513          	addi	a0,a0,-662 # 80008790 <syscall_names+0x248>
    80003a2e:	00002097          	auipc	ra,0x2
    80003a32:	1d2080e7          	jalr	466(ra) # 80005c00 <panic>

0000000080003a36 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a36:	7139                	addi	sp,sp,-64
    80003a38:	fc06                	sd	ra,56(sp)
    80003a3a:	f822                	sd	s0,48(sp)
    80003a3c:	f426                	sd	s1,40(sp)
    80003a3e:	f04a                	sd	s2,32(sp)
    80003a40:	ec4e                	sd	s3,24(sp)
    80003a42:	e852                	sd	s4,16(sp)
    80003a44:	e456                	sd	s5,8(sp)
    80003a46:	0080                	addi	s0,sp,64
    80003a48:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a4a:	00015517          	auipc	a0,0x15
    80003a4e:	71e50513          	addi	a0,a0,1822 # 80019168 <ftable>
    80003a52:	00002097          	auipc	ra,0x2
    80003a56:	6e6080e7          	jalr	1766(ra) # 80006138 <acquire>
  if(f->ref < 1)
    80003a5a:	40dc                	lw	a5,4(s1)
    80003a5c:	06f05163          	blez	a5,80003abe <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a60:	37fd                	addiw	a5,a5,-1
    80003a62:	0007871b          	sext.w	a4,a5
    80003a66:	c0dc                	sw	a5,4(s1)
    80003a68:	06e04363          	bgtz	a4,80003ace <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a6c:	0004a903          	lw	s2,0(s1)
    80003a70:	0094ca83          	lbu	s5,9(s1)
    80003a74:	0104ba03          	ld	s4,16(s1)
    80003a78:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a7c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a80:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a84:	00015517          	auipc	a0,0x15
    80003a88:	6e450513          	addi	a0,a0,1764 # 80019168 <ftable>
    80003a8c:	00002097          	auipc	ra,0x2
    80003a90:	760080e7          	jalr	1888(ra) # 800061ec <release>

  if(ff.type == FD_PIPE){
    80003a94:	4785                	li	a5,1
    80003a96:	04f90d63          	beq	s2,a5,80003af0 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a9a:	3979                	addiw	s2,s2,-2
    80003a9c:	4785                	li	a5,1
    80003a9e:	0527e063          	bltu	a5,s2,80003ade <fileclose+0xa8>
    begin_op();
    80003aa2:	00000097          	auipc	ra,0x0
    80003aa6:	acc080e7          	jalr	-1332(ra) # 8000356e <begin_op>
    iput(ff.ip);
    80003aaa:	854e                	mv	a0,s3
    80003aac:	fffff097          	auipc	ra,0xfffff
    80003ab0:	2a0080e7          	jalr	672(ra) # 80002d4c <iput>
    end_op();
    80003ab4:	00000097          	auipc	ra,0x0
    80003ab8:	b38080e7          	jalr	-1224(ra) # 800035ec <end_op>
    80003abc:	a00d                	j	80003ade <fileclose+0xa8>
    panic("fileclose");
    80003abe:	00005517          	auipc	a0,0x5
    80003ac2:	cda50513          	addi	a0,a0,-806 # 80008798 <syscall_names+0x250>
    80003ac6:	00002097          	auipc	ra,0x2
    80003aca:	13a080e7          	jalr	314(ra) # 80005c00 <panic>
    release(&ftable.lock);
    80003ace:	00015517          	auipc	a0,0x15
    80003ad2:	69a50513          	addi	a0,a0,1690 # 80019168 <ftable>
    80003ad6:	00002097          	auipc	ra,0x2
    80003ada:	716080e7          	jalr	1814(ra) # 800061ec <release>
  }
}
    80003ade:	70e2                	ld	ra,56(sp)
    80003ae0:	7442                	ld	s0,48(sp)
    80003ae2:	74a2                	ld	s1,40(sp)
    80003ae4:	7902                	ld	s2,32(sp)
    80003ae6:	69e2                	ld	s3,24(sp)
    80003ae8:	6a42                	ld	s4,16(sp)
    80003aea:	6aa2                	ld	s5,8(sp)
    80003aec:	6121                	addi	sp,sp,64
    80003aee:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003af0:	85d6                	mv	a1,s5
    80003af2:	8552                	mv	a0,s4
    80003af4:	00000097          	auipc	ra,0x0
    80003af8:	34c080e7          	jalr	844(ra) # 80003e40 <pipeclose>
    80003afc:	b7cd                	j	80003ade <fileclose+0xa8>

0000000080003afe <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003afe:	715d                	addi	sp,sp,-80
    80003b00:	e486                	sd	ra,72(sp)
    80003b02:	e0a2                	sd	s0,64(sp)
    80003b04:	fc26                	sd	s1,56(sp)
    80003b06:	f84a                	sd	s2,48(sp)
    80003b08:	f44e                	sd	s3,40(sp)
    80003b0a:	0880                	addi	s0,sp,80
    80003b0c:	84aa                	mv	s1,a0
    80003b0e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b10:	ffffd097          	auipc	ra,0xffffd
    80003b14:	358080e7          	jalr	856(ra) # 80000e68 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b18:	409c                	lw	a5,0(s1)
    80003b1a:	37f9                	addiw	a5,a5,-2
    80003b1c:	4705                	li	a4,1
    80003b1e:	04f76763          	bltu	a4,a5,80003b6c <filestat+0x6e>
    80003b22:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b24:	6c88                	ld	a0,24(s1)
    80003b26:	fffff097          	auipc	ra,0xfffff
    80003b2a:	06c080e7          	jalr	108(ra) # 80002b92 <ilock>
    stati(f->ip, &st);
    80003b2e:	fb840593          	addi	a1,s0,-72
    80003b32:	6c88                	ld	a0,24(s1)
    80003b34:	fffff097          	auipc	ra,0xfffff
    80003b38:	2e8080e7          	jalr	744(ra) # 80002e1c <stati>
    iunlock(f->ip);
    80003b3c:	6c88                	ld	a0,24(s1)
    80003b3e:	fffff097          	auipc	ra,0xfffff
    80003b42:	116080e7          	jalr	278(ra) # 80002c54 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b46:	46e1                	li	a3,24
    80003b48:	fb840613          	addi	a2,s0,-72
    80003b4c:	85ce                	mv	a1,s3
    80003b4e:	05093503          	ld	a0,80(s2)
    80003b52:	ffffd097          	auipc	ra,0xffffd
    80003b56:	fda080e7          	jalr	-38(ra) # 80000b2c <copyout>
    80003b5a:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b5e:	60a6                	ld	ra,72(sp)
    80003b60:	6406                	ld	s0,64(sp)
    80003b62:	74e2                	ld	s1,56(sp)
    80003b64:	7942                	ld	s2,48(sp)
    80003b66:	79a2                	ld	s3,40(sp)
    80003b68:	6161                	addi	sp,sp,80
    80003b6a:	8082                	ret
  return -1;
    80003b6c:	557d                	li	a0,-1
    80003b6e:	bfc5                	j	80003b5e <filestat+0x60>

0000000080003b70 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b70:	7179                	addi	sp,sp,-48
    80003b72:	f406                	sd	ra,40(sp)
    80003b74:	f022                	sd	s0,32(sp)
    80003b76:	ec26                	sd	s1,24(sp)
    80003b78:	e84a                	sd	s2,16(sp)
    80003b7a:	e44e                	sd	s3,8(sp)
    80003b7c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b7e:	00854783          	lbu	a5,8(a0)
    80003b82:	c3d5                	beqz	a5,80003c26 <fileread+0xb6>
    80003b84:	84aa                	mv	s1,a0
    80003b86:	89ae                	mv	s3,a1
    80003b88:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b8a:	411c                	lw	a5,0(a0)
    80003b8c:	4705                	li	a4,1
    80003b8e:	04e78963          	beq	a5,a4,80003be0 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b92:	470d                	li	a4,3
    80003b94:	04e78d63          	beq	a5,a4,80003bee <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b98:	4709                	li	a4,2
    80003b9a:	06e79e63          	bne	a5,a4,80003c16 <fileread+0xa6>
    ilock(f->ip);
    80003b9e:	6d08                	ld	a0,24(a0)
    80003ba0:	fffff097          	auipc	ra,0xfffff
    80003ba4:	ff2080e7          	jalr	-14(ra) # 80002b92 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ba8:	874a                	mv	a4,s2
    80003baa:	5094                	lw	a3,32(s1)
    80003bac:	864e                	mv	a2,s3
    80003bae:	4585                	li	a1,1
    80003bb0:	6c88                	ld	a0,24(s1)
    80003bb2:	fffff097          	auipc	ra,0xfffff
    80003bb6:	294080e7          	jalr	660(ra) # 80002e46 <readi>
    80003bba:	892a                	mv	s2,a0
    80003bbc:	00a05563          	blez	a0,80003bc6 <fileread+0x56>
      f->off += r;
    80003bc0:	509c                	lw	a5,32(s1)
    80003bc2:	9fa9                	addw	a5,a5,a0
    80003bc4:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003bc6:	6c88                	ld	a0,24(s1)
    80003bc8:	fffff097          	auipc	ra,0xfffff
    80003bcc:	08c080e7          	jalr	140(ra) # 80002c54 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003bd0:	854a                	mv	a0,s2
    80003bd2:	70a2                	ld	ra,40(sp)
    80003bd4:	7402                	ld	s0,32(sp)
    80003bd6:	64e2                	ld	s1,24(sp)
    80003bd8:	6942                	ld	s2,16(sp)
    80003bda:	69a2                	ld	s3,8(sp)
    80003bdc:	6145                	addi	sp,sp,48
    80003bde:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003be0:	6908                	ld	a0,16(a0)
    80003be2:	00000097          	auipc	ra,0x0
    80003be6:	3c0080e7          	jalr	960(ra) # 80003fa2 <piperead>
    80003bea:	892a                	mv	s2,a0
    80003bec:	b7d5                	j	80003bd0 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003bee:	02451783          	lh	a5,36(a0)
    80003bf2:	03079693          	slli	a3,a5,0x30
    80003bf6:	92c1                	srli	a3,a3,0x30
    80003bf8:	4725                	li	a4,9
    80003bfa:	02d76863          	bltu	a4,a3,80003c2a <fileread+0xba>
    80003bfe:	0792                	slli	a5,a5,0x4
    80003c00:	00015717          	auipc	a4,0x15
    80003c04:	4c870713          	addi	a4,a4,1224 # 800190c8 <devsw>
    80003c08:	97ba                	add	a5,a5,a4
    80003c0a:	639c                	ld	a5,0(a5)
    80003c0c:	c38d                	beqz	a5,80003c2e <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c0e:	4505                	li	a0,1
    80003c10:	9782                	jalr	a5
    80003c12:	892a                	mv	s2,a0
    80003c14:	bf75                	j	80003bd0 <fileread+0x60>
    panic("fileread");
    80003c16:	00005517          	auipc	a0,0x5
    80003c1a:	b9250513          	addi	a0,a0,-1134 # 800087a8 <syscall_names+0x260>
    80003c1e:	00002097          	auipc	ra,0x2
    80003c22:	fe2080e7          	jalr	-30(ra) # 80005c00 <panic>
    return -1;
    80003c26:	597d                	li	s2,-1
    80003c28:	b765                	j	80003bd0 <fileread+0x60>
      return -1;
    80003c2a:	597d                	li	s2,-1
    80003c2c:	b755                	j	80003bd0 <fileread+0x60>
    80003c2e:	597d                	li	s2,-1
    80003c30:	b745                	j	80003bd0 <fileread+0x60>

0000000080003c32 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c32:	715d                	addi	sp,sp,-80
    80003c34:	e486                	sd	ra,72(sp)
    80003c36:	e0a2                	sd	s0,64(sp)
    80003c38:	fc26                	sd	s1,56(sp)
    80003c3a:	f84a                	sd	s2,48(sp)
    80003c3c:	f44e                	sd	s3,40(sp)
    80003c3e:	f052                	sd	s4,32(sp)
    80003c40:	ec56                	sd	s5,24(sp)
    80003c42:	e85a                	sd	s6,16(sp)
    80003c44:	e45e                	sd	s7,8(sp)
    80003c46:	e062                	sd	s8,0(sp)
    80003c48:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c4a:	00954783          	lbu	a5,9(a0)
    80003c4e:	10078663          	beqz	a5,80003d5a <filewrite+0x128>
    80003c52:	892a                	mv	s2,a0
    80003c54:	8b2e                	mv	s6,a1
    80003c56:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c58:	411c                	lw	a5,0(a0)
    80003c5a:	4705                	li	a4,1
    80003c5c:	02e78263          	beq	a5,a4,80003c80 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c60:	470d                	li	a4,3
    80003c62:	02e78663          	beq	a5,a4,80003c8e <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c66:	4709                	li	a4,2
    80003c68:	0ee79163          	bne	a5,a4,80003d4a <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c6c:	0ac05d63          	blez	a2,80003d26 <filewrite+0xf4>
    int i = 0;
    80003c70:	4981                	li	s3,0
    80003c72:	6b85                	lui	s7,0x1
    80003c74:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003c78:	6c05                	lui	s8,0x1
    80003c7a:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003c7e:	a861                	j	80003d16 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003c80:	6908                	ld	a0,16(a0)
    80003c82:	00000097          	auipc	ra,0x0
    80003c86:	22e080e7          	jalr	558(ra) # 80003eb0 <pipewrite>
    80003c8a:	8a2a                	mv	s4,a0
    80003c8c:	a045                	j	80003d2c <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c8e:	02451783          	lh	a5,36(a0)
    80003c92:	03079693          	slli	a3,a5,0x30
    80003c96:	92c1                	srli	a3,a3,0x30
    80003c98:	4725                	li	a4,9
    80003c9a:	0cd76263          	bltu	a4,a3,80003d5e <filewrite+0x12c>
    80003c9e:	0792                	slli	a5,a5,0x4
    80003ca0:	00015717          	auipc	a4,0x15
    80003ca4:	42870713          	addi	a4,a4,1064 # 800190c8 <devsw>
    80003ca8:	97ba                	add	a5,a5,a4
    80003caa:	679c                	ld	a5,8(a5)
    80003cac:	cbdd                	beqz	a5,80003d62 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cae:	4505                	li	a0,1
    80003cb0:	9782                	jalr	a5
    80003cb2:	8a2a                	mv	s4,a0
    80003cb4:	a8a5                	j	80003d2c <filewrite+0xfa>
    80003cb6:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003cba:	00000097          	auipc	ra,0x0
    80003cbe:	8b4080e7          	jalr	-1868(ra) # 8000356e <begin_op>
      ilock(f->ip);
    80003cc2:	01893503          	ld	a0,24(s2)
    80003cc6:	fffff097          	auipc	ra,0xfffff
    80003cca:	ecc080e7          	jalr	-308(ra) # 80002b92 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cce:	8756                	mv	a4,s5
    80003cd0:	02092683          	lw	a3,32(s2)
    80003cd4:	01698633          	add	a2,s3,s6
    80003cd8:	4585                	li	a1,1
    80003cda:	01893503          	ld	a0,24(s2)
    80003cde:	fffff097          	auipc	ra,0xfffff
    80003ce2:	260080e7          	jalr	608(ra) # 80002f3e <writei>
    80003ce6:	84aa                	mv	s1,a0
    80003ce8:	00a05763          	blez	a0,80003cf6 <filewrite+0xc4>
        f->off += r;
    80003cec:	02092783          	lw	a5,32(s2)
    80003cf0:	9fa9                	addw	a5,a5,a0
    80003cf2:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003cf6:	01893503          	ld	a0,24(s2)
    80003cfa:	fffff097          	auipc	ra,0xfffff
    80003cfe:	f5a080e7          	jalr	-166(ra) # 80002c54 <iunlock>
      end_op();
    80003d02:	00000097          	auipc	ra,0x0
    80003d06:	8ea080e7          	jalr	-1814(ra) # 800035ec <end_op>

      if(r != n1){
    80003d0a:	009a9f63          	bne	s5,s1,80003d28 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d0e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d12:	0149db63          	bge	s3,s4,80003d28 <filewrite+0xf6>
      int n1 = n - i;
    80003d16:	413a04bb          	subw	s1,s4,s3
    80003d1a:	0004879b          	sext.w	a5,s1
    80003d1e:	f8fbdce3          	bge	s7,a5,80003cb6 <filewrite+0x84>
    80003d22:	84e2                	mv	s1,s8
    80003d24:	bf49                	j	80003cb6 <filewrite+0x84>
    int i = 0;
    80003d26:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d28:	013a1f63          	bne	s4,s3,80003d46 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d2c:	8552                	mv	a0,s4
    80003d2e:	60a6                	ld	ra,72(sp)
    80003d30:	6406                	ld	s0,64(sp)
    80003d32:	74e2                	ld	s1,56(sp)
    80003d34:	7942                	ld	s2,48(sp)
    80003d36:	79a2                	ld	s3,40(sp)
    80003d38:	7a02                	ld	s4,32(sp)
    80003d3a:	6ae2                	ld	s5,24(sp)
    80003d3c:	6b42                	ld	s6,16(sp)
    80003d3e:	6ba2                	ld	s7,8(sp)
    80003d40:	6c02                	ld	s8,0(sp)
    80003d42:	6161                	addi	sp,sp,80
    80003d44:	8082                	ret
    ret = (i == n ? n : -1);
    80003d46:	5a7d                	li	s4,-1
    80003d48:	b7d5                	j	80003d2c <filewrite+0xfa>
    panic("filewrite");
    80003d4a:	00005517          	auipc	a0,0x5
    80003d4e:	a6e50513          	addi	a0,a0,-1426 # 800087b8 <syscall_names+0x270>
    80003d52:	00002097          	auipc	ra,0x2
    80003d56:	eae080e7          	jalr	-338(ra) # 80005c00 <panic>
    return -1;
    80003d5a:	5a7d                	li	s4,-1
    80003d5c:	bfc1                	j	80003d2c <filewrite+0xfa>
      return -1;
    80003d5e:	5a7d                	li	s4,-1
    80003d60:	b7f1                	j	80003d2c <filewrite+0xfa>
    80003d62:	5a7d                	li	s4,-1
    80003d64:	b7e1                	j	80003d2c <filewrite+0xfa>

0000000080003d66 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d66:	7179                	addi	sp,sp,-48
    80003d68:	f406                	sd	ra,40(sp)
    80003d6a:	f022                	sd	s0,32(sp)
    80003d6c:	ec26                	sd	s1,24(sp)
    80003d6e:	e84a                	sd	s2,16(sp)
    80003d70:	e44e                	sd	s3,8(sp)
    80003d72:	e052                	sd	s4,0(sp)
    80003d74:	1800                	addi	s0,sp,48
    80003d76:	84aa                	mv	s1,a0
    80003d78:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d7a:	0005b023          	sd	zero,0(a1)
    80003d7e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d82:	00000097          	auipc	ra,0x0
    80003d86:	bf8080e7          	jalr	-1032(ra) # 8000397a <filealloc>
    80003d8a:	e088                	sd	a0,0(s1)
    80003d8c:	c551                	beqz	a0,80003e18 <pipealloc+0xb2>
    80003d8e:	00000097          	auipc	ra,0x0
    80003d92:	bec080e7          	jalr	-1044(ra) # 8000397a <filealloc>
    80003d96:	00aa3023          	sd	a0,0(s4)
    80003d9a:	c92d                	beqz	a0,80003e0c <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d9c:	ffffc097          	auipc	ra,0xffffc
    80003da0:	37e080e7          	jalr	894(ra) # 8000011a <kalloc>
    80003da4:	892a                	mv	s2,a0
    80003da6:	c125                	beqz	a0,80003e06 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003da8:	4985                	li	s3,1
    80003daa:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dae:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003db2:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003db6:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003dba:	00004597          	auipc	a1,0x4
    80003dbe:	62658593          	addi	a1,a1,1574 # 800083e0 <states.0+0x1a0>
    80003dc2:	00002097          	auipc	ra,0x2
    80003dc6:	2e6080e7          	jalr	742(ra) # 800060a8 <initlock>
  (*f0)->type = FD_PIPE;
    80003dca:	609c                	ld	a5,0(s1)
    80003dcc:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003dd0:	609c                	ld	a5,0(s1)
    80003dd2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003dd6:	609c                	ld	a5,0(s1)
    80003dd8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003ddc:	609c                	ld	a5,0(s1)
    80003dde:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003de2:	000a3783          	ld	a5,0(s4)
    80003de6:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003dea:	000a3783          	ld	a5,0(s4)
    80003dee:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003df2:	000a3783          	ld	a5,0(s4)
    80003df6:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003dfa:	000a3783          	ld	a5,0(s4)
    80003dfe:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e02:	4501                	li	a0,0
    80003e04:	a025                	j	80003e2c <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e06:	6088                	ld	a0,0(s1)
    80003e08:	e501                	bnez	a0,80003e10 <pipealloc+0xaa>
    80003e0a:	a039                	j	80003e18 <pipealloc+0xb2>
    80003e0c:	6088                	ld	a0,0(s1)
    80003e0e:	c51d                	beqz	a0,80003e3c <pipealloc+0xd6>
    fileclose(*f0);
    80003e10:	00000097          	auipc	ra,0x0
    80003e14:	c26080e7          	jalr	-986(ra) # 80003a36 <fileclose>
  if(*f1)
    80003e18:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e1c:	557d                	li	a0,-1
  if(*f1)
    80003e1e:	c799                	beqz	a5,80003e2c <pipealloc+0xc6>
    fileclose(*f1);
    80003e20:	853e                	mv	a0,a5
    80003e22:	00000097          	auipc	ra,0x0
    80003e26:	c14080e7          	jalr	-1004(ra) # 80003a36 <fileclose>
  return -1;
    80003e2a:	557d                	li	a0,-1
}
    80003e2c:	70a2                	ld	ra,40(sp)
    80003e2e:	7402                	ld	s0,32(sp)
    80003e30:	64e2                	ld	s1,24(sp)
    80003e32:	6942                	ld	s2,16(sp)
    80003e34:	69a2                	ld	s3,8(sp)
    80003e36:	6a02                	ld	s4,0(sp)
    80003e38:	6145                	addi	sp,sp,48
    80003e3a:	8082                	ret
  return -1;
    80003e3c:	557d                	li	a0,-1
    80003e3e:	b7fd                	j	80003e2c <pipealloc+0xc6>

0000000080003e40 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e40:	1101                	addi	sp,sp,-32
    80003e42:	ec06                	sd	ra,24(sp)
    80003e44:	e822                	sd	s0,16(sp)
    80003e46:	e426                	sd	s1,8(sp)
    80003e48:	e04a                	sd	s2,0(sp)
    80003e4a:	1000                	addi	s0,sp,32
    80003e4c:	84aa                	mv	s1,a0
    80003e4e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e50:	00002097          	auipc	ra,0x2
    80003e54:	2e8080e7          	jalr	744(ra) # 80006138 <acquire>
  if(writable){
    80003e58:	02090d63          	beqz	s2,80003e92 <pipeclose+0x52>
    pi->writeopen = 0;
    80003e5c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e60:	21848513          	addi	a0,s1,536
    80003e64:	ffffe097          	auipc	ra,0xffffe
    80003e68:	85a080e7          	jalr	-1958(ra) # 800016be <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e6c:	2204b783          	ld	a5,544(s1)
    80003e70:	eb95                	bnez	a5,80003ea4 <pipeclose+0x64>
    release(&pi->lock);
    80003e72:	8526                	mv	a0,s1
    80003e74:	00002097          	auipc	ra,0x2
    80003e78:	378080e7          	jalr	888(ra) # 800061ec <release>
    kfree((char*)pi);
    80003e7c:	8526                	mv	a0,s1
    80003e7e:	ffffc097          	auipc	ra,0xffffc
    80003e82:	19e080e7          	jalr	414(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e86:	60e2                	ld	ra,24(sp)
    80003e88:	6442                	ld	s0,16(sp)
    80003e8a:	64a2                	ld	s1,8(sp)
    80003e8c:	6902                	ld	s2,0(sp)
    80003e8e:	6105                	addi	sp,sp,32
    80003e90:	8082                	ret
    pi->readopen = 0;
    80003e92:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e96:	21c48513          	addi	a0,s1,540
    80003e9a:	ffffe097          	auipc	ra,0xffffe
    80003e9e:	824080e7          	jalr	-2012(ra) # 800016be <wakeup>
    80003ea2:	b7e9                	j	80003e6c <pipeclose+0x2c>
    release(&pi->lock);
    80003ea4:	8526                	mv	a0,s1
    80003ea6:	00002097          	auipc	ra,0x2
    80003eaa:	346080e7          	jalr	838(ra) # 800061ec <release>
}
    80003eae:	bfe1                	j	80003e86 <pipeclose+0x46>

0000000080003eb0 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003eb0:	711d                	addi	sp,sp,-96
    80003eb2:	ec86                	sd	ra,88(sp)
    80003eb4:	e8a2                	sd	s0,80(sp)
    80003eb6:	e4a6                	sd	s1,72(sp)
    80003eb8:	e0ca                	sd	s2,64(sp)
    80003eba:	fc4e                	sd	s3,56(sp)
    80003ebc:	f852                	sd	s4,48(sp)
    80003ebe:	f456                	sd	s5,40(sp)
    80003ec0:	f05a                	sd	s6,32(sp)
    80003ec2:	ec5e                	sd	s7,24(sp)
    80003ec4:	e862                	sd	s8,16(sp)
    80003ec6:	1080                	addi	s0,sp,96
    80003ec8:	84aa                	mv	s1,a0
    80003eca:	8aae                	mv	s5,a1
    80003ecc:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ece:	ffffd097          	auipc	ra,0xffffd
    80003ed2:	f9a080e7          	jalr	-102(ra) # 80000e68 <myproc>
    80003ed6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003ed8:	8526                	mv	a0,s1
    80003eda:	00002097          	auipc	ra,0x2
    80003ede:	25e080e7          	jalr	606(ra) # 80006138 <acquire>
  while(i < n){
    80003ee2:	0b405363          	blez	s4,80003f88 <pipewrite+0xd8>
  int i = 0;
    80003ee6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ee8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003eea:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003eee:	21c48b93          	addi	s7,s1,540
    80003ef2:	a089                	j	80003f34 <pipewrite+0x84>
      release(&pi->lock);
    80003ef4:	8526                	mv	a0,s1
    80003ef6:	00002097          	auipc	ra,0x2
    80003efa:	2f6080e7          	jalr	758(ra) # 800061ec <release>
      return -1;
    80003efe:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f00:	854a                	mv	a0,s2
    80003f02:	60e6                	ld	ra,88(sp)
    80003f04:	6446                	ld	s0,80(sp)
    80003f06:	64a6                	ld	s1,72(sp)
    80003f08:	6906                	ld	s2,64(sp)
    80003f0a:	79e2                	ld	s3,56(sp)
    80003f0c:	7a42                	ld	s4,48(sp)
    80003f0e:	7aa2                	ld	s5,40(sp)
    80003f10:	7b02                	ld	s6,32(sp)
    80003f12:	6be2                	ld	s7,24(sp)
    80003f14:	6c42                	ld	s8,16(sp)
    80003f16:	6125                	addi	sp,sp,96
    80003f18:	8082                	ret
      wakeup(&pi->nread);
    80003f1a:	8562                	mv	a0,s8
    80003f1c:	ffffd097          	auipc	ra,0xffffd
    80003f20:	7a2080e7          	jalr	1954(ra) # 800016be <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f24:	85a6                	mv	a1,s1
    80003f26:	855e                	mv	a0,s7
    80003f28:	ffffd097          	auipc	ra,0xffffd
    80003f2c:	60a080e7          	jalr	1546(ra) # 80001532 <sleep>
  while(i < n){
    80003f30:	05495d63          	bge	s2,s4,80003f8a <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80003f34:	2204a783          	lw	a5,544(s1)
    80003f38:	dfd5                	beqz	a5,80003ef4 <pipewrite+0x44>
    80003f3a:	0289a783          	lw	a5,40(s3)
    80003f3e:	fbdd                	bnez	a5,80003ef4 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f40:	2184a783          	lw	a5,536(s1)
    80003f44:	21c4a703          	lw	a4,540(s1)
    80003f48:	2007879b          	addiw	a5,a5,512
    80003f4c:	fcf707e3          	beq	a4,a5,80003f1a <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f50:	4685                	li	a3,1
    80003f52:	01590633          	add	a2,s2,s5
    80003f56:	faf40593          	addi	a1,s0,-81
    80003f5a:	0509b503          	ld	a0,80(s3)
    80003f5e:	ffffd097          	auipc	ra,0xffffd
    80003f62:	c5a080e7          	jalr	-934(ra) # 80000bb8 <copyin>
    80003f66:	03650263          	beq	a0,s6,80003f8a <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f6a:	21c4a783          	lw	a5,540(s1)
    80003f6e:	0017871b          	addiw	a4,a5,1
    80003f72:	20e4ae23          	sw	a4,540(s1)
    80003f76:	1ff7f793          	andi	a5,a5,511
    80003f7a:	97a6                	add	a5,a5,s1
    80003f7c:	faf44703          	lbu	a4,-81(s0)
    80003f80:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f84:	2905                	addiw	s2,s2,1
    80003f86:	b76d                	j	80003f30 <pipewrite+0x80>
  int i = 0;
    80003f88:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003f8a:	21848513          	addi	a0,s1,536
    80003f8e:	ffffd097          	auipc	ra,0xffffd
    80003f92:	730080e7          	jalr	1840(ra) # 800016be <wakeup>
  release(&pi->lock);
    80003f96:	8526                	mv	a0,s1
    80003f98:	00002097          	auipc	ra,0x2
    80003f9c:	254080e7          	jalr	596(ra) # 800061ec <release>
  return i;
    80003fa0:	b785                	j	80003f00 <pipewrite+0x50>

0000000080003fa2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fa2:	715d                	addi	sp,sp,-80
    80003fa4:	e486                	sd	ra,72(sp)
    80003fa6:	e0a2                	sd	s0,64(sp)
    80003fa8:	fc26                	sd	s1,56(sp)
    80003faa:	f84a                	sd	s2,48(sp)
    80003fac:	f44e                	sd	s3,40(sp)
    80003fae:	f052                	sd	s4,32(sp)
    80003fb0:	ec56                	sd	s5,24(sp)
    80003fb2:	e85a                	sd	s6,16(sp)
    80003fb4:	0880                	addi	s0,sp,80
    80003fb6:	84aa                	mv	s1,a0
    80003fb8:	892e                	mv	s2,a1
    80003fba:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fbc:	ffffd097          	auipc	ra,0xffffd
    80003fc0:	eac080e7          	jalr	-340(ra) # 80000e68 <myproc>
    80003fc4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003fc6:	8526                	mv	a0,s1
    80003fc8:	00002097          	auipc	ra,0x2
    80003fcc:	170080e7          	jalr	368(ra) # 80006138 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fd0:	2184a703          	lw	a4,536(s1)
    80003fd4:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fd8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fdc:	02f71463          	bne	a4,a5,80004004 <piperead+0x62>
    80003fe0:	2244a783          	lw	a5,548(s1)
    80003fe4:	c385                	beqz	a5,80004004 <piperead+0x62>
    if(pr->killed){
    80003fe6:	028a2783          	lw	a5,40(s4)
    80003fea:	ebc9                	bnez	a5,8000407c <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fec:	85a6                	mv	a1,s1
    80003fee:	854e                	mv	a0,s3
    80003ff0:	ffffd097          	auipc	ra,0xffffd
    80003ff4:	542080e7          	jalr	1346(ra) # 80001532 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ff8:	2184a703          	lw	a4,536(s1)
    80003ffc:	21c4a783          	lw	a5,540(s1)
    80004000:	fef700e3          	beq	a4,a5,80003fe0 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004004:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004006:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004008:	05505463          	blez	s5,80004050 <piperead+0xae>
    if(pi->nread == pi->nwrite)
    8000400c:	2184a783          	lw	a5,536(s1)
    80004010:	21c4a703          	lw	a4,540(s1)
    80004014:	02f70e63          	beq	a4,a5,80004050 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004018:	0017871b          	addiw	a4,a5,1
    8000401c:	20e4ac23          	sw	a4,536(s1)
    80004020:	1ff7f793          	andi	a5,a5,511
    80004024:	97a6                	add	a5,a5,s1
    80004026:	0187c783          	lbu	a5,24(a5)
    8000402a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000402e:	4685                	li	a3,1
    80004030:	fbf40613          	addi	a2,s0,-65
    80004034:	85ca                	mv	a1,s2
    80004036:	050a3503          	ld	a0,80(s4)
    8000403a:	ffffd097          	auipc	ra,0xffffd
    8000403e:	af2080e7          	jalr	-1294(ra) # 80000b2c <copyout>
    80004042:	01650763          	beq	a0,s6,80004050 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004046:	2985                	addiw	s3,s3,1
    80004048:	0905                	addi	s2,s2,1
    8000404a:	fd3a91e3          	bne	s5,s3,8000400c <piperead+0x6a>
    8000404e:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004050:	21c48513          	addi	a0,s1,540
    80004054:	ffffd097          	auipc	ra,0xffffd
    80004058:	66a080e7          	jalr	1642(ra) # 800016be <wakeup>
  release(&pi->lock);
    8000405c:	8526                	mv	a0,s1
    8000405e:	00002097          	auipc	ra,0x2
    80004062:	18e080e7          	jalr	398(ra) # 800061ec <release>
  return i;
}
    80004066:	854e                	mv	a0,s3
    80004068:	60a6                	ld	ra,72(sp)
    8000406a:	6406                	ld	s0,64(sp)
    8000406c:	74e2                	ld	s1,56(sp)
    8000406e:	7942                	ld	s2,48(sp)
    80004070:	79a2                	ld	s3,40(sp)
    80004072:	7a02                	ld	s4,32(sp)
    80004074:	6ae2                	ld	s5,24(sp)
    80004076:	6b42                	ld	s6,16(sp)
    80004078:	6161                	addi	sp,sp,80
    8000407a:	8082                	ret
      release(&pi->lock);
    8000407c:	8526                	mv	a0,s1
    8000407e:	00002097          	auipc	ra,0x2
    80004082:	16e080e7          	jalr	366(ra) # 800061ec <release>
      return -1;
    80004086:	59fd                	li	s3,-1
    80004088:	bff9                	j	80004066 <piperead+0xc4>

000000008000408a <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000408a:	de010113          	addi	sp,sp,-544
    8000408e:	20113c23          	sd	ra,536(sp)
    80004092:	20813823          	sd	s0,528(sp)
    80004096:	20913423          	sd	s1,520(sp)
    8000409a:	21213023          	sd	s2,512(sp)
    8000409e:	ffce                	sd	s3,504(sp)
    800040a0:	fbd2                	sd	s4,496(sp)
    800040a2:	f7d6                	sd	s5,488(sp)
    800040a4:	f3da                	sd	s6,480(sp)
    800040a6:	efde                	sd	s7,472(sp)
    800040a8:	ebe2                	sd	s8,464(sp)
    800040aa:	e7e6                	sd	s9,456(sp)
    800040ac:	e3ea                	sd	s10,448(sp)
    800040ae:	ff6e                	sd	s11,440(sp)
    800040b0:	1400                	addi	s0,sp,544
    800040b2:	892a                	mv	s2,a0
    800040b4:	dea43423          	sd	a0,-536(s0)
    800040b8:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040bc:	ffffd097          	auipc	ra,0xffffd
    800040c0:	dac080e7          	jalr	-596(ra) # 80000e68 <myproc>
    800040c4:	84aa                	mv	s1,a0

  begin_op();
    800040c6:	fffff097          	auipc	ra,0xfffff
    800040ca:	4a8080e7          	jalr	1192(ra) # 8000356e <begin_op>
   
  if((ip = namei(path)) == 0){
    800040ce:	854a                	mv	a0,s2
    800040d0:	fffff097          	auipc	ra,0xfffff
    800040d4:	27e080e7          	jalr	638(ra) # 8000334e <namei>
    800040d8:	c93d                	beqz	a0,8000414e <exec+0xc4>
    800040da:	8aaa                	mv	s5,a0
    end_op();
    return -1;

  }
  ilock(ip);
    800040dc:	fffff097          	auipc	ra,0xfffff
    800040e0:	ab6080e7          	jalr	-1354(ra) # 80002b92 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800040e4:	04000713          	li	a4,64
    800040e8:	4681                	li	a3,0
    800040ea:	e5040613          	addi	a2,s0,-432
    800040ee:	4581                	li	a1,0
    800040f0:	8556                	mv	a0,s5
    800040f2:	fffff097          	auipc	ra,0xfffff
    800040f6:	d54080e7          	jalr	-684(ra) # 80002e46 <readi>
    800040fa:	04000793          	li	a5,64
    800040fe:	00f51a63          	bne	a0,a5,80004112 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004102:	e5042703          	lw	a4,-432(s0)
    80004106:	464c47b7          	lui	a5,0x464c4
    8000410a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000410e:	04f70663          	beq	a4,a5,8000415a <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004112:	8556                	mv	a0,s5
    80004114:	fffff097          	auipc	ra,0xfffff
    80004118:	ce0080e7          	jalr	-800(ra) # 80002df4 <iunlockput>
    end_op();
    8000411c:	fffff097          	auipc	ra,0xfffff
    80004120:	4d0080e7          	jalr	1232(ra) # 800035ec <end_op>
  }
  return -1;
    80004124:	557d                	li	a0,-1
}
    80004126:	21813083          	ld	ra,536(sp)
    8000412a:	21013403          	ld	s0,528(sp)
    8000412e:	20813483          	ld	s1,520(sp)
    80004132:	20013903          	ld	s2,512(sp)
    80004136:	79fe                	ld	s3,504(sp)
    80004138:	7a5e                	ld	s4,496(sp)
    8000413a:	7abe                	ld	s5,488(sp)
    8000413c:	7b1e                	ld	s6,480(sp)
    8000413e:	6bfe                	ld	s7,472(sp)
    80004140:	6c5e                	ld	s8,464(sp)
    80004142:	6cbe                	ld	s9,456(sp)
    80004144:	6d1e                	ld	s10,448(sp)
    80004146:	7dfa                	ld	s11,440(sp)
    80004148:	22010113          	addi	sp,sp,544
    8000414c:	8082                	ret
    end_op();
    8000414e:	fffff097          	auipc	ra,0xfffff
    80004152:	49e080e7          	jalr	1182(ra) # 800035ec <end_op>
    return -1;
    80004156:	557d                	li	a0,-1
    80004158:	b7f9                	j	80004126 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    8000415a:	8526                	mv	a0,s1
    8000415c:	ffffd097          	auipc	ra,0xffffd
    80004160:	dd0080e7          	jalr	-560(ra) # 80000f2c <proc_pagetable>
    80004164:	8b2a                	mv	s6,a0
    80004166:	d555                	beqz	a0,80004112 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004168:	e7042783          	lw	a5,-400(s0)
    8000416c:	e8845703          	lhu	a4,-376(s0)
    80004170:	c735                	beqz	a4,800041dc <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004172:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004174:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    80004178:	6a05                	lui	s4,0x1
    8000417a:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000417e:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004182:	6d85                	lui	s11,0x1
    80004184:	7d7d                	lui	s10,0xfffff
    80004186:	ac1d                	j	800043bc <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004188:	00004517          	auipc	a0,0x4
    8000418c:	64050513          	addi	a0,a0,1600 # 800087c8 <syscall_names+0x280>
    80004190:	00002097          	auipc	ra,0x2
    80004194:	a70080e7          	jalr	-1424(ra) # 80005c00 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004198:	874a                	mv	a4,s2
    8000419a:	009c86bb          	addw	a3,s9,s1
    8000419e:	4581                	li	a1,0
    800041a0:	8556                	mv	a0,s5
    800041a2:	fffff097          	auipc	ra,0xfffff
    800041a6:	ca4080e7          	jalr	-860(ra) # 80002e46 <readi>
    800041aa:	2501                	sext.w	a0,a0
    800041ac:	1aa91863          	bne	s2,a0,8000435c <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    800041b0:	009d84bb          	addw	s1,s11,s1
    800041b4:	013d09bb          	addw	s3,s10,s3
    800041b8:	1f74f263          	bgeu	s1,s7,8000439c <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    800041bc:	02049593          	slli	a1,s1,0x20
    800041c0:	9181                	srli	a1,a1,0x20
    800041c2:	95e2                	add	a1,a1,s8
    800041c4:	855a                	mv	a0,s6
    800041c6:	ffffc097          	auipc	ra,0xffffc
    800041ca:	35e080e7          	jalr	862(ra) # 80000524 <walkaddr>
    800041ce:	862a                	mv	a2,a0
    if(pa == 0)
    800041d0:	dd45                	beqz	a0,80004188 <exec+0xfe>
      n = PGSIZE;
    800041d2:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800041d4:	fd49f2e3          	bgeu	s3,s4,80004198 <exec+0x10e>
      n = sz - i;
    800041d8:	894e                	mv	s2,s3
    800041da:	bf7d                	j	80004198 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041dc:	4481                	li	s1,0
  iunlockput(ip);
    800041de:	8556                	mv	a0,s5
    800041e0:	fffff097          	auipc	ra,0xfffff
    800041e4:	c14080e7          	jalr	-1004(ra) # 80002df4 <iunlockput>
  end_op();
    800041e8:	fffff097          	auipc	ra,0xfffff
    800041ec:	404080e7          	jalr	1028(ra) # 800035ec <end_op>
  p = myproc();
    800041f0:	ffffd097          	auipc	ra,0xffffd
    800041f4:	c78080e7          	jalr	-904(ra) # 80000e68 <myproc>
    800041f8:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800041fa:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800041fe:	6785                	lui	a5,0x1
    80004200:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004202:	97a6                	add	a5,a5,s1
    80004204:	777d                	lui	a4,0xfffff
    80004206:	8ff9                	and	a5,a5,a4
    80004208:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000420c:	6609                	lui	a2,0x2
    8000420e:	963e                	add	a2,a2,a5
    80004210:	85be                	mv	a1,a5
    80004212:	855a                	mv	a0,s6
    80004214:	ffffc097          	auipc	ra,0xffffc
    80004218:	6c4080e7          	jalr	1732(ra) # 800008d8 <uvmalloc>
    8000421c:	8c2a                	mv	s8,a0
  ip = 0;
    8000421e:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004220:	12050e63          	beqz	a0,8000435c <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004224:	75f9                	lui	a1,0xffffe
    80004226:	95aa                	add	a1,a1,a0
    80004228:	855a                	mv	a0,s6
    8000422a:	ffffd097          	auipc	ra,0xffffd
    8000422e:	8d0080e7          	jalr	-1840(ra) # 80000afa <uvmclear>
  stackbase = sp - PGSIZE;
    80004232:	7afd                	lui	s5,0xfffff
    80004234:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004236:	df043783          	ld	a5,-528(s0)
    8000423a:	6388                	ld	a0,0(a5)
    8000423c:	c925                	beqz	a0,800042ac <exec+0x222>
    8000423e:	e9040993          	addi	s3,s0,-368
    80004242:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004246:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004248:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000424a:	ffffc097          	auipc	ra,0xffffc
    8000424e:	0d0080e7          	jalr	208(ra) # 8000031a <strlen>
    80004252:	0015079b          	addiw	a5,a0,1
    80004256:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000425a:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000425e:	13596363          	bltu	s2,s5,80004384 <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004262:	df043d83          	ld	s11,-528(s0)
    80004266:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000426a:	8552                	mv	a0,s4
    8000426c:	ffffc097          	auipc	ra,0xffffc
    80004270:	0ae080e7          	jalr	174(ra) # 8000031a <strlen>
    80004274:	0015069b          	addiw	a3,a0,1
    80004278:	8652                	mv	a2,s4
    8000427a:	85ca                	mv	a1,s2
    8000427c:	855a                	mv	a0,s6
    8000427e:	ffffd097          	auipc	ra,0xffffd
    80004282:	8ae080e7          	jalr	-1874(ra) # 80000b2c <copyout>
    80004286:	10054363          	bltz	a0,8000438c <exec+0x302>
    ustack[argc] = sp;
    8000428a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000428e:	0485                	addi	s1,s1,1
    80004290:	008d8793          	addi	a5,s11,8
    80004294:	def43823          	sd	a5,-528(s0)
    80004298:	008db503          	ld	a0,8(s11)
    8000429c:	c911                	beqz	a0,800042b0 <exec+0x226>
    if(argc >= MAXARG)
    8000429e:	09a1                	addi	s3,s3,8
    800042a0:	fb3c95e3          	bne	s9,s3,8000424a <exec+0x1c0>
  sz = sz1;
    800042a4:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042a8:	4a81                	li	s5,0
    800042aa:	a84d                	j	8000435c <exec+0x2d2>
  sp = sz;
    800042ac:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800042ae:	4481                	li	s1,0
  ustack[argc] = 0;
    800042b0:	00349793          	slli	a5,s1,0x3
    800042b4:	f9078793          	addi	a5,a5,-112
    800042b8:	97a2                	add	a5,a5,s0
    800042ba:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800042be:	00148693          	addi	a3,s1,1
    800042c2:	068e                	slli	a3,a3,0x3
    800042c4:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800042c8:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800042cc:	01597663          	bgeu	s2,s5,800042d8 <exec+0x24e>
  sz = sz1;
    800042d0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042d4:	4a81                	li	s5,0
    800042d6:	a059                	j	8000435c <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800042d8:	e9040613          	addi	a2,s0,-368
    800042dc:	85ca                	mv	a1,s2
    800042de:	855a                	mv	a0,s6
    800042e0:	ffffd097          	auipc	ra,0xffffd
    800042e4:	84c080e7          	jalr	-1972(ra) # 80000b2c <copyout>
    800042e8:	0a054663          	bltz	a0,80004394 <exec+0x30a>
  p->trapframe->a1 = sp;
    800042ec:	058bb783          	ld	a5,88(s7)
    800042f0:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800042f4:	de843783          	ld	a5,-536(s0)
    800042f8:	0007c703          	lbu	a4,0(a5)
    800042fc:	cf11                	beqz	a4,80004318 <exec+0x28e>
    800042fe:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004300:	02f00693          	li	a3,47
    80004304:	a039                	j	80004312 <exec+0x288>
      last = s+1;
    80004306:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    8000430a:	0785                	addi	a5,a5,1
    8000430c:	fff7c703          	lbu	a4,-1(a5)
    80004310:	c701                	beqz	a4,80004318 <exec+0x28e>
    if(*s == '/')
    80004312:	fed71ce3          	bne	a4,a3,8000430a <exec+0x280>
    80004316:	bfc5                	j	80004306 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004318:	4641                	li	a2,16
    8000431a:	de843583          	ld	a1,-536(s0)
    8000431e:	158b8513          	addi	a0,s7,344
    80004322:	ffffc097          	auipc	ra,0xffffc
    80004326:	fc6080e7          	jalr	-58(ra) # 800002e8 <safestrcpy>
  oldpagetable = p->pagetable;
    8000432a:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    8000432e:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004332:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004336:	058bb783          	ld	a5,88(s7)
    8000433a:	e6843703          	ld	a4,-408(s0)
    8000433e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004340:	058bb783          	ld	a5,88(s7)
    80004344:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004348:	85ea                	mv	a1,s10
    8000434a:	ffffd097          	auipc	ra,0xffffd
    8000434e:	c7e080e7          	jalr	-898(ra) # 80000fc8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004352:	0004851b          	sext.w	a0,s1
    80004356:	bbc1                	j	80004126 <exec+0x9c>
    80004358:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000435c:	df843583          	ld	a1,-520(s0)
    80004360:	855a                	mv	a0,s6
    80004362:	ffffd097          	auipc	ra,0xffffd
    80004366:	c66080e7          	jalr	-922(ra) # 80000fc8 <proc_freepagetable>
  if(ip){
    8000436a:	da0a94e3          	bnez	s5,80004112 <exec+0x88>
  return -1;
    8000436e:	557d                	li	a0,-1
    80004370:	bb5d                	j	80004126 <exec+0x9c>
    80004372:	de943c23          	sd	s1,-520(s0)
    80004376:	b7dd                	j	8000435c <exec+0x2d2>
    80004378:	de943c23          	sd	s1,-520(s0)
    8000437c:	b7c5                	j	8000435c <exec+0x2d2>
    8000437e:	de943c23          	sd	s1,-520(s0)
    80004382:	bfe9                	j	8000435c <exec+0x2d2>
  sz = sz1;
    80004384:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004388:	4a81                	li	s5,0
    8000438a:	bfc9                	j	8000435c <exec+0x2d2>
  sz = sz1;
    8000438c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004390:	4a81                	li	s5,0
    80004392:	b7e9                	j	8000435c <exec+0x2d2>
  sz = sz1;
    80004394:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004398:	4a81                	li	s5,0
    8000439a:	b7c9                	j	8000435c <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000439c:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043a0:	e0843783          	ld	a5,-504(s0)
    800043a4:	0017869b          	addiw	a3,a5,1
    800043a8:	e0d43423          	sd	a3,-504(s0)
    800043ac:	e0043783          	ld	a5,-512(s0)
    800043b0:	0387879b          	addiw	a5,a5,56
    800043b4:	e8845703          	lhu	a4,-376(s0)
    800043b8:	e2e6d3e3          	bge	a3,a4,800041de <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043bc:	2781                	sext.w	a5,a5
    800043be:	e0f43023          	sd	a5,-512(s0)
    800043c2:	03800713          	li	a4,56
    800043c6:	86be                	mv	a3,a5
    800043c8:	e1840613          	addi	a2,s0,-488
    800043cc:	4581                	li	a1,0
    800043ce:	8556                	mv	a0,s5
    800043d0:	fffff097          	auipc	ra,0xfffff
    800043d4:	a76080e7          	jalr	-1418(ra) # 80002e46 <readi>
    800043d8:	03800793          	li	a5,56
    800043dc:	f6f51ee3          	bne	a0,a5,80004358 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    800043e0:	e1842783          	lw	a5,-488(s0)
    800043e4:	4705                	li	a4,1
    800043e6:	fae79de3          	bne	a5,a4,800043a0 <exec+0x316>
    if(ph.memsz < ph.filesz)
    800043ea:	e4043603          	ld	a2,-448(s0)
    800043ee:	e3843783          	ld	a5,-456(s0)
    800043f2:	f8f660e3          	bltu	a2,a5,80004372 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800043f6:	e2843783          	ld	a5,-472(s0)
    800043fa:	963e                	add	a2,a2,a5
    800043fc:	f6f66ee3          	bltu	a2,a5,80004378 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004400:	85a6                	mv	a1,s1
    80004402:	855a                	mv	a0,s6
    80004404:	ffffc097          	auipc	ra,0xffffc
    80004408:	4d4080e7          	jalr	1236(ra) # 800008d8 <uvmalloc>
    8000440c:	dea43c23          	sd	a0,-520(s0)
    80004410:	d53d                	beqz	a0,8000437e <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    80004412:	e2843c03          	ld	s8,-472(s0)
    80004416:	de043783          	ld	a5,-544(s0)
    8000441a:	00fc77b3          	and	a5,s8,a5
    8000441e:	ff9d                	bnez	a5,8000435c <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004420:	e2042c83          	lw	s9,-480(s0)
    80004424:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004428:	f60b8ae3          	beqz	s7,8000439c <exec+0x312>
    8000442c:	89de                	mv	s3,s7
    8000442e:	4481                	li	s1,0
    80004430:	b371                	j	800041bc <exec+0x132>

0000000080004432 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004432:	7179                	addi	sp,sp,-48
    80004434:	f406                	sd	ra,40(sp)
    80004436:	f022                	sd	s0,32(sp)
    80004438:	ec26                	sd	s1,24(sp)
    8000443a:	e84a                	sd	s2,16(sp)
    8000443c:	1800                	addi	s0,sp,48
    8000443e:	892e                	mv	s2,a1
    80004440:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004442:	fdc40593          	addi	a1,s0,-36
    80004446:	ffffe097          	auipc	ra,0xffffe
    8000444a:	b0c080e7          	jalr	-1268(ra) # 80001f52 <argint>
    8000444e:	04054063          	bltz	a0,8000448e <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004452:	fdc42703          	lw	a4,-36(s0)
    80004456:	47bd                	li	a5,15
    80004458:	02e7ed63          	bltu	a5,a4,80004492 <argfd+0x60>
    8000445c:	ffffd097          	auipc	ra,0xffffd
    80004460:	a0c080e7          	jalr	-1524(ra) # 80000e68 <myproc>
    80004464:	fdc42703          	lw	a4,-36(s0)
    80004468:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffd8dda>
    8000446c:	078e                	slli	a5,a5,0x3
    8000446e:	953e                	add	a0,a0,a5
    80004470:	611c                	ld	a5,0(a0)
    80004472:	c395                	beqz	a5,80004496 <argfd+0x64>
    return -1;
  if(pfd)
    80004474:	00090463          	beqz	s2,8000447c <argfd+0x4a>
    *pfd = fd;
    80004478:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000447c:	4501                	li	a0,0
  if(pf)
    8000447e:	c091                	beqz	s1,80004482 <argfd+0x50>
    *pf = f;
    80004480:	e09c                	sd	a5,0(s1)
}
    80004482:	70a2                	ld	ra,40(sp)
    80004484:	7402                	ld	s0,32(sp)
    80004486:	64e2                	ld	s1,24(sp)
    80004488:	6942                	ld	s2,16(sp)
    8000448a:	6145                	addi	sp,sp,48
    8000448c:	8082                	ret
    return -1;
    8000448e:	557d                	li	a0,-1
    80004490:	bfcd                	j	80004482 <argfd+0x50>
    return -1;
    80004492:	557d                	li	a0,-1
    80004494:	b7fd                	j	80004482 <argfd+0x50>
    80004496:	557d                	li	a0,-1
    80004498:	b7ed                	j	80004482 <argfd+0x50>

000000008000449a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000449a:	1101                	addi	sp,sp,-32
    8000449c:	ec06                	sd	ra,24(sp)
    8000449e:	e822                	sd	s0,16(sp)
    800044a0:	e426                	sd	s1,8(sp)
    800044a2:	1000                	addi	s0,sp,32
    800044a4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044a6:	ffffd097          	auipc	ra,0xffffd
    800044aa:	9c2080e7          	jalr	-1598(ra) # 80000e68 <myproc>
    800044ae:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044b0:	0d050793          	addi	a5,a0,208
    800044b4:	4501                	li	a0,0
    800044b6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044b8:	6398                	ld	a4,0(a5)
    800044ba:	cb19                	beqz	a4,800044d0 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044bc:	2505                	addiw	a0,a0,1
    800044be:	07a1                	addi	a5,a5,8
    800044c0:	fed51ce3          	bne	a0,a3,800044b8 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044c4:	557d                	li	a0,-1
}
    800044c6:	60e2                	ld	ra,24(sp)
    800044c8:	6442                	ld	s0,16(sp)
    800044ca:	64a2                	ld	s1,8(sp)
    800044cc:	6105                	addi	sp,sp,32
    800044ce:	8082                	ret
      p->ofile[fd] = f;
    800044d0:	01a50793          	addi	a5,a0,26
    800044d4:	078e                	slli	a5,a5,0x3
    800044d6:	963e                	add	a2,a2,a5
    800044d8:	e204                	sd	s1,0(a2)
      return fd;
    800044da:	b7f5                	j	800044c6 <fdalloc+0x2c>

00000000800044dc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800044dc:	715d                	addi	sp,sp,-80
    800044de:	e486                	sd	ra,72(sp)
    800044e0:	e0a2                	sd	s0,64(sp)
    800044e2:	fc26                	sd	s1,56(sp)
    800044e4:	f84a                	sd	s2,48(sp)
    800044e6:	f44e                	sd	s3,40(sp)
    800044e8:	f052                	sd	s4,32(sp)
    800044ea:	ec56                	sd	s5,24(sp)
    800044ec:	0880                	addi	s0,sp,80
    800044ee:	89ae                	mv	s3,a1
    800044f0:	8ab2                	mv	s5,a2
    800044f2:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800044f4:	fb040593          	addi	a1,s0,-80
    800044f8:	fffff097          	auipc	ra,0xfffff
    800044fc:	e74080e7          	jalr	-396(ra) # 8000336c <nameiparent>
    80004500:	892a                	mv	s2,a0
    80004502:	12050e63          	beqz	a0,8000463e <create+0x162>
    return 0;

  ilock(dp);
    80004506:	ffffe097          	auipc	ra,0xffffe
    8000450a:	68c080e7          	jalr	1676(ra) # 80002b92 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000450e:	4601                	li	a2,0
    80004510:	fb040593          	addi	a1,s0,-80
    80004514:	854a                	mv	a0,s2
    80004516:	fffff097          	auipc	ra,0xfffff
    8000451a:	b60080e7          	jalr	-1184(ra) # 80003076 <dirlookup>
    8000451e:	84aa                	mv	s1,a0
    80004520:	c921                	beqz	a0,80004570 <create+0x94>
    iunlockput(dp);
    80004522:	854a                	mv	a0,s2
    80004524:	fffff097          	auipc	ra,0xfffff
    80004528:	8d0080e7          	jalr	-1840(ra) # 80002df4 <iunlockput>
    ilock(ip);
    8000452c:	8526                	mv	a0,s1
    8000452e:	ffffe097          	auipc	ra,0xffffe
    80004532:	664080e7          	jalr	1636(ra) # 80002b92 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004536:	2981                	sext.w	s3,s3
    80004538:	4789                	li	a5,2
    8000453a:	02f99463          	bne	s3,a5,80004562 <create+0x86>
    8000453e:	0444d783          	lhu	a5,68(s1)
    80004542:	37f9                	addiw	a5,a5,-2
    80004544:	17c2                	slli	a5,a5,0x30
    80004546:	93c1                	srli	a5,a5,0x30
    80004548:	4705                	li	a4,1
    8000454a:	00f76c63          	bltu	a4,a5,80004562 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000454e:	8526                	mv	a0,s1
    80004550:	60a6                	ld	ra,72(sp)
    80004552:	6406                	ld	s0,64(sp)
    80004554:	74e2                	ld	s1,56(sp)
    80004556:	7942                	ld	s2,48(sp)
    80004558:	79a2                	ld	s3,40(sp)
    8000455a:	7a02                	ld	s4,32(sp)
    8000455c:	6ae2                	ld	s5,24(sp)
    8000455e:	6161                	addi	sp,sp,80
    80004560:	8082                	ret
    iunlockput(ip);
    80004562:	8526                	mv	a0,s1
    80004564:	fffff097          	auipc	ra,0xfffff
    80004568:	890080e7          	jalr	-1904(ra) # 80002df4 <iunlockput>
    return 0;
    8000456c:	4481                	li	s1,0
    8000456e:	b7c5                	j	8000454e <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004570:	85ce                	mv	a1,s3
    80004572:	00092503          	lw	a0,0(s2)
    80004576:	ffffe097          	auipc	ra,0xffffe
    8000457a:	482080e7          	jalr	1154(ra) # 800029f8 <ialloc>
    8000457e:	84aa                	mv	s1,a0
    80004580:	c521                	beqz	a0,800045c8 <create+0xec>
  ilock(ip);
    80004582:	ffffe097          	auipc	ra,0xffffe
    80004586:	610080e7          	jalr	1552(ra) # 80002b92 <ilock>
  ip->major = major;
    8000458a:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000458e:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004592:	4a05                	li	s4,1
    80004594:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80004598:	8526                	mv	a0,s1
    8000459a:	ffffe097          	auipc	ra,0xffffe
    8000459e:	52c080e7          	jalr	1324(ra) # 80002ac6 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045a2:	2981                	sext.w	s3,s3
    800045a4:	03498a63          	beq	s3,s4,800045d8 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800045a8:	40d0                	lw	a2,4(s1)
    800045aa:	fb040593          	addi	a1,s0,-80
    800045ae:	854a                	mv	a0,s2
    800045b0:	fffff097          	auipc	ra,0xfffff
    800045b4:	cdc080e7          	jalr	-804(ra) # 8000328c <dirlink>
    800045b8:	06054b63          	bltz	a0,8000462e <create+0x152>
  iunlockput(dp);
    800045bc:	854a                	mv	a0,s2
    800045be:	fffff097          	auipc	ra,0xfffff
    800045c2:	836080e7          	jalr	-1994(ra) # 80002df4 <iunlockput>
  return ip;
    800045c6:	b761                	j	8000454e <create+0x72>
    panic("create: ialloc");
    800045c8:	00004517          	auipc	a0,0x4
    800045cc:	22050513          	addi	a0,a0,544 # 800087e8 <syscall_names+0x2a0>
    800045d0:	00001097          	auipc	ra,0x1
    800045d4:	630080e7          	jalr	1584(ra) # 80005c00 <panic>
    dp->nlink++;  // for ".."
    800045d8:	04a95783          	lhu	a5,74(s2)
    800045dc:	2785                	addiw	a5,a5,1
    800045de:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800045e2:	854a                	mv	a0,s2
    800045e4:	ffffe097          	auipc	ra,0xffffe
    800045e8:	4e2080e7          	jalr	1250(ra) # 80002ac6 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800045ec:	40d0                	lw	a2,4(s1)
    800045ee:	00004597          	auipc	a1,0x4
    800045f2:	20a58593          	addi	a1,a1,522 # 800087f8 <syscall_names+0x2b0>
    800045f6:	8526                	mv	a0,s1
    800045f8:	fffff097          	auipc	ra,0xfffff
    800045fc:	c94080e7          	jalr	-876(ra) # 8000328c <dirlink>
    80004600:	00054f63          	bltz	a0,8000461e <create+0x142>
    80004604:	00492603          	lw	a2,4(s2)
    80004608:	00004597          	auipc	a1,0x4
    8000460c:	1f858593          	addi	a1,a1,504 # 80008800 <syscall_names+0x2b8>
    80004610:	8526                	mv	a0,s1
    80004612:	fffff097          	auipc	ra,0xfffff
    80004616:	c7a080e7          	jalr	-902(ra) # 8000328c <dirlink>
    8000461a:	f80557e3          	bgez	a0,800045a8 <create+0xcc>
      panic("create dots");
    8000461e:	00004517          	auipc	a0,0x4
    80004622:	1ea50513          	addi	a0,a0,490 # 80008808 <syscall_names+0x2c0>
    80004626:	00001097          	auipc	ra,0x1
    8000462a:	5da080e7          	jalr	1498(ra) # 80005c00 <panic>
    panic("create: dirlink");
    8000462e:	00004517          	auipc	a0,0x4
    80004632:	1ea50513          	addi	a0,a0,490 # 80008818 <syscall_names+0x2d0>
    80004636:	00001097          	auipc	ra,0x1
    8000463a:	5ca080e7          	jalr	1482(ra) # 80005c00 <panic>
    return 0;
    8000463e:	84aa                	mv	s1,a0
    80004640:	b739                	j	8000454e <create+0x72>

0000000080004642 <sys_dup>:
{
    80004642:	7179                	addi	sp,sp,-48
    80004644:	f406                	sd	ra,40(sp)
    80004646:	f022                	sd	s0,32(sp)
    80004648:	ec26                	sd	s1,24(sp)
    8000464a:	e84a                	sd	s2,16(sp)
    8000464c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000464e:	fd840613          	addi	a2,s0,-40
    80004652:	4581                	li	a1,0
    80004654:	4501                	li	a0,0
    80004656:	00000097          	auipc	ra,0x0
    8000465a:	ddc080e7          	jalr	-548(ra) # 80004432 <argfd>
    return -1;
    8000465e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004660:	02054363          	bltz	a0,80004686 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80004664:	fd843903          	ld	s2,-40(s0)
    80004668:	854a                	mv	a0,s2
    8000466a:	00000097          	auipc	ra,0x0
    8000466e:	e30080e7          	jalr	-464(ra) # 8000449a <fdalloc>
    80004672:	84aa                	mv	s1,a0
    return -1;
    80004674:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004676:	00054863          	bltz	a0,80004686 <sys_dup+0x44>
  filedup(f);
    8000467a:	854a                	mv	a0,s2
    8000467c:	fffff097          	auipc	ra,0xfffff
    80004680:	368080e7          	jalr	872(ra) # 800039e4 <filedup>
  return fd;
    80004684:	87a6                	mv	a5,s1
}
    80004686:	853e                	mv	a0,a5
    80004688:	70a2                	ld	ra,40(sp)
    8000468a:	7402                	ld	s0,32(sp)
    8000468c:	64e2                	ld	s1,24(sp)
    8000468e:	6942                	ld	s2,16(sp)
    80004690:	6145                	addi	sp,sp,48
    80004692:	8082                	ret

0000000080004694 <sys_read>:
{
    80004694:	7179                	addi	sp,sp,-48
    80004696:	f406                	sd	ra,40(sp)
    80004698:	f022                	sd	s0,32(sp)
    8000469a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000469c:	fe840613          	addi	a2,s0,-24
    800046a0:	4581                	li	a1,0
    800046a2:	4501                	li	a0,0
    800046a4:	00000097          	auipc	ra,0x0
    800046a8:	d8e080e7          	jalr	-626(ra) # 80004432 <argfd>
    return -1;
    800046ac:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ae:	04054163          	bltz	a0,800046f0 <sys_read+0x5c>
    800046b2:	fe440593          	addi	a1,s0,-28
    800046b6:	4509                	li	a0,2
    800046b8:	ffffe097          	auipc	ra,0xffffe
    800046bc:	89a080e7          	jalr	-1894(ra) # 80001f52 <argint>
    return -1;
    800046c0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046c2:	02054763          	bltz	a0,800046f0 <sys_read+0x5c>
    800046c6:	fd840593          	addi	a1,s0,-40
    800046ca:	4505                	li	a0,1
    800046cc:	ffffe097          	auipc	ra,0xffffe
    800046d0:	8a8080e7          	jalr	-1880(ra) # 80001f74 <argaddr>
    return -1;
    800046d4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046d6:	00054d63          	bltz	a0,800046f0 <sys_read+0x5c>
  return fileread(f, p, n);
    800046da:	fe442603          	lw	a2,-28(s0)
    800046de:	fd843583          	ld	a1,-40(s0)
    800046e2:	fe843503          	ld	a0,-24(s0)
    800046e6:	fffff097          	auipc	ra,0xfffff
    800046ea:	48a080e7          	jalr	1162(ra) # 80003b70 <fileread>
    800046ee:	87aa                	mv	a5,a0
}
    800046f0:	853e                	mv	a0,a5
    800046f2:	70a2                	ld	ra,40(sp)
    800046f4:	7402                	ld	s0,32(sp)
    800046f6:	6145                	addi	sp,sp,48
    800046f8:	8082                	ret

00000000800046fa <sys_write>:
{
    800046fa:	7179                	addi	sp,sp,-48
    800046fc:	f406                	sd	ra,40(sp)
    800046fe:	f022                	sd	s0,32(sp)
    80004700:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004702:	fe840613          	addi	a2,s0,-24
    80004706:	4581                	li	a1,0
    80004708:	4501                	li	a0,0
    8000470a:	00000097          	auipc	ra,0x0
    8000470e:	d28080e7          	jalr	-728(ra) # 80004432 <argfd>
    return -1;
    80004712:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004714:	04054163          	bltz	a0,80004756 <sys_write+0x5c>
    80004718:	fe440593          	addi	a1,s0,-28
    8000471c:	4509                	li	a0,2
    8000471e:	ffffe097          	auipc	ra,0xffffe
    80004722:	834080e7          	jalr	-1996(ra) # 80001f52 <argint>
    return -1;
    80004726:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004728:	02054763          	bltz	a0,80004756 <sys_write+0x5c>
    8000472c:	fd840593          	addi	a1,s0,-40
    80004730:	4505                	li	a0,1
    80004732:	ffffe097          	auipc	ra,0xffffe
    80004736:	842080e7          	jalr	-1982(ra) # 80001f74 <argaddr>
    return -1;
    8000473a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000473c:	00054d63          	bltz	a0,80004756 <sys_write+0x5c>
  return filewrite(f, p, n);
    80004740:	fe442603          	lw	a2,-28(s0)
    80004744:	fd843583          	ld	a1,-40(s0)
    80004748:	fe843503          	ld	a0,-24(s0)
    8000474c:	fffff097          	auipc	ra,0xfffff
    80004750:	4e6080e7          	jalr	1254(ra) # 80003c32 <filewrite>
    80004754:	87aa                	mv	a5,a0
}
    80004756:	853e                	mv	a0,a5
    80004758:	70a2                	ld	ra,40(sp)
    8000475a:	7402                	ld	s0,32(sp)
    8000475c:	6145                	addi	sp,sp,48
    8000475e:	8082                	ret

0000000080004760 <sys_close>:
{
    80004760:	1101                	addi	sp,sp,-32
    80004762:	ec06                	sd	ra,24(sp)
    80004764:	e822                	sd	s0,16(sp)
    80004766:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004768:	fe040613          	addi	a2,s0,-32
    8000476c:	fec40593          	addi	a1,s0,-20
    80004770:	4501                	li	a0,0
    80004772:	00000097          	auipc	ra,0x0
    80004776:	cc0080e7          	jalr	-832(ra) # 80004432 <argfd>
    return -1;
    8000477a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000477c:	02054463          	bltz	a0,800047a4 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004780:	ffffc097          	auipc	ra,0xffffc
    80004784:	6e8080e7          	jalr	1768(ra) # 80000e68 <myproc>
    80004788:	fec42783          	lw	a5,-20(s0)
    8000478c:	07e9                	addi	a5,a5,26
    8000478e:	078e                	slli	a5,a5,0x3
    80004790:	953e                	add	a0,a0,a5
    80004792:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004796:	fe043503          	ld	a0,-32(s0)
    8000479a:	fffff097          	auipc	ra,0xfffff
    8000479e:	29c080e7          	jalr	668(ra) # 80003a36 <fileclose>
  return 0;
    800047a2:	4781                	li	a5,0
}
    800047a4:	853e                	mv	a0,a5
    800047a6:	60e2                	ld	ra,24(sp)
    800047a8:	6442                	ld	s0,16(sp)
    800047aa:	6105                	addi	sp,sp,32
    800047ac:	8082                	ret

00000000800047ae <sys_fstat>:
{
    800047ae:	1101                	addi	sp,sp,-32
    800047b0:	ec06                	sd	ra,24(sp)
    800047b2:	e822                	sd	s0,16(sp)
    800047b4:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047b6:	fe840613          	addi	a2,s0,-24
    800047ba:	4581                	li	a1,0
    800047bc:	4501                	li	a0,0
    800047be:	00000097          	auipc	ra,0x0
    800047c2:	c74080e7          	jalr	-908(ra) # 80004432 <argfd>
    return -1;
    800047c6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047c8:	02054563          	bltz	a0,800047f2 <sys_fstat+0x44>
    800047cc:	fe040593          	addi	a1,s0,-32
    800047d0:	4505                	li	a0,1
    800047d2:	ffffd097          	auipc	ra,0xffffd
    800047d6:	7a2080e7          	jalr	1954(ra) # 80001f74 <argaddr>
    return -1;
    800047da:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047dc:	00054b63          	bltz	a0,800047f2 <sys_fstat+0x44>
  return filestat(f, st);
    800047e0:	fe043583          	ld	a1,-32(s0)
    800047e4:	fe843503          	ld	a0,-24(s0)
    800047e8:	fffff097          	auipc	ra,0xfffff
    800047ec:	316080e7          	jalr	790(ra) # 80003afe <filestat>
    800047f0:	87aa                	mv	a5,a0
}
    800047f2:	853e                	mv	a0,a5
    800047f4:	60e2                	ld	ra,24(sp)
    800047f6:	6442                	ld	s0,16(sp)
    800047f8:	6105                	addi	sp,sp,32
    800047fa:	8082                	ret

00000000800047fc <sys_link>:
{
    800047fc:	7169                	addi	sp,sp,-304
    800047fe:	f606                	sd	ra,296(sp)
    80004800:	f222                	sd	s0,288(sp)
    80004802:	ee26                	sd	s1,280(sp)
    80004804:	ea4a                	sd	s2,272(sp)
    80004806:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004808:	08000613          	li	a2,128
    8000480c:	ed040593          	addi	a1,s0,-304
    80004810:	4501                	li	a0,0
    80004812:	ffffd097          	auipc	ra,0xffffd
    80004816:	784080e7          	jalr	1924(ra) # 80001f96 <argstr>
    return -1;
    8000481a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000481c:	10054e63          	bltz	a0,80004938 <sys_link+0x13c>
    80004820:	08000613          	li	a2,128
    80004824:	f5040593          	addi	a1,s0,-176
    80004828:	4505                	li	a0,1
    8000482a:	ffffd097          	auipc	ra,0xffffd
    8000482e:	76c080e7          	jalr	1900(ra) # 80001f96 <argstr>
    return -1;
    80004832:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004834:	10054263          	bltz	a0,80004938 <sys_link+0x13c>
  begin_op();
    80004838:	fffff097          	auipc	ra,0xfffff
    8000483c:	d36080e7          	jalr	-714(ra) # 8000356e <begin_op>
  if((ip = namei(old)) == 0){
    80004840:	ed040513          	addi	a0,s0,-304
    80004844:	fffff097          	auipc	ra,0xfffff
    80004848:	b0a080e7          	jalr	-1270(ra) # 8000334e <namei>
    8000484c:	84aa                	mv	s1,a0
    8000484e:	c551                	beqz	a0,800048da <sys_link+0xde>
  ilock(ip);
    80004850:	ffffe097          	auipc	ra,0xffffe
    80004854:	342080e7          	jalr	834(ra) # 80002b92 <ilock>
  if(ip->type == T_DIR){
    80004858:	04449703          	lh	a4,68(s1)
    8000485c:	4785                	li	a5,1
    8000485e:	08f70463          	beq	a4,a5,800048e6 <sys_link+0xea>
  ip->nlink++;
    80004862:	04a4d783          	lhu	a5,74(s1)
    80004866:	2785                	addiw	a5,a5,1
    80004868:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000486c:	8526                	mv	a0,s1
    8000486e:	ffffe097          	auipc	ra,0xffffe
    80004872:	258080e7          	jalr	600(ra) # 80002ac6 <iupdate>
  iunlock(ip);
    80004876:	8526                	mv	a0,s1
    80004878:	ffffe097          	auipc	ra,0xffffe
    8000487c:	3dc080e7          	jalr	988(ra) # 80002c54 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004880:	fd040593          	addi	a1,s0,-48
    80004884:	f5040513          	addi	a0,s0,-176
    80004888:	fffff097          	auipc	ra,0xfffff
    8000488c:	ae4080e7          	jalr	-1308(ra) # 8000336c <nameiparent>
    80004890:	892a                	mv	s2,a0
    80004892:	c935                	beqz	a0,80004906 <sys_link+0x10a>
  ilock(dp);
    80004894:	ffffe097          	auipc	ra,0xffffe
    80004898:	2fe080e7          	jalr	766(ra) # 80002b92 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000489c:	00092703          	lw	a4,0(s2)
    800048a0:	409c                	lw	a5,0(s1)
    800048a2:	04f71d63          	bne	a4,a5,800048fc <sys_link+0x100>
    800048a6:	40d0                	lw	a2,4(s1)
    800048a8:	fd040593          	addi	a1,s0,-48
    800048ac:	854a                	mv	a0,s2
    800048ae:	fffff097          	auipc	ra,0xfffff
    800048b2:	9de080e7          	jalr	-1570(ra) # 8000328c <dirlink>
    800048b6:	04054363          	bltz	a0,800048fc <sys_link+0x100>
  iunlockput(dp);
    800048ba:	854a                	mv	a0,s2
    800048bc:	ffffe097          	auipc	ra,0xffffe
    800048c0:	538080e7          	jalr	1336(ra) # 80002df4 <iunlockput>
  iput(ip);
    800048c4:	8526                	mv	a0,s1
    800048c6:	ffffe097          	auipc	ra,0xffffe
    800048ca:	486080e7          	jalr	1158(ra) # 80002d4c <iput>
  end_op();
    800048ce:	fffff097          	auipc	ra,0xfffff
    800048d2:	d1e080e7          	jalr	-738(ra) # 800035ec <end_op>
  return 0;
    800048d6:	4781                	li	a5,0
    800048d8:	a085                	j	80004938 <sys_link+0x13c>
    end_op();
    800048da:	fffff097          	auipc	ra,0xfffff
    800048de:	d12080e7          	jalr	-750(ra) # 800035ec <end_op>
    return -1;
    800048e2:	57fd                	li	a5,-1
    800048e4:	a891                	j	80004938 <sys_link+0x13c>
    iunlockput(ip);
    800048e6:	8526                	mv	a0,s1
    800048e8:	ffffe097          	auipc	ra,0xffffe
    800048ec:	50c080e7          	jalr	1292(ra) # 80002df4 <iunlockput>
    end_op();
    800048f0:	fffff097          	auipc	ra,0xfffff
    800048f4:	cfc080e7          	jalr	-772(ra) # 800035ec <end_op>
    return -1;
    800048f8:	57fd                	li	a5,-1
    800048fa:	a83d                	j	80004938 <sys_link+0x13c>
    iunlockput(dp);
    800048fc:	854a                	mv	a0,s2
    800048fe:	ffffe097          	auipc	ra,0xffffe
    80004902:	4f6080e7          	jalr	1270(ra) # 80002df4 <iunlockput>
  ilock(ip);
    80004906:	8526                	mv	a0,s1
    80004908:	ffffe097          	auipc	ra,0xffffe
    8000490c:	28a080e7          	jalr	650(ra) # 80002b92 <ilock>
  ip->nlink--;
    80004910:	04a4d783          	lhu	a5,74(s1)
    80004914:	37fd                	addiw	a5,a5,-1
    80004916:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000491a:	8526                	mv	a0,s1
    8000491c:	ffffe097          	auipc	ra,0xffffe
    80004920:	1aa080e7          	jalr	426(ra) # 80002ac6 <iupdate>
  iunlockput(ip);
    80004924:	8526                	mv	a0,s1
    80004926:	ffffe097          	auipc	ra,0xffffe
    8000492a:	4ce080e7          	jalr	1230(ra) # 80002df4 <iunlockput>
  end_op();
    8000492e:	fffff097          	auipc	ra,0xfffff
    80004932:	cbe080e7          	jalr	-834(ra) # 800035ec <end_op>
  return -1;
    80004936:	57fd                	li	a5,-1
}
    80004938:	853e                	mv	a0,a5
    8000493a:	70b2                	ld	ra,296(sp)
    8000493c:	7412                	ld	s0,288(sp)
    8000493e:	64f2                	ld	s1,280(sp)
    80004940:	6952                	ld	s2,272(sp)
    80004942:	6155                	addi	sp,sp,304
    80004944:	8082                	ret

0000000080004946 <sys_unlink>:
{
    80004946:	7151                	addi	sp,sp,-240
    80004948:	f586                	sd	ra,232(sp)
    8000494a:	f1a2                	sd	s0,224(sp)
    8000494c:	eda6                	sd	s1,216(sp)
    8000494e:	e9ca                	sd	s2,208(sp)
    80004950:	e5ce                	sd	s3,200(sp)
    80004952:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004954:	08000613          	li	a2,128
    80004958:	f3040593          	addi	a1,s0,-208
    8000495c:	4501                	li	a0,0
    8000495e:	ffffd097          	auipc	ra,0xffffd
    80004962:	638080e7          	jalr	1592(ra) # 80001f96 <argstr>
    80004966:	18054163          	bltz	a0,80004ae8 <sys_unlink+0x1a2>
  begin_op();
    8000496a:	fffff097          	auipc	ra,0xfffff
    8000496e:	c04080e7          	jalr	-1020(ra) # 8000356e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004972:	fb040593          	addi	a1,s0,-80
    80004976:	f3040513          	addi	a0,s0,-208
    8000497a:	fffff097          	auipc	ra,0xfffff
    8000497e:	9f2080e7          	jalr	-1550(ra) # 8000336c <nameiparent>
    80004982:	84aa                	mv	s1,a0
    80004984:	c979                	beqz	a0,80004a5a <sys_unlink+0x114>
  ilock(dp);
    80004986:	ffffe097          	auipc	ra,0xffffe
    8000498a:	20c080e7          	jalr	524(ra) # 80002b92 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000498e:	00004597          	auipc	a1,0x4
    80004992:	e6a58593          	addi	a1,a1,-406 # 800087f8 <syscall_names+0x2b0>
    80004996:	fb040513          	addi	a0,s0,-80
    8000499a:	ffffe097          	auipc	ra,0xffffe
    8000499e:	6c2080e7          	jalr	1730(ra) # 8000305c <namecmp>
    800049a2:	14050a63          	beqz	a0,80004af6 <sys_unlink+0x1b0>
    800049a6:	00004597          	auipc	a1,0x4
    800049aa:	e5a58593          	addi	a1,a1,-422 # 80008800 <syscall_names+0x2b8>
    800049ae:	fb040513          	addi	a0,s0,-80
    800049b2:	ffffe097          	auipc	ra,0xffffe
    800049b6:	6aa080e7          	jalr	1706(ra) # 8000305c <namecmp>
    800049ba:	12050e63          	beqz	a0,80004af6 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049be:	f2c40613          	addi	a2,s0,-212
    800049c2:	fb040593          	addi	a1,s0,-80
    800049c6:	8526                	mv	a0,s1
    800049c8:	ffffe097          	auipc	ra,0xffffe
    800049cc:	6ae080e7          	jalr	1710(ra) # 80003076 <dirlookup>
    800049d0:	892a                	mv	s2,a0
    800049d2:	12050263          	beqz	a0,80004af6 <sys_unlink+0x1b0>
  ilock(ip);
    800049d6:	ffffe097          	auipc	ra,0xffffe
    800049da:	1bc080e7          	jalr	444(ra) # 80002b92 <ilock>
  if(ip->nlink < 1)
    800049de:	04a91783          	lh	a5,74(s2)
    800049e2:	08f05263          	blez	a5,80004a66 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800049e6:	04491703          	lh	a4,68(s2)
    800049ea:	4785                	li	a5,1
    800049ec:	08f70563          	beq	a4,a5,80004a76 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800049f0:	4641                	li	a2,16
    800049f2:	4581                	li	a1,0
    800049f4:	fc040513          	addi	a0,s0,-64
    800049f8:	ffffb097          	auipc	ra,0xffffb
    800049fc:	7a6080e7          	jalr	1958(ra) # 8000019e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a00:	4741                	li	a4,16
    80004a02:	f2c42683          	lw	a3,-212(s0)
    80004a06:	fc040613          	addi	a2,s0,-64
    80004a0a:	4581                	li	a1,0
    80004a0c:	8526                	mv	a0,s1
    80004a0e:	ffffe097          	auipc	ra,0xffffe
    80004a12:	530080e7          	jalr	1328(ra) # 80002f3e <writei>
    80004a16:	47c1                	li	a5,16
    80004a18:	0af51563          	bne	a0,a5,80004ac2 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a1c:	04491703          	lh	a4,68(s2)
    80004a20:	4785                	li	a5,1
    80004a22:	0af70863          	beq	a4,a5,80004ad2 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a26:	8526                	mv	a0,s1
    80004a28:	ffffe097          	auipc	ra,0xffffe
    80004a2c:	3cc080e7          	jalr	972(ra) # 80002df4 <iunlockput>
  ip->nlink--;
    80004a30:	04a95783          	lhu	a5,74(s2)
    80004a34:	37fd                	addiw	a5,a5,-1
    80004a36:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a3a:	854a                	mv	a0,s2
    80004a3c:	ffffe097          	auipc	ra,0xffffe
    80004a40:	08a080e7          	jalr	138(ra) # 80002ac6 <iupdate>
  iunlockput(ip);
    80004a44:	854a                	mv	a0,s2
    80004a46:	ffffe097          	auipc	ra,0xffffe
    80004a4a:	3ae080e7          	jalr	942(ra) # 80002df4 <iunlockput>
  end_op();
    80004a4e:	fffff097          	auipc	ra,0xfffff
    80004a52:	b9e080e7          	jalr	-1122(ra) # 800035ec <end_op>
  return 0;
    80004a56:	4501                	li	a0,0
    80004a58:	a84d                	j	80004b0a <sys_unlink+0x1c4>
    end_op();
    80004a5a:	fffff097          	auipc	ra,0xfffff
    80004a5e:	b92080e7          	jalr	-1134(ra) # 800035ec <end_op>
    return -1;
    80004a62:	557d                	li	a0,-1
    80004a64:	a05d                	j	80004b0a <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a66:	00004517          	auipc	a0,0x4
    80004a6a:	dc250513          	addi	a0,a0,-574 # 80008828 <syscall_names+0x2e0>
    80004a6e:	00001097          	auipc	ra,0x1
    80004a72:	192080e7          	jalr	402(ra) # 80005c00 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a76:	04c92703          	lw	a4,76(s2)
    80004a7a:	02000793          	li	a5,32
    80004a7e:	f6e7f9e3          	bgeu	a5,a4,800049f0 <sys_unlink+0xaa>
    80004a82:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a86:	4741                	li	a4,16
    80004a88:	86ce                	mv	a3,s3
    80004a8a:	f1840613          	addi	a2,s0,-232
    80004a8e:	4581                	li	a1,0
    80004a90:	854a                	mv	a0,s2
    80004a92:	ffffe097          	auipc	ra,0xffffe
    80004a96:	3b4080e7          	jalr	948(ra) # 80002e46 <readi>
    80004a9a:	47c1                	li	a5,16
    80004a9c:	00f51b63          	bne	a0,a5,80004ab2 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004aa0:	f1845783          	lhu	a5,-232(s0)
    80004aa4:	e7a1                	bnez	a5,80004aec <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004aa6:	29c1                	addiw	s3,s3,16
    80004aa8:	04c92783          	lw	a5,76(s2)
    80004aac:	fcf9ede3          	bltu	s3,a5,80004a86 <sys_unlink+0x140>
    80004ab0:	b781                	j	800049f0 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ab2:	00004517          	auipc	a0,0x4
    80004ab6:	d8e50513          	addi	a0,a0,-626 # 80008840 <syscall_names+0x2f8>
    80004aba:	00001097          	auipc	ra,0x1
    80004abe:	146080e7          	jalr	326(ra) # 80005c00 <panic>
    panic("unlink: writei");
    80004ac2:	00004517          	auipc	a0,0x4
    80004ac6:	d9650513          	addi	a0,a0,-618 # 80008858 <syscall_names+0x310>
    80004aca:	00001097          	auipc	ra,0x1
    80004ace:	136080e7          	jalr	310(ra) # 80005c00 <panic>
    dp->nlink--;
    80004ad2:	04a4d783          	lhu	a5,74(s1)
    80004ad6:	37fd                	addiw	a5,a5,-1
    80004ad8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004adc:	8526                	mv	a0,s1
    80004ade:	ffffe097          	auipc	ra,0xffffe
    80004ae2:	fe8080e7          	jalr	-24(ra) # 80002ac6 <iupdate>
    80004ae6:	b781                	j	80004a26 <sys_unlink+0xe0>
    return -1;
    80004ae8:	557d                	li	a0,-1
    80004aea:	a005                	j	80004b0a <sys_unlink+0x1c4>
    iunlockput(ip);
    80004aec:	854a                	mv	a0,s2
    80004aee:	ffffe097          	auipc	ra,0xffffe
    80004af2:	306080e7          	jalr	774(ra) # 80002df4 <iunlockput>
  iunlockput(dp);
    80004af6:	8526                	mv	a0,s1
    80004af8:	ffffe097          	auipc	ra,0xffffe
    80004afc:	2fc080e7          	jalr	764(ra) # 80002df4 <iunlockput>
  end_op();
    80004b00:	fffff097          	auipc	ra,0xfffff
    80004b04:	aec080e7          	jalr	-1300(ra) # 800035ec <end_op>
  return -1;
    80004b08:	557d                	li	a0,-1
}
    80004b0a:	70ae                	ld	ra,232(sp)
    80004b0c:	740e                	ld	s0,224(sp)
    80004b0e:	64ee                	ld	s1,216(sp)
    80004b10:	694e                	ld	s2,208(sp)
    80004b12:	69ae                	ld	s3,200(sp)
    80004b14:	616d                	addi	sp,sp,240
    80004b16:	8082                	ret

0000000080004b18 <sys_open>:

uint64
sys_open(void)
{
    80004b18:	7131                	addi	sp,sp,-192
    80004b1a:	fd06                	sd	ra,184(sp)
    80004b1c:	f922                	sd	s0,176(sp)
    80004b1e:	f526                	sd	s1,168(sp)
    80004b20:	f14a                	sd	s2,160(sp)
    80004b22:	ed4e                	sd	s3,152(sp)
    80004b24:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b26:	08000613          	li	a2,128
    80004b2a:	f5040593          	addi	a1,s0,-176
    80004b2e:	4501                	li	a0,0
    80004b30:	ffffd097          	auipc	ra,0xffffd
    80004b34:	466080e7          	jalr	1126(ra) # 80001f96 <argstr>
    return -1;
    80004b38:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b3a:	0c054163          	bltz	a0,80004bfc <sys_open+0xe4>
    80004b3e:	f4c40593          	addi	a1,s0,-180
    80004b42:	4505                	li	a0,1
    80004b44:	ffffd097          	auipc	ra,0xffffd
    80004b48:	40e080e7          	jalr	1038(ra) # 80001f52 <argint>
    80004b4c:	0a054863          	bltz	a0,80004bfc <sys_open+0xe4>

  begin_op();
    80004b50:	fffff097          	auipc	ra,0xfffff
    80004b54:	a1e080e7          	jalr	-1506(ra) # 8000356e <begin_op>

  if(omode & O_CREATE){
    80004b58:	f4c42783          	lw	a5,-180(s0)
    80004b5c:	2007f793          	andi	a5,a5,512
    80004b60:	cbdd                	beqz	a5,80004c16 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b62:	4681                	li	a3,0
    80004b64:	4601                	li	a2,0
    80004b66:	4589                	li	a1,2
    80004b68:	f5040513          	addi	a0,s0,-176
    80004b6c:	00000097          	auipc	ra,0x0
    80004b70:	970080e7          	jalr	-1680(ra) # 800044dc <create>
    80004b74:	892a                	mv	s2,a0
    if(ip == 0){
    80004b76:	c959                	beqz	a0,80004c0c <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b78:	04491703          	lh	a4,68(s2)
    80004b7c:	478d                	li	a5,3
    80004b7e:	00f71763          	bne	a4,a5,80004b8c <sys_open+0x74>
    80004b82:	04695703          	lhu	a4,70(s2)
    80004b86:	47a5                	li	a5,9
    80004b88:	0ce7ec63          	bltu	a5,a4,80004c60 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b8c:	fffff097          	auipc	ra,0xfffff
    80004b90:	dee080e7          	jalr	-530(ra) # 8000397a <filealloc>
    80004b94:	89aa                	mv	s3,a0
    80004b96:	10050263          	beqz	a0,80004c9a <sys_open+0x182>
    80004b9a:	00000097          	auipc	ra,0x0
    80004b9e:	900080e7          	jalr	-1792(ra) # 8000449a <fdalloc>
    80004ba2:	84aa                	mv	s1,a0
    80004ba4:	0e054663          	bltz	a0,80004c90 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ba8:	04491703          	lh	a4,68(s2)
    80004bac:	478d                	li	a5,3
    80004bae:	0cf70463          	beq	a4,a5,80004c76 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bb2:	4789                	li	a5,2
    80004bb4:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bb8:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004bbc:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004bc0:	f4c42783          	lw	a5,-180(s0)
    80004bc4:	0017c713          	xori	a4,a5,1
    80004bc8:	8b05                	andi	a4,a4,1
    80004bca:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004bce:	0037f713          	andi	a4,a5,3
    80004bd2:	00e03733          	snez	a4,a4
    80004bd6:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004bda:	4007f793          	andi	a5,a5,1024
    80004bde:	c791                	beqz	a5,80004bea <sys_open+0xd2>
    80004be0:	04491703          	lh	a4,68(s2)
    80004be4:	4789                	li	a5,2
    80004be6:	08f70f63          	beq	a4,a5,80004c84 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004bea:	854a                	mv	a0,s2
    80004bec:	ffffe097          	auipc	ra,0xffffe
    80004bf0:	068080e7          	jalr	104(ra) # 80002c54 <iunlock>
  end_op();
    80004bf4:	fffff097          	auipc	ra,0xfffff
    80004bf8:	9f8080e7          	jalr	-1544(ra) # 800035ec <end_op>

  return fd;
}
    80004bfc:	8526                	mv	a0,s1
    80004bfe:	70ea                	ld	ra,184(sp)
    80004c00:	744a                	ld	s0,176(sp)
    80004c02:	74aa                	ld	s1,168(sp)
    80004c04:	790a                	ld	s2,160(sp)
    80004c06:	69ea                	ld	s3,152(sp)
    80004c08:	6129                	addi	sp,sp,192
    80004c0a:	8082                	ret
      end_op();
    80004c0c:	fffff097          	auipc	ra,0xfffff
    80004c10:	9e0080e7          	jalr	-1568(ra) # 800035ec <end_op>
      return -1;
    80004c14:	b7e5                	j	80004bfc <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c16:	f5040513          	addi	a0,s0,-176
    80004c1a:	ffffe097          	auipc	ra,0xffffe
    80004c1e:	734080e7          	jalr	1844(ra) # 8000334e <namei>
    80004c22:	892a                	mv	s2,a0
    80004c24:	c905                	beqz	a0,80004c54 <sys_open+0x13c>
    ilock(ip);
    80004c26:	ffffe097          	auipc	ra,0xffffe
    80004c2a:	f6c080e7          	jalr	-148(ra) # 80002b92 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c2e:	04491703          	lh	a4,68(s2)
    80004c32:	4785                	li	a5,1
    80004c34:	f4f712e3          	bne	a4,a5,80004b78 <sys_open+0x60>
    80004c38:	f4c42783          	lw	a5,-180(s0)
    80004c3c:	dba1                	beqz	a5,80004b8c <sys_open+0x74>
      iunlockput(ip);
    80004c3e:	854a                	mv	a0,s2
    80004c40:	ffffe097          	auipc	ra,0xffffe
    80004c44:	1b4080e7          	jalr	436(ra) # 80002df4 <iunlockput>
      end_op();
    80004c48:	fffff097          	auipc	ra,0xfffff
    80004c4c:	9a4080e7          	jalr	-1628(ra) # 800035ec <end_op>
      return -1;
    80004c50:	54fd                	li	s1,-1
    80004c52:	b76d                	j	80004bfc <sys_open+0xe4>
      end_op();
    80004c54:	fffff097          	auipc	ra,0xfffff
    80004c58:	998080e7          	jalr	-1640(ra) # 800035ec <end_op>
      return -1;
    80004c5c:	54fd                	li	s1,-1
    80004c5e:	bf79                	j	80004bfc <sys_open+0xe4>
    iunlockput(ip);
    80004c60:	854a                	mv	a0,s2
    80004c62:	ffffe097          	auipc	ra,0xffffe
    80004c66:	192080e7          	jalr	402(ra) # 80002df4 <iunlockput>
    end_op();
    80004c6a:	fffff097          	auipc	ra,0xfffff
    80004c6e:	982080e7          	jalr	-1662(ra) # 800035ec <end_op>
    return -1;
    80004c72:	54fd                	li	s1,-1
    80004c74:	b761                	j	80004bfc <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c76:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c7a:	04691783          	lh	a5,70(s2)
    80004c7e:	02f99223          	sh	a5,36(s3)
    80004c82:	bf2d                	j	80004bbc <sys_open+0xa4>
    itrunc(ip);
    80004c84:	854a                	mv	a0,s2
    80004c86:	ffffe097          	auipc	ra,0xffffe
    80004c8a:	01a080e7          	jalr	26(ra) # 80002ca0 <itrunc>
    80004c8e:	bfb1                	j	80004bea <sys_open+0xd2>
      fileclose(f);
    80004c90:	854e                	mv	a0,s3
    80004c92:	fffff097          	auipc	ra,0xfffff
    80004c96:	da4080e7          	jalr	-604(ra) # 80003a36 <fileclose>
    iunlockput(ip);
    80004c9a:	854a                	mv	a0,s2
    80004c9c:	ffffe097          	auipc	ra,0xffffe
    80004ca0:	158080e7          	jalr	344(ra) # 80002df4 <iunlockput>
    end_op();
    80004ca4:	fffff097          	auipc	ra,0xfffff
    80004ca8:	948080e7          	jalr	-1720(ra) # 800035ec <end_op>
    return -1;
    80004cac:	54fd                	li	s1,-1
    80004cae:	b7b9                	j	80004bfc <sys_open+0xe4>

0000000080004cb0 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cb0:	7175                	addi	sp,sp,-144
    80004cb2:	e506                	sd	ra,136(sp)
    80004cb4:	e122                	sd	s0,128(sp)
    80004cb6:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cb8:	fffff097          	auipc	ra,0xfffff
    80004cbc:	8b6080e7          	jalr	-1866(ra) # 8000356e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004cc0:	08000613          	li	a2,128
    80004cc4:	f7040593          	addi	a1,s0,-144
    80004cc8:	4501                	li	a0,0
    80004cca:	ffffd097          	auipc	ra,0xffffd
    80004cce:	2cc080e7          	jalr	716(ra) # 80001f96 <argstr>
    80004cd2:	02054963          	bltz	a0,80004d04 <sys_mkdir+0x54>
    80004cd6:	4681                	li	a3,0
    80004cd8:	4601                	li	a2,0
    80004cda:	4585                	li	a1,1
    80004cdc:	f7040513          	addi	a0,s0,-144
    80004ce0:	fffff097          	auipc	ra,0xfffff
    80004ce4:	7fc080e7          	jalr	2044(ra) # 800044dc <create>
    80004ce8:	cd11                	beqz	a0,80004d04 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cea:	ffffe097          	auipc	ra,0xffffe
    80004cee:	10a080e7          	jalr	266(ra) # 80002df4 <iunlockput>
  end_op();
    80004cf2:	fffff097          	auipc	ra,0xfffff
    80004cf6:	8fa080e7          	jalr	-1798(ra) # 800035ec <end_op>
  return 0;
    80004cfa:	4501                	li	a0,0
}
    80004cfc:	60aa                	ld	ra,136(sp)
    80004cfe:	640a                	ld	s0,128(sp)
    80004d00:	6149                	addi	sp,sp,144
    80004d02:	8082                	ret
    end_op();
    80004d04:	fffff097          	auipc	ra,0xfffff
    80004d08:	8e8080e7          	jalr	-1816(ra) # 800035ec <end_op>
    return -1;
    80004d0c:	557d                	li	a0,-1
    80004d0e:	b7fd                	j	80004cfc <sys_mkdir+0x4c>

0000000080004d10 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d10:	7135                	addi	sp,sp,-160
    80004d12:	ed06                	sd	ra,152(sp)
    80004d14:	e922                	sd	s0,144(sp)
    80004d16:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d18:	fffff097          	auipc	ra,0xfffff
    80004d1c:	856080e7          	jalr	-1962(ra) # 8000356e <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d20:	08000613          	li	a2,128
    80004d24:	f7040593          	addi	a1,s0,-144
    80004d28:	4501                	li	a0,0
    80004d2a:	ffffd097          	auipc	ra,0xffffd
    80004d2e:	26c080e7          	jalr	620(ra) # 80001f96 <argstr>
    80004d32:	04054a63          	bltz	a0,80004d86 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d36:	f6c40593          	addi	a1,s0,-148
    80004d3a:	4505                	li	a0,1
    80004d3c:	ffffd097          	auipc	ra,0xffffd
    80004d40:	216080e7          	jalr	534(ra) # 80001f52 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d44:	04054163          	bltz	a0,80004d86 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d48:	f6840593          	addi	a1,s0,-152
    80004d4c:	4509                	li	a0,2
    80004d4e:	ffffd097          	auipc	ra,0xffffd
    80004d52:	204080e7          	jalr	516(ra) # 80001f52 <argint>
     argint(1, &major) < 0 ||
    80004d56:	02054863          	bltz	a0,80004d86 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d5a:	f6841683          	lh	a3,-152(s0)
    80004d5e:	f6c41603          	lh	a2,-148(s0)
    80004d62:	458d                	li	a1,3
    80004d64:	f7040513          	addi	a0,s0,-144
    80004d68:	fffff097          	auipc	ra,0xfffff
    80004d6c:	774080e7          	jalr	1908(ra) # 800044dc <create>
     argint(2, &minor) < 0 ||
    80004d70:	c919                	beqz	a0,80004d86 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d72:	ffffe097          	auipc	ra,0xffffe
    80004d76:	082080e7          	jalr	130(ra) # 80002df4 <iunlockput>
  end_op();
    80004d7a:	fffff097          	auipc	ra,0xfffff
    80004d7e:	872080e7          	jalr	-1934(ra) # 800035ec <end_op>
  return 0;
    80004d82:	4501                	li	a0,0
    80004d84:	a031                	j	80004d90 <sys_mknod+0x80>
    end_op();
    80004d86:	fffff097          	auipc	ra,0xfffff
    80004d8a:	866080e7          	jalr	-1946(ra) # 800035ec <end_op>
    return -1;
    80004d8e:	557d                	li	a0,-1
}
    80004d90:	60ea                	ld	ra,152(sp)
    80004d92:	644a                	ld	s0,144(sp)
    80004d94:	610d                	addi	sp,sp,160
    80004d96:	8082                	ret

0000000080004d98 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d98:	7135                	addi	sp,sp,-160
    80004d9a:	ed06                	sd	ra,152(sp)
    80004d9c:	e922                	sd	s0,144(sp)
    80004d9e:	e526                	sd	s1,136(sp)
    80004da0:	e14a                	sd	s2,128(sp)
    80004da2:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004da4:	ffffc097          	auipc	ra,0xffffc
    80004da8:	0c4080e7          	jalr	196(ra) # 80000e68 <myproc>
    80004dac:	892a                	mv	s2,a0
  
  begin_op();
    80004dae:	ffffe097          	auipc	ra,0xffffe
    80004db2:	7c0080e7          	jalr	1984(ra) # 8000356e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004db6:	08000613          	li	a2,128
    80004dba:	f6040593          	addi	a1,s0,-160
    80004dbe:	4501                	li	a0,0
    80004dc0:	ffffd097          	auipc	ra,0xffffd
    80004dc4:	1d6080e7          	jalr	470(ra) # 80001f96 <argstr>
    80004dc8:	04054b63          	bltz	a0,80004e1e <sys_chdir+0x86>
    80004dcc:	f6040513          	addi	a0,s0,-160
    80004dd0:	ffffe097          	auipc	ra,0xffffe
    80004dd4:	57e080e7          	jalr	1406(ra) # 8000334e <namei>
    80004dd8:	84aa                	mv	s1,a0
    80004dda:	c131                	beqz	a0,80004e1e <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004ddc:	ffffe097          	auipc	ra,0xffffe
    80004de0:	db6080e7          	jalr	-586(ra) # 80002b92 <ilock>
  if(ip->type != T_DIR){
    80004de4:	04449703          	lh	a4,68(s1)
    80004de8:	4785                	li	a5,1
    80004dea:	04f71063          	bne	a4,a5,80004e2a <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004dee:	8526                	mv	a0,s1
    80004df0:	ffffe097          	auipc	ra,0xffffe
    80004df4:	e64080e7          	jalr	-412(ra) # 80002c54 <iunlock>
  iput(p->cwd);
    80004df8:	15093503          	ld	a0,336(s2)
    80004dfc:	ffffe097          	auipc	ra,0xffffe
    80004e00:	f50080e7          	jalr	-176(ra) # 80002d4c <iput>
  end_op();
    80004e04:	ffffe097          	auipc	ra,0xffffe
    80004e08:	7e8080e7          	jalr	2024(ra) # 800035ec <end_op>
  p->cwd = ip;
    80004e0c:	14993823          	sd	s1,336(s2)
  return 0;
    80004e10:	4501                	li	a0,0
}
    80004e12:	60ea                	ld	ra,152(sp)
    80004e14:	644a                	ld	s0,144(sp)
    80004e16:	64aa                	ld	s1,136(sp)
    80004e18:	690a                	ld	s2,128(sp)
    80004e1a:	610d                	addi	sp,sp,160
    80004e1c:	8082                	ret
    end_op();
    80004e1e:	ffffe097          	auipc	ra,0xffffe
    80004e22:	7ce080e7          	jalr	1998(ra) # 800035ec <end_op>
    return -1;
    80004e26:	557d                	li	a0,-1
    80004e28:	b7ed                	j	80004e12 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e2a:	8526                	mv	a0,s1
    80004e2c:	ffffe097          	auipc	ra,0xffffe
    80004e30:	fc8080e7          	jalr	-56(ra) # 80002df4 <iunlockput>
    end_op();
    80004e34:	ffffe097          	auipc	ra,0xffffe
    80004e38:	7b8080e7          	jalr	1976(ra) # 800035ec <end_op>
    return -1;
    80004e3c:	557d                	li	a0,-1
    80004e3e:	bfd1                	j	80004e12 <sys_chdir+0x7a>

0000000080004e40 <sys_exec>:

uint64
sys_exec(void)
{
    80004e40:	7145                	addi	sp,sp,-464
    80004e42:	e786                	sd	ra,456(sp)
    80004e44:	e3a2                	sd	s0,448(sp)
    80004e46:	ff26                	sd	s1,440(sp)
    80004e48:	fb4a                	sd	s2,432(sp)
    80004e4a:	f74e                	sd	s3,424(sp)
    80004e4c:	f352                	sd	s4,416(sp)
    80004e4e:	ef56                	sd	s5,408(sp)
    80004e50:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e52:	08000613          	li	a2,128
    80004e56:	f4040593          	addi	a1,s0,-192
    80004e5a:	4501                	li	a0,0
    80004e5c:	ffffd097          	auipc	ra,0xffffd
    80004e60:	13a080e7          	jalr	314(ra) # 80001f96 <argstr>
    return -1;
    80004e64:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e66:	0c054b63          	bltz	a0,80004f3c <sys_exec+0xfc>
    80004e6a:	e3840593          	addi	a1,s0,-456
    80004e6e:	4505                	li	a0,1
    80004e70:	ffffd097          	auipc	ra,0xffffd
    80004e74:	104080e7          	jalr	260(ra) # 80001f74 <argaddr>
    80004e78:	0c054263          	bltz	a0,80004f3c <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004e7c:	10000613          	li	a2,256
    80004e80:	4581                	li	a1,0
    80004e82:	e4040513          	addi	a0,s0,-448
    80004e86:	ffffb097          	auipc	ra,0xffffb
    80004e8a:	318080e7          	jalr	792(ra) # 8000019e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e8e:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004e92:	89a6                	mv	s3,s1
    80004e94:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e96:	02000a13          	li	s4,32
    80004e9a:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e9e:	00391513          	slli	a0,s2,0x3
    80004ea2:	e3040593          	addi	a1,s0,-464
    80004ea6:	e3843783          	ld	a5,-456(s0)
    80004eaa:	953e                	add	a0,a0,a5
    80004eac:	ffffd097          	auipc	ra,0xffffd
    80004eb0:	00c080e7          	jalr	12(ra) # 80001eb8 <fetchaddr>
    80004eb4:	02054a63          	bltz	a0,80004ee8 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004eb8:	e3043783          	ld	a5,-464(s0)
    80004ebc:	c3b9                	beqz	a5,80004f02 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ebe:	ffffb097          	auipc	ra,0xffffb
    80004ec2:	25c080e7          	jalr	604(ra) # 8000011a <kalloc>
    80004ec6:	85aa                	mv	a1,a0
    80004ec8:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ecc:	cd11                	beqz	a0,80004ee8 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ece:	6605                	lui	a2,0x1
    80004ed0:	e3043503          	ld	a0,-464(s0)
    80004ed4:	ffffd097          	auipc	ra,0xffffd
    80004ed8:	036080e7          	jalr	54(ra) # 80001f0a <fetchstr>
    80004edc:	00054663          	bltz	a0,80004ee8 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004ee0:	0905                	addi	s2,s2,1
    80004ee2:	09a1                	addi	s3,s3,8
    80004ee4:	fb491be3          	bne	s2,s4,80004e9a <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ee8:	f4040913          	addi	s2,s0,-192
    80004eec:	6088                	ld	a0,0(s1)
    80004eee:	c531                	beqz	a0,80004f3a <sys_exec+0xfa>
    kfree(argv[i]);
    80004ef0:	ffffb097          	auipc	ra,0xffffb
    80004ef4:	12c080e7          	jalr	300(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ef8:	04a1                	addi	s1,s1,8
    80004efa:	ff2499e3          	bne	s1,s2,80004eec <sys_exec+0xac>
  return -1;
    80004efe:	597d                	li	s2,-1
    80004f00:	a835                	j	80004f3c <sys_exec+0xfc>
      argv[i] = 0;
    80004f02:	0a8e                	slli	s5,s5,0x3
    80004f04:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffd8d80>
    80004f08:	00878ab3          	add	s5,a5,s0
    80004f0c:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f10:	e4040593          	addi	a1,s0,-448
    80004f14:	f4040513          	addi	a0,s0,-192
    80004f18:	fffff097          	auipc	ra,0xfffff
    80004f1c:	172080e7          	jalr	370(ra) # 8000408a <exec>
    80004f20:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f22:	f4040993          	addi	s3,s0,-192
    80004f26:	6088                	ld	a0,0(s1)
    80004f28:	c911                	beqz	a0,80004f3c <sys_exec+0xfc>
    kfree(argv[i]);
    80004f2a:	ffffb097          	auipc	ra,0xffffb
    80004f2e:	0f2080e7          	jalr	242(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f32:	04a1                	addi	s1,s1,8
    80004f34:	ff3499e3          	bne	s1,s3,80004f26 <sys_exec+0xe6>
    80004f38:	a011                	j	80004f3c <sys_exec+0xfc>
  return -1;
    80004f3a:	597d                	li	s2,-1
}
    80004f3c:	854a                	mv	a0,s2
    80004f3e:	60be                	ld	ra,456(sp)
    80004f40:	641e                	ld	s0,448(sp)
    80004f42:	74fa                	ld	s1,440(sp)
    80004f44:	795a                	ld	s2,432(sp)
    80004f46:	79ba                	ld	s3,424(sp)
    80004f48:	7a1a                	ld	s4,416(sp)
    80004f4a:	6afa                	ld	s5,408(sp)
    80004f4c:	6179                	addi	sp,sp,464
    80004f4e:	8082                	ret

0000000080004f50 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f50:	7139                	addi	sp,sp,-64
    80004f52:	fc06                	sd	ra,56(sp)
    80004f54:	f822                	sd	s0,48(sp)
    80004f56:	f426                	sd	s1,40(sp)
    80004f58:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f5a:	ffffc097          	auipc	ra,0xffffc
    80004f5e:	f0e080e7          	jalr	-242(ra) # 80000e68 <myproc>
    80004f62:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f64:	fd840593          	addi	a1,s0,-40
    80004f68:	4501                	li	a0,0
    80004f6a:	ffffd097          	auipc	ra,0xffffd
    80004f6e:	00a080e7          	jalr	10(ra) # 80001f74 <argaddr>
    return -1;
    80004f72:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004f74:	0e054063          	bltz	a0,80005054 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004f78:	fc840593          	addi	a1,s0,-56
    80004f7c:	fd040513          	addi	a0,s0,-48
    80004f80:	fffff097          	auipc	ra,0xfffff
    80004f84:	de6080e7          	jalr	-538(ra) # 80003d66 <pipealloc>
    return -1;
    80004f88:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f8a:	0c054563          	bltz	a0,80005054 <sys_pipe+0x104>
  fd0 = -1;
    80004f8e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f92:	fd043503          	ld	a0,-48(s0)
    80004f96:	fffff097          	auipc	ra,0xfffff
    80004f9a:	504080e7          	jalr	1284(ra) # 8000449a <fdalloc>
    80004f9e:	fca42223          	sw	a0,-60(s0)
    80004fa2:	08054c63          	bltz	a0,8000503a <sys_pipe+0xea>
    80004fa6:	fc843503          	ld	a0,-56(s0)
    80004faa:	fffff097          	auipc	ra,0xfffff
    80004fae:	4f0080e7          	jalr	1264(ra) # 8000449a <fdalloc>
    80004fb2:	fca42023          	sw	a0,-64(s0)
    80004fb6:	06054963          	bltz	a0,80005028 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fba:	4691                	li	a3,4
    80004fbc:	fc440613          	addi	a2,s0,-60
    80004fc0:	fd843583          	ld	a1,-40(s0)
    80004fc4:	68a8                	ld	a0,80(s1)
    80004fc6:	ffffc097          	auipc	ra,0xffffc
    80004fca:	b66080e7          	jalr	-1178(ra) # 80000b2c <copyout>
    80004fce:	02054063          	bltz	a0,80004fee <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004fd2:	4691                	li	a3,4
    80004fd4:	fc040613          	addi	a2,s0,-64
    80004fd8:	fd843583          	ld	a1,-40(s0)
    80004fdc:	0591                	addi	a1,a1,4
    80004fde:	68a8                	ld	a0,80(s1)
    80004fe0:	ffffc097          	auipc	ra,0xffffc
    80004fe4:	b4c080e7          	jalr	-1204(ra) # 80000b2c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004fe8:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fea:	06055563          	bgez	a0,80005054 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004fee:	fc442783          	lw	a5,-60(s0)
    80004ff2:	07e9                	addi	a5,a5,26
    80004ff4:	078e                	slli	a5,a5,0x3
    80004ff6:	97a6                	add	a5,a5,s1
    80004ff8:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004ffc:	fc042783          	lw	a5,-64(s0)
    80005000:	07e9                	addi	a5,a5,26
    80005002:	078e                	slli	a5,a5,0x3
    80005004:	00f48533          	add	a0,s1,a5
    80005008:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000500c:	fd043503          	ld	a0,-48(s0)
    80005010:	fffff097          	auipc	ra,0xfffff
    80005014:	a26080e7          	jalr	-1498(ra) # 80003a36 <fileclose>
    fileclose(wf);
    80005018:	fc843503          	ld	a0,-56(s0)
    8000501c:	fffff097          	auipc	ra,0xfffff
    80005020:	a1a080e7          	jalr	-1510(ra) # 80003a36 <fileclose>
    return -1;
    80005024:	57fd                	li	a5,-1
    80005026:	a03d                	j	80005054 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005028:	fc442783          	lw	a5,-60(s0)
    8000502c:	0007c763          	bltz	a5,8000503a <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005030:	07e9                	addi	a5,a5,26
    80005032:	078e                	slli	a5,a5,0x3
    80005034:	97a6                	add	a5,a5,s1
    80005036:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000503a:	fd043503          	ld	a0,-48(s0)
    8000503e:	fffff097          	auipc	ra,0xfffff
    80005042:	9f8080e7          	jalr	-1544(ra) # 80003a36 <fileclose>
    fileclose(wf);
    80005046:	fc843503          	ld	a0,-56(s0)
    8000504a:	fffff097          	auipc	ra,0xfffff
    8000504e:	9ec080e7          	jalr	-1556(ra) # 80003a36 <fileclose>
    return -1;
    80005052:	57fd                	li	a5,-1
}
    80005054:	853e                	mv	a0,a5
    80005056:	70e2                	ld	ra,56(sp)
    80005058:	7442                	ld	s0,48(sp)
    8000505a:	74a2                	ld	s1,40(sp)
    8000505c:	6121                	addi	sp,sp,64
    8000505e:	8082                	ret

0000000080005060 <kernelvec>:
    80005060:	7111                	addi	sp,sp,-256
    80005062:	e006                	sd	ra,0(sp)
    80005064:	e40a                	sd	sp,8(sp)
    80005066:	e80e                	sd	gp,16(sp)
    80005068:	ec12                	sd	tp,24(sp)
    8000506a:	f016                	sd	t0,32(sp)
    8000506c:	f41a                	sd	t1,40(sp)
    8000506e:	f81e                	sd	t2,48(sp)
    80005070:	fc22                	sd	s0,56(sp)
    80005072:	e0a6                	sd	s1,64(sp)
    80005074:	e4aa                	sd	a0,72(sp)
    80005076:	e8ae                	sd	a1,80(sp)
    80005078:	ecb2                	sd	a2,88(sp)
    8000507a:	f0b6                	sd	a3,96(sp)
    8000507c:	f4ba                	sd	a4,104(sp)
    8000507e:	f8be                	sd	a5,112(sp)
    80005080:	fcc2                	sd	a6,120(sp)
    80005082:	e146                	sd	a7,128(sp)
    80005084:	e54a                	sd	s2,136(sp)
    80005086:	e94e                	sd	s3,144(sp)
    80005088:	ed52                	sd	s4,152(sp)
    8000508a:	f156                	sd	s5,160(sp)
    8000508c:	f55a                	sd	s6,168(sp)
    8000508e:	f95e                	sd	s7,176(sp)
    80005090:	fd62                	sd	s8,184(sp)
    80005092:	e1e6                	sd	s9,192(sp)
    80005094:	e5ea                	sd	s10,200(sp)
    80005096:	e9ee                	sd	s11,208(sp)
    80005098:	edf2                	sd	t3,216(sp)
    8000509a:	f1f6                	sd	t4,224(sp)
    8000509c:	f5fa                	sd	t5,232(sp)
    8000509e:	f9fe                	sd	t6,240(sp)
    800050a0:	ce5fc0ef          	jal	ra,80001d84 <kerneltrap>
    800050a4:	6082                	ld	ra,0(sp)
    800050a6:	6122                	ld	sp,8(sp)
    800050a8:	61c2                	ld	gp,16(sp)
    800050aa:	7282                	ld	t0,32(sp)
    800050ac:	7322                	ld	t1,40(sp)
    800050ae:	73c2                	ld	t2,48(sp)
    800050b0:	7462                	ld	s0,56(sp)
    800050b2:	6486                	ld	s1,64(sp)
    800050b4:	6526                	ld	a0,72(sp)
    800050b6:	65c6                	ld	a1,80(sp)
    800050b8:	6666                	ld	a2,88(sp)
    800050ba:	7686                	ld	a3,96(sp)
    800050bc:	7726                	ld	a4,104(sp)
    800050be:	77c6                	ld	a5,112(sp)
    800050c0:	7866                	ld	a6,120(sp)
    800050c2:	688a                	ld	a7,128(sp)
    800050c4:	692a                	ld	s2,136(sp)
    800050c6:	69ca                	ld	s3,144(sp)
    800050c8:	6a6a                	ld	s4,152(sp)
    800050ca:	7a8a                	ld	s5,160(sp)
    800050cc:	7b2a                	ld	s6,168(sp)
    800050ce:	7bca                	ld	s7,176(sp)
    800050d0:	7c6a                	ld	s8,184(sp)
    800050d2:	6c8e                	ld	s9,192(sp)
    800050d4:	6d2e                	ld	s10,200(sp)
    800050d6:	6dce                	ld	s11,208(sp)
    800050d8:	6e6e                	ld	t3,216(sp)
    800050da:	7e8e                	ld	t4,224(sp)
    800050dc:	7f2e                	ld	t5,232(sp)
    800050de:	7fce                	ld	t6,240(sp)
    800050e0:	6111                	addi	sp,sp,256
    800050e2:	10200073          	sret
    800050e6:	00000013          	nop
    800050ea:	00000013          	nop
    800050ee:	0001                	nop

00000000800050f0 <timervec>:
    800050f0:	34051573          	csrrw	a0,mscratch,a0
    800050f4:	e10c                	sd	a1,0(a0)
    800050f6:	e510                	sd	a2,8(a0)
    800050f8:	e914                	sd	a3,16(a0)
    800050fa:	6d0c                	ld	a1,24(a0)
    800050fc:	7110                	ld	a2,32(a0)
    800050fe:	6194                	ld	a3,0(a1)
    80005100:	96b2                	add	a3,a3,a2
    80005102:	e194                	sd	a3,0(a1)
    80005104:	4589                	li	a1,2
    80005106:	14459073          	csrw	sip,a1
    8000510a:	6914                	ld	a3,16(a0)
    8000510c:	6510                	ld	a2,8(a0)
    8000510e:	610c                	ld	a1,0(a0)
    80005110:	34051573          	csrrw	a0,mscratch,a0
    80005114:	30200073          	mret
	...

000000008000511a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000511a:	1141                	addi	sp,sp,-16
    8000511c:	e422                	sd	s0,8(sp)
    8000511e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005120:	0c0007b7          	lui	a5,0xc000
    80005124:	4705                	li	a4,1
    80005126:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005128:	c3d8                	sw	a4,4(a5)
}
    8000512a:	6422                	ld	s0,8(sp)
    8000512c:	0141                	addi	sp,sp,16
    8000512e:	8082                	ret

0000000080005130 <plicinithart>:

void
plicinithart(void)
{
    80005130:	1141                	addi	sp,sp,-16
    80005132:	e406                	sd	ra,8(sp)
    80005134:	e022                	sd	s0,0(sp)
    80005136:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005138:	ffffc097          	auipc	ra,0xffffc
    8000513c:	d04080e7          	jalr	-764(ra) # 80000e3c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005140:	0085171b          	slliw	a4,a0,0x8
    80005144:	0c0027b7          	lui	a5,0xc002
    80005148:	97ba                	add	a5,a5,a4
    8000514a:	40200713          	li	a4,1026
    8000514e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005152:	00d5151b          	slliw	a0,a0,0xd
    80005156:	0c2017b7          	lui	a5,0xc201
    8000515a:	97aa                	add	a5,a5,a0
    8000515c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005160:	60a2                	ld	ra,8(sp)
    80005162:	6402                	ld	s0,0(sp)
    80005164:	0141                	addi	sp,sp,16
    80005166:	8082                	ret

0000000080005168 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005168:	1141                	addi	sp,sp,-16
    8000516a:	e406                	sd	ra,8(sp)
    8000516c:	e022                	sd	s0,0(sp)
    8000516e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005170:	ffffc097          	auipc	ra,0xffffc
    80005174:	ccc080e7          	jalr	-820(ra) # 80000e3c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005178:	00d5151b          	slliw	a0,a0,0xd
    8000517c:	0c2017b7          	lui	a5,0xc201
    80005180:	97aa                	add	a5,a5,a0
  return irq;
}
    80005182:	43c8                	lw	a0,4(a5)
    80005184:	60a2                	ld	ra,8(sp)
    80005186:	6402                	ld	s0,0(sp)
    80005188:	0141                	addi	sp,sp,16
    8000518a:	8082                	ret

000000008000518c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000518c:	1101                	addi	sp,sp,-32
    8000518e:	ec06                	sd	ra,24(sp)
    80005190:	e822                	sd	s0,16(sp)
    80005192:	e426                	sd	s1,8(sp)
    80005194:	1000                	addi	s0,sp,32
    80005196:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005198:	ffffc097          	auipc	ra,0xffffc
    8000519c:	ca4080e7          	jalr	-860(ra) # 80000e3c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051a0:	00d5151b          	slliw	a0,a0,0xd
    800051a4:	0c2017b7          	lui	a5,0xc201
    800051a8:	97aa                	add	a5,a5,a0
    800051aa:	c3c4                	sw	s1,4(a5)
}
    800051ac:	60e2                	ld	ra,24(sp)
    800051ae:	6442                	ld	s0,16(sp)
    800051b0:	64a2                	ld	s1,8(sp)
    800051b2:	6105                	addi	sp,sp,32
    800051b4:	8082                	ret

00000000800051b6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051b6:	1141                	addi	sp,sp,-16
    800051b8:	e406                	sd	ra,8(sp)
    800051ba:	e022                	sd	s0,0(sp)
    800051bc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051be:	479d                	li	a5,7
    800051c0:	06a7c863          	blt	a5,a0,80005230 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    800051c4:	00016717          	auipc	a4,0x16
    800051c8:	e3c70713          	addi	a4,a4,-452 # 8001b000 <disk>
    800051cc:	972a                	add	a4,a4,a0
    800051ce:	6789                	lui	a5,0x2
    800051d0:	97ba                	add	a5,a5,a4
    800051d2:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800051d6:	e7ad                	bnez	a5,80005240 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051d8:	00451793          	slli	a5,a0,0x4
    800051dc:	00018717          	auipc	a4,0x18
    800051e0:	e2470713          	addi	a4,a4,-476 # 8001d000 <disk+0x2000>
    800051e4:	6314                	ld	a3,0(a4)
    800051e6:	96be                	add	a3,a3,a5
    800051e8:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800051ec:	6314                	ld	a3,0(a4)
    800051ee:	96be                	add	a3,a3,a5
    800051f0:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800051f4:	6314                	ld	a3,0(a4)
    800051f6:	96be                	add	a3,a3,a5
    800051f8:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800051fc:	6318                	ld	a4,0(a4)
    800051fe:	97ba                	add	a5,a5,a4
    80005200:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005204:	00016717          	auipc	a4,0x16
    80005208:	dfc70713          	addi	a4,a4,-516 # 8001b000 <disk>
    8000520c:	972a                	add	a4,a4,a0
    8000520e:	6789                	lui	a5,0x2
    80005210:	97ba                	add	a5,a5,a4
    80005212:	4705                	li	a4,1
    80005214:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005218:	00018517          	auipc	a0,0x18
    8000521c:	e0050513          	addi	a0,a0,-512 # 8001d018 <disk+0x2018>
    80005220:	ffffc097          	auipc	ra,0xffffc
    80005224:	49e080e7          	jalr	1182(ra) # 800016be <wakeup>
}
    80005228:	60a2                	ld	ra,8(sp)
    8000522a:	6402                	ld	s0,0(sp)
    8000522c:	0141                	addi	sp,sp,16
    8000522e:	8082                	ret
    panic("free_desc 1");
    80005230:	00003517          	auipc	a0,0x3
    80005234:	63850513          	addi	a0,a0,1592 # 80008868 <syscall_names+0x320>
    80005238:	00001097          	auipc	ra,0x1
    8000523c:	9c8080e7          	jalr	-1592(ra) # 80005c00 <panic>
    panic("free_desc 2");
    80005240:	00003517          	auipc	a0,0x3
    80005244:	63850513          	addi	a0,a0,1592 # 80008878 <syscall_names+0x330>
    80005248:	00001097          	auipc	ra,0x1
    8000524c:	9b8080e7          	jalr	-1608(ra) # 80005c00 <panic>

0000000080005250 <virtio_disk_init>:
{
    80005250:	1101                	addi	sp,sp,-32
    80005252:	ec06                	sd	ra,24(sp)
    80005254:	e822                	sd	s0,16(sp)
    80005256:	e426                	sd	s1,8(sp)
    80005258:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000525a:	00003597          	auipc	a1,0x3
    8000525e:	62e58593          	addi	a1,a1,1582 # 80008888 <syscall_names+0x340>
    80005262:	00018517          	auipc	a0,0x18
    80005266:	ec650513          	addi	a0,a0,-314 # 8001d128 <disk+0x2128>
    8000526a:	00001097          	auipc	ra,0x1
    8000526e:	e3e080e7          	jalr	-450(ra) # 800060a8 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005272:	100017b7          	lui	a5,0x10001
    80005276:	4398                	lw	a4,0(a5)
    80005278:	2701                	sext.w	a4,a4
    8000527a:	747277b7          	lui	a5,0x74727
    8000527e:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005282:	0ef71063          	bne	a4,a5,80005362 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005286:	100017b7          	lui	a5,0x10001
    8000528a:	43dc                	lw	a5,4(a5)
    8000528c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000528e:	4705                	li	a4,1
    80005290:	0ce79963          	bne	a5,a4,80005362 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005294:	100017b7          	lui	a5,0x10001
    80005298:	479c                	lw	a5,8(a5)
    8000529a:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000529c:	4709                	li	a4,2
    8000529e:	0ce79263          	bne	a5,a4,80005362 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052a2:	100017b7          	lui	a5,0x10001
    800052a6:	47d8                	lw	a4,12(a5)
    800052a8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052aa:	554d47b7          	lui	a5,0x554d4
    800052ae:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052b2:	0af71863          	bne	a4,a5,80005362 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052b6:	100017b7          	lui	a5,0x10001
    800052ba:	4705                	li	a4,1
    800052bc:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052be:	470d                	li	a4,3
    800052c0:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052c2:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052c4:	c7ffe6b7          	lui	a3,0xc7ffe
    800052c8:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    800052cc:	8f75                	and	a4,a4,a3
    800052ce:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052d0:	472d                	li	a4,11
    800052d2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052d4:	473d                	li	a4,15
    800052d6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800052d8:	6705                	lui	a4,0x1
    800052da:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052dc:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800052e0:	5bdc                	lw	a5,52(a5)
    800052e2:	2781                	sext.w	a5,a5
  if(max == 0)
    800052e4:	c7d9                	beqz	a5,80005372 <virtio_disk_init+0x122>
  if(max < NUM)
    800052e6:	471d                	li	a4,7
    800052e8:	08f77d63          	bgeu	a4,a5,80005382 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052ec:	100014b7          	lui	s1,0x10001
    800052f0:	47a1                	li	a5,8
    800052f2:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800052f4:	6609                	lui	a2,0x2
    800052f6:	4581                	li	a1,0
    800052f8:	00016517          	auipc	a0,0x16
    800052fc:	d0850513          	addi	a0,a0,-760 # 8001b000 <disk>
    80005300:	ffffb097          	auipc	ra,0xffffb
    80005304:	e9e080e7          	jalr	-354(ra) # 8000019e <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005308:	00016717          	auipc	a4,0x16
    8000530c:	cf870713          	addi	a4,a4,-776 # 8001b000 <disk>
    80005310:	00c75793          	srli	a5,a4,0xc
    80005314:	2781                	sext.w	a5,a5
    80005316:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005318:	00018797          	auipc	a5,0x18
    8000531c:	ce878793          	addi	a5,a5,-792 # 8001d000 <disk+0x2000>
    80005320:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005322:	00016717          	auipc	a4,0x16
    80005326:	d5e70713          	addi	a4,a4,-674 # 8001b080 <disk+0x80>
    8000532a:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000532c:	00017717          	auipc	a4,0x17
    80005330:	cd470713          	addi	a4,a4,-812 # 8001c000 <disk+0x1000>
    80005334:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005336:	4705                	li	a4,1
    80005338:	00e78c23          	sb	a4,24(a5)
    8000533c:	00e78ca3          	sb	a4,25(a5)
    80005340:	00e78d23          	sb	a4,26(a5)
    80005344:	00e78da3          	sb	a4,27(a5)
    80005348:	00e78e23          	sb	a4,28(a5)
    8000534c:	00e78ea3          	sb	a4,29(a5)
    80005350:	00e78f23          	sb	a4,30(a5)
    80005354:	00e78fa3          	sb	a4,31(a5)
}
    80005358:	60e2                	ld	ra,24(sp)
    8000535a:	6442                	ld	s0,16(sp)
    8000535c:	64a2                	ld	s1,8(sp)
    8000535e:	6105                	addi	sp,sp,32
    80005360:	8082                	ret
    panic("could not find virtio disk");
    80005362:	00003517          	auipc	a0,0x3
    80005366:	53650513          	addi	a0,a0,1334 # 80008898 <syscall_names+0x350>
    8000536a:	00001097          	auipc	ra,0x1
    8000536e:	896080e7          	jalr	-1898(ra) # 80005c00 <panic>
    panic("virtio disk has no queue 0");
    80005372:	00003517          	auipc	a0,0x3
    80005376:	54650513          	addi	a0,a0,1350 # 800088b8 <syscall_names+0x370>
    8000537a:	00001097          	auipc	ra,0x1
    8000537e:	886080e7          	jalr	-1914(ra) # 80005c00 <panic>
    panic("virtio disk max queue too short");
    80005382:	00003517          	auipc	a0,0x3
    80005386:	55650513          	addi	a0,a0,1366 # 800088d8 <syscall_names+0x390>
    8000538a:	00001097          	auipc	ra,0x1
    8000538e:	876080e7          	jalr	-1930(ra) # 80005c00 <panic>

0000000080005392 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005392:	7119                	addi	sp,sp,-128
    80005394:	fc86                	sd	ra,120(sp)
    80005396:	f8a2                	sd	s0,112(sp)
    80005398:	f4a6                	sd	s1,104(sp)
    8000539a:	f0ca                	sd	s2,96(sp)
    8000539c:	ecce                	sd	s3,88(sp)
    8000539e:	e8d2                	sd	s4,80(sp)
    800053a0:	e4d6                	sd	s5,72(sp)
    800053a2:	e0da                	sd	s6,64(sp)
    800053a4:	fc5e                	sd	s7,56(sp)
    800053a6:	f862                	sd	s8,48(sp)
    800053a8:	f466                	sd	s9,40(sp)
    800053aa:	f06a                	sd	s10,32(sp)
    800053ac:	ec6e                	sd	s11,24(sp)
    800053ae:	0100                	addi	s0,sp,128
    800053b0:	8aaa                	mv	s5,a0
    800053b2:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053b4:	00c52c83          	lw	s9,12(a0)
    800053b8:	001c9c9b          	slliw	s9,s9,0x1
    800053bc:	1c82                	slli	s9,s9,0x20
    800053be:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800053c2:	00018517          	auipc	a0,0x18
    800053c6:	d6650513          	addi	a0,a0,-666 # 8001d128 <disk+0x2128>
    800053ca:	00001097          	auipc	ra,0x1
    800053ce:	d6e080e7          	jalr	-658(ra) # 80006138 <acquire>
  for(int i = 0; i < 3; i++){
    800053d2:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800053d4:	44a1                	li	s1,8
      disk.free[i] = 0;
    800053d6:	00016c17          	auipc	s8,0x16
    800053da:	c2ac0c13          	addi	s8,s8,-982 # 8001b000 <disk>
    800053de:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    800053e0:	4b0d                	li	s6,3
    800053e2:	a0ad                	j	8000544c <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800053e4:	00fc0733          	add	a4,s8,a5
    800053e8:	975e                	add	a4,a4,s7
    800053ea:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800053ee:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800053f0:	0207c563          	bltz	a5,8000541a <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800053f4:	2905                	addiw	s2,s2,1
    800053f6:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    800053f8:	19690c63          	beq	s2,s6,80005590 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    800053fc:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800053fe:	00018717          	auipc	a4,0x18
    80005402:	c1a70713          	addi	a4,a4,-998 # 8001d018 <disk+0x2018>
    80005406:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005408:	00074683          	lbu	a3,0(a4)
    8000540c:	fee1                	bnez	a3,800053e4 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    8000540e:	2785                	addiw	a5,a5,1
    80005410:	0705                	addi	a4,a4,1
    80005412:	fe979be3          	bne	a5,s1,80005408 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005416:	57fd                	li	a5,-1
    80005418:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000541a:	01205d63          	blez	s2,80005434 <virtio_disk_rw+0xa2>
    8000541e:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005420:	000a2503          	lw	a0,0(s4)
    80005424:	00000097          	auipc	ra,0x0
    80005428:	d92080e7          	jalr	-622(ra) # 800051b6 <free_desc>
      for(int j = 0; j < i; j++)
    8000542c:	2d85                	addiw	s11,s11,1
    8000542e:	0a11                	addi	s4,s4,4
    80005430:	ff2d98e3          	bne	s11,s2,80005420 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005434:	00018597          	auipc	a1,0x18
    80005438:	cf458593          	addi	a1,a1,-780 # 8001d128 <disk+0x2128>
    8000543c:	00018517          	auipc	a0,0x18
    80005440:	bdc50513          	addi	a0,a0,-1060 # 8001d018 <disk+0x2018>
    80005444:	ffffc097          	auipc	ra,0xffffc
    80005448:	0ee080e7          	jalr	238(ra) # 80001532 <sleep>
  for(int i = 0; i < 3; i++){
    8000544c:	f8040a13          	addi	s4,s0,-128
{
    80005450:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005452:	894e                	mv	s2,s3
    80005454:	b765                	j	800053fc <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005456:	00018697          	auipc	a3,0x18
    8000545a:	baa6b683          	ld	a3,-1110(a3) # 8001d000 <disk+0x2000>
    8000545e:	96ba                	add	a3,a3,a4
    80005460:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005464:	00016817          	auipc	a6,0x16
    80005468:	b9c80813          	addi	a6,a6,-1124 # 8001b000 <disk>
    8000546c:	00018697          	auipc	a3,0x18
    80005470:	b9468693          	addi	a3,a3,-1132 # 8001d000 <disk+0x2000>
    80005474:	6290                	ld	a2,0(a3)
    80005476:	963a                	add	a2,a2,a4
    80005478:	00c65583          	lhu	a1,12(a2)
    8000547c:	0015e593          	ori	a1,a1,1
    80005480:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005484:	f8842603          	lw	a2,-120(s0)
    80005488:	628c                	ld	a1,0(a3)
    8000548a:	972e                	add	a4,a4,a1
    8000548c:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005490:	20050593          	addi	a1,a0,512
    80005494:	0592                	slli	a1,a1,0x4
    80005496:	95c2                	add	a1,a1,a6
    80005498:	577d                	li	a4,-1
    8000549a:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000549e:	00461713          	slli	a4,a2,0x4
    800054a2:	6290                	ld	a2,0(a3)
    800054a4:	963a                	add	a2,a2,a4
    800054a6:	03078793          	addi	a5,a5,48
    800054aa:	97c2                	add	a5,a5,a6
    800054ac:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    800054ae:	629c                	ld	a5,0(a3)
    800054b0:	97ba                	add	a5,a5,a4
    800054b2:	4605                	li	a2,1
    800054b4:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800054b6:	629c                	ld	a5,0(a3)
    800054b8:	97ba                	add	a5,a5,a4
    800054ba:	4809                	li	a6,2
    800054bc:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800054c0:	629c                	ld	a5,0(a3)
    800054c2:	97ba                	add	a5,a5,a4
    800054c4:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800054c8:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800054cc:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800054d0:	6698                	ld	a4,8(a3)
    800054d2:	00275783          	lhu	a5,2(a4)
    800054d6:	8b9d                	andi	a5,a5,7
    800054d8:	0786                	slli	a5,a5,0x1
    800054da:	973e                	add	a4,a4,a5
    800054dc:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    800054e0:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800054e4:	6698                	ld	a4,8(a3)
    800054e6:	00275783          	lhu	a5,2(a4)
    800054ea:	2785                	addiw	a5,a5,1
    800054ec:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800054f0:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800054f4:	100017b7          	lui	a5,0x10001
    800054f8:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800054fc:	004aa783          	lw	a5,4(s5)
    80005500:	02c79163          	bne	a5,a2,80005522 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005504:	00018917          	auipc	s2,0x18
    80005508:	c2490913          	addi	s2,s2,-988 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    8000550c:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000550e:	85ca                	mv	a1,s2
    80005510:	8556                	mv	a0,s5
    80005512:	ffffc097          	auipc	ra,0xffffc
    80005516:	020080e7          	jalr	32(ra) # 80001532 <sleep>
  while(b->disk == 1) {
    8000551a:	004aa783          	lw	a5,4(s5)
    8000551e:	fe9788e3          	beq	a5,s1,8000550e <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005522:	f8042903          	lw	s2,-128(s0)
    80005526:	20090713          	addi	a4,s2,512
    8000552a:	0712                	slli	a4,a4,0x4
    8000552c:	00016797          	auipc	a5,0x16
    80005530:	ad478793          	addi	a5,a5,-1324 # 8001b000 <disk>
    80005534:	97ba                	add	a5,a5,a4
    80005536:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000553a:	00018997          	auipc	s3,0x18
    8000553e:	ac698993          	addi	s3,s3,-1338 # 8001d000 <disk+0x2000>
    80005542:	00491713          	slli	a4,s2,0x4
    80005546:	0009b783          	ld	a5,0(s3)
    8000554a:	97ba                	add	a5,a5,a4
    8000554c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005550:	854a                	mv	a0,s2
    80005552:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005556:	00000097          	auipc	ra,0x0
    8000555a:	c60080e7          	jalr	-928(ra) # 800051b6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000555e:	8885                	andi	s1,s1,1
    80005560:	f0ed                	bnez	s1,80005542 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005562:	00018517          	auipc	a0,0x18
    80005566:	bc650513          	addi	a0,a0,-1082 # 8001d128 <disk+0x2128>
    8000556a:	00001097          	auipc	ra,0x1
    8000556e:	c82080e7          	jalr	-894(ra) # 800061ec <release>
}
    80005572:	70e6                	ld	ra,120(sp)
    80005574:	7446                	ld	s0,112(sp)
    80005576:	74a6                	ld	s1,104(sp)
    80005578:	7906                	ld	s2,96(sp)
    8000557a:	69e6                	ld	s3,88(sp)
    8000557c:	6a46                	ld	s4,80(sp)
    8000557e:	6aa6                	ld	s5,72(sp)
    80005580:	6b06                	ld	s6,64(sp)
    80005582:	7be2                	ld	s7,56(sp)
    80005584:	7c42                	ld	s8,48(sp)
    80005586:	7ca2                	ld	s9,40(sp)
    80005588:	7d02                	ld	s10,32(sp)
    8000558a:	6de2                	ld	s11,24(sp)
    8000558c:	6109                	addi	sp,sp,128
    8000558e:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005590:	f8042503          	lw	a0,-128(s0)
    80005594:	20050793          	addi	a5,a0,512
    80005598:	0792                	slli	a5,a5,0x4
  if(write)
    8000559a:	00016817          	auipc	a6,0x16
    8000559e:	a6680813          	addi	a6,a6,-1434 # 8001b000 <disk>
    800055a2:	00f80733          	add	a4,a6,a5
    800055a6:	01a036b3          	snez	a3,s10
    800055aa:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    800055ae:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800055b2:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055b6:	7679                	lui	a2,0xffffe
    800055b8:	963e                	add	a2,a2,a5
    800055ba:	00018697          	auipc	a3,0x18
    800055be:	a4668693          	addi	a3,a3,-1466 # 8001d000 <disk+0x2000>
    800055c2:	6298                	ld	a4,0(a3)
    800055c4:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055c6:	0a878593          	addi	a1,a5,168
    800055ca:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055cc:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055ce:	6298                	ld	a4,0(a3)
    800055d0:	9732                	add	a4,a4,a2
    800055d2:	45c1                	li	a1,16
    800055d4:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055d6:	6298                	ld	a4,0(a3)
    800055d8:	9732                	add	a4,a4,a2
    800055da:	4585                	li	a1,1
    800055dc:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800055e0:	f8442703          	lw	a4,-124(s0)
    800055e4:	628c                	ld	a1,0(a3)
    800055e6:	962e                	add	a2,a2,a1
    800055e8:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    800055ec:	0712                	slli	a4,a4,0x4
    800055ee:	6290                	ld	a2,0(a3)
    800055f0:	963a                	add	a2,a2,a4
    800055f2:	058a8593          	addi	a1,s5,88
    800055f6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800055f8:	6294                	ld	a3,0(a3)
    800055fa:	96ba                	add	a3,a3,a4
    800055fc:	40000613          	li	a2,1024
    80005600:	c690                	sw	a2,8(a3)
  if(write)
    80005602:	e40d1ae3          	bnez	s10,80005456 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005606:	00018697          	auipc	a3,0x18
    8000560a:	9fa6b683          	ld	a3,-1542(a3) # 8001d000 <disk+0x2000>
    8000560e:	96ba                	add	a3,a3,a4
    80005610:	4609                	li	a2,2
    80005612:	00c69623          	sh	a2,12(a3)
    80005616:	b5b9                	j	80005464 <virtio_disk_rw+0xd2>

0000000080005618 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005618:	1101                	addi	sp,sp,-32
    8000561a:	ec06                	sd	ra,24(sp)
    8000561c:	e822                	sd	s0,16(sp)
    8000561e:	e426                	sd	s1,8(sp)
    80005620:	e04a                	sd	s2,0(sp)
    80005622:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005624:	00018517          	auipc	a0,0x18
    80005628:	b0450513          	addi	a0,a0,-1276 # 8001d128 <disk+0x2128>
    8000562c:	00001097          	auipc	ra,0x1
    80005630:	b0c080e7          	jalr	-1268(ra) # 80006138 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005634:	10001737          	lui	a4,0x10001
    80005638:	533c                	lw	a5,96(a4)
    8000563a:	8b8d                	andi	a5,a5,3
    8000563c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000563e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005642:	00018797          	auipc	a5,0x18
    80005646:	9be78793          	addi	a5,a5,-1602 # 8001d000 <disk+0x2000>
    8000564a:	6b94                	ld	a3,16(a5)
    8000564c:	0207d703          	lhu	a4,32(a5)
    80005650:	0026d783          	lhu	a5,2(a3)
    80005654:	06f70163          	beq	a4,a5,800056b6 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005658:	00016917          	auipc	s2,0x16
    8000565c:	9a890913          	addi	s2,s2,-1624 # 8001b000 <disk>
    80005660:	00018497          	auipc	s1,0x18
    80005664:	9a048493          	addi	s1,s1,-1632 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    80005668:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000566c:	6898                	ld	a4,16(s1)
    8000566e:	0204d783          	lhu	a5,32(s1)
    80005672:	8b9d                	andi	a5,a5,7
    80005674:	078e                	slli	a5,a5,0x3
    80005676:	97ba                	add	a5,a5,a4
    80005678:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000567a:	20078713          	addi	a4,a5,512
    8000567e:	0712                	slli	a4,a4,0x4
    80005680:	974a                	add	a4,a4,s2
    80005682:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005686:	e731                	bnez	a4,800056d2 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005688:	20078793          	addi	a5,a5,512
    8000568c:	0792                	slli	a5,a5,0x4
    8000568e:	97ca                	add	a5,a5,s2
    80005690:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005692:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005696:	ffffc097          	auipc	ra,0xffffc
    8000569a:	028080e7          	jalr	40(ra) # 800016be <wakeup>

    disk.used_idx += 1;
    8000569e:	0204d783          	lhu	a5,32(s1)
    800056a2:	2785                	addiw	a5,a5,1
    800056a4:	17c2                	slli	a5,a5,0x30
    800056a6:	93c1                	srli	a5,a5,0x30
    800056a8:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800056ac:	6898                	ld	a4,16(s1)
    800056ae:	00275703          	lhu	a4,2(a4)
    800056b2:	faf71be3          	bne	a4,a5,80005668 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800056b6:	00018517          	auipc	a0,0x18
    800056ba:	a7250513          	addi	a0,a0,-1422 # 8001d128 <disk+0x2128>
    800056be:	00001097          	auipc	ra,0x1
    800056c2:	b2e080e7          	jalr	-1234(ra) # 800061ec <release>
}
    800056c6:	60e2                	ld	ra,24(sp)
    800056c8:	6442                	ld	s0,16(sp)
    800056ca:	64a2                	ld	s1,8(sp)
    800056cc:	6902                	ld	s2,0(sp)
    800056ce:	6105                	addi	sp,sp,32
    800056d0:	8082                	ret
      panic("virtio_disk_intr status");
    800056d2:	00003517          	auipc	a0,0x3
    800056d6:	22650513          	addi	a0,a0,550 # 800088f8 <syscall_names+0x3b0>
    800056da:	00000097          	auipc	ra,0x0
    800056de:	526080e7          	jalr	1318(ra) # 80005c00 <panic>

00000000800056e2 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800056e2:	1141                	addi	sp,sp,-16
    800056e4:	e422                	sd	s0,8(sp)
    800056e6:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800056e8:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800056ec:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800056f0:	0037979b          	slliw	a5,a5,0x3
    800056f4:	02004737          	lui	a4,0x2004
    800056f8:	97ba                	add	a5,a5,a4
    800056fa:	0200c737          	lui	a4,0x200c
    800056fe:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005702:	000f4637          	lui	a2,0xf4
    80005706:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000570a:	9732                	add	a4,a4,a2
    8000570c:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000570e:	00259693          	slli	a3,a1,0x2
    80005712:	96ae                	add	a3,a3,a1
    80005714:	068e                	slli	a3,a3,0x3
    80005716:	00019717          	auipc	a4,0x19
    8000571a:	8ea70713          	addi	a4,a4,-1814 # 8001e000 <timer_scratch>
    8000571e:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005720:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005722:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005724:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005728:	00000797          	auipc	a5,0x0
    8000572c:	9c878793          	addi	a5,a5,-1592 # 800050f0 <timervec>
    80005730:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005734:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005738:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000573c:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005740:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005744:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005748:	30479073          	csrw	mie,a5
}
    8000574c:	6422                	ld	s0,8(sp)
    8000574e:	0141                	addi	sp,sp,16
    80005750:	8082                	ret

0000000080005752 <start>:
{
    80005752:	1141                	addi	sp,sp,-16
    80005754:	e406                	sd	ra,8(sp)
    80005756:	e022                	sd	s0,0(sp)
    80005758:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000575a:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000575e:	7779                	lui	a4,0xffffe
    80005760:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    80005764:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005766:	6705                	lui	a4,0x1
    80005768:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000576c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000576e:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005772:	ffffb797          	auipc	a5,0xffffb
    80005776:	bd278793          	addi	a5,a5,-1070 # 80000344 <main>
    8000577a:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000577e:	4781                	li	a5,0
    80005780:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005784:	67c1                	lui	a5,0x10
    80005786:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005788:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000578c:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005790:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005794:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005798:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    8000579c:	57fd                	li	a5,-1
    8000579e:	83a9                	srli	a5,a5,0xa
    800057a0:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057a4:	47bd                	li	a5,15
    800057a6:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800057aa:	00000097          	auipc	ra,0x0
    800057ae:	f38080e7          	jalr	-200(ra) # 800056e2 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057b2:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800057b6:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800057b8:	823e                	mv	tp,a5
  asm volatile("mret");
    800057ba:	30200073          	mret
}
    800057be:	60a2                	ld	ra,8(sp)
    800057c0:	6402                	ld	s0,0(sp)
    800057c2:	0141                	addi	sp,sp,16
    800057c4:	8082                	ret

00000000800057c6 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800057c6:	715d                	addi	sp,sp,-80
    800057c8:	e486                	sd	ra,72(sp)
    800057ca:	e0a2                	sd	s0,64(sp)
    800057cc:	fc26                	sd	s1,56(sp)
    800057ce:	f84a                	sd	s2,48(sp)
    800057d0:	f44e                	sd	s3,40(sp)
    800057d2:	f052                	sd	s4,32(sp)
    800057d4:	ec56                	sd	s5,24(sp)
    800057d6:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800057d8:	04c05763          	blez	a2,80005826 <consolewrite+0x60>
    800057dc:	8a2a                	mv	s4,a0
    800057de:	84ae                	mv	s1,a1
    800057e0:	89b2                	mv	s3,a2
    800057e2:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800057e4:	5afd                	li	s5,-1
    800057e6:	4685                	li	a3,1
    800057e8:	8626                	mv	a2,s1
    800057ea:	85d2                	mv	a1,s4
    800057ec:	fbf40513          	addi	a0,s0,-65
    800057f0:	ffffc097          	auipc	ra,0xffffc
    800057f4:	13c080e7          	jalr	316(ra) # 8000192c <either_copyin>
    800057f8:	01550d63          	beq	a0,s5,80005812 <consolewrite+0x4c>
      break;
    uartputc(c);
    800057fc:	fbf44503          	lbu	a0,-65(s0)
    80005800:	00000097          	auipc	ra,0x0
    80005804:	77e080e7          	jalr	1918(ra) # 80005f7e <uartputc>
  for(i = 0; i < n; i++){
    80005808:	2905                	addiw	s2,s2,1
    8000580a:	0485                	addi	s1,s1,1
    8000580c:	fd299de3          	bne	s3,s2,800057e6 <consolewrite+0x20>
    80005810:	894e                	mv	s2,s3
  }

  return i;
}
    80005812:	854a                	mv	a0,s2
    80005814:	60a6                	ld	ra,72(sp)
    80005816:	6406                	ld	s0,64(sp)
    80005818:	74e2                	ld	s1,56(sp)
    8000581a:	7942                	ld	s2,48(sp)
    8000581c:	79a2                	ld	s3,40(sp)
    8000581e:	7a02                	ld	s4,32(sp)
    80005820:	6ae2                	ld	s5,24(sp)
    80005822:	6161                	addi	sp,sp,80
    80005824:	8082                	ret
  for(i = 0; i < n; i++){
    80005826:	4901                	li	s2,0
    80005828:	b7ed                	j	80005812 <consolewrite+0x4c>

000000008000582a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000582a:	7159                	addi	sp,sp,-112
    8000582c:	f486                	sd	ra,104(sp)
    8000582e:	f0a2                	sd	s0,96(sp)
    80005830:	eca6                	sd	s1,88(sp)
    80005832:	e8ca                	sd	s2,80(sp)
    80005834:	e4ce                	sd	s3,72(sp)
    80005836:	e0d2                	sd	s4,64(sp)
    80005838:	fc56                	sd	s5,56(sp)
    8000583a:	f85a                	sd	s6,48(sp)
    8000583c:	f45e                	sd	s7,40(sp)
    8000583e:	f062                	sd	s8,32(sp)
    80005840:	ec66                	sd	s9,24(sp)
    80005842:	e86a                	sd	s10,16(sp)
    80005844:	1880                	addi	s0,sp,112
    80005846:	8aaa                	mv	s5,a0
    80005848:	8a2e                	mv	s4,a1
    8000584a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000584c:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005850:	00021517          	auipc	a0,0x21
    80005854:	8f050513          	addi	a0,a0,-1808 # 80026140 <cons>
    80005858:	00001097          	auipc	ra,0x1
    8000585c:	8e0080e7          	jalr	-1824(ra) # 80006138 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005860:	00021497          	auipc	s1,0x21
    80005864:	8e048493          	addi	s1,s1,-1824 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005868:	00021917          	auipc	s2,0x21
    8000586c:	97090913          	addi	s2,s2,-1680 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005870:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005872:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005874:	4ca9                	li	s9,10
  while(n > 0){
    80005876:	07305863          	blez	s3,800058e6 <consoleread+0xbc>
    while(cons.r == cons.w){
    8000587a:	0984a783          	lw	a5,152(s1)
    8000587e:	09c4a703          	lw	a4,156(s1)
    80005882:	02f71463          	bne	a4,a5,800058aa <consoleread+0x80>
      if(myproc()->killed){
    80005886:	ffffb097          	auipc	ra,0xffffb
    8000588a:	5e2080e7          	jalr	1506(ra) # 80000e68 <myproc>
    8000588e:	551c                	lw	a5,40(a0)
    80005890:	e7b5                	bnez	a5,800058fc <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80005892:	85a6                	mv	a1,s1
    80005894:	854a                	mv	a0,s2
    80005896:	ffffc097          	auipc	ra,0xffffc
    8000589a:	c9c080e7          	jalr	-868(ra) # 80001532 <sleep>
    while(cons.r == cons.w){
    8000589e:	0984a783          	lw	a5,152(s1)
    800058a2:	09c4a703          	lw	a4,156(s1)
    800058a6:	fef700e3          	beq	a4,a5,80005886 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800058aa:	0017871b          	addiw	a4,a5,1
    800058ae:	08e4ac23          	sw	a4,152(s1)
    800058b2:	07f7f713          	andi	a4,a5,127
    800058b6:	9726                	add	a4,a4,s1
    800058b8:	01874703          	lbu	a4,24(a4)
    800058bc:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800058c0:	077d0563          	beq	s10,s7,8000592a <consoleread+0x100>
    cbuf = c;
    800058c4:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058c8:	4685                	li	a3,1
    800058ca:	f9f40613          	addi	a2,s0,-97
    800058ce:	85d2                	mv	a1,s4
    800058d0:	8556                	mv	a0,s5
    800058d2:	ffffc097          	auipc	ra,0xffffc
    800058d6:	004080e7          	jalr	4(ra) # 800018d6 <either_copyout>
    800058da:	01850663          	beq	a0,s8,800058e6 <consoleread+0xbc>
    dst++;
    800058de:	0a05                	addi	s4,s4,1
    --n;
    800058e0:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    800058e2:	f99d1ae3          	bne	s10,s9,80005876 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800058e6:	00021517          	auipc	a0,0x21
    800058ea:	85a50513          	addi	a0,a0,-1958 # 80026140 <cons>
    800058ee:	00001097          	auipc	ra,0x1
    800058f2:	8fe080e7          	jalr	-1794(ra) # 800061ec <release>

  return target - n;
    800058f6:	413b053b          	subw	a0,s6,s3
    800058fa:	a811                	j	8000590e <consoleread+0xe4>
        release(&cons.lock);
    800058fc:	00021517          	auipc	a0,0x21
    80005900:	84450513          	addi	a0,a0,-1980 # 80026140 <cons>
    80005904:	00001097          	auipc	ra,0x1
    80005908:	8e8080e7          	jalr	-1816(ra) # 800061ec <release>
        return -1;
    8000590c:	557d                	li	a0,-1
}
    8000590e:	70a6                	ld	ra,104(sp)
    80005910:	7406                	ld	s0,96(sp)
    80005912:	64e6                	ld	s1,88(sp)
    80005914:	6946                	ld	s2,80(sp)
    80005916:	69a6                	ld	s3,72(sp)
    80005918:	6a06                	ld	s4,64(sp)
    8000591a:	7ae2                	ld	s5,56(sp)
    8000591c:	7b42                	ld	s6,48(sp)
    8000591e:	7ba2                	ld	s7,40(sp)
    80005920:	7c02                	ld	s8,32(sp)
    80005922:	6ce2                	ld	s9,24(sp)
    80005924:	6d42                	ld	s10,16(sp)
    80005926:	6165                	addi	sp,sp,112
    80005928:	8082                	ret
      if(n < target){
    8000592a:	0009871b          	sext.w	a4,s3
    8000592e:	fb677ce3          	bgeu	a4,s6,800058e6 <consoleread+0xbc>
        cons.r--;
    80005932:	00021717          	auipc	a4,0x21
    80005936:	8af72323          	sw	a5,-1882(a4) # 800261d8 <cons+0x98>
    8000593a:	b775                	j	800058e6 <consoleread+0xbc>

000000008000593c <consputc>:
{
    8000593c:	1141                	addi	sp,sp,-16
    8000593e:	e406                	sd	ra,8(sp)
    80005940:	e022                	sd	s0,0(sp)
    80005942:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005944:	10000793          	li	a5,256
    80005948:	00f50a63          	beq	a0,a5,8000595c <consputc+0x20>
    uartputc_sync(c);
    8000594c:	00000097          	auipc	ra,0x0
    80005950:	560080e7          	jalr	1376(ra) # 80005eac <uartputc_sync>
}
    80005954:	60a2                	ld	ra,8(sp)
    80005956:	6402                	ld	s0,0(sp)
    80005958:	0141                	addi	sp,sp,16
    8000595a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000595c:	4521                	li	a0,8
    8000595e:	00000097          	auipc	ra,0x0
    80005962:	54e080e7          	jalr	1358(ra) # 80005eac <uartputc_sync>
    80005966:	02000513          	li	a0,32
    8000596a:	00000097          	auipc	ra,0x0
    8000596e:	542080e7          	jalr	1346(ra) # 80005eac <uartputc_sync>
    80005972:	4521                	li	a0,8
    80005974:	00000097          	auipc	ra,0x0
    80005978:	538080e7          	jalr	1336(ra) # 80005eac <uartputc_sync>
    8000597c:	bfe1                	j	80005954 <consputc+0x18>

000000008000597e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    8000597e:	1101                	addi	sp,sp,-32
    80005980:	ec06                	sd	ra,24(sp)
    80005982:	e822                	sd	s0,16(sp)
    80005984:	e426                	sd	s1,8(sp)
    80005986:	e04a                	sd	s2,0(sp)
    80005988:	1000                	addi	s0,sp,32
    8000598a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000598c:	00020517          	auipc	a0,0x20
    80005990:	7b450513          	addi	a0,a0,1972 # 80026140 <cons>
    80005994:	00000097          	auipc	ra,0x0
    80005998:	7a4080e7          	jalr	1956(ra) # 80006138 <acquire>

  switch(c){
    8000599c:	47d5                	li	a5,21
    8000599e:	0af48663          	beq	s1,a5,80005a4a <consoleintr+0xcc>
    800059a2:	0297ca63          	blt	a5,s1,800059d6 <consoleintr+0x58>
    800059a6:	47a1                	li	a5,8
    800059a8:	0ef48763          	beq	s1,a5,80005a96 <consoleintr+0x118>
    800059ac:	47c1                	li	a5,16
    800059ae:	10f49a63          	bne	s1,a5,80005ac2 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800059b2:	ffffc097          	auipc	ra,0xffffc
    800059b6:	fd0080e7          	jalr	-48(ra) # 80001982 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800059ba:	00020517          	auipc	a0,0x20
    800059be:	78650513          	addi	a0,a0,1926 # 80026140 <cons>
    800059c2:	00001097          	auipc	ra,0x1
    800059c6:	82a080e7          	jalr	-2006(ra) # 800061ec <release>
}
    800059ca:	60e2                	ld	ra,24(sp)
    800059cc:	6442                	ld	s0,16(sp)
    800059ce:	64a2                	ld	s1,8(sp)
    800059d0:	6902                	ld	s2,0(sp)
    800059d2:	6105                	addi	sp,sp,32
    800059d4:	8082                	ret
  switch(c){
    800059d6:	07f00793          	li	a5,127
    800059da:	0af48e63          	beq	s1,a5,80005a96 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800059de:	00020717          	auipc	a4,0x20
    800059e2:	76270713          	addi	a4,a4,1890 # 80026140 <cons>
    800059e6:	0a072783          	lw	a5,160(a4)
    800059ea:	09872703          	lw	a4,152(a4)
    800059ee:	9f99                	subw	a5,a5,a4
    800059f0:	07f00713          	li	a4,127
    800059f4:	fcf763e3          	bltu	a4,a5,800059ba <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    800059f8:	47b5                	li	a5,13
    800059fa:	0cf48763          	beq	s1,a5,80005ac8 <consoleintr+0x14a>
      consputc(c);
    800059fe:	8526                	mv	a0,s1
    80005a00:	00000097          	auipc	ra,0x0
    80005a04:	f3c080e7          	jalr	-196(ra) # 8000593c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a08:	00020797          	auipc	a5,0x20
    80005a0c:	73878793          	addi	a5,a5,1848 # 80026140 <cons>
    80005a10:	0a07a703          	lw	a4,160(a5)
    80005a14:	0017069b          	addiw	a3,a4,1
    80005a18:	0006861b          	sext.w	a2,a3
    80005a1c:	0ad7a023          	sw	a3,160(a5)
    80005a20:	07f77713          	andi	a4,a4,127
    80005a24:	97ba                	add	a5,a5,a4
    80005a26:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a2a:	47a9                	li	a5,10
    80005a2c:	0cf48563          	beq	s1,a5,80005af6 <consoleintr+0x178>
    80005a30:	4791                	li	a5,4
    80005a32:	0cf48263          	beq	s1,a5,80005af6 <consoleintr+0x178>
    80005a36:	00020797          	auipc	a5,0x20
    80005a3a:	7a27a783          	lw	a5,1954(a5) # 800261d8 <cons+0x98>
    80005a3e:	0807879b          	addiw	a5,a5,128
    80005a42:	f6f61ce3          	bne	a2,a5,800059ba <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a46:	863e                	mv	a2,a5
    80005a48:	a07d                	j	80005af6 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005a4a:	00020717          	auipc	a4,0x20
    80005a4e:	6f670713          	addi	a4,a4,1782 # 80026140 <cons>
    80005a52:	0a072783          	lw	a5,160(a4)
    80005a56:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005a5a:	00020497          	auipc	s1,0x20
    80005a5e:	6e648493          	addi	s1,s1,1766 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005a62:	4929                	li	s2,10
    80005a64:	f4f70be3          	beq	a4,a5,800059ba <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005a68:	37fd                	addiw	a5,a5,-1
    80005a6a:	07f7f713          	andi	a4,a5,127
    80005a6e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005a70:	01874703          	lbu	a4,24(a4)
    80005a74:	f52703e3          	beq	a4,s2,800059ba <consoleintr+0x3c>
      cons.e--;
    80005a78:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005a7c:	10000513          	li	a0,256
    80005a80:	00000097          	auipc	ra,0x0
    80005a84:	ebc080e7          	jalr	-324(ra) # 8000593c <consputc>
    while(cons.e != cons.w &&
    80005a88:	0a04a783          	lw	a5,160(s1)
    80005a8c:	09c4a703          	lw	a4,156(s1)
    80005a90:	fcf71ce3          	bne	a4,a5,80005a68 <consoleintr+0xea>
    80005a94:	b71d                	j	800059ba <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005a96:	00020717          	auipc	a4,0x20
    80005a9a:	6aa70713          	addi	a4,a4,1706 # 80026140 <cons>
    80005a9e:	0a072783          	lw	a5,160(a4)
    80005aa2:	09c72703          	lw	a4,156(a4)
    80005aa6:	f0f70ae3          	beq	a4,a5,800059ba <consoleintr+0x3c>
      cons.e--;
    80005aaa:	37fd                	addiw	a5,a5,-1
    80005aac:	00020717          	auipc	a4,0x20
    80005ab0:	72f72a23          	sw	a5,1844(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005ab4:	10000513          	li	a0,256
    80005ab8:	00000097          	auipc	ra,0x0
    80005abc:	e84080e7          	jalr	-380(ra) # 8000593c <consputc>
    80005ac0:	bded                	j	800059ba <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005ac2:	ee048ce3          	beqz	s1,800059ba <consoleintr+0x3c>
    80005ac6:	bf21                	j	800059de <consoleintr+0x60>
      consputc(c);
    80005ac8:	4529                	li	a0,10
    80005aca:	00000097          	auipc	ra,0x0
    80005ace:	e72080e7          	jalr	-398(ra) # 8000593c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ad2:	00020797          	auipc	a5,0x20
    80005ad6:	66e78793          	addi	a5,a5,1646 # 80026140 <cons>
    80005ada:	0a07a703          	lw	a4,160(a5)
    80005ade:	0017069b          	addiw	a3,a4,1
    80005ae2:	0006861b          	sext.w	a2,a3
    80005ae6:	0ad7a023          	sw	a3,160(a5)
    80005aea:	07f77713          	andi	a4,a4,127
    80005aee:	97ba                	add	a5,a5,a4
    80005af0:	4729                	li	a4,10
    80005af2:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005af6:	00020797          	auipc	a5,0x20
    80005afa:	6ec7a323          	sw	a2,1766(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005afe:	00020517          	auipc	a0,0x20
    80005b02:	6da50513          	addi	a0,a0,1754 # 800261d8 <cons+0x98>
    80005b06:	ffffc097          	auipc	ra,0xffffc
    80005b0a:	bb8080e7          	jalr	-1096(ra) # 800016be <wakeup>
    80005b0e:	b575                	j	800059ba <consoleintr+0x3c>

0000000080005b10 <consoleinit>:

void
consoleinit(void)
{
    80005b10:	1141                	addi	sp,sp,-16
    80005b12:	e406                	sd	ra,8(sp)
    80005b14:	e022                	sd	s0,0(sp)
    80005b16:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b18:	00003597          	auipc	a1,0x3
    80005b1c:	df858593          	addi	a1,a1,-520 # 80008910 <syscall_names+0x3c8>
    80005b20:	00020517          	auipc	a0,0x20
    80005b24:	62050513          	addi	a0,a0,1568 # 80026140 <cons>
    80005b28:	00000097          	auipc	ra,0x0
    80005b2c:	580080e7          	jalr	1408(ra) # 800060a8 <initlock>

  uartinit();
    80005b30:	00000097          	auipc	ra,0x0
    80005b34:	32c080e7          	jalr	812(ra) # 80005e5c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b38:	00013797          	auipc	a5,0x13
    80005b3c:	59078793          	addi	a5,a5,1424 # 800190c8 <devsw>
    80005b40:	00000717          	auipc	a4,0x0
    80005b44:	cea70713          	addi	a4,a4,-790 # 8000582a <consoleread>
    80005b48:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005b4a:	00000717          	auipc	a4,0x0
    80005b4e:	c7c70713          	addi	a4,a4,-900 # 800057c6 <consolewrite>
    80005b52:	ef98                	sd	a4,24(a5)
}
    80005b54:	60a2                	ld	ra,8(sp)
    80005b56:	6402                	ld	s0,0(sp)
    80005b58:	0141                	addi	sp,sp,16
    80005b5a:	8082                	ret

0000000080005b5c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005b5c:	7179                	addi	sp,sp,-48
    80005b5e:	f406                	sd	ra,40(sp)
    80005b60:	f022                	sd	s0,32(sp)
    80005b62:	ec26                	sd	s1,24(sp)
    80005b64:	e84a                	sd	s2,16(sp)
    80005b66:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005b68:	c219                	beqz	a2,80005b6e <printint+0x12>
    80005b6a:	08054763          	bltz	a0,80005bf8 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005b6e:	2501                	sext.w	a0,a0
    80005b70:	4881                	li	a7,0
    80005b72:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005b76:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005b78:	2581                	sext.w	a1,a1
    80005b7a:	00003617          	auipc	a2,0x3
    80005b7e:	dc660613          	addi	a2,a2,-570 # 80008940 <digits>
    80005b82:	883a                	mv	a6,a4
    80005b84:	2705                	addiw	a4,a4,1
    80005b86:	02b577bb          	remuw	a5,a0,a1
    80005b8a:	1782                	slli	a5,a5,0x20
    80005b8c:	9381                	srli	a5,a5,0x20
    80005b8e:	97b2                	add	a5,a5,a2
    80005b90:	0007c783          	lbu	a5,0(a5)
    80005b94:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005b98:	0005079b          	sext.w	a5,a0
    80005b9c:	02b5553b          	divuw	a0,a0,a1
    80005ba0:	0685                	addi	a3,a3,1
    80005ba2:	feb7f0e3          	bgeu	a5,a1,80005b82 <printint+0x26>

  if(sign)
    80005ba6:	00088c63          	beqz	a7,80005bbe <printint+0x62>
    buf[i++] = '-';
    80005baa:	fe070793          	addi	a5,a4,-32
    80005bae:	00878733          	add	a4,a5,s0
    80005bb2:	02d00793          	li	a5,45
    80005bb6:	fef70823          	sb	a5,-16(a4)
    80005bba:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005bbe:	02e05763          	blez	a4,80005bec <printint+0x90>
    80005bc2:	fd040793          	addi	a5,s0,-48
    80005bc6:	00e784b3          	add	s1,a5,a4
    80005bca:	fff78913          	addi	s2,a5,-1
    80005bce:	993a                	add	s2,s2,a4
    80005bd0:	377d                	addiw	a4,a4,-1
    80005bd2:	1702                	slli	a4,a4,0x20
    80005bd4:	9301                	srli	a4,a4,0x20
    80005bd6:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005bda:	fff4c503          	lbu	a0,-1(s1)
    80005bde:	00000097          	auipc	ra,0x0
    80005be2:	d5e080e7          	jalr	-674(ra) # 8000593c <consputc>
  while(--i >= 0)
    80005be6:	14fd                	addi	s1,s1,-1
    80005be8:	ff2499e3          	bne	s1,s2,80005bda <printint+0x7e>
}
    80005bec:	70a2                	ld	ra,40(sp)
    80005bee:	7402                	ld	s0,32(sp)
    80005bf0:	64e2                	ld	s1,24(sp)
    80005bf2:	6942                	ld	s2,16(sp)
    80005bf4:	6145                	addi	sp,sp,48
    80005bf6:	8082                	ret
    x = -xx;
    80005bf8:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005bfc:	4885                	li	a7,1
    x = -xx;
    80005bfe:	bf95                	j	80005b72 <printint+0x16>

0000000080005c00 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c00:	1101                	addi	sp,sp,-32
    80005c02:	ec06                	sd	ra,24(sp)
    80005c04:	e822                	sd	s0,16(sp)
    80005c06:	e426                	sd	s1,8(sp)
    80005c08:	1000                	addi	s0,sp,32
    80005c0a:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c0c:	00020797          	auipc	a5,0x20
    80005c10:	5e07aa23          	sw	zero,1524(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005c14:	00003517          	auipc	a0,0x3
    80005c18:	d0450513          	addi	a0,a0,-764 # 80008918 <syscall_names+0x3d0>
    80005c1c:	00000097          	auipc	ra,0x0
    80005c20:	02e080e7          	jalr	46(ra) # 80005c4a <printf>
  printf(s);
    80005c24:	8526                	mv	a0,s1
    80005c26:	00000097          	auipc	ra,0x0
    80005c2a:	024080e7          	jalr	36(ra) # 80005c4a <printf>
  printf("\n");
    80005c2e:	00002517          	auipc	a0,0x2
    80005c32:	41a50513          	addi	a0,a0,1050 # 80008048 <etext+0x48>
    80005c36:	00000097          	auipc	ra,0x0
    80005c3a:	014080e7          	jalr	20(ra) # 80005c4a <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005c3e:	4785                	li	a5,1
    80005c40:	00003717          	auipc	a4,0x3
    80005c44:	3cf72e23          	sw	a5,988(a4) # 8000901c <panicked>
  for(;;)
    80005c48:	a001                	j	80005c48 <panic+0x48>

0000000080005c4a <printf>:
{
    80005c4a:	7131                	addi	sp,sp,-192
    80005c4c:	fc86                	sd	ra,120(sp)
    80005c4e:	f8a2                	sd	s0,112(sp)
    80005c50:	f4a6                	sd	s1,104(sp)
    80005c52:	f0ca                	sd	s2,96(sp)
    80005c54:	ecce                	sd	s3,88(sp)
    80005c56:	e8d2                	sd	s4,80(sp)
    80005c58:	e4d6                	sd	s5,72(sp)
    80005c5a:	e0da                	sd	s6,64(sp)
    80005c5c:	fc5e                	sd	s7,56(sp)
    80005c5e:	f862                	sd	s8,48(sp)
    80005c60:	f466                	sd	s9,40(sp)
    80005c62:	f06a                	sd	s10,32(sp)
    80005c64:	ec6e                	sd	s11,24(sp)
    80005c66:	0100                	addi	s0,sp,128
    80005c68:	8a2a                	mv	s4,a0
    80005c6a:	e40c                	sd	a1,8(s0)
    80005c6c:	e810                	sd	a2,16(s0)
    80005c6e:	ec14                	sd	a3,24(s0)
    80005c70:	f018                	sd	a4,32(s0)
    80005c72:	f41c                	sd	a5,40(s0)
    80005c74:	03043823          	sd	a6,48(s0)
    80005c78:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005c7c:	00020d97          	auipc	s11,0x20
    80005c80:	584dad83          	lw	s11,1412(s11) # 80026200 <pr+0x18>
  if(locking)
    80005c84:	020d9b63          	bnez	s11,80005cba <printf+0x70>
  if (fmt == 0)
    80005c88:	040a0263          	beqz	s4,80005ccc <printf+0x82>
  va_start(ap, fmt);
    80005c8c:	00840793          	addi	a5,s0,8
    80005c90:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c94:	000a4503          	lbu	a0,0(s4)
    80005c98:	14050f63          	beqz	a0,80005df6 <printf+0x1ac>
    80005c9c:	4981                	li	s3,0
    if(c != '%'){
    80005c9e:	02500a93          	li	s5,37
    switch(c){
    80005ca2:	07000b93          	li	s7,112
  consputc('x');
    80005ca6:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ca8:	00003b17          	auipc	s6,0x3
    80005cac:	c98b0b13          	addi	s6,s6,-872 # 80008940 <digits>
    switch(c){
    80005cb0:	07300c93          	li	s9,115
    80005cb4:	06400c13          	li	s8,100
    80005cb8:	a82d                	j	80005cf2 <printf+0xa8>
    acquire(&pr.lock);
    80005cba:	00020517          	auipc	a0,0x20
    80005cbe:	52e50513          	addi	a0,a0,1326 # 800261e8 <pr>
    80005cc2:	00000097          	auipc	ra,0x0
    80005cc6:	476080e7          	jalr	1142(ra) # 80006138 <acquire>
    80005cca:	bf7d                	j	80005c88 <printf+0x3e>
    panic("null fmt");
    80005ccc:	00003517          	auipc	a0,0x3
    80005cd0:	c5c50513          	addi	a0,a0,-932 # 80008928 <syscall_names+0x3e0>
    80005cd4:	00000097          	auipc	ra,0x0
    80005cd8:	f2c080e7          	jalr	-212(ra) # 80005c00 <panic>
      consputc(c);
    80005cdc:	00000097          	auipc	ra,0x0
    80005ce0:	c60080e7          	jalr	-928(ra) # 8000593c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005ce4:	2985                	addiw	s3,s3,1
    80005ce6:	013a07b3          	add	a5,s4,s3
    80005cea:	0007c503          	lbu	a0,0(a5)
    80005cee:	10050463          	beqz	a0,80005df6 <printf+0x1ac>
    if(c != '%'){
    80005cf2:	ff5515e3          	bne	a0,s5,80005cdc <printf+0x92>
    c = fmt[++i] & 0xff;
    80005cf6:	2985                	addiw	s3,s3,1
    80005cf8:	013a07b3          	add	a5,s4,s3
    80005cfc:	0007c783          	lbu	a5,0(a5)
    80005d00:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005d04:	cbed                	beqz	a5,80005df6 <printf+0x1ac>
    switch(c){
    80005d06:	05778a63          	beq	a5,s7,80005d5a <printf+0x110>
    80005d0a:	02fbf663          	bgeu	s7,a5,80005d36 <printf+0xec>
    80005d0e:	09978863          	beq	a5,s9,80005d9e <printf+0x154>
    80005d12:	07800713          	li	a4,120
    80005d16:	0ce79563          	bne	a5,a4,80005de0 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005d1a:	f8843783          	ld	a5,-120(s0)
    80005d1e:	00878713          	addi	a4,a5,8
    80005d22:	f8e43423          	sd	a4,-120(s0)
    80005d26:	4605                	li	a2,1
    80005d28:	85ea                	mv	a1,s10
    80005d2a:	4388                	lw	a0,0(a5)
    80005d2c:	00000097          	auipc	ra,0x0
    80005d30:	e30080e7          	jalr	-464(ra) # 80005b5c <printint>
      break;
    80005d34:	bf45                	j	80005ce4 <printf+0x9a>
    switch(c){
    80005d36:	09578f63          	beq	a5,s5,80005dd4 <printf+0x18a>
    80005d3a:	0b879363          	bne	a5,s8,80005de0 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005d3e:	f8843783          	ld	a5,-120(s0)
    80005d42:	00878713          	addi	a4,a5,8
    80005d46:	f8e43423          	sd	a4,-120(s0)
    80005d4a:	4605                	li	a2,1
    80005d4c:	45a9                	li	a1,10
    80005d4e:	4388                	lw	a0,0(a5)
    80005d50:	00000097          	auipc	ra,0x0
    80005d54:	e0c080e7          	jalr	-500(ra) # 80005b5c <printint>
      break;
    80005d58:	b771                	j	80005ce4 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005d5a:	f8843783          	ld	a5,-120(s0)
    80005d5e:	00878713          	addi	a4,a5,8
    80005d62:	f8e43423          	sd	a4,-120(s0)
    80005d66:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005d6a:	03000513          	li	a0,48
    80005d6e:	00000097          	auipc	ra,0x0
    80005d72:	bce080e7          	jalr	-1074(ra) # 8000593c <consputc>
  consputc('x');
    80005d76:	07800513          	li	a0,120
    80005d7a:	00000097          	auipc	ra,0x0
    80005d7e:	bc2080e7          	jalr	-1086(ra) # 8000593c <consputc>
    80005d82:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d84:	03c95793          	srli	a5,s2,0x3c
    80005d88:	97da                	add	a5,a5,s6
    80005d8a:	0007c503          	lbu	a0,0(a5)
    80005d8e:	00000097          	auipc	ra,0x0
    80005d92:	bae080e7          	jalr	-1106(ra) # 8000593c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005d96:	0912                	slli	s2,s2,0x4
    80005d98:	34fd                	addiw	s1,s1,-1
    80005d9a:	f4ed                	bnez	s1,80005d84 <printf+0x13a>
    80005d9c:	b7a1                	j	80005ce4 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005d9e:	f8843783          	ld	a5,-120(s0)
    80005da2:	00878713          	addi	a4,a5,8
    80005da6:	f8e43423          	sd	a4,-120(s0)
    80005daa:	6384                	ld	s1,0(a5)
    80005dac:	cc89                	beqz	s1,80005dc6 <printf+0x17c>
      for(; *s; s++)
    80005dae:	0004c503          	lbu	a0,0(s1)
    80005db2:	d90d                	beqz	a0,80005ce4 <printf+0x9a>
        consputc(*s);
    80005db4:	00000097          	auipc	ra,0x0
    80005db8:	b88080e7          	jalr	-1144(ra) # 8000593c <consputc>
      for(; *s; s++)
    80005dbc:	0485                	addi	s1,s1,1
    80005dbe:	0004c503          	lbu	a0,0(s1)
    80005dc2:	f96d                	bnez	a0,80005db4 <printf+0x16a>
    80005dc4:	b705                	j	80005ce4 <printf+0x9a>
        s = "(null)";
    80005dc6:	00003497          	auipc	s1,0x3
    80005dca:	b5a48493          	addi	s1,s1,-1190 # 80008920 <syscall_names+0x3d8>
      for(; *s; s++)
    80005dce:	02800513          	li	a0,40
    80005dd2:	b7cd                	j	80005db4 <printf+0x16a>
      consputc('%');
    80005dd4:	8556                	mv	a0,s5
    80005dd6:	00000097          	auipc	ra,0x0
    80005dda:	b66080e7          	jalr	-1178(ra) # 8000593c <consputc>
      break;
    80005dde:	b719                	j	80005ce4 <printf+0x9a>
      consputc('%');
    80005de0:	8556                	mv	a0,s5
    80005de2:	00000097          	auipc	ra,0x0
    80005de6:	b5a080e7          	jalr	-1190(ra) # 8000593c <consputc>
      consputc(c);
    80005dea:	8526                	mv	a0,s1
    80005dec:	00000097          	auipc	ra,0x0
    80005df0:	b50080e7          	jalr	-1200(ra) # 8000593c <consputc>
      break;
    80005df4:	bdc5                	j	80005ce4 <printf+0x9a>
  if(locking)
    80005df6:	020d9163          	bnez	s11,80005e18 <printf+0x1ce>
}
    80005dfa:	70e6                	ld	ra,120(sp)
    80005dfc:	7446                	ld	s0,112(sp)
    80005dfe:	74a6                	ld	s1,104(sp)
    80005e00:	7906                	ld	s2,96(sp)
    80005e02:	69e6                	ld	s3,88(sp)
    80005e04:	6a46                	ld	s4,80(sp)
    80005e06:	6aa6                	ld	s5,72(sp)
    80005e08:	6b06                	ld	s6,64(sp)
    80005e0a:	7be2                	ld	s7,56(sp)
    80005e0c:	7c42                	ld	s8,48(sp)
    80005e0e:	7ca2                	ld	s9,40(sp)
    80005e10:	7d02                	ld	s10,32(sp)
    80005e12:	6de2                	ld	s11,24(sp)
    80005e14:	6129                	addi	sp,sp,192
    80005e16:	8082                	ret
    release(&pr.lock);
    80005e18:	00020517          	auipc	a0,0x20
    80005e1c:	3d050513          	addi	a0,a0,976 # 800261e8 <pr>
    80005e20:	00000097          	auipc	ra,0x0
    80005e24:	3cc080e7          	jalr	972(ra) # 800061ec <release>
}
    80005e28:	bfc9                	j	80005dfa <printf+0x1b0>

0000000080005e2a <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e2a:	1101                	addi	sp,sp,-32
    80005e2c:	ec06                	sd	ra,24(sp)
    80005e2e:	e822                	sd	s0,16(sp)
    80005e30:	e426                	sd	s1,8(sp)
    80005e32:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e34:	00020497          	auipc	s1,0x20
    80005e38:	3b448493          	addi	s1,s1,948 # 800261e8 <pr>
    80005e3c:	00003597          	auipc	a1,0x3
    80005e40:	afc58593          	addi	a1,a1,-1284 # 80008938 <syscall_names+0x3f0>
    80005e44:	8526                	mv	a0,s1
    80005e46:	00000097          	auipc	ra,0x0
    80005e4a:	262080e7          	jalr	610(ra) # 800060a8 <initlock>
  pr.locking = 1;
    80005e4e:	4785                	li	a5,1
    80005e50:	cc9c                	sw	a5,24(s1)
}
    80005e52:	60e2                	ld	ra,24(sp)
    80005e54:	6442                	ld	s0,16(sp)
    80005e56:	64a2                	ld	s1,8(sp)
    80005e58:	6105                	addi	sp,sp,32
    80005e5a:	8082                	ret

0000000080005e5c <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005e5c:	1141                	addi	sp,sp,-16
    80005e5e:	e406                	sd	ra,8(sp)
    80005e60:	e022                	sd	s0,0(sp)
    80005e62:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005e64:	100007b7          	lui	a5,0x10000
    80005e68:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005e6c:	f8000713          	li	a4,-128
    80005e70:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005e74:	470d                	li	a4,3
    80005e76:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005e7a:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005e7e:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005e82:	469d                	li	a3,7
    80005e84:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005e88:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005e8c:	00003597          	auipc	a1,0x3
    80005e90:	acc58593          	addi	a1,a1,-1332 # 80008958 <digits+0x18>
    80005e94:	00020517          	auipc	a0,0x20
    80005e98:	37450513          	addi	a0,a0,884 # 80026208 <uart_tx_lock>
    80005e9c:	00000097          	auipc	ra,0x0
    80005ea0:	20c080e7          	jalr	524(ra) # 800060a8 <initlock>
}
    80005ea4:	60a2                	ld	ra,8(sp)
    80005ea6:	6402                	ld	s0,0(sp)
    80005ea8:	0141                	addi	sp,sp,16
    80005eaa:	8082                	ret

0000000080005eac <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005eac:	1101                	addi	sp,sp,-32
    80005eae:	ec06                	sd	ra,24(sp)
    80005eb0:	e822                	sd	s0,16(sp)
    80005eb2:	e426                	sd	s1,8(sp)
    80005eb4:	1000                	addi	s0,sp,32
    80005eb6:	84aa                	mv	s1,a0
  push_off();
    80005eb8:	00000097          	auipc	ra,0x0
    80005ebc:	234080e7          	jalr	564(ra) # 800060ec <push_off>

  if(panicked){
    80005ec0:	00003797          	auipc	a5,0x3
    80005ec4:	15c7a783          	lw	a5,348(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005ec8:	10000737          	lui	a4,0x10000
  if(panicked){
    80005ecc:	c391                	beqz	a5,80005ed0 <uartputc_sync+0x24>
    for(;;)
    80005ece:	a001                	j	80005ece <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005ed0:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005ed4:	0207f793          	andi	a5,a5,32
    80005ed8:	dfe5                	beqz	a5,80005ed0 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005eda:	0ff4f513          	zext.b	a0,s1
    80005ede:	100007b7          	lui	a5,0x10000
    80005ee2:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005ee6:	00000097          	auipc	ra,0x0
    80005eea:	2a6080e7          	jalr	678(ra) # 8000618c <pop_off>
}
    80005eee:	60e2                	ld	ra,24(sp)
    80005ef0:	6442                	ld	s0,16(sp)
    80005ef2:	64a2                	ld	s1,8(sp)
    80005ef4:	6105                	addi	sp,sp,32
    80005ef6:	8082                	ret

0000000080005ef8 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005ef8:	00003797          	auipc	a5,0x3
    80005efc:	1287b783          	ld	a5,296(a5) # 80009020 <uart_tx_r>
    80005f00:	00003717          	auipc	a4,0x3
    80005f04:	12873703          	ld	a4,296(a4) # 80009028 <uart_tx_w>
    80005f08:	06f70a63          	beq	a4,a5,80005f7c <uartstart+0x84>
{
    80005f0c:	7139                	addi	sp,sp,-64
    80005f0e:	fc06                	sd	ra,56(sp)
    80005f10:	f822                	sd	s0,48(sp)
    80005f12:	f426                	sd	s1,40(sp)
    80005f14:	f04a                	sd	s2,32(sp)
    80005f16:	ec4e                	sd	s3,24(sp)
    80005f18:	e852                	sd	s4,16(sp)
    80005f1a:	e456                	sd	s5,8(sp)
    80005f1c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f1e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f22:	00020a17          	auipc	s4,0x20
    80005f26:	2e6a0a13          	addi	s4,s4,742 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005f2a:	00003497          	auipc	s1,0x3
    80005f2e:	0f648493          	addi	s1,s1,246 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005f32:	00003997          	auipc	s3,0x3
    80005f36:	0f698993          	addi	s3,s3,246 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f3a:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005f3e:	02077713          	andi	a4,a4,32
    80005f42:	c705                	beqz	a4,80005f6a <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f44:	01f7f713          	andi	a4,a5,31
    80005f48:	9752                	add	a4,a4,s4
    80005f4a:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005f4e:	0785                	addi	a5,a5,1
    80005f50:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005f52:	8526                	mv	a0,s1
    80005f54:	ffffb097          	auipc	ra,0xffffb
    80005f58:	76a080e7          	jalr	1898(ra) # 800016be <wakeup>
    
    WriteReg(THR, c);
    80005f5c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005f60:	609c                	ld	a5,0(s1)
    80005f62:	0009b703          	ld	a4,0(s3)
    80005f66:	fcf71ae3          	bne	a4,a5,80005f3a <uartstart+0x42>
  }
}
    80005f6a:	70e2                	ld	ra,56(sp)
    80005f6c:	7442                	ld	s0,48(sp)
    80005f6e:	74a2                	ld	s1,40(sp)
    80005f70:	7902                	ld	s2,32(sp)
    80005f72:	69e2                	ld	s3,24(sp)
    80005f74:	6a42                	ld	s4,16(sp)
    80005f76:	6aa2                	ld	s5,8(sp)
    80005f78:	6121                	addi	sp,sp,64
    80005f7a:	8082                	ret
    80005f7c:	8082                	ret

0000000080005f7e <uartputc>:
{
    80005f7e:	7179                	addi	sp,sp,-48
    80005f80:	f406                	sd	ra,40(sp)
    80005f82:	f022                	sd	s0,32(sp)
    80005f84:	ec26                	sd	s1,24(sp)
    80005f86:	e84a                	sd	s2,16(sp)
    80005f88:	e44e                	sd	s3,8(sp)
    80005f8a:	e052                	sd	s4,0(sp)
    80005f8c:	1800                	addi	s0,sp,48
    80005f8e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005f90:	00020517          	auipc	a0,0x20
    80005f94:	27850513          	addi	a0,a0,632 # 80026208 <uart_tx_lock>
    80005f98:	00000097          	auipc	ra,0x0
    80005f9c:	1a0080e7          	jalr	416(ra) # 80006138 <acquire>
  if(panicked){
    80005fa0:	00003797          	auipc	a5,0x3
    80005fa4:	07c7a783          	lw	a5,124(a5) # 8000901c <panicked>
    80005fa8:	c391                	beqz	a5,80005fac <uartputc+0x2e>
    for(;;)
    80005faa:	a001                	j	80005faa <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005fac:	00003717          	auipc	a4,0x3
    80005fb0:	07c73703          	ld	a4,124(a4) # 80009028 <uart_tx_w>
    80005fb4:	00003797          	auipc	a5,0x3
    80005fb8:	06c7b783          	ld	a5,108(a5) # 80009020 <uart_tx_r>
    80005fbc:	02078793          	addi	a5,a5,32
    80005fc0:	02e79b63          	bne	a5,a4,80005ff6 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80005fc4:	00020997          	auipc	s3,0x20
    80005fc8:	24498993          	addi	s3,s3,580 # 80026208 <uart_tx_lock>
    80005fcc:	00003497          	auipc	s1,0x3
    80005fd0:	05448493          	addi	s1,s1,84 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005fd4:	00003917          	auipc	s2,0x3
    80005fd8:	05490913          	addi	s2,s2,84 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80005fdc:	85ce                	mv	a1,s3
    80005fde:	8526                	mv	a0,s1
    80005fe0:	ffffb097          	auipc	ra,0xffffb
    80005fe4:	552080e7          	jalr	1362(ra) # 80001532 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005fe8:	00093703          	ld	a4,0(s2)
    80005fec:	609c                	ld	a5,0(s1)
    80005fee:	02078793          	addi	a5,a5,32
    80005ff2:	fee785e3          	beq	a5,a4,80005fdc <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005ff6:	00020497          	auipc	s1,0x20
    80005ffa:	21248493          	addi	s1,s1,530 # 80026208 <uart_tx_lock>
    80005ffe:	01f77793          	andi	a5,a4,31
    80006002:	97a6                	add	a5,a5,s1
    80006004:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006008:	0705                	addi	a4,a4,1
    8000600a:	00003797          	auipc	a5,0x3
    8000600e:	00e7bf23          	sd	a4,30(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006012:	00000097          	auipc	ra,0x0
    80006016:	ee6080e7          	jalr	-282(ra) # 80005ef8 <uartstart>
      release(&uart_tx_lock);
    8000601a:	8526                	mv	a0,s1
    8000601c:	00000097          	auipc	ra,0x0
    80006020:	1d0080e7          	jalr	464(ra) # 800061ec <release>
}
    80006024:	70a2                	ld	ra,40(sp)
    80006026:	7402                	ld	s0,32(sp)
    80006028:	64e2                	ld	s1,24(sp)
    8000602a:	6942                	ld	s2,16(sp)
    8000602c:	69a2                	ld	s3,8(sp)
    8000602e:	6a02                	ld	s4,0(sp)
    80006030:	6145                	addi	sp,sp,48
    80006032:	8082                	ret

0000000080006034 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006034:	1141                	addi	sp,sp,-16
    80006036:	e422                	sd	s0,8(sp)
    80006038:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000603a:	100007b7          	lui	a5,0x10000
    8000603e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006042:	8b85                	andi	a5,a5,1
    80006044:	cb81                	beqz	a5,80006054 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006046:	100007b7          	lui	a5,0x10000
    8000604a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000604e:	6422                	ld	s0,8(sp)
    80006050:	0141                	addi	sp,sp,16
    80006052:	8082                	ret
    return -1;
    80006054:	557d                	li	a0,-1
    80006056:	bfe5                	j	8000604e <uartgetc+0x1a>

0000000080006058 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006058:	1101                	addi	sp,sp,-32
    8000605a:	ec06                	sd	ra,24(sp)
    8000605c:	e822                	sd	s0,16(sp)
    8000605e:	e426                	sd	s1,8(sp)
    80006060:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006062:	54fd                	li	s1,-1
    80006064:	a029                	j	8000606e <uartintr+0x16>
      break;
    consoleintr(c);
    80006066:	00000097          	auipc	ra,0x0
    8000606a:	918080e7          	jalr	-1768(ra) # 8000597e <consoleintr>
    int c = uartgetc();
    8000606e:	00000097          	auipc	ra,0x0
    80006072:	fc6080e7          	jalr	-58(ra) # 80006034 <uartgetc>
    if(c == -1)
    80006076:	fe9518e3          	bne	a0,s1,80006066 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000607a:	00020497          	auipc	s1,0x20
    8000607e:	18e48493          	addi	s1,s1,398 # 80026208 <uart_tx_lock>
    80006082:	8526                	mv	a0,s1
    80006084:	00000097          	auipc	ra,0x0
    80006088:	0b4080e7          	jalr	180(ra) # 80006138 <acquire>
  uartstart();
    8000608c:	00000097          	auipc	ra,0x0
    80006090:	e6c080e7          	jalr	-404(ra) # 80005ef8 <uartstart>
  release(&uart_tx_lock);
    80006094:	8526                	mv	a0,s1
    80006096:	00000097          	auipc	ra,0x0
    8000609a:	156080e7          	jalr	342(ra) # 800061ec <release>
}
    8000609e:	60e2                	ld	ra,24(sp)
    800060a0:	6442                	ld	s0,16(sp)
    800060a2:	64a2                	ld	s1,8(sp)
    800060a4:	6105                	addi	sp,sp,32
    800060a6:	8082                	ret

00000000800060a8 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800060a8:	1141                	addi	sp,sp,-16
    800060aa:	e422                	sd	s0,8(sp)
    800060ac:	0800                	addi	s0,sp,16
  lk->name = name;
    800060ae:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800060b0:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800060b4:	00053823          	sd	zero,16(a0)
}
    800060b8:	6422                	ld	s0,8(sp)
    800060ba:	0141                	addi	sp,sp,16
    800060bc:	8082                	ret

00000000800060be <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800060be:	411c                	lw	a5,0(a0)
    800060c0:	e399                	bnez	a5,800060c6 <holding+0x8>
    800060c2:	4501                	li	a0,0
  return r;
}
    800060c4:	8082                	ret
{
    800060c6:	1101                	addi	sp,sp,-32
    800060c8:	ec06                	sd	ra,24(sp)
    800060ca:	e822                	sd	s0,16(sp)
    800060cc:	e426                	sd	s1,8(sp)
    800060ce:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800060d0:	6904                	ld	s1,16(a0)
    800060d2:	ffffb097          	auipc	ra,0xffffb
    800060d6:	d7a080e7          	jalr	-646(ra) # 80000e4c <mycpu>
    800060da:	40a48533          	sub	a0,s1,a0
    800060de:	00153513          	seqz	a0,a0
}
    800060e2:	60e2                	ld	ra,24(sp)
    800060e4:	6442                	ld	s0,16(sp)
    800060e6:	64a2                	ld	s1,8(sp)
    800060e8:	6105                	addi	sp,sp,32
    800060ea:	8082                	ret

00000000800060ec <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800060ec:	1101                	addi	sp,sp,-32
    800060ee:	ec06                	sd	ra,24(sp)
    800060f0:	e822                	sd	s0,16(sp)
    800060f2:	e426                	sd	s1,8(sp)
    800060f4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800060f6:	100024f3          	csrr	s1,sstatus
    800060fa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800060fe:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006100:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006104:	ffffb097          	auipc	ra,0xffffb
    80006108:	d48080e7          	jalr	-696(ra) # 80000e4c <mycpu>
    8000610c:	5d3c                	lw	a5,120(a0)
    8000610e:	cf89                	beqz	a5,80006128 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006110:	ffffb097          	auipc	ra,0xffffb
    80006114:	d3c080e7          	jalr	-708(ra) # 80000e4c <mycpu>
    80006118:	5d3c                	lw	a5,120(a0)
    8000611a:	2785                	addiw	a5,a5,1
    8000611c:	dd3c                	sw	a5,120(a0)
}
    8000611e:	60e2                	ld	ra,24(sp)
    80006120:	6442                	ld	s0,16(sp)
    80006122:	64a2                	ld	s1,8(sp)
    80006124:	6105                	addi	sp,sp,32
    80006126:	8082                	ret
    mycpu()->intena = old;
    80006128:	ffffb097          	auipc	ra,0xffffb
    8000612c:	d24080e7          	jalr	-732(ra) # 80000e4c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006130:	8085                	srli	s1,s1,0x1
    80006132:	8885                	andi	s1,s1,1
    80006134:	dd64                	sw	s1,124(a0)
    80006136:	bfe9                	j	80006110 <push_off+0x24>

0000000080006138 <acquire>:
{
    80006138:	1101                	addi	sp,sp,-32
    8000613a:	ec06                	sd	ra,24(sp)
    8000613c:	e822                	sd	s0,16(sp)
    8000613e:	e426                	sd	s1,8(sp)
    80006140:	1000                	addi	s0,sp,32
    80006142:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006144:	00000097          	auipc	ra,0x0
    80006148:	fa8080e7          	jalr	-88(ra) # 800060ec <push_off>
  if(holding(lk))
    8000614c:	8526                	mv	a0,s1
    8000614e:	00000097          	auipc	ra,0x0
    80006152:	f70080e7          	jalr	-144(ra) # 800060be <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006156:	4705                	li	a4,1
  if(holding(lk))
    80006158:	e115                	bnez	a0,8000617c <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000615a:	87ba                	mv	a5,a4
    8000615c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006160:	2781                	sext.w	a5,a5
    80006162:	ffe5                	bnez	a5,8000615a <acquire+0x22>
  __sync_synchronize();
    80006164:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006168:	ffffb097          	auipc	ra,0xffffb
    8000616c:	ce4080e7          	jalr	-796(ra) # 80000e4c <mycpu>
    80006170:	e888                	sd	a0,16(s1)
}
    80006172:	60e2                	ld	ra,24(sp)
    80006174:	6442                	ld	s0,16(sp)
    80006176:	64a2                	ld	s1,8(sp)
    80006178:	6105                	addi	sp,sp,32
    8000617a:	8082                	ret
    panic("acquire");
    8000617c:	00002517          	auipc	a0,0x2
    80006180:	7e450513          	addi	a0,a0,2020 # 80008960 <digits+0x20>
    80006184:	00000097          	auipc	ra,0x0
    80006188:	a7c080e7          	jalr	-1412(ra) # 80005c00 <panic>

000000008000618c <pop_off>:

void
pop_off(void)
{
    8000618c:	1141                	addi	sp,sp,-16
    8000618e:	e406                	sd	ra,8(sp)
    80006190:	e022                	sd	s0,0(sp)
    80006192:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006194:	ffffb097          	auipc	ra,0xffffb
    80006198:	cb8080e7          	jalr	-840(ra) # 80000e4c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000619c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800061a0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800061a2:	e78d                	bnez	a5,800061cc <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800061a4:	5d3c                	lw	a5,120(a0)
    800061a6:	02f05b63          	blez	a5,800061dc <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800061aa:	37fd                	addiw	a5,a5,-1
    800061ac:	0007871b          	sext.w	a4,a5
    800061b0:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800061b2:	eb09                	bnez	a4,800061c4 <pop_off+0x38>
    800061b4:	5d7c                	lw	a5,124(a0)
    800061b6:	c799                	beqz	a5,800061c4 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061b8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800061bc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061c0:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800061c4:	60a2                	ld	ra,8(sp)
    800061c6:	6402                	ld	s0,0(sp)
    800061c8:	0141                	addi	sp,sp,16
    800061ca:	8082                	ret
    panic("pop_off - interruptible");
    800061cc:	00002517          	auipc	a0,0x2
    800061d0:	79c50513          	addi	a0,a0,1948 # 80008968 <digits+0x28>
    800061d4:	00000097          	auipc	ra,0x0
    800061d8:	a2c080e7          	jalr	-1492(ra) # 80005c00 <panic>
    panic("pop_off");
    800061dc:	00002517          	auipc	a0,0x2
    800061e0:	7a450513          	addi	a0,a0,1956 # 80008980 <digits+0x40>
    800061e4:	00000097          	auipc	ra,0x0
    800061e8:	a1c080e7          	jalr	-1508(ra) # 80005c00 <panic>

00000000800061ec <release>:
{
    800061ec:	1101                	addi	sp,sp,-32
    800061ee:	ec06                	sd	ra,24(sp)
    800061f0:	e822                	sd	s0,16(sp)
    800061f2:	e426                	sd	s1,8(sp)
    800061f4:	1000                	addi	s0,sp,32
    800061f6:	84aa                	mv	s1,a0
  if(!holding(lk))
    800061f8:	00000097          	auipc	ra,0x0
    800061fc:	ec6080e7          	jalr	-314(ra) # 800060be <holding>
    80006200:	c115                	beqz	a0,80006224 <release+0x38>
  lk->cpu = 0;
    80006202:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006206:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000620a:	0f50000f          	fence	iorw,ow
    8000620e:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006212:	00000097          	auipc	ra,0x0
    80006216:	f7a080e7          	jalr	-134(ra) # 8000618c <pop_off>
}
    8000621a:	60e2                	ld	ra,24(sp)
    8000621c:	6442                	ld	s0,16(sp)
    8000621e:	64a2                	ld	s1,8(sp)
    80006220:	6105                	addi	sp,sp,32
    80006222:	8082                	ret
    panic("release");
    80006224:	00002517          	auipc	a0,0x2
    80006228:	76450513          	addi	a0,a0,1892 # 80008988 <digits+0x48>
    8000622c:	00000097          	auipc	ra,0x0
    80006230:	9d4080e7          	jalr	-1580(ra) # 80005c00 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
