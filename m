Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262Ab1BRO2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 09:28:18 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:55979
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758091Ab1BRO2O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 09:28:14 -0500
X-SpamScore: -43
X-BigFish: VPS-43(zzbb2cK542N1432N98dN4015L1447R9371Pzz1202hzz8275dhz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH V3 3/4] ARM: Xilinx: base header files and assembly macros
Date: Fri, 18 Feb 2011 07:28:06 -0700
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V3 3/4] ARM: Xilinx: base header files and assembly macros
Thread-Index: AcvPSyP5S2fshXJuTDCvIT2GxtrUTQAKKMAgAAD+uBA=
References: <1297872716-13353-1-git-send-email-john.linn@xilinx.com> <1297872716-13353-2-git-send-email-john.linn@xilinx.com> <1297872716-13353-3-git-send-email-john.linn@xilinx.com> <e58673f5-2881-4820-b5cd-99e8ef294ed5@VA3EHSMHS024.ehs.local> <20110217100126.GD22961@pulham.picochip.com> <2fdc2d92-486e-4319-866f-3882938363c3@VA3EHSMHS026.ehs.local> <20110218090625.GA3203@pulham.picochip.com> 
From: John Linn <John.Linn@xilinx.com>
To: Jamie Iles <jamie@jamieiles.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <arnd@arndb.de>
X-OriginalArrivalTime: 18 Feb 2011 14:28:07.0575 (UTC) FILETIME=[0FA5F270:01CBCF78]
X-RCIS-Action: ALLOW
Message-ID: <c0424845-2a91-490c-858f-208ae6eebbe0@VA3EHSMHS025.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: John Linn
> Sent: Friday, February 18, 2011 7:00 AM
> To: 'Jamie Iles'
> Cc: linux-arm-kernel@lists.infradead.org;
linux-kernel@vger.kernel.org; linux@arm.linux.org.uk;
> catalin.marinas@arm.com; glikely@secretlab.ca; arnd@arndb.de
> Subject: RE: [PATCH V3 3/4] ARM: Xilinx: base header files and
assembly macros
> 
> > -----Original Message-----
> > From: Jamie Iles [mailto:jamie@jamieiles.com]
> > Sent: Friday, February 18, 2011 2:06 AM
> > To: John Linn
> > Cc: Jamie Iles; linux-arm-kernel@lists.infradead.org;
linux-kernel@vger.kernel.org;
> > linux@arm.linux.org.uk; catalin.marinas@arm.com;
glikely@secretlab.ca; arnd@arndb.de
> > Subject: Re: [PATCH V3 3/4] ARM: Xilinx: base header files and
assembly macros
> >
> > On Thu, Feb 17, 2011 at 06:19:09PM -0700, John Linn wrote:
> > > > > +#define PHYS_OFFSET             0x0
> > > >
> > > > This should be PLAT_PHYS_OFFSET and could do with being
surrounded
> > > with
> > > > UL() e.g.
> > > >
> > > > #define PLAT_PHYS_OFFSET	UL(0x00000000)
> > >
> > > This doesn't build with 2.6.38-rc5, am I missing something?
> > >
> > > PHYS_OFFSET is still needed from what I can tell, but maybe I
overlooked
> > > something.
> >
> > The change is queued up in Russell's devel branch for the dynamic
p2v
> > and will be in 2.6.39.  For a patch series like this it's probably
worth
> > developing off of linux-next[1].  This contains all of the trees
that
> > will be mereged into the next kernel so carries the bigger changes
like
> > dynamic p2v.
> 
> My hope was to get into 2.6.38 and maybe that was not realistic.  If
it's too late
> for 2.6.38 then I'll revise the patch for this branch.

I guess it was too early and I wasn't thinking clearly there with
2.6.38.

You were right on 2.6.39.  Sounds like I should switch to this other
branch
to develop against.

Thanks,
John

> 
> Any thoughts Russell based on where we are?
> 
> Thanks for the insight.
> John
> 
> >
> > Jamie
> >
> > 1. git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


