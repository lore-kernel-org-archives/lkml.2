Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab1BRBT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 20:19:28 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:10614
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754581Ab1BRBTX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 20:19:23 -0500
X-SpamScore: -27
X-BigFish: VPS-27(zz542N1432N98dN4015L9371Pc8kzz1202hzz8275bhz2dh95h668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH V3 3/4] ARM: Xilinx: base header files and assembly macros
Date: Thu, 17 Feb 2011 18:19:09 -0700
In-Reply-To: <20110217100126.GD22961@pulham.picochip.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V3 3/4] ARM: Xilinx: base header files and assembly macros
Thread-Index: AcvOiaqH2Tx1dCmwT9aSQkkUsS4tSAAf9sHw
References: <1297872716-13353-1-git-send-email-john.linn@xilinx.com> <1297872716-13353-2-git-send-email-john.linn@xilinx.com> <1297872716-13353-3-git-send-email-john.linn@xilinx.com> <e58673f5-2881-4820-b5cd-99e8ef294ed5@VA3EHSMHS024.ehs.local> <20110217100126.GD22961@pulham.picochip.com>
From: John Linn <John.Linn@xilinx.com>
To: Jamie Iles <jamie@jamieiles.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <arnd@arndb.de>
X-OriginalArrivalTime: 18 Feb 2011 01:19:10.0023 (UTC) FILETIME=[D844BD70:01CBCF09]
X-RCIS-Action: ALLOW
Message-ID: <2fdc2d92-486e-4319-866f-3882938363c3@VA3EHSMHS026.ehs.local>
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

<snip>

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

This doesn't build with 2.6.38-rc5, am I missing something?

PHYS_OFFSET is still needed from what I can tell, but maybe I overlooked
something.

Thanks,
John


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


