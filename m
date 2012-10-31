Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935140Ab2JaInu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 04:43:50 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:24773
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935029Ab2JaIno convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 04:43:44 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 7
X-BigFish: VPS7(zz98dI9371I542M1dbaI1432I4015Izz1202h1d1ah1d2ahzzz30ih95h668h839h944hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1307i1155h)
From: Michal Simek <michal.simek@xilinx.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Josh Cartwright <josh.cartwright@ni.com>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        John Linn <linnj@xilinx.com>, Nick Bowler <nbowler@elliptictech.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: RE: [PATCH v4 4/5] ARM: annotate VMALLOC_END definition with _AC
Thread-Topic: [PATCH v4 4/5] ARM: annotate VMALLOC_END definition with _AC
Thread-Index: AQHNsiLT7JMbcxvGH06LPjyGiap5f5fTDj/HgAAU1eA=
Date: Wed, 31 Oct 2012 08:43:35 +0000
References: <20121024200222.GA6713@beefymiracle.amer.corp.natinst.com>
 <20121024200431.GE6713@beefymiracle.amer.corp.natinst.com>
 <3c9e591c-a29f-446b-9256-bb23ff6d840d@TX2EHSMHS014.ehs.local>
 <201210302222.15656.arnd@arndb.de>
In-Reply-To: <201210302222.15656.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.26.162]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <29530110-f967-49c0-a2bc-d035d02da2a5@VA3EHSMHS020.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Tuesday, October 30, 2012 11:22 PM
> To: Michal Simek
> Cc: Josh Cartwright; arm@kernel.org; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; John Linn; Nick Bowler; Russell King - ARM Linux
> Subject: Re: [PATCH v4 4/5] ARM: annotate VMALLOC_END definition with _AC
>
> On Saturday 27 October 2012, Michal Simek wrote:
> > > diff --git a/arch/arm/include/asm/pgtable.h
> > > b/arch/arm/include/asm/pgtable.h index 08c1231..72904a2 100644
> > > --- a/arch/arm/include/asm/pgtable.h
> > > +++ b/arch/arm/include/asm/pgtable.h
> > > @@ -40,7 +40,7 @@
> > >   */
> > >  #define VMALLOC_OFFSET               (8*1024*1024)
> > >  #define VMALLOC_START                (((unsigned long)high_memory +
> > > VMALLOC_OFFSET) & ~(VMALLOC_OFFSET-1))
> > > -#define VMALLOC_END          0xff000000UL
> > > +#define VMALLOC_END          _AC(0xff000000,UL)
> >
> > This shouldn't be the part of this series but should go to mainline through
> different tree.
> > Arnd, Olof: Can you take this patch to your arm-soc tree?
> >
> > I don't think it is a good workstyle to propose it to mainline through zynq soc
> tree.
> > What do you think?
>
> The arm-soc tree is not the right place either, this is architecture code which is in
> Russell's domain. I would suggest getting an Ack from Russell if he's ok with it
> and then merging it together with your other changes into arm-soc.

That's what I thought too.
Not sure if Josh wants to push this to mainline.

Thanks,
Michal




This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


