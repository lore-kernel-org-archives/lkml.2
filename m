Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530Ab2EPHad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:30:33 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:57244 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759223Ab2EPHab convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:30:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAJOA=zNVQUDbHQCgnQ56S50fva2eKUXAH9aVkTbtyvQW+fq9SA@mail.gmail.com>
References: <1336798797-8724-1-git-send-email-skannan@codeaurora.org>
	<CAJOA=zNVQUDbHQCgnQ56S50fva2eKUXAH9aVkTbtyvQW+fq9SA@mail.gmail.com>
Date: Wed, 16 May 2012 09:30:30 +0200
Message-ID: <CACRpkda94B1JDC0T8eafBkHDg8JFy19OAH3NgGZRBLA28i9iRQ@mail.gmail.com>
Subject: Re: [PATCH] clk: Fix race conditions between clk_set_parent() and clk_enable()
From: Linus Walleij <linus.walleij@linaro.org>
To: "Turquette, Mike" <mturquette@ti.com>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Paul Walmsley <paul@pwsan.com>, Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 8:00 AM, Turquette, Mike <mturquette@ti.com> wrote:

> The above hunk is a good change since it fixes a bug where we
> prepare/enable the parent clocks around the .set_parent callback, even
> when CLK_SET_PARENT_GATE is set.  It should be a separate patch.

This makes me think that maybe some of these clk fixes really
need to add Cc: stable@kernel.org so they get into 3.4 as well.

Not that there are plenty of in-kernel users, but since people may
be basing development off the 3.4 tree, it would be good to have
fixes propagate there.

Linus Walleij
