Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab2CUTde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 15:33:34 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:32478 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab2CUTdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 15:33:31 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+TAhg5OGbJ04+NQsDrBUMf
Date: Wed, 21 Mar 2012 12:33:04 -0700
From: Tony Lindgren <tony@atomide.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Saravana Kannan <skannan@codeaurora.org>, Paul Walmsley <paul@pwsan.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Mike Turquette <mturquette@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, patches@linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/3] Documentation: common clk API
Message-ID: <20120321193304.GO9859@atomide.com>
References: <4F6A2042.9030302@codeaurora.org>
 <20120321190741.GL3226@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120321190741.GL3226@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mark Brown <broonie@opensource.wolfsonmicro.com> [120321 12:11]:
> On Wed, Mar 21, 2012 at 11:38:58AM -0700, Saravana Kannan wrote:
> 
> > >So it would be interesting to know more about why you (or anyone else)
> > >perceive that the Kconfig changes would be harmful.
> 
> > But the enthusiasm of the clock driver developers doesn't
> > necessarily translate to users of the clock APIs (other driver
> > devs). My worry with marking it as experimental in Kconfig and to a
> > certain extent in the documentation is that it will discourage the
> > driver devs from switching to the new APIs. If no one is using the
> > new APIs, then platforms can't switch to the common clock framework
> 
> These aren't new APIs, the clock API has been around since forever.
> For driver authors working on anything that isn't platform specific the
> issue has been that it's not implemented at all on the overwhelming
> majority of architectures and those that do all have their own random
> implementations with their own random quirks and with no ability for
> anything except the platform to even try to do incredibly basic stuff
> like register a new clock.
> 
> Simply having something, anything, in place even if it's going to churn
> is a massive step forward here for people working with clocks.

Right, and now at least the people reading this thread are pretty
aware of the yet unsolved issues with clock fwk api :)

Regards,

Tony
