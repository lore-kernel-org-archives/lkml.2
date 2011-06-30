Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab1F3PLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 11:11:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51434 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab1F3PLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 11:11:44 -0400
Date: Thu, 30 Jun 2011 17:11:38 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Shawn Guo <shawn.guo@linaro.org>, Ryan Mallon <ryan@bluewatersys.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] pwm: Add a i.MX23/28 pwm driver
Message-ID: <20110630151138.GB9349@pengutronix.de>
References: <1309430517-23821-1-git-send-email-s.hauer@pengutronix.de>
 <1309430517-23821-4-git-send-email-s.hauer@pengutronix.de>
 <201106301342.36088.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106301342.36088.arnd@arndb.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:10:47 up 8 days, 20:58, 30 users,  load average: 0.06, 0.29, 0.75
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 01:42:35PM +0200, Arnd Bergmann wrote:
> On Thursday 30 June 2011, Sascha Hauer wrote:
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> 
> Hi Sascha,
> 
> The probing looks good to me now. I would have added extra code to avoid
> ioremapping the same page multiple times, but I see this as a matter of
> different preferences, so I'm fine with that.
> 
> You are still missing a description of the driver, both in the changelog
> above and in the Kconfig patch. A small sentence to spell out PWM
> in the changelog and to list the devices that will use this driver
> would be helpful to the causal reader.

Ok, will add.

> 
> Provided that you add that:
> 
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> 
> > diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> > index 93c1052..5694574 100644
> > --- a/drivers/pwm/Kconfig
> > +++ b/drivers/pwm/Kconfig
> > @@ -2,11 +2,15 @@ menuconfig PWM
> >  	bool "PWM Support"
> >  	help
> >  	  This enables PWM support through the generic PWM framework.
> > -	  You only need to enable this, if you also want to enable
> > +	  You only need to enable this if you also want to enable
> >  	  one or more of the PWM drivers below.
> >  
> >  	  If unsure, say N.
> >  
> 
> I think this hunk should have been in the other first patch.

Indeed, will fix.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
