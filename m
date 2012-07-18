Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab2GRFMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 01:12:53 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:38107 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026Ab2GRFMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 01:12:46 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dIzz1202hzzz2dh2a8h668h839h944hd25hf0ah107ah)
Date: Wed, 18 Jul 2012 13:33:42 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Lee Jones <lee.jones@linaro.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Walleij <linus.walleij@stericsson.com>,
        <devicetree-discuss@lists.ozlabs.org>,
        Wolfram Sang <w.sang@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        Deepak Saxena <dsaxena@linaro.org>, <linux-next@vger.kernel.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: linux-next: manual merge of the arm-soc tree with the
 i2c-embedded tree
Message-ID: <20120718053341.GA4009@S2100-06.ap.freescale.net>
References: <5003FB7C.4030509@linaro.org>
 <20120717130650.GB27595@sirena.org.uk>
 <500568D9.10805@linaro.org>
 <20120717133550.GC4477@opensource.wolfsonmicro.com>
 <50057058.2060002@linaro.org>
 <20120717142222.GE4477@opensource.wolfsonmicro.com>
 <50057C1A.80606@linaro.org>
 <20120717152001.GF4477@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120717152001.GF4477@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 04:20:01PM +0100, Mark Brown wrote:
> Looking at what's specified in the platform data in the current kernel
> it seems like there's a mixture of things in there that are board and
> silicon specific.  We've got parameters like the the speed mode and
> timeout which are reasonably board specific but we've also got things
> like the FIFO sizes which shouldn't be at all board specific and slsu
> which really looks like it's something that that the driver ought to be
> able to figure out for itself.

I have an IP block getting different FIFO size on different IMX SoCs.
We could introduce a new compatible string for driver to figure it out,
but I think the simpler way is just have the data encoded in device
tree.  In any case DT is not completely limited in encoding board
specific data.  Today, we have IO region and interrupt number of
hardware blocks encoded in DT, and to me, FIFO size could just be
another aspect of hardware block we could choose to encode in DT.

-- 
Regards,
Shawn

