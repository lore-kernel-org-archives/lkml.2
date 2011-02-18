Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab1BRAiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 19:38:05 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:40386
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757882Ab1BRAhy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 19:37:54 -0500
X-SpamScore: -31
X-BigFish: VPS-31(zz542N1432N98dN4015L1fa4L9371Pc8kzz1202hzz8275bh8275dhz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH V3 3/4] ARM: Xilinx: base header files and assembly macros
Date: Thu, 17 Feb 2011 17:37:47 -0700
In-Reply-To: <20110217100126.GD22961@pulham.picochip.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V3 3/4] ARM: Xilinx: base header files and assembly macros
Thread-Index: AcvOiaqH2Tx1dCmwT9aSQkkUsS4tSAAejN0A
References: <1297872716-13353-1-git-send-email-john.linn@xilinx.com> <1297872716-13353-2-git-send-email-john.linn@xilinx.com> <1297872716-13353-3-git-send-email-john.linn@xilinx.com> <e58673f5-2881-4820-b5cd-99e8ef294ed5@VA3EHSMHS024.ehs.local> <20110217100126.GD22961@pulham.picochip.com>
From: John Linn <John.Linn@xilinx.com>
To: Jamie Iles <jamie@jamieiles.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <arnd@arndb.de>
X-OriginalArrivalTime: 18 Feb 2011 00:37:49.0090 (UTC) FILETIME=[11846820:01CBCF04]
X-RCIS-Action: ALLOW
Message-ID: <cb015a68-c46f-400b-97ba-e1bf32e8dc2c@VA3EHSMHS019.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jamie Iles [mailto:jamie@jamieiles.com]
> Sent: Thursday, February 17, 2011 3:01 AM
> To: John Linn
> Cc: linux-arm-kernel@lists.infradead.org;
linux-kernel@vger.kernel.org; linux@arm.linux.org.uk;
> catalin.marinas@arm.com; glikely@secretlab.ca; arnd@arndb.de
> Subject: Re: [PATCH V3 3/4] ARM: Xilinx: base header files and
assembly macros
> 
> Hi John,
> 
> A few more nitpicks, but looking good now!
> 
> Jamie
> 
> On Wed, Feb 16, 2011 at 09:11:55AM -0700, John Linn wrote:
> > These are the minimum needed to build the kernel for the new
platform.
> >
> > Signed-off-by: John Linn <john.linn@xilinx.com>
> > ---
> >
> > V3 Changes
> >
> > Updates based on Russell Kings' comments
> > 	Changed headers to update the license info and remove
> > 	the address
> >
> > 	Updated the constant to use UL in vmalloc.h
> >
> > V2 Changes
> >
> > Updates based on Russell King's comments
> > 	moved to using entry-macro-gic.S
> > 	moved stuff from hardware.h to xilinx_soc.h
> > 	added IOMEM() in io.h to help with typing
> > 	Minor updates to IO_SPACE_LIMIT and __io()
> > 	Updated addresses to be clear with seperate virtual
> > 		and physical addresses
> >
> >  arch/arm/mach-xilinx/include/mach/clkdev.h      |   33
++++++++++++++++
> >  arch/arm/mach-xilinx/include/mach/debug-macro.S |   36
+++++++++++++++++
> >  arch/arm/mach-xilinx/include/mach/entry-macro.S |   30
++++++++++++++
> >  arch/arm/mach-xilinx/include/mach/hardware.h    |   18 +++++++++
> >  arch/arm/mach-xilinx/include/mach/io.h          |   33
++++++++++++++++
> >  arch/arm/mach-xilinx/include/mach/irqs.h        |   29
++++++++++++++
> >  arch/arm/mach-xilinx/include/mach/memory.h      |   23 +++++++++++
> >  arch/arm/mach-xilinx/include/mach/system.h      |   28
+++++++++++++
> >  arch/arm/mach-xilinx/include/mach/timex.h       |   24 ++++++++++++
> >  arch/arm/mach-xilinx/include/mach/uart.h        |   31
+++++++++++++++
> >  arch/arm/mach-xilinx/include/mach/uncompress.h  |   47
+++++++++++++++++++++++
> >  arch/arm/mach-xilinx/include/mach/vmalloc.h     |   20 ++++++++++
> >  arch/arm/mach-xilinx/include/mach/xilinx_soc.h  |   46
++++++++++++++++++++++
> >  13 files changed, 398 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/arm/mach-xilinx/include/mach/clkdev.h
> >  create mode 100644 arch/arm/mach-xilinx/include/mach/debug-macro.S
> >  create mode 100644 arch/arm/mach-xilinx/include/mach/entry-macro.S
> >  create mode 100644 arch/arm/mach-xilinx/include/mach/hardware.h
> >  create mode 100644 arch/arm/mach-xilinx/include/mach/io.h
> >  create mode 100644 arch/arm/mach-xilinx/include/mach/irqs.h
> >  create mode 100644 arch/arm/mach-xilinx/include/mach/memory.h
> >  create mode 100644 arch/arm/mach-xilinx/include/mach/system.h
> >  create mode 100644 arch/arm/mach-xilinx/include/mach/timex.h
> >  create mode 100644 arch/arm/mach-xilinx/include/mach/uart.h
> >  create mode 100644 arch/arm/mach-xilinx/include/mach/uncompress.h
> >  create mode 100644 arch/arm/mach-xilinx/include/mach/vmalloc.h
> >  create mode 100644 arch/arm/mach-xilinx/include/mach/xilinx_soc.h
> >
> > diff --git a/arch/arm/mach-xilinx/include/mach/clkdev.h
b/arch/arm/mach-xilinx/include/mach/clkdev.h
> > new file mode 100644
> > index 0000000..5dd1453
> > --- /dev/null
> > +++ b/arch/arm/mach-xilinx/include/mach/clkdev.h
> > @@ -0,0 +1,33 @@
> > +/*
> > + * arch/arm/mach-xilinx/include/mach/clkdev.h
> > + *
> > + *  Copyright (C) 2011 Xilinx, Inc.
> > + *
> > + * This software is licensed under the terms of the GNU General
Public
> > + * License version 2, as published by the Free Software Foundation,
and
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + */
> > +
> > +#ifndef __MACH_CLKDEV_H__
> > +#define __MACH_CLKDEV_H__
> > +
> > +struct clk {
> > +	unsigned long rate;
> > +};
> > +
> > +static inline int __clk_get(struct clk *clk)
> > +{
> > +	return 1;
> > +}
> > +
> > +static inline void __clk_put(struct clk *clk)
> > +{
> > +}
> > +
> > +#endif
> > diff --git a/arch/arm/mach-xilinx/include/mach/debug-macro.S
b/arch/arm/mach-
> xilinx/include/mach/debug-macro.S
> > new file mode 100644
> > index 0000000..30d3d3d
> > --- /dev/null
> > +++ b/arch/arm/mach-xilinx/include/mach/debug-macro.S
> > @@ -0,0 +1,36 @@
> > +/* arch/arm/mach-xilinx/include/mach/debug-macro.S
> > + *
> > + * Debugging macro include header
> > + *
> > + *  Copyright (C) 2011 Xilinx
> > + *
> > + * This software is licensed under the terms of the GNU General
Public
> > + * License version 2, as published by the Free Software Foundation,
and
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <mach/xilinx_soc.h>
> > +#include <mach/uart.h>
> > +
> > +		.macro	addruart, rp, rv
> > +		ldr	\rp, =LL_UART_PADDR	@ physical
> > +		ldr	\rv, =LL_UART_VADDR	@ virtual
> > +		.endm
> > +
> > +		.macro	senduart,rd,rx
> > +		str	\rd, [\rx, #UART_FIFO_OFFSET]	@ TXDATA
> > +		.endm
> > +
> > +		.macro	waituart,rd,rx
> > +		.endm
> > +
> > +		.macro	busyuart,rd,rx
> > +1002:		ldr	\rd, [\rx, #UART_SR_OFFSET]	@ get
status register
> > +		tst	\rd, #UART_SR_TXFULL		@
> > +		bne	1002b			@ wait if FIFO is full
> > +		.endm
> > diff --git a/arch/arm/mach-xilinx/include/mach/entry-macro.S
b/arch/arm/mach-
> xilinx/include/mach/entry-macro.S
> > new file mode 100644
> > index 0000000..11a2866
> > --- /dev/null
> > +++ b/arch/arm/mach-xilinx/include/mach/entry-macro.S
> > @@ -0,0 +1,30 @@
> > +/*
> > + * arch/arm/mach-xilinx/include/mach/entry-macro.S
> > + *
> > + * Low-level IRQ helper macros
> > + *
> > + *  Copyright (C) 2011 Xilinx
> > + *
> > + * based on arch/plat-mxc/include/mach/entry-macro.S
> > + *
> > + *  Copyright (C) 2007 Lennert Buytenhek <buytenh@wantstofly.org>
> > + *  Copyright 2004-2007 Freescale Semiconductor, Inc. All Rights
Reserved.
> > + *
> > + * This software is licensed under the terms of the GNU General
Public
> > + * License version 2, as published by the Free Software Foundation,
and
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <mach/hardware.h>
> > +#include <asm/hardware/entry-macro-gic.S>
> > +
> > +                .macro  disable_fiq
> > +                .endm
> > +
> > +                .macro  arch_ret_to_user, tmp1, tmp2
> > +                .endm
> > diff --git a/arch/arm/mach-xilinx/include/mach/hardware.h
b/arch/arm/mach-
> xilinx/include/mach/hardware.h
> > new file mode 100644
> > index 0000000..f9685c4
> > --- /dev/null
> > +++ b/arch/arm/mach-xilinx/include/mach/hardware.h
> > @@ -0,0 +1,18 @@
> > +/* arch/arm/mach-xilinx/include/mach/hardware.h
> > + *
> > + *  Copyright (C) 2011 Xilinx
> > + *
> > + * This software is licensed under the terms of the GNU General
Public
> > + * License version 2, as published by the Free Software Foundation,
and
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef __MACH_HARDWARE_H__
> > +#define __MACH_HARDWARE_H__
> > +
> > +#endif
> > diff --git a/arch/arm/mach-xilinx/include/mach/io.h
b/arch/arm/mach-xilinx/include/mach/io.h
> > new file mode 100644
> > index 0000000..ef69e65
> > --- /dev/null
> > +++ b/arch/arm/mach-xilinx/include/mach/io.h
> > @@ -0,0 +1,33 @@
> > +/* arch/arm/mach-xilinx/include/mach/io.h
> > + *
> > + *  Copyright (C) 2011 Xilinx
> > + *
> > + * This software is licensed under the terms of the GNU General
Public
> > + * License version 2, as published by the Free Software Foundation,
and
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef __MACH_IO_H__
> > +#define __MACH_IO_H__
> > +
> > +/* Allow IO space to be anywhere in the memory */
> > +
> > +#define IO_SPACE_LIMIT 0xffff
> > +
> > +/* IO address mapping macros, nothing special at this time but
required */
> > +
> > +#ifdef __ASSEMBLER__
> > +#define IOMEM(x)		(x)
> > +#else
> > +#define IOMEM(x)		((void __force __iomem *)(x))
> > +#endif
> > +
> > +#define __io(a)			__typesafe_io(a)
> > +#define __mem_pci(a)		(a)
> > +
> > +#endif
> > diff --git a/arch/arm/mach-xilinx/include/mach/irqs.h
b/arch/arm/mach-xilinx/include/mach/irqs.h
> > new file mode 100644
> > index 0000000..47a8162
> > --- /dev/null
> > +++ b/arch/arm/mach-xilinx/include/mach/irqs.h
> > @@ -0,0 +1,29 @@
> > +/* arch/arm/mach-xilinx/include/mach/irqs.h
> > + *
> > + *  Copyright (C) 2011 Xilinx
> > + *
> > + * This software is licensed under the terms of the GNU General
Public
> > + * License version 2, as published by the Free Software Foundation,
and
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef __MACH_IRQS_H
> > +#define __MACH_IRQS_H
> > +
> > +#define ARCH_NR_GPIOS	118
> > +#define NR_IRQS		(128 + ARCH_NR_GPIOS)
> > +
> > +/*
> > + * GIC Interrupts
> > + */
> > +
> > +#define IRQ_GIC_SPI_START	32
> > +#define IRQ_TIMERCOUNTER0	42
> > +#define IRQ_UART0		59
> > +
> > +#endif
> > diff --git a/arch/arm/mach-xilinx/include/mach/memory.h
b/arch/arm/mach-xilinx/include/mach/memory.h
> > new file mode 100644
> > index 0000000..c200486
> > --- /dev/null
> > +++ b/arch/arm/mach-xilinx/include/mach/memory.h
> > @@ -0,0 +1,23 @@
> > +/* arch/arm/mach-xilinx/include/mach/memory.h
> > + *
> > + *  Copyright (C) 2011 Xilinx
> > + *
> > + * This software is licensed under the terms of the GNU General
Public
> > + * License version 2, as published by the Free Software Foundation,
and
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef __MACH_MEMORY_H__
> > +#define __MACH_MEMORY_H__
> > +
> > +#include <mach/hardware.h>
> > +
> > +#define PHYS_OFFSET             0x0
> 
> This should be PLAT_PHYS_OFFSET and could do with being surrounded
with
> UL() e.g.
> 
> #define PLAT_PHYS_OFFSET	UL(0x00000000)
> 
> > +#define MEM_SIZE		SZ_256M
> > +
> > +#endif
> > diff --git a/arch/arm/mach-xilinx/include/mach/system.h
b/arch/arm/mach-xilinx/include/mach/system.h
> > new file mode 100644
> > index 0000000..e8514a0
> > --- /dev/null
> > +++ b/arch/arm/mach-xilinx/include/mach/system.h
> > @@ -0,0 +1,28 @@
> > +/* arch/arm/mach-xilinx/include/mach/system.h
> > + *
> > + *  Copyright (C) 2011 Xilinx
> > + *
> > + * This software is licensed under the terms of the GNU General
Public
> > + * License version 2, as published by the Free Software Foundation,
and
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef __MACH_SYSTEM_H__
> > +#define __MACH_SYSTEM_H__
> > +
> > +static inline void arch_idle(void)
> > +{
> > +	cpu_do_idle();
> > +}
> > +
> > +static inline void arch_reset(char mode, const char *cmd)
> > +{
> > +	/* Add architecture specific reset processing here */
> 
> I think you can add cpu_reset(0) in here to try a soft reset by
jumping
> to the reset vector.  This should give you some reset functionality.

