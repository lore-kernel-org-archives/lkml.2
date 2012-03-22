Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab2CVDXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 23:23:52 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39532 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab2CVDXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 23:23:49 -0400
Date: Thu, 22 Mar 2012 11:23:26 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Saravana Kannan <skannan@codeaurora.org>, Andrew Lunn <andrew@lunn.ch>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Mike Turquette <mturquette@linaro.org>,
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
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCH 2/2] clk: Move init fields from clk to clk_hw
Message-ID: <20120322032323.GA2213@S2101-09.ap.freescale.net>
References: <CAJOA=zN2cSSpM92oRnW0RyU_ZzyoQ=jthc-fAkf-P3z37uWt7w@mail.gmail.com>
 <1332214706-675-1-git-send-email-skannan@codeaurora.org>
 <1332214706-675-2-git-send-email-skannan@codeaurora.org>
 <20120320072018.GC32469@S2101-09.ap.freescale.net>
 <cbd6490459b9fd68875fec4a7c7de073.squirrel@www.codeaurora.org>
 <20120320094031.GI3852@pengutronix.de>
 <e22898bc8b69e85f1e6390d7d858f85c.squirrel@www.codeaurora.org>
 <20120320181441.GO3852@pengutronix.de>
 <4F68E53B.7040800@codeaurora.org>
 <20120320224021.GF29317@pengutronix.de>
MIME-Version: 1.0
In-Reply-To: <20120320224021.GF29317@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 11:40:21PM +0100, Sascha Hauer wrote:
> On Tue, Mar 20, 2012 at 01:14:51PM -0700, Saravana Kannan wrote:
...
> > Ah, I see. That's a lot of functions calls. I think it would be much
> > more efficient if you just have an array and loop over it. With my
> > patch, you can just call a single register function for all these
> > clocks.
> 
> I was curious and gave it a try. I registered a fixed clock and 100
> gates as child clocks. I tried both DEFINE_CLK_GATE and
> clk_register_gate. It turned out there was no difference in speed.
> 
While there is no difference in speed efficiency, I think we will
gain space efficiency if we can have Saravana's patch to copy the
clk_hw fields and make the static array __initdata as you mentioned.

-- 
Regards,
Shawn
