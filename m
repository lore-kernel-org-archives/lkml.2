Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab1EIIAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 04:00:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47377 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab1EIIAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 04:00:16 -0400
Date: Mon, 9 May 2011 10:00:02 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Andrew Morton <akpm@linux-foundation.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] leds: provide helper to register "leds-gpio" devices
Message-ID: <20110509080002.GA29089@pengutronix.de>
References: <1302097097.22904.41.camel@rex>
 <1302554157-24145-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20110412214848.GI7806@n2100.arm.linux.org.uk>
 <20110413062316.GH18850@pengutronix.de>
 <1304715802.30391.157.camel@rex>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1304715802.30391.157.camel@rex>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Richard,

On Fri, May 06, 2011 at 10:03:22PM +0100, Richard Purdie wrote:
> On Wed, 2011-04-13 at 08:23 +0200, Uwe Kleine-König wrote:
> > On Tue, Apr 12, 2011 at 10:48:48PM +0100, Russell King - ARM Linux wrote:
> > > On Mon, Apr 11, 2011 at 10:35:57PM +0200, Uwe Kleine-König wrote:
> > > > +obj-y					+= led-register.o
> > > 
> > > Why not obj-$(CONFIG_LED_REGISTER_GPIO) += led-register.o
> > > 
> > > rather than wrapping the code of led-register.c with a #ifdef for the
> > > same symbol?
> > I thought that the registration for other led-devices could go into that
> > file, too. That's why I choosed the name led-register and not
> > leds-gpio-register.c. Agreed? I don't insist on that.
> 
> I'm not sure we want/need to put other registration functions in this
> file? obj-$(CONFIG_LED_REGISTER_GPIO) probably therefore makes sense
> until some other registration need arises.
OK, then I will name the file leds-gpio-register.c. This can be renamed
to led-register.c when/if other registrations follow.

> Regardless, I'm happier with this patch than the previous ones. If you
> change it to use obj-$(CONFIG_LED_REGISTER_GPIO), 
> 
> Acked-by: Richard Purdie <richard.purdie@linuxfoundation.org>
Who will take the patch then? Andrew? Or is there someone else I need to
Cc?

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
