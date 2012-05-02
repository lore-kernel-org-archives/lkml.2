Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523Ab2EBCPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 22:15:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58796 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757641Ab2EBCPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 22:15:09 -0400
Date: Wed, 2 May 2012 10:14:45 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Mike Turquette <mturquette@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Grant Likely <grant.likely@secretlab.ca>, h@pengutronix.de,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergman <arnd.bergmann@linaro.org>, linux-arm-msm@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCH] clk: Use a separate struct for holding init data.
Message-ID: <20120502021443.GQ2194@S2101-09.ap.freescale.net>
References: <20120426095135.GG17184@pengutronix.de>
 <4F9EE84C.90106@codeaurora.org>
 <CAJOA=zNCagT6GaeHi_jq7-LU9P-SfJZ8PA9bo-oeswjC0tHyYA@mail.gmail.com>
 <4F9F1659.1010804@codeaurora.org>
 <20120501081103.GC2194@S2101-09.ap.freescale.net>
 <20120501091334.GG15541@lunn.ch>
 <20120501170001.GB4089@opensource.wolfsonmicro.com>
 <4FA0258D.8020807@codeaurora.org>
 <20120501181922.GD4089@opensource.wolfsonmicro.com>
 <20120502015650.GE17311@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120502015650.GE17311@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 06:56:50PM -0700, Mike Turquette wrote:
> I could use some suggestions on the best way to resolve the merge issues
> we have currently.  It appears that we have three bases that platforms
> need to port over the common clk framework:
> 
> Russell's clkdev
> Arnd's arm-soc
> My clk-next branch
> 
> I was happy to push my changes to Linus directly (as discussed in
> previous mails) but I'm starting to think that maybe having Arnd absorb
> the clk-next branch as part of arm-soc would be the fastest way to
> assist platforms that are porting over.
> 
> Do the platform folks agree?  Is this suggestion sane?
> 
As one of the people who are working on platform porting, I'm not
concerned about the path that clk core goes to Linus, but the time
when we have a stable clk core branch appears on arm-soc either as
a dependency or a downstream tree.  Once we have stable branches for
both rmk's clkdev and clk core appear on arm-soc, we can start asking
Arnd to pull platform porting.

-- 
Regards,
Shawn
