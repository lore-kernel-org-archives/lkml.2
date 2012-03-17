Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab2CQD2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 23:28:05 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8320 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2CQD2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 23:28:02 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6651"; a="171028709"
Message-ID: <4F6404C2.7000506@codeaurora.org>
Date: Fri, 16 Mar 2012 20:28:02 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>, patches@linaro.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Richard Zhao <richard.zhao@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, linaro-dev@lists.linaro.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [PATCH v7 2/3] clk: introduce the common clock framework
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org> <1331878280-2758-3-git-send-email-mturquette@linaro.org>
In-Reply-To: <1331878280-2758-3-git-send-email-mturquette@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2012 11:11 PM, Mike Turquette wrote:
> The common clock framework defines a common struct clk useful across
> most platforms as well as an implementation of the clk api that drivers
> can use safely for managing clocks.
>
> The net result is consolidation of many different struct clk definitions
> and platform-specific clock framework implementations.
>
> This patch introduces the common struct clk, struct clk_ops and an
> implementation of the well-known clock api in include/clk/clk.h.
> Platforms may define their own hardware-specific clock structure and
> their own clock operation callbacks, so long as it wraps an instance of
> struct clk_hw.
>
> See Documentation/clk.txt for more details.
>
> This patch is based on the work of Jeremy Kerr, which in turn was based
> on the work of Ben Herrenschmidt.
>
> Signed-off-by: Mike Turquette<mturquette@linaro.org>
> Signed-off-by: Mike Turquette<mturquette@ti.com>
> Reviewed-by: Thomas Gleixner<tglx@linutronix.de>
> Tested-by: Andrew Lunn<andrew@lunn.ch>
> Reviewed-by: Rob Herring<rob.herring<at>  calxeda.com>
> Cc: Russell King<linux@arm.linux.org.uk>
> Cc: Jeremy Kerr<jeremy.kerr@canonical.com>
> Cc: Arnd Bergman<arnd.bergmann@linaro.org>
> Cc: Paul Walmsley<paul@pwsan.com>
> Cc: Shawn Guo<shawn.guo@freescale.com>
> Cc: Sascha Hauer<s.hauer@pengutronix.de>
> Cc: Richard Zhao<richard.zhao@linaro.org>
> Cc: Saravana Kannan<skannan@codeaurora.org>
> Cc: Magnus Damm<magnus.damm@gmail.com>
> Cc: Mark Brown<broonie@opensource.wolfsonmicro.com>
> Cc: Linus Walleij<linus.walleij@stericsson.com>
> Cc: Stephen Boyd<sboyd@codeaurora.org>
> Cc: Amit Kucheria<amit.kucheria@linaro.org>
> Cc: Deepak Saxena<dsaxena@linaro.org>
> Cc: Grant Likely<grant.likely@secretlab.ca>
> ---

Mike,

Thanks for the patches! Glad to see that it's finally getting in! I sent 
a request for a minor change as a reply to the v5 series (since it had 
more context). Can you please take a look at that and let me know if you 
can send out a v8 or a patch on top of this to do that?

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
