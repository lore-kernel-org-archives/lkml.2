Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab2LNAMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 19:12:06 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:21842
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120Ab2LNAME convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 19:12:04 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I542I1432Izz1de0h1202h1e76h1d1ah1d2ahzz8275dhz2fh95h668h839h944hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h906i1155h)
From: John Linn <John.Linn@xilinx.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Michal Simek <michals@xilinx.com>
Subject: RE: linux-next: fetch failure the xilinx tree
Thread-Topic: linux-next: fetch failure the xilinx tree
Thread-Index: AQHN1c2FxE/lJZAkm06qu2YbyZk7yJgSoA0AgAVZS4D//3oLcA==
Date: Fri, 14 Dec 2012 00:11:53 +0000
References: <20121209162442.15fbb8509569c193bfd88986@canb.auug.org.au>
	<50C5F1CE.30402@metafoo.de>
 <20121214111027.d191eaa1799c0ce194aacfa7@canb.auug.org.au>
In-Reply-To: <20121214111027.d191eaa1799c0ce194aacfa7@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.19.166.196]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <09cbc642-239b-4e0f-b863-66821b09954c@CH1EHSMHS012.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: Thursday, December 13, 2012 4:10 PM
> To: John Linn
> Cc: Lars-Peter Clausen; linux-kernel@vger.kernel.org; linux-next@vger.kernel.org
> Subject: Re: linux-next: fetch failure the xilinx tree
> 
> Hi John,
> 
> On Mon, 10 Dec 2012 15:29:34 +0100 Lars-Peter Clausen <lars@metafoo.de> wrote:
> >
> > On 12/09/2012 06:24 AM, Stephen Rothwell wrote:
> > >
> > > Attempting to fetch the xilinx tree produces this error (and has for some
> > > days, now):
> > >
> > > fatal: The remote end hung up unexpectedly
> >
> > They renamed the repository from linux-2.6-xlnx to linux-xlnx. I stumbled
> > over it as well.
> 
> Is this the correct thing for me to do?

Yes that's right, thanks.

-- John

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


