Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab2KPRNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:13:38 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:42553
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752114Ab2KPRNh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:13:37 -0500
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 5
X-BigFish: VPS5(zz98dI9371I103dK542M1432I4015Izz1de0h1202h1d1ah1d2ahzzz30ih95h668h839h944hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1307i1155h)
From: Michal Simek <michal.simek@xilinx.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "arm@kernel.org" <arm@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>,
        Nick Bowler <nbowler@elliptictech.com>,
        Josh Cartwright <josh.cartwright@ni.com>, John Linn <linnj@xilinx.com>
Subject: RE: [GIT PULL] arm-soc: Xilinx zynq changes for v3.8
Thread-Topic: [GIT PULL] arm-soc: Xilinx zynq changes for v3.8
Thread-Index: AQHNxBsbeh6pPCgvtU2wWLXiGF9qT5fsr2XA
Date: Fri, 16 Nov 2012 17:13:30 +0000
References: <CAHTX3dLdGie9gtxbPq_gb8BLao7YYohqQWZFg3LzyNHxu=imdg@mail.gmail.com>
 <CAHTX3dLijLK45ddZQVYHcrs6QQbmdRmQbPmTKada9nXx3ZAe3w@mail.gmail.com>
 <201211161654.23470.arnd@arndb.de>
In-Reply-To: <201211161654.23470.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.24.221]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <52241ede-3d28-43fc-967d-36ab64d52592@CH1EHSMHS038.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Friday, November 16, 2012 5:54 PM
> To: Michal Simek
> Cc: arm@kernel.org; LKML; linux-arm; Olof Johansson; Nick Bowler; Josh
> Cartwright; John Linn
> Subject: Re: [GIT PULL] arm-soc: Xilinx zynq changes for v3.8
>
> On Friday 16 November 2012, Michal Simek wrote:
> > I have 7 new follow up patches for zynq. They are based on previous
> > patches (arm-soc zynq/cleanup branch).
> > The branch is still based on rc3 but I have also tried to merged it
> > with the v3.7-rc5 and there is no issue.
> >
> > It should be the last pull request for v3.8.
> >
>
> Pulled into next/dt, thanks!
>
> This was a small set of patches and you're new to the job, so there is no problem
> with what you sent me, but I have a few comments for the
> future:

Yeah, need to learn more how arm-soc works.

>
> * Please provide a description of the series that I can put into the merge
> changeset, either in the introductory mail or (better) into the signed tag that
> you send (git tag -s). Have a look at how Tony Lindgren does this, he writes the
> best descriptions.

No. Do you have a link?

> * I've used the next/dt branch, since that is what most of the patches from this
> series best fit in. However, some of the patches would have made more sense
> in a different branch (clock, cleanup, ...).
> When you have things that are logically separate, just send separate pull
> requests. This takes some practice to get the dependencies right, so please ask
> if you are not sure how to do it.

yeah. I forget.

> * It seems the zynq multiplatform changes didn't make it for 3.8. I hope you can
> do this for 3.9, as this should not be too hard.

We have done a lot of changes and I believe I will have more time to do it soon.

Thanks,
Michal


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


