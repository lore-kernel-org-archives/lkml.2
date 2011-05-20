Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901Ab1ETDNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 23:13:54 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:18683 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab1ETDNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 23:13:53 -0400
X-SpamScore: -21
X-BigFish: VS-21(zz9371O1521M1432N98dKzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 20 May 2011 11:18:18 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Sascha Hauer <s.hauer@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 02/10] mach-u300: rewrite gpio driver, move to
 drivers/gpio
Message-ID: <20110520031818.GB27251@S2100-06.ap.freescale.net>
References: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com>
 <20110519085638.GA26816@S2100-06.ap.freescale.net>
 <BANLkTinD9rAipfwNnh6QpgbcogckdtQ=OQ@mail.gmail.com>
 <20110519135631.GB26816@S2100-06.ap.freescale.net>
 <20110519191156.GE2429@pengutronix.de>
 <alpine.LFD.2.00.1105191527440.14430@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1105191527440.14430@xanadu.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 03:30:36PM -0400, Nicolas Pitre wrote:
> On Thu, 19 May 2011, Sascha Hauer wrote:
> 
> > On Thu, May 19, 2011 at 09:56:32PM +0800, Shawn Guo wrote:
> > > On Thu, May 19, 2011 at 02:21:27PM +0200, Linus Walleij wrote:
> > > > On Thu, May 19, 2011 at 10:56 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
> > > > 
> > > > > I start working on moving mxs gpio (arch/arm/mach-mxs/gpio.c) into
> > > > > driver/gpio, and I see the possibility to go a different approach
> > > > > from U300 one posted here.
> > > > 
> > > > I've tried to figure out what relation the mail has to the U300 driver
> > > > but cannot find any, more than that it's moving a driver... Please
> > > > start a new mail thread.
> > > > 
> > > I will post mxs-gpio driver once I get it done.  Then please review
> > > the code and see the difference between mxs-gpio and u300-gpio,
> > > though these hardwares have something in common.
> > 
> > I'm pretty sure they have something in common and even more that *all*
> > gpio drivers have something in common. I wonder if it really makes sense
> > to move the gpio driver to drivers/gpio without creating a common
> > mmio_gpio_chip beforehand. This can't be very hard.
> 
> I do think that performing the move first will make a subsequent 
> conversion easier.  And since a move is a no-op from a functional point 
> of view, it is the safest thing to do first.
> 
That's also what I heard on UDS week.  Move stuff into driver/gpio
first, then try to find the pattern in those drivers and come up with
some framework.

-- 
Regards,
Shawn

