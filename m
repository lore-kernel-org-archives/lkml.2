Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760461Ab2CMKix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 06:38:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43025 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759976Ab2CMKiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 06:38:52 -0400
Date: Tue, 13 Mar 2012 11:38:29 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Matt Sealey <matt@genesi-usa.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        linaro-dev@lists.linaro.org, Saravana Kannan <skannan@codeaurora.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergman <arnd.bergmann@linaro.org>, patches@linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/3] clk: basic clock hardware types
Message-ID: <20120313103829.GR3852@pengutronix.de>
References: <1331366064-1273-1-git-send-email-mturquette@linaro.org>
 <1331366064-1273-4-git-send-email-mturquette@linaro.org>
 <CAKGA1b=huAnG6tLoaGqoFoJnuEg-+rs8KLYVB1KF6_q73ot63A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKGA1b=huAnG6tLoaGqoFoJnuEg-+rs8KLYVB1KF6_q73ot63A@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:37:08 up 121 days, 18:24, 68 users,  load average: 0.00, 0.67,
 0.85
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 10:50:09PM -0500, Matt Sealey wrote:
> Hi Mike,
> 
> Can I suggest/we discuss that we support fractional (i.e. represented
> by fixed point value with integer and fractional part) dividers in the
> common divider clock case, simplistically just adding a divider
> fractional width and shifting all the calculations by it (and fixing
> the "maxdiv" calculation as in a fractional case width of the divider
> area in the register is not an indicator of the actual maximum
> divider)? (I guess for the standard integer divider case, it would be
> continually shifting by 0 which might make the code a bit bigger, I
> don't think that would truly be a concern though?)

I have patches for this, see

git://git.pengutronix.de/git/imx/linux-2.6.git imx/work/imx-clkv6

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
