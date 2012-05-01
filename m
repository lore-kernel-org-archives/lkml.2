Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481Ab2EASCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 14:02:37 -0400
Received: from londo.lunn.ch ([80.238.139.98]:35635 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757952Ab2EASCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 14:02:35 -0400
Date: Tue, 1 May 2012 20:04:25 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Saravana Kannan <skannan@codeaurora.org>,
        "Turquette, Mike" <mturquette@ti.com>,
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
Message-ID: <20120501180425.GV25584@lunn.ch>
Mail-Followup-To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Saravana Kannan <skannan@codeaurora.org>,
	"Turquette, Mike" <mturquette@ti.com>,
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
References: <4F98EB10.2000505@codeaurora.org>
 <20120426084201.GF17184@pengutronix.de>
 <4d67387a86d99cbb4e2acf68d3588b1c.squirrel@www.codeaurora.org>
 <20120426095135.GG17184@pengutronix.de>
 <4F9EE84C.90106@codeaurora.org>
 <CAJOA=zNCagT6GaeHi_jq7-LU9P-SfJZ8PA9bo-oeswjC0tHyYA@mail.gmail.com>
 <4F9F1659.1010804@codeaurora.org>
 <20120501081103.GC2194@S2101-09.ap.freescale.net>
 <20120501091334.GG15541@lunn.ch>
 <20120501170001.GB4089@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120501170001.GB4089@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Or merge the platforms then do framework changes incrementally, updating
> the platforms as we go (which is the normal pattern for maintaining a
> framework...).  I see we've already got SPEAr merged.

I'm not too sure SPEAr has been really merged. As far as i understand,
its dependencies have not been fulfilled, so it does not compile. This
to me is another indication of the problems we have at the moment...

   Andrew

