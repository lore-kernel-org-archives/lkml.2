Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935163Ab1ETBud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 21:50:33 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63314 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934716Ab1ETBub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 21:50:31 -0400
Date: Fri, 20 May 2011 02:50:22 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jamie Iles <jamie@jamieiles.com>
Subject: Re: [PATCH 02/10] mach-u300: rewrite gpio driver, move to
 drivers/gpio
Message-ID: <20110520015022.GA3095@pulham.picochip.com>
References: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com>
 <20110519085638.GA26816@S2100-06.ap.freescale.net>
 <BANLkTinD9rAipfwNnh6QpgbcogckdtQ=OQ@mail.gmail.com>
 <20110519135631.GB26816@S2100-06.ap.freescale.net>
 <20110519191156.GE2429@pengutronix.de>
 <0D753D10438DA54287A00B027084269764D3045B3B@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D753D10438DA54287A00B027084269764D3045B3B@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 04:18:56PM -0500, H Hartley Sweeten wrote:
> On Thursday, May 19, 2011 12:12 PM, Sascha Hauer wrote:
> > On Thu, May 19, 2011 at 09:56:32PM +0800, Shawn Guo wrote:
> >> On Thu, May 19, 2011 at 02:21:27PM +0200, Linus Walleij wrote:
> >>> On Thu, May 19, 2011 at 10:56 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
> >>> 
> >>>> I start working on moving mxs gpio (arch/arm/mach-mxs/gpio.c) into
> >>>> driver/gpio, and I see the possibility to go a different approach
> >>>> from U300 one posted here.
> >>> 
> >>> I've tried to figure out what relation the mail has to the U300 driver
> >>> but cannot find any, more than that it's moving a driver... Please
> >>> start a new mail thread.
> >>> 
> >> I will post mxs-gpio driver once I get it done.  Then please review
> >> the code and see the difference between mxs-gpio and u300-gpio,
> >> though these hardwares have something in common.
> >
> > I'm pretty sure they have something in common and even more that *all*
> > gpio drivers have something in common. I wonder if it really makes sense
> > to move the gpio driver to drivers/gpio without creating a common
> > mmio_gpio_chip beforehand. This can't be very hard.
> 
> Jamie Iles (cc'ed) posted some patches that extended the basic_mmio_gpio
> driver so that it could be used as a library by other gpio drivers.
> 
> Jamie, could you re-post that series to the linux-arm-kernel list for
> review?

Grant has applied these patches but I've put them in a public branch if 
that's OK rather than reposting:

	git://github.com/jamieiles/linux-2.6-ji.git gpio

Jamie
