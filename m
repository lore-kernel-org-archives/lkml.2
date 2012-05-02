Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469Ab2EBFOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 01:14:30 -0400
Received: from londo.lunn.ch ([80.238.139.98]:36103 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678Ab2EBFO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 01:14:27 -0400
Date: Wed, 2 May 2012 07:16:33 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Mike Turquette <mturquette@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Shawn Guo <shawn.guo@linaro.org>,
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
Message-ID: <20120502051633.GH15541@lunn.ch>
Mail-Followup-To: Mike Turquette <mturquette@ti.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Saravana Kannan <skannan@codeaurora.org>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <s.hauer@pengutronix.de>, Andrew Lunn <andrew@lunn.ch>,
	Grant Likely <grant.likely@secretlab.ca>, h@pengutronix.de,
	Jamie Iles <jamie@jamieiles.com>,
	Jeremy Kerr <jeremy.kerr@canonical.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Deepak Saxena <dsaxena@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	Arnd Bergman <arnd.bergmann@linaro.org>,
	linux-arm-msm@vger.kernel.org,
	Rob Herring <rob.herring@calxeda.com>,
	Russell King <linux@arm.linux.org.uk>,
	Thomas Gleixner <tglx@linutronix.de>,
	Richard Zhao <richard.zhao@linaro.org>,
	Shawn Guo <shawn.guo@freescale.com>, Paul Walmsley <paul@pwsan.com>,
	Linus Walleij <linus.walleij@stericsson.com>,
	Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
	Amit Kucheria <amit.kucheria@linaro.org>
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

> I could use some suggestions on the best way to resolve the merge issues
> we have currently.  It appears that we have three bases that platforms
> need to port over the common clk framework:
> 
> Russell's clkdev
> Arnd's arm-soc
> My clk-next branch

Hi Mike

The Orion code only depends on clk-next. I've been more conservative
with the changes, knowing that once they are merged i can add more
patches to make use of devm_get_clk() etc.

So for my, as well as going in via arm-soc, i could also imaging
giving you a pull request and becoming part of clk-next. However, i
don't care what route they take.

      Andrew
