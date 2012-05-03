Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab2ECOTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:19:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50671 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195Ab2ECOTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:19:09 -0400
Date: Thu, 3 May 2012 15:18:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Deepak Saxena <dsaxena@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>, shawn.guo@linaro.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>, Nicolas Pitre <nico@fluxnic.net>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: Making ARM multiplatform kernels DT-only?
Message-ID: <20120503141853.GC897@n2100.arm.linux.org.uk>
References: <201205031350.35476.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205031350.35476.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 01:50:35PM +0000, Arnd Bergmann wrote:
> My feeling is that we should just mandate DT booting for multiplatform
> kernels, because it significantly reduces the combinatorial space
> at compile time, avoids a lot of legacy board files that we cannot
> test anyway, reduces the total kernel size and gives an incentive
> for people to move forward to DT with their existing boards.

On this point, I strongly object, especially as I'm one who uses the
existing non-DT multiplatform support extensively.  It's really not
a problem for what you're trying to achieve.

I think what you're proposing is a totally artificial restriction.
There's no problem with a kernel supporting DT and non-DT together.
We've proven that many many times.  I prove it _every_ night that my
build and boot system runs - the OMAP LDP boots a multiplatform kernel
just fine without DT.

In any case, this is the least of the worries when you're wanting to
build multiple SoCs into the same kernel image.  See my previous reply
concerning that.
