Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934005Ab1ESTMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:12:03 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48829 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933806Ab1ESTMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:12:01 -0400
Date: Thu, 19 May 2011 21:11:56 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/10] mach-u300: rewrite gpio driver, move to
 drivers/gpio
Message-ID: <20110519191156.GE2429@pengutronix.de>
References: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com>
 <20110519085638.GA26816@S2100-06.ap.freescale.net>
 <BANLkTinD9rAipfwNnh6QpgbcogckdtQ=OQ@mail.gmail.com>
 <20110519135631.GB26816@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519135631.GB26816@S2100-06.ap.freescale.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 21:09:20 up 12 days, 10:47, 26 users,  load average: 0.30, 0.54,
 0.61
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 09:56:32PM +0800, Shawn Guo wrote:
> On Thu, May 19, 2011 at 02:21:27PM +0200, Linus Walleij wrote:
> > On Thu, May 19, 2011 at 10:56 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
> > 
> > > I start working on moving mxs gpio (arch/arm/mach-mxs/gpio.c) into
> > > driver/gpio, and I see the possibility to go a different approach
> > > from U300 one posted here.
> > 
> > I've tried to figure out what relation the mail has to the U300 driver
> > but cannot find any, more than that it's moving a driver... Please
> > start a new mail thread.
> > 
> I will post mxs-gpio driver once I get it done.  Then please review
> the code and see the difference between mxs-gpio and u300-gpio,
> though these hardwares have something in common.

I'm pretty sure they have something in common and even more that *all*
gpio drivers have something in common. I wonder if it really makes sense
to move the gpio driver to drivers/gpio without creating a common
mmio_gpio_chip beforehand. This can't be very hard.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
