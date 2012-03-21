Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab2CULcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 07:32:01 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33694 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab2CULcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 07:32:00 -0400
Date: Wed, 21 Mar 2012 12:31:55 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Bernhard Walle <bernhard@bwalle.de>,
        Bernhard Walle <walle@corscience.de>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] mfd: Add TWL4030 PWM driver
Message-ID: <20120321113155.GS3852@pengutronix.de>
References: <1332262083-9375-1-git-send-email-walle@corscience.de>
 <201203210839.06258.arnd@arndb.de>
 <20120321084856.GA17472@avionic-0098.mockup.avionic-design.de>
 <201203211003.28019.arnd@arndb.de>
 <20120321102847.GA13630@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120321102847.GA13630@avionic-0098.mockup.avionic-design.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:30:10 up 129 days, 19:17, 69 users,  load average: 0.26, 2.19,
 1.53
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 11:28:47AM +0100, Thierry Reding wrote:
> * Arnd Bergmann wrote:
> > On Wednesday 21 March 2012, Thierry Reding wrote:
> > > I don't have a public tree anywhere. Does anyone have a recommendation where
> > > I could set one up? github or gitorious are the first to come to my mind.
> > 
> > They both work fine and are easy to set up, at least as a temporary location.
> 
> Okay, I'll check both and will also investigate whether one can be setup on
> our domain.
> 
> > If you want to have something more official in the long run, you could
> > either set up your own git server on your employer's domain or if that
> > is impractical, get an account on kernel.org or linaro.org. Both of those
> > try to limit the amount of accounts they hand out to external people, but
> > since you are going to be a subsystem maintainer, I don't see it as a
> > problem.
> 
> Maybe Sascha should have a say in this (adding to Cc). He wrote the original
> code and got the ball rolling, so I don't want to jump the queue. If he's
> okay with it, though, I'd be happy to take over.

I'm okay with this. I only wanted to write code for pwm, not maintain it ;)

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
