Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab2EEIJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 04:09:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56117 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab2EEIJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 04:09:51 -0400
Date: Sat, 5 May 2012 10:09:36 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        linaro-dev@lists.linaro.org, Jason Cooper <jason@lakedaemon.net>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>, shawn.guo@linaro.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: Making ARM multiplatform kernels DT-only?
Message-ID: <20120505080936.GP4141@pengutronix.de>
References: <201205031350.35476.arnd@arndb.de>
 <20120503144609.GK4141@pengutronix.de>
 <201205041624.17850.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205041624.17850.arnd@arndb.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:56:12 up 174 days, 15:43, 14 users,  load average: 0.02, 0.04,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 04:24:17PM +0000, Arnd Bergmann wrote:
> On Thursday 03 May 2012, Sascha Hauer wrote:
> > I don't think that enforcing DT only in multiplatform kernels will speed
> > up porting to DT. As a platform maintainer I am interested in building
> > multiplatform Kernels, but our customers are mostly uninterested in
> > this. They probably disable other platforms anyway to save the binary space.
> 
> I was not asking about enabling multiple board files but multiple mach-*
> directories, 

Yes, I understood that.

> which is something that I'm probably more interested in than
> you are, and the customers you refer to would certainly not do that if
> they only want to run on one board.
> 
> This is really about people who distribute kernels that run on a wide
> variety of machines across soc vendor boundaries, people like
> ubuntu or cyanogenmod. The question is really whether you see a reason
> why they should enable the 25 non-DT board files on your platform, rather
> than helping out getting DT support for the machines they are
> interested in?

They should not if they are not interested in these boards, but why
shouldn't I be able to enable these 25 boards plus a few atmel or pxa
boards?

When there are technical reasons to limit a multiplatform Kernel to DT
only, then fine, lets do it that way. If there are no technical reasons
and this limitation shall only be used to put some political pressure on
platform board maintainers, then I am against it. Look around, people
actually *are* porting their boards over to device tree, I don't think
that such pressure is necessary.

Only my two cents, it's not that important to me since I want to port my
(relevant) boards over to DT anyway, so I won't argue about this.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
