Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab2EAJLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 05:11:44 -0400
Received: from londo.lunn.ch ([80.238.139.98]:34863 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545Ab2EAJLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 05:11:33 -0400
Date: Tue, 1 May 2012 11:13:34 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Saravana Kannan <skannan@codeaurora.org>,
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
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCH] clk: Use a separate struct for holding init data.
Message-ID: <20120501091334.GG15541@lunn.ch>
Mail-Followup-To: Shawn Guo <shawn.guo@linaro.org>,
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
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
	Amit Kucheria <amit.kucheria@linaro.org>
References: <1335419936-10881-1-git-send-email-skannan@codeaurora.org>
 <4F98EB10.2000505@codeaurora.org>
 <20120426084201.GF17184@pengutronix.de>
 <4d67387a86d99cbb4e2acf68d3588b1c.squirrel@www.codeaurora.org>
 <20120426095135.GG17184@pengutronix.de>
 <4F9EE84C.90106@codeaurora.org>
 <CAJOA=zNCagT6GaeHi_jq7-LU9P-SfJZ8PA9bo-oeswjC0tHyYA@mail.gmail.com>
 <4F9F1659.1010804@codeaurora.org>
 <20120501081103.GC2194@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120501081103.GC2194@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 04:11:05PM +0800, Shawn Guo wrote:
> On Mon, Apr 30, 2012 at 03:46:49PM -0700, Saravana Kannan wrote:
> > I'm still hoping a Ack/Nack for the general idea from the others.
> > 
> I believe that I have Acked the idea when you proposed it at the first
> time.  What I really hoped is you can post the patch at least 1 week
> earlier.  Basically I share the same frustration that Sascha has, the
> platform porting have been delayed by flowing changes on the core code.
> It's been -rc5, but we have not got a stable core base to have platform
> porting expose on linux-next.

Hi folks

I agree with you as well, it is frustrating. Could we agree, that once
this patch is in, we freeze the core until the start of the next
cycle. We use the remainder of this cycle for porting platforms to the
generic clock framework.

	  Andrew

