Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032648Ab2CPIZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 04:25:22 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60044 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030462Ab2CPIZQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 04:25:16 -0400
MIME-Version: 1.0
In-Reply-To: <1331878280-2758-2-git-send-email-mturquette@linaro.org>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org>
	<1331878280-2758-2-git-send-email-mturquette@linaro.org>
Date: Fri, 16 Mar 2012 09:25:12 +0100
Message-ID: <CACRpkdbXq7zX_XrvAOJc7U6=T0Aaoq+U9_GmZS4fVmVd_arC7A@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] Documentation: common clk API
From: Linus Walleij <linus.walleij@linaro.org>
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
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 7:11 AM, Mike Turquette <mturquette@linaro.org> wrote:

> Provide documentation for the common clk structures and APIs.  This code
> can be found in drivers/clk/ and include/linux/clk*.h.

Acked-by: Linus Wallej <linus.walleij@linaro.org>
For this three-piece v7 patchset.

It already does magnitudes more advanced stuff than what I need
so I'm pretty pleased, any remaining details can surely be ironed out
in-tree.

Thanks,
Linus Walleij
