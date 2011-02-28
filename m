Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab1B1OXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 09:23:00 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:4443 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab1B1OW7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 09:22:59 -0500
X-SpamScore: -27
X-BigFish: VPS-27(zz542N1432N98dN4015L9371Pc8kzz1202hzzz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH V4 3/4] ARM: Xilinx: base header files and assemblymacros
Date: Mon, 28 Feb 2011 07:22:52 -0700
In-Reply-To: <20110228112055.GC29843@n2100.arm.linux.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V4 3/4] ARM: Xilinx: base header files and assemblymacros
Thread-Index: AcvXOa5TcQfsEcZsQWOcE8Ro1sRxKgAGT0Sg
References: <1298052881-14591-1-git-send-email-john.linn@xilinx.com> <1298052881-14591-2-git-send-email-john.linn@xilinx.com> <1298052881-14591-3-git-send-email-john.linn@xilinx.com> <42efee69-aca1-446b-a997-f0063e113877@VA3EHSMHS009.ehs.local> <20110228112055.GC29843@n2100.arm.linux.org.uk>
From: John Linn <John.Linn@xilinx.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <catalin.marinas@arm.com>, <glikely@secretlab.ca>,
        <jamie@jamieiles.com>, <arnd@arndb.de>
X-OriginalArrivalTime: 28 Feb 2011 14:22:53.0434 (UTC) FILETIME=[FC8955A0:01CBD752]
X-RCIS-Action: ALLOW
Message-ID: <b5d1dbd3-91ed-4199-b416-c9cd923ad72b@VA3EHSMHS029.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk]
> Sent: Monday, February 28, 2011 4:21 AM
> To: John Linn
> Cc: linux-arm-kernel@lists.infradead.org;
linux-kernel@vger.kernel.org; catalin.marinas@arm.com;
> glikely@secretlab.ca; jamie@jamieiles.com; arnd@arndb.de
> Subject: Re: [PATCH V4 3/4] ARM: Xilinx: base header files and
assemblymacros
> 
> On Fri, Feb 18, 2011 at 11:14:40AM -0700, John Linn wrote:
> > diff --git a/arch/arm/mach-xilinx/include/mach/uncompress.h
b/arch/arm/mach-
> xilinx/include/mach/uncompress.h
> > new file mode 100644
> > index 0000000..ff3754c
> > --- /dev/null
> > +++ b/arch/arm/mach-xilinx/include/mach/uncompress.h
> > @@ -0,0 +1,61 @@
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
> > +#include <asm/processor.h>
> > +#include <asm/io.h>
> > +#include <mach/io.h>
> 
> You don't need mach/io.h here - it's already included by asm/io.h.
> It's probably also worth trying linux/io.h instead of asm/io.h too.

Makes sense, will incorporate that into next patch version.

Thanks,
John

This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


