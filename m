Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab2EJKzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 06:55:39 -0400
Received: from trinity.fluff.org ([89.16.178.74]:51011 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758939Ab2EJKze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 06:55:34 -0400
X-Greylist: delayed 828 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 May 2012 06:55:34 EDT
Date: Thu, 10 May 2012 11:55:15 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Kukjin Kim <kgene.kim@samsung.com>,
        linaro-dev@lists.linaro.org, Jason Cooper <jason@lakedaemon.net>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>, shawn.guo@linaro.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Making ARM multiplatform kernels DT-only?
Message-ID: <20120510105515.GC30103@trinity.fluff.org>
References: <201205031350.35476.arnd@arndb.de>
 <20120503141853.GC897@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503141853.GC897@n2100.arm.linux.org.uk>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 03:18:53PM +0100, Russell King - ARM Linux wrote:
> On Thu, May 03, 2012 at 01:50:35PM +0000, Arnd Bergmann wrote:
> > My feeling is that we should just mandate DT booting for multiplatform
> > kernels, because it significantly reduces the combinatorial space
> > at compile time, avoids a lot of legacy board files that we cannot
> > test anyway, reduces the total kernel size and gives an incentive
> > for people to move forward to DT with their existing boards.
> 
> On this point, I strongly object, especially as I'm one who uses the
> existing non-DT multiplatform support extensively.  It's really not
> a problem for what you're trying to achieve.

I object firstly on principle that you don't need the DT support to
allow this, it could have been done years ago if anyone had taken the
time to do it.
 
> I think what you're proposing is a totally artificial restriction.
> There's no problem with a kernel supporting DT and non-DT together.
> We've proven that many many times.  I prove it _every_ night that my
> build and boot system runs - the OMAP LDP boots a multiplatform kernel
> just fine without DT.

We could have had the same for Samsung's entire range if a bit of work
had been applied to do things like PAGE_OFFSET and replaceable IRQ
controllers.

> In any case, this is the least of the worries when you're wanting to
> build multiple SoCs into the same kernel image.  See my previous reply
> concerning that.

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