Hi Jamie,

How strongly do you feel that this has to be in on this initial patch
set?

There will be many more coming later and I'd like to postpone that one
as it's really additional
functionality vs a bug (to me anyway).

Thanks,
John

> 
> > +}
> > +
> > +#endif
> > diff --git a/arch/arm/mach-xilinx/include/mach/timex.h
b/arch/arm/mach-xilinx/include/mach/timex.h
> > new file mode 100644
> > index 0000000..6765e15
> > --- /dev/null
> > +++ b/arch/arm/mach-xilinx/include/mach/timex.h
> > @@ -0,0 +1,24 @@
> > +/* arch/arm/mach-xilinx/include/mach/timex.h
> > + *
> > + *  Copyright (C) 2011 Xilinx
> > + *
> > + * This software is licensed under the terms of the GNU General
Public
> > + * License version 2, as published by the Free Software Foundation,
and
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef __MACH_TIMEX_H__
> > +#define __MACH_TIMEX_H__
> > +
> > +#include <mach/hardware.h>
> 
> I don't think you need mach/hardware.h included in here.
> 
> > +
> > +#define PERIPHERAL_CLOCK_RATE	2500000
> > +
> > +#define CLOCK_TICK_RATE	(PERIPHERAL_CLOCK_RATE / 32)
> > +
> > +#endif
> > diff --git a/arch/arm/mach-xilinx/include/mach/uart.h
b/arch/arm/mach-xilinx/include/mach/uart.h
> > new file mode 100644
> > index 0000000..20a10d7
> > --- /dev/null
> > +++ b/arch/arm/mach-xilinx/include/mach/uart.h
> > @@ -0,0 +1,31 @@
> > +/* arch/arm/mach-xilinx/include/mach/uart.h
> > + *
> > + *  Copyright (C) 2011 Xilinx
> > + *
> > + * This software is licensed under the terms of the GNU General
Public
> > + * License version 2, as published by the Free Software Foundation,
and
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef __MACH_UART_H__
> > +#define __MACH_UART_H__
> > +
> > +#define UART_CR_OFFSET          0x00  /* Control Register [8:0] */
> > +#define UART_SR_OFFSET          0x2C  /* Channel Status [11:0] */
> > +#define UART_FIFO_OFFSET        0x30  /* FIFO [15:0] or [7:0] */
> > +
> > +#define UART_SR_TXFULL		0x00000010	/* TX FIFO full
*/
> > +#define UART_SR_TXEMPTY		0x00000008	/* TX FIFO empty
*/
> > +
> > +#define UART_FIFO_WRITE(base, value) \
> > +	(*(volatile unsigned int *)((base) + UART_FIFO_OFFSET) =
(value))
> > +
> > +#define UART_STATUS(base) \
> > +	(*(volatile unsigned int *)((base) + UART_SR_OFFSET))
> 
> You could probably make these static inline functions in the header
and
> use __raw_{readl,writel}() to make this a little cleaner.
> 
> > +
> > +#endif
> > diff --git a/arch/arm/mach-xilinx/include/mach/uncompress.h
b/arch/arm/mach-
> xilinx/include/mach/uncompress.h
> > new file mode 100644
> > index 0000000..b7a5110
> > --- /dev/null
> > +++ b/arch/arm/mach-xilinx/include/mach/uncompress.h
> > @@ -0,0 +1,47 @@
> > +/* arch/arm/mach-xilinx/include/mach/uncompress.h
> > + *
> > + *  Copyright (C) 2011 Xilinx
> > + *
> > + * This software is licensed under the terms of the GNU General
Public
> > + * License version 2, as published by the Free Software Foundation,
and
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef __MACH_UNCOMPRESS_H__
> > +#define __MACH_UNCOMPRESS_H__
> > +
> > +#include <mach/xilinx_soc.h>
> > +#include <mach/uart.h>
> > +
> > +void arch_decomp_setup(void)
> > +{
> > +}
> > +
> > +static inline void flush(void)
> > +{
> > +	/*
> > +	 * Wait while the FIFO is not empty
> > +	 */
> > +	while (!(UART_STATUS(LL_UART_PADDR) & UART_SR_TXEMPTY))
> > +		;
> > +}
> > +
> > +#define arch_decomp_wdog()
> > +
> > +static void putc(char ch)
> > +{
> > +	/*
> > +	 * Wait for room in the FIFO, then write the char into the FIFO
> > +	 */
> > +	while (UART_STATUS(LL_UART_PADDR) & UART_SR_TXFULL)
> > +		;
> 
> It might be worth adding a barrier() call to these loops to be
explicit
> about the volatility.
> 
> > +
> > +	UART_FIFO_WRITE(LL_UART_PADDR, ch);
> > +}
> > +
> > +#endif
> > diff --git a/arch/arm/mach-xilinx/include/mach/vmalloc.h
b/arch/arm/mach-
> xilinx/include/mach/vmalloc.h
> > new file mode 100644
> > index 0000000..aba20a3
> > --- /dev/null
> > +++ b/arch/arm/mach-xilinx/include/mach/vmalloc.h
> > @@ -0,0 +1,20 @@
> > +/* arch/arm/mach-xilinx/include/mach/vmalloc.h
> > + *
> > + *  Copyright (C) 2011 Xilinx
> > + *
> > + * This software is licensed under the terms of the GNU General
Public
> > + * License version 2, as published by the Free Software Foundation,
and
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef __MACH_VMALLOC_H__
> > +#define __MACH_VMALLOC_H__
> > +
> > +#define VMALLOC_END       0xE0000000UL
> > +
> > +#endif
> > diff --git a/arch/arm/mach-xilinx/include/mach/xilinx_soc.h
b/arch/arm/mach-
> xilinx/include/mach/xilinx_soc.h
> > new file mode 100644
> > index 0000000..d01cde1
> > --- /dev/null
> > +++ b/arch/arm/mach-xilinx/include/mach/xilinx_soc.h
> > @@ -0,0 +1,46 @@
> > +/* arch/arm/mach-xilinx/include/mach/xilinx_soc.h
> > + *
> > + *  Copyright (C) 2011 Xilinx
> > + *
> > + * This software is licensed under the terms of the GNU General
Public
> > + * License version 2, as published by the Free Software Foundation,
and
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef __MACH_XILINX_SOC_H__
> > +#define __MACH_XILINX_SOC_H__
> > +
> > +/* For now, all mappings are flat (physical = virtual)
> > + */
> > +#define UART0_PHYS			0xE0000000
> > +#define UART0_VIRT			UART0_PHYS
> > +
> > +#define TTC0_PHYS			0xF8001000
> > +#define TTC0_VIRT			TTC0_PHYS
> > +
> > +#define PL310_L2CC_PHYS			0xF8F02000
> > +#define PL310_L2CC_VIRT			PL310_L2CC_PHYS
> > +
> > +#define SCU_PERIPH_PHYS			0xF8F00000
> > +#define SCU_PERIPH_VIRT			SCU_PERIPH_PHYS
> > +
> > +/* The following are intended for the devices that are mapped early
*/
> > +
> > +#define TTC0_BASE			IOMEM(TTC0_VIRT)
> > +#define SCU_PERIPH_BASE			IOMEM(SCU_PERIPH_VIRT)
> > +#define SCU_GIC_CPU_BASE		(SCU_PERIPH_BASE + 0x100)
> > +#define SCU_GIC_DIST_BASE		(SCU_PERIPH_BASE + 0x1000)
> > +#define PL310_L2CC_BASE			IOMEM(PL310_L2CC_VIRT)
> > +
> > +/*
> > + * Mandatory for CONFIG_LL_DEBUG, UART is mapped virtual = physical
> > + */
> > +#define LL_UART_PADDR	UART0_PHYS
> > +#define LL_UART_VADDR	UART0_VIRT
> > +
> > +#endif
> > --
> > 1.6.2.1
> >
> >
> >
> > This email and any attachments are intended for the sole use of the
named recipient(s) and
> contain(s) confidential information that may be proprietary,
privileged or copyrighted under
> applicable law. If you are not the intended recipient, do not read,
copy, or forward this email
> message or any attachments. Delete this email message and any
attachments immediately.
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


