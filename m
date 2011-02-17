Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab1BQOY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 09:24:26 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:41192
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751728Ab1BQOYY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 09:24:24 -0500
X-SpamScore: -27
X-BigFish: VPS-27(zz542N1432N98dN4015L9371Pc8kzz1202hzzz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH V3 1/4] ARM: Xilinx: Adding Xilinx board support
Date: Thu, 17 Feb 2011 07:24:10 -0700
In-Reply-To: <20110217093433.GB22961@pulham.picochip.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V3 1/4] ARM: Xilinx: Adding Xilinx board support
Thread-Index: AcvOheecRyLjWj1lTju8qYlLCQw+1gAKGB/Q
References: <1297872716-13353-1-git-send-email-john.linn@xilinx.com> <ad969bd6-87bb-4910-a04a-d680e90d69af@VA3EHSMHS009.ehs.local> <20110217093433.GB22961@pulham.picochip.com>
From: John Linn <John.Linn@xilinx.com>
To: Jamie Iles <jamie@jamieiles.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <arnd@arndb.de>
X-OriginalArrivalTime: 17 Feb 2011 14:24:13.0768 (UTC) FILETIME=[59E01480:01CBCEAE]
X-RCIS-Action: ALLOW
Message-ID: <42b47211-fd94-4abd-a4c0-27e9a733f2f1@VA3EHSMHS025.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jamie Iles [mailto:jamie@jamieiles.com]
> Sent: Thursday, February 17, 2011 2:35 AM
> To: John Linn
> Cc: linux-arm-kernel@lists.infradead.org;
linux-kernel@vger.kernel.org; linux@arm.linux.org.uk;
> catalin.marinas@arm.com; glikely@secretlab.ca; arnd@arndb.de
> Subject: Re: [PATCH V3 1/4] ARM: Xilinx: Adding Xilinx board support
> 
> Hi John,
> 
> One nitpick, otherwise looks nice.
> 
> Jamie
> 
> On Wed, Feb 16, 2011 at 09:11:53AM -0700, John Linn wrote:
> > diff --git a/arch/arm/mach-xilinx/common.h
b/arch/arm/mach-xilinx/common.h
> > new file mode 100644
> > index 0000000..9a7cf65
> > --- /dev/null
> > +++ b/arch/arm/mach-xilinx/common.h
> > @@ -0,0 +1,30 @@
> > +/* arch/arm/mach-xilinx/common.h
> > + *
> > + * This file contains common function prototypes to avoid externs
> > + * in the c files.
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
> > +#ifndef __MACH_XILINX_COMMON_H__
> > +#define __MACH_XILINX_COMMON_H__
> > +
> > +#include <linux/init.h>
> > +#include <linux/platform_device.h>
> 
> You don't appear to use the contents of platform_device.h in here so
you
> could probably drop this include.

Good point.  Easy enough.

Thanks,
John

This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


