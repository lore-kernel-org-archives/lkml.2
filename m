Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab2JVN1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:27:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60857 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753993Ab2JVN1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:27:15 -0400
Date: Mon, 22 Oct 2012 14:27:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Ralf Baechle <ralf@linux-mips.org>,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: Make the generic clock API available by default
Message-ID: <20121022132711.GE4477@opensource.wolfsonmicro.com>
References: <1350910970-9095-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20121022130556.GM21164@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022130556.GM21164@n2100.arm.linux.org.uk>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 02:05:57PM +0100, Russell King - ARM Linux wrote:
> On Mon, Oct 22, 2012 at 02:02:50PM +0100, Mark Brown wrote:
> > @@ -327,6 +328,7 @@ config ARCH_AT91
> >  	select ARCH_REQUIRE_GPIOLIB
> >  	select CLKDEV_LOOKUP
> >  	select HAVE_CLK
> > +	select HAVE_CUSTOM_CLK

> This is silly.  If you select "HAVE_CUSTOM_CLK" then isn't it true that
> "HAVE_CLK" should also be selected?  If so, why not have "HAVE_CUSTOM_CLK"
> do that selection and remove it from all these entries?

If we're worrying about that there's the larger point that the effect of
this patch is to make HAVE_CLK meaningless as there will be no platform
for which it's not true.  I was just leaving HAVE_CLK alone for now
ready to circle around on it if we ever manage to get the enabling bit
sorted.
