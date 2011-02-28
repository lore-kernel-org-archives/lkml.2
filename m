Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab1B1OWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 09:22:24 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:6589 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754037Ab1B1OWX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 09:22:23 -0500
X-SpamScore: -30
X-BigFish: VPS-30(zz542N1432N98dN4015L9371Pzz1202hzz8275bhz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH V4 0/4] ARM: Basic Xilinx Support
Date: Mon, 28 Feb 2011 07:22:15 -0700
In-Reply-To: <20110228111949.GC2754@pulham.picochip.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V4 0/4] ARM: Basic Xilinx Support
Thread-Index: AcvXOW3tCndHTg1oRQG3tThvWnyuEgAGUPXg
References: <0d410c20-32b4-46d6-9639-249a2816cbe9@VA3EHSMHS005.ehs.local> <20110228111949.GC2754@pulham.picochip.com>
From: John Linn <John.Linn@xilinx.com>
To: Jamie Iles <jamie@jamieiles.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <arnd@arndb.de>
X-OriginalArrivalTime: 28 Feb 2011 14:22:16.0459 (UTC) FILETIME=[E67F65B0:01CBD752]
X-RCIS-Action: ALLOW
Message-ID: <091b12f3-f266-4727-8166-962af92872d3@VA3EHSMHS022.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jamie Iles [mailto:jamie@jamieiles.com]
> Sent: Monday, February 28, 2011 4:20 AM
> To: John Linn
> Cc: linux-arm-kernel@lists.infradead.org;
linux-kernel@vger.kernel.org; linux@arm.linux.org.uk;
> catalin.marinas@arm.com; glikely@secretlab.ca; jamie@jamieiles.com;
arnd@arndb.de
> Subject: Re: [PATCH V4 0/4] ARM: Basic Xilinx Support
> 
> On Fri, Feb 18, 2011 at 11:14:37AM -0700, John Linn wrote:
> >
> > V4
> >
> > I incorporated more feedback from Jamie Iles. It was
> > primariy cleanup with the only significant change
> > being a move to using raw_read/write in the uncompressor
> > uart code.
> >
> > The other changes were minor updates so that the patch
> > set applies to linux-next.
> >
> > This patch set is now tested against the linux-next branch
> > from pub/scm/linux/kernel/git/sfr/linux-next.git.
> 
> Hi John,
> 
> I've just tried a quick dummy build of this series (with a fudge in
> mach-types to get it building) and I see a couple of minor sparse
> warnings:
> 
> arch/arm/mach-xilinx/common.c:54:13: warning: symbol
> 'xilinx_system_init' was not declared. Should it be static?
> arch/arm/mach-xilinx/common.c:68:13: warning: symbol 'xilinx_irq_init'
> was not declared. Should it be static?
> arch/arm/mach-xilinx/common.c:110:13: warning: symbol 'xilinx_map_io'
> was not declared. Should it be static?
> arch/arm/mach-xilinx/timer.c:290:18: warning: symbol
'xttcpss_sys_timer'
> was not declared. Should it be static?
> 
> I think all of these can be resolved by including "common.h" in both
> timer.c and common.c.

Will have a look at it.  Easy enough to fix and verify.

> 
> I've put a couple of nitpicks for the individual patches, sorry I
didn't
> spot them before.  Otherwise,

No problem, appreciate your time, patience and input.

Thanks,
John

> 
> Reviewed-by: Jamie Iles <jamie@jamieiles.com>
> 
> Jamie


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


