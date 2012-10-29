Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab2J2OtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 10:49:04 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:1423 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756047Ab2J2OtB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 10:49:01 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 6
X-BigFish: VPS6(zz98dI9371I1454I542M1432I1418I4015Izz1202h1d1ah1d2ahzzz30ih95h668h839h944hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1307i1155h)
From: Michal Simek <michal.simek@xilinx.com>
To: Josh Cartwright <josh.cartwright@ni.com>
CC: "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        John Linn <linnj@xilinx.com>, Nick Bowler <nbowler@elliptictech.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: RE: [PATCH v4 0/5] zynq subarch cleanups
Thread-Topic: [PATCH v4 0/5] zynq subarch cleanups
Thread-Index: AQHNtWmr0RZRheffW0uxuGWIfit9cJfQTfbSgAAQIEA=
Date: Mon, 29 Oct 2012 14:48:55 +0000
References: <cover.1351466765.git.josh.cartwright@ni.com>
 <5c2911d7-f753-4d9f-b8d8-3bf011d58e52@TX2EHSMHS014.ehs.local>
 <20121029133609.GE5190@beefymiracle.amer.corp.natinst.com>
In-Reply-To: <20121029133609.GE5190@beefymiracle.amer.corp.natinst.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.26.71]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <92733d32-890b-42ab-b693-3240e9613935@TX2EHSMHS013.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Josh Cartwright [mailto:josh.cartwright@ni.com]
> Sent: Monday, October 29, 2012 2:36 PM
> To: Michal Simek
> Cc: arm@kernel.org; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; John Linn; Nick Bowler; Arnd Bergmann
> Subject: Re: [PATCH v4 0/5] zynq subarch cleanups
> 
> On Mon, Oct 29, 2012 at 07:24:16AM +0000, Michal Simek wrote:
> > Hi Josh,
> >
> > > Michal-
> > >
> > > Here is a v5 of the zynq cleanup patchset that addresses your
> > > feedback.  I've intentionally left patches 4 and 5 in the set until
> > > we figure out the appropriate way to get them in tree (feel free to
> > > just apply 1-3)
> >
> > I am ok to pick just several patches from your patchset. But this is
> > no definitely good working style. Not expert for submission process
> > but I think that if there is one broken patch maintainer shouldn't
> > apply it.  Can someone else check this?
> 
> It turns out that with the change to patch 5 to map the uart to a known working
> address (instead of VMALLOC_END - 0x1000), patch 4 isn't needed, and as such
> can be dropped.  (I didn't realize this until this morning until I had saw you had
> applied 1-3,5 to your tree, but not 4).
> 
> So, for what it's worth, you've applied all of the relevant patches for this
> patchset.

Ok. Great.

Thanks,
MIchal


