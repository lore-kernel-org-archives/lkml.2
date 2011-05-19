Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934384Ab1ESTal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:30:41 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41983 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934235Ab1ESTak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:30:40 -0400
Date: Thu, 19 May 2011 15:30:36 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/10] mach-u300: rewrite gpio driver, move to
 drivers/gpio
In-Reply-To: <20110519191156.GE2429@pengutronix.de>
Message-ID: <alpine.LFD.2.00.1105191527440.14430@xanadu.home>
References: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com> <20110519085638.GA26816@S2100-06.ap.freescale.net> <BANLkTinD9rAipfwNnh6QpgbcogckdtQ=OQ@mail.gmail.com> <20110519135631.GB26816@S2100-06.ap.freescale.net>
 <20110519191156.GE2429@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011, Sascha Hauer wrote:

> On Thu, May 19, 2011 at 09:56:32PM +0800, Shawn Guo wrote:
> > On Thu, May 19, 2011 at 02:21:27PM +0200, Linus Walleij wrote:
> > > On Thu, May 19, 2011 at 10:56 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
> > > 
> > > > I start working on moving mxs gpio (arch/arm/mach-mxs/gpio.c) into
> > > > driver/gpio, and I see the possibility to go a different approach
> > > > from U300 one posted here.
> > > 
> > > I've tried to figure out what relation the mail has to the U300 driver
> > > but cannot find any, more than that it's moving a driver... Please
> > > start a new mail thread.
> > > 
> > I will post mxs-gpio driver once I get it done.  Then please review
> > the code and see the difference between mxs-gpio and u300-gpio,
> > though these hardwares have something in common.
> 
> I'm pretty sure they have something in common and even more that *all*
> gpio drivers have something in common. I wonder if it really makes sense
> to move the gpio driver to drivers/gpio without creating a common
> mmio_gpio_chip beforehand. This can't be very hard.

I do think that performing the move first will make a subsequent 
conversion easier.  And since a move is a no-op from a functional point 
of view, it is the safest thing to do first.


Nicolas
