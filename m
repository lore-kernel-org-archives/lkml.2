Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab2CJRvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 12:51:21 -0500
Received: from londo.lunn.ch ([80.238.139.98]:59299 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab2CJRvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 12:51:20 -0500
Date: Sat, 10 Mar 2012 18:51:13 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Mike Turquette <mturquette@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Mike Turquette <mturquette@ti.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Paul Walmsley <paul@pwsan.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v6 2/3] clk: introduce the common clock framework
Message-ID: <20120310175113.GK16608@lunn.ch>
Mail-Followup-To: Mike Turquette <mturquette@linaro.org>,
	Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
	patches@linaro.org, Mike Turquette <mturquette@ti.com>,
	Jeremy Kerr <jeremy.kerr@canonical.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Arnd Bergman <arnd.bergmann@linaro.org>,
	Paul Walmsley <paul@pwsan.com>, Shawn Guo <shawn.guo@freescale.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Richard Zhao <richard.zhao@linaro.org>,
	Saravana Kannan <skannan@codeaurora.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Linus Walleij <linus.walleij@stericsson.com>,
	Stephen Boyd <sboyd@codeaurora.org>,
	Amit Kucheria <amit.kucheria@linaro.org>,
	Deepak Saxena <dsaxena@linaro.org>,
	Grant Likely <grant.likely@secretlab.ca>,
	Andrew Lunn <andrew@lunn.ch>
References: <1331366064-1273-1-git-send-email-mturquette@linaro.org>
 <1331366064-1273-3-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331366064-1273-3-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 11:54:23PM -0800, Mike Turquette wrote:
> The common clock framework defines a common struct clk useful across
> most platforms as well as an implementation of the clk api that drivers
> can use safely for managing clocks.

Hi Mike

Please feel free to add:

Tested-by: Andrew Lunn <andrew@lunn.ch>

	   Andrew
