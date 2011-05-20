Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935594Ab1ETLZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 07:25:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55175 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934675Ab1ETLZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 07:25:28 -0400
Date: Fri, 20 May 2011 13:25:25 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
Subject: Re: [PATCH 0/4] add gpio driver gpio-mxs
Message-ID: <20110520112524.GC10403@pengutronix.de>
References: <1305885089-27343-1-git-send-email-shawn.guo@linaro.org>
 <20110520100242.GA10403@pengutronix.de>
 <20110520102410.GD27251@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110520102410.GD27251@S2100-06.ap.freescale.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:24:59 up  5:05,  6 users,  load average: 0.00, 0.03, 0.00
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:66ff:fe5b:d076
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 06:24:11PM +0800, Shawn Guo wrote:
> On Fri, May 20, 2011 at 12:02:42PM +0200, Sascha Hauer wrote:
> > Hi Shawn,
> > 
> Hi Sascha,
> 
> > On Fri, May 20, 2011 at 05:51:25PM +0800, Shawn Guo wrote:
> > > The patch set is to move Freescale MXS gpio driver from mach-mxs
> > > into drivers/gpio.  Different from u300 gpio driver that all gpio
> > > ports are registered as one device, gpio-mxs expects every single
> > > port is a gpio device.
> > > 
> > > The first 3 patches are just to ease review and can be squashed into
> > > the last one.
> > > 
> > > Shawn Guo (4):
> > >       gpio: gpio-mxs: add file gpio-mxs.c
> > >       gpio: gpio-mxs: drop mach-specific accessors
> > >       gpio: gpio-mxs: remove gpio port definition and registration
> > >       gpio: gpio-mxs: add gpio driver for Freescale MXS architecture
> > 
> > Your series should be bisectible. So please either:
> > 
> > - Add the driver the way you want it (no need to modify a new file in
> >   four steps)
> 
> As I said above, I split it into 4 patches just to ease the review,
> and they can be squashed into one when applying.
> 
> > - atomically switch to the new driver
> > - remove old driver
> > 
> These two steps happened in the patch set '[PATCH 0/3] remove mach-mxs
> gpio driver'.  The patch order should be reworked though.
> 
> BTW, are you looking at moving plat-mxc/gpio.c, or I can give a hand
> there?

I'm not working on this, go ahead.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
