Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab1EUNDN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 09:03:13 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59873 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab1EUNDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 09:03:11 -0400
Date: Sat, 21 May 2011 14:03:02 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Jamie Iles <jamie@jamieiles.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH 02/10] mach-u300: rewrite gpio driver, move to
 drivers/gpio
Message-ID: <20110521130302.GA4111@pulham.picochip.com>
References: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com>
 <20110519085638.GA26816@S2100-06.ap.freescale.net>
 <BANLkTinD9rAipfwNnh6QpgbcogckdtQ=OQ@mail.gmail.com>
 <20110519135631.GB26816@S2100-06.ap.freescale.net>
 <20110519191156.GE2429@pengutronix.de>
 <0D753D10438DA54287A00B027084269764D3045B3B@AUSP01VMBX24.collaborationhost.net>
 <20110520015022.GA3095@pulham.picochip.com>
 <0D753D10438DA54287A00B027084269764D30C10DC@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D753D10438DA54287A00B027084269764D30C10DC@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 05:07:12PM -0500, H Hartley Sweeten wrote:
> On Thursday, May 19, 2011 6:50 PM, Jamie Iles wrote:
> > diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> > index becef59..aa9e97f 100644
> > --- a/drivers/gpio/Makefile
> > +++ b/drivers/gpio/Makefile
> > @@ -10,6 +10,7 @@ obj-$(CONFIG_GPIOLIB)         += gpiolib.o
> >  
> >  obj-$(CONFIG_GPIO_ADP5520)     += adp5520-gpio.o
> >  obj-$(CONFIG_GPIO_ADP5588)     += adp5588-gpio.o
> > +obj-$(CONFIG_GPIO_BASIC_MMIO_CORE)     += basic_mmio_gpio.o
> >  obj-$(CONFIG_GPIO_BASIC_MMIO)  += basic_mmio_gpio.o
> 
> I think the line above should be removed.  GPIO_BASIC_MMIO selects
> GPIO_BASIC_MMIO_CORE so the line you added previous to it will cause
> basic_mmio_gpio to be compiled.
> 
> GPIO_BASIC_MMIO is really just used in the driver to enable the code
> at the end which creates the generic gbpio_driver.

Yes, well spotted.  I'll create a patch to remove this.

Jamie
