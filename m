Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448Ab1C3NhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 09:37:23 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:41676
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750798Ab1C3NhW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 09:37:22 -0400
X-SpamScore: -30
X-BigFish: VPS-30(zz542N1432N98dN4015L9371Pzz1202hzz8275bhz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH V5 3/4] ARM: Xilinx: base header files and assembly macros
Date: Wed, 30 Mar 2011 07:37:10 -0600
In-Reply-To: <201103301529.03648.arnd@arndb.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V5 3/4] ARM: Xilinx: base header files and assembly macros
Thread-Index: Acvu3nddRGhv2g2TTRCM/xVgJ3B8YgAADFpw
References: <1301444651-18008-1-git-send-email-john.linn@xilinx.com> <201103301344.45307.arnd@arndb.de> <f4872ed7-b6e4-4050-9445-5176f5aa961a@VA3EHSMHS017.ehs.local> <201103301529.03648.arnd@arndb.de>
From: John Linn <John.Linn@xilinx.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <jamie@jamieiles.com>
X-OriginalArrivalTime: 30 Mar 2011 13:37:11.0668 (UTC) FILETIME=[92B58B40:01CBEEDF]
X-RCIS-Action: ALLOW
Message-ID: <807f31a6-c9ff-4f35-bece-e0222a8e1fda@VA3EHSMHS006.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Wednesday, March 30, 2011 7:29 AM
> To: John Linn
> Cc: linux-arm-kernel@lists.infradead.org;
linux-kernel@vger.kernel.org;
> linux@arm.linux.org.uk; catalin.marinas@arm.com; glikely@secretlab.ca;
> jamie@jamieiles.com
> Subject: Re: [PATCH V5 3/4] ARM: Xilinx: base header files and
assembly
> macros
> 
> On Wednesday 30 March 2011, John Linn wrote:
> > Yes that makes sense.  We don't have immediate plans for PCI and
> > I was assuming when we add PCI we would need to change that.
> >
> > If you think I shouldn't put it off then I'll fix it now.  My
> > preference was to get the platform supported, then add more
features.
> 
> Getting it fixed properly depends a bit on the PCI implementation.
> I've been planning to clean up this part of the ARM architecture
> for some time and I can probably do it for one more platform when
> I get to it.

Sounds like it's fine to postpone it til we do PCI as I don't know all
the
details of the system yet. Soft logic in FPGAs is great :)

> 
> My idea for the multiplatform kernel is to have a global I/O space
> window (maybe 1 MB) that is in the same location in the virtual
> address space all the time, so any platform that wants to support
> PCI with direct-mapped I/O space can simply map it in there
> at boot time.
> 

Sounds like that will make it easier for everyone and more consistent.

Thanks,
John

> 	Arnd


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


