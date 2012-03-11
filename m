Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab2CKVDZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 17:03:25 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:44352 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751447Ab2CKVDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 17:03:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120311075250.GB3138@richard-laptop>
References: <1331366064-1273-1-git-send-email-mturquette@linaro.org>
 <1331366064-1273-3-git-send-email-mturquette@linaro.org> <20120311075250.GB3138@richard-laptop>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Sun, 11 Mar 2012 14:02:53 -0700
Message-ID: <CAJOA=zPzCSBHEynvm1hf-5VqdevAg26KQ2PZ5yykZqmxFywZpw@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] clk: introduce the common clock framework
To: Richard Zhao <richard.zhao@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Paul Walmsley <paul@pwsan.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Saravana Kannan <skannan@codeaurora.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>, Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 11:52 PM, Richard Zhao <richard.zhao@linaro.org> wrote:
> Looks like you didn't take my comments for v5.
> http://www.spinics.net/lists/arm-kernel/msg162903.html

Sorry Richard, that one slipped through the cracks.  I'll publish a
new version tomorrow with some of those fixes.  Some of the others
(such as multiple pre-rate change notifiers) I won't take in, but we
can discuss more.

Regards,
Mike

>
> Regards
> Richard
