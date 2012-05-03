Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab2ECOqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:46:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52689 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757035Ab2ECOqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:46:17 -0400
Date: Thu, 3 May 2012 16:46:09 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>, shawn.guo@linaro.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>, Nicolas Pitre <nico@fluxnic.net>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: Making ARM multiplatform kernels DT-only?
Message-ID: <20120503144609.GK4141@pengutronix.de>
References: <201205031350.35476.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205031350.35476.arnd@arndb.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:27:34 up 172 days, 22:14, 85 users,  load average: 4.28, 3.27,
 1.76
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 01:50:35PM +0000, Arnd Bergmann wrote:
> Hi everyone,
> 
> I've been discussing multiplatform kernels with a few people recently,
> and we will have a lot of discussion sessions about this at Linaro
> Connect in Hong Kong.
> 
> One question that came up repeatedly is whether we should support all
> possible board files for each platform in a multiplatform kernel,
> or just the ones that are already using DT probing. I would like
> to get a quick poll of opinions on that and I've tried to put those
> people on Cc that would be most impacted by this, i.e. the maintainers
> for platforms that have both DT and non-DT board files at the moment.
> 
> My feeling is that we should just mandate DT booting for multiplatform
> kernels, because it significantly reduces the combinatorial space
> at compile time, avoids a lot of legacy board files that we cannot
> test anyway, reduces the total kernel size and gives an incentive
> for people to move forward to DT with their existing boards.
> 
> The counterargument is that we won't be able to support all the
> boards we currently do when the user switches on multiplatform,
> but I think that is acceptable.
> Note that I would still want to allow users to build platforms
> separately in order to enable the ATAG style board files, even
> for platforms that are not multiplatform capable.
> 
> Other opinions?

I don't think that enforcing DT only in multiplatform kernels will speed
up porting to DT. As a platform maintainer I am interested in building
multiplatform Kernels, but our customers are mostly uninterested in
this. They probably disable other platforms anyway to save the binary space.

So unless there are real technical problems supporting DT and !DT in a
single kernel (and Russells answer seems to say there aren't) I say no
to creating this restriction.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
