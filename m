Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645Ab2CJSBb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 13:01:31 -0500
Received: from londo.lunn.ch ([80.238.139.98]:59324 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172Ab2CJSBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 13:01:30 -0500
Date: Sat, 10 Mar 2012 19:01:21 +0100
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
        Jamie Iles <jamie@jamieiles.com>,
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
Subject: Re: [PATCH v6 3/3] clk: basic clock hardware types
Message-ID: <20120310180121.GL16608@lunn.ch>
Mail-Followup-To: Mike Turquette <mturquette@linaro.org>,
	Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
	patches@linaro.org, Mike Turquette <mturquette@ti.com>,
	Jeremy Kerr <jeremy.kerr@canonical.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Arnd Bergman <arnd.bergmann@linaro.org>,
	Paul Walmsley <paul@pwsan.com>, Shawn Guo <shawn.guo@freescale.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Jamie Iles <jamie@jamieiles.com>,
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
 <1331366064-1273-4-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331366064-1273-4-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 11:54:24PM -0800, Mike Turquette wrote:
> Many platforms support simple gateable clocks, fixed-rate clocks,
> adjustable divider clocks and multi-parent multiplexer clocks.

Hi Mike

Please feel free to add:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Andrew Lunn <andrew@lunn.ch>

	   Andrew
