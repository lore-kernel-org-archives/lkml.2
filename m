Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab2E2RWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 13:22:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35144 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab2E2RWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 13:22:46 -0400
Date: Tue, 29 May 2012 19:22:34 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drop superfluous setting of i2c_board_info.type
Message-ID: <20120529172234.GC30400@pengutronix.de>
References: <1337870303.22505.20.camel@x61.thuisdomein>
 <20120524162230.GU3710@pengutronix.de>
 <1337877626.22505.30.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1337877626.22505.30.camel@x61.thuisdomein>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:21:58 up 199 days,  1:09, 23 users,  load average: 0.04, 0.57,
 0.64
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 06:40:26PM +0200, Paul Bolle wrote:
> On Thu, 2012-05-24 at 18:22 +0200, Uwe Kleine-König wrote:
> > On Thu, May 24, 2012 at 04:38:23PM +0200, Paul Bolle wrote:
> > > 1) This is apparently legal. Doesn't gcc issue a warning for this?
> > I wondered about that too, gcc doesn't even warn when the two values are
> > different. See for example commit
> > bd9e310dca15c9987256f67af19f9f42426e7493.
> 
> In that case it were two strings ("rtc-pcf8563" versus "pcf8563"). Why
> should gcc care? Or is there something going on behind the scenes which
> somehow depends on the contents of the string?
>  
> > >  arch/arm/mach-imx/mach-cpuimx35.c     |    1 -
> > >  arch/arm/mach-imx/mach-cpuimx51sd.c   |    1 -
> > I already submitted a patch for the imx bits with Message id
> > 1335989287-10094-1-git-send-email-u.kleine-koenig@pengutronix.de.
> > (e.g.
> > http://mid.gmane.org/1335989287-10094-1-git-send-email-u.kleine-koenig@pengutronix.de)
> 
> Thanks. I missed that one, obviously. Should I just drop that part of
> the patch and resend?

I just merged Uwes patch, this leaves the sh-mobile hunk still to be
fixed.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
