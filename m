Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab1CYRKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 13:10:00 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:25810
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754717Ab1CYRJ6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 13:09:58 -0400
X-SpamScore: -29
X-BigFish: VPS-29(z2005kzbb2dK542N1432N98dN4015L9371Pzz1202hzz8275eh8275dha1495iz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: multiple definition of `show_mem'
Date: Fri, 25 Mar 2011 11:09:52 -0600
In-Reply-To: <4D8C7750.5070102@pengutronix.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: multiple definition of `show_mem'
Thread-Index: Acvq3O2fUH5oqrpARQKK+0QBXVXhmwAMmeiw
References: <4D8B6140.4020300@pengutronix.de><alpine.DEB.2.00.1103241522230.26730@chino.kir.corp.google.com> <4D8C7750.5070102@pengutronix.de>
From: John Linn <John.Linn@xilinx.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>,
        David Rientjes <rientjes@google.com>
CC: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, <kernel@pengutronix.de>
X-OriginalArrivalTime: 25 Mar 2011 17:09:54.0817 (UTC) FILETIME=[7612C710:01CBEB0F]
X-RCIS-Action: ALLOW
Message-ID: <4dc8fdc5-b255-4c26-93ec-8be5056f8646@VA3EHSMHS001.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-arm-kernel-bounces@lists.infradead.org
[mailto:linux-arm-kernel-
> bounces@lists.infradead.org] On Behalf Of Marc Kleine-Budde
> Sent: Friday, March 25, 2011 5:07 AM
> To: David Rientjes
> Cc: linux-arm-kernel; LKML; kernel@pengutronix.de
> Subject: Re: multiple definition of `show_mem'
> 
> On 03/24/2011 11:22 PM, David Rientjes wrote:
> >> current mainline (v2.6.38-7210-gb81a618) on ARM/mxs has the
following build failure:
> >>
> >>> lib/lib.a(show_mem.o): In function `show_mem':
> >>> .../linux-2.6/lib/show_mem.c:67: multiple definition of `show_mem'
> >>> arch/arm/mm/built-in.o:.../linux-2.6/arch/arm/mm/init.c:82: first
> >>> defined here
> >>> make: *** [vmlinux.o] Error 1
> 
> [..]
> 
> > Sorry about that, Marc.  I have a patch at
> >
> > 	http://marc.info/?l=linux-kernel&m=130100511521954
> >
> > which should fix the issue for you (and I tested it with my arm
cross
> > compiler).
> 
> \o/ - the patch is already in mainline, boots like charm on my
mx28evk.

I pulled it, rebuilt without any issues, and it runs also on the Xilinx
platform.

Thanks,
John

> 
> regards, Marc
> --
> Pengutronix e.K.                  | Marc Kleine-Budde           |
> Industrial Linux Solutions        | Phone: +49-231-2826-924     |
> Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
> Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


