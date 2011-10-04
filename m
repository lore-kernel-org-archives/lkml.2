Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933825Ab1JDXWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 19:22:34 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59898 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933299Ab1JDXWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 19:22:33 -0400
Date: Tue, 4 Oct 2011 17:22:28 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mike Turquette <mturquette@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, paul@pwsan.com, sboyd@quiinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, linux@arm.linux.org.uk, eric.miao@linaro.org,
        richard.zhao@linaro.org
Subject: Re: [PATCH v2 6/7] clk: Add initial WM831x clock driver
Message-ID: <20111004232228.GA3009@ponder.secretlab.ca>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-7-git-send-email-mturquette@ti.com>
 <20110925040836.GP24631@ponder.secretlab.ca>
 <20110926093858.GD2946@opensource.wolfsonmicro.com>
 <20111004181818.GD2870@ponder.secretlab.ca>
 <20111004205002.GA20296@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111004205002.GA20296@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 09:50:02PM +0100, Mark Brown wrote:
> On Tue, Oct 04, 2011 at 12:18:18PM -0600, Grant Likely wrote:
> > #define module_platform_driver(__driver) \
> > int __driver##_init(void) \
> > { \
> > 	return platform_driver_register(&(__driver)); \
> > } \
> > module_init(__driver##_init); \
> > void ##__driver##_exit(void) \
> > { \
> > 	platform_driver_unregister(&(__driver)); \
> > } \
> > module_exit(##__driver##_exit);
> 
> > It's not a lot of code, but I dislike how much boilerplate every
> > single driver has to use if it doesn't do anything special.
> 
> Yeah, this sort of stuff would be helpful - there's quite a bit of
> boilerplate you end up having to write to get drivers going.

Draft patch written, and posting to the list soon...

g.

