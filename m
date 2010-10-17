Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab0JQNGo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 09:06:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50388 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521Ab0JQNGn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 09:06:43 -0400
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Arnd Hannemann <arnd@arndnet.de>, "Pedanekar, Hemant" <hemantp@ti.com>,
        Greg KH <greg@kroah.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Date: Sun, 17 Oct 2010 08:05:35 -0500
Subject: RE: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Thread-Topic: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Thread-Index: Acts3TqUzA45InBWS1Oa1Ig47eJsqQBG1CEg
Message-ID: <13B9B4C6EF24D648824FF11BE896716203D76F71F4@dlee02.ent.ti.com>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
	<20101007192245.GC26435@n2100.arm.linux.org.uk>
	<AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com>
	<20101008175308.GA10975@n2100.arm.linux.org.uk>
 <1287196588.2370.1.camel@pasglop>
In-Reply-To: <1287196588.2370.1.camel@pasglop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: linux-arm-kernel-bounces@lists.infradead.org [mailto:linux-arm-
> kernel-bounces@lists.infradead.org] On Behalf Of Benjamin
> Herrenschmidt

> > If you want the old way back, apply pressure to silicon vendors and
> > ARM Ltd to change the architecture to lift this restriction - which
> > will probably mean doing away with aggressive speculative
> prefetching
> > so that it's possible to predict what will be in the cache at any
> > point in time.
>
> Note that we have the exact same problem on powerpc. The only sane
> solution is that SoCs designed around such cores or versions of the
> architecture should be fully DMA coherent to avoid the need for funky
> mapping attributes. Anything else is garbage HW, but sadly, it looks
> like way too many idiots still find jobs as HW designers.

ARM has always been a rawer (and cheaper) environment than many other CPU architectures. Until maybe this year coherency was never even an option provided in the hardware. The vast majority of the systems currently in mass production in 2010 and before don't have coherency.  The software has to handle all the details.

Starting today and onwards coherency options will start to be seen in high end. It seems likely some of the old external IP won't be compliant and likely have bugs undercutting it.

People from high ends like x86 and PPC have different expectations and problems. Your chip set nightmares are our standard in some areas. In my narrow experience PPC pioneered many techniques 15 years back which are now just coming into ARM. They are coming in at a much reduced power and cost footprint.

Regards,
Richard W.

