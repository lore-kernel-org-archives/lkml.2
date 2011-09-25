Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347Ab1IYECX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 00:02:23 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:50106 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab1IYECW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 00:02:22 -0400
Date: Sat, 24 Sep 2011 22:02:17 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Mike Turquette <mturquette@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, paul@pwsan.com, sboyd@quiinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, linux@arm.linux.org.uk, eric.miao@linaro.org,
        richard.zhao@linaro.org, Jamie Iles <jamie@jamieiles.com>
Subject: Re: [PATCH v2 4/7] clk: Add simple gated clock
Message-ID: <20110925040217.GO24631@ponder.secretlab.ca>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-5-git-send-email-mturquette@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316730422-20027-5-git-send-email-mturquette@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 03:26:59PM -0700, Mike Turquette wrote:
> From: Jeremy Kerr <jeremy.kerr@canonical.com>
> 
> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> Signed-off-by: Mike Turquette <mturquette@ti.com>
> ---
> Changes since v1:
> Add copyright header
> Fold in Jamie's patch for set-to-disable clks
> Use BIT macro instead of shift
> 
>  drivers/clk/Kconfig    |    4 ++
>  drivers/clk/Makefile   |    1 +
>  drivers/clk/clk-gate.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/clk.h    |   13 ++++++++
>  4 files changed, 96 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/clk/clk-gate.c
> 
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index d8313d7..a78967c 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -12,3 +12,7 @@ config GENERIC_CLK
>  config GENERIC_CLK_FIXED
>  	bool
>  	depends on GENERIC_CLK
> +
> +config GENERIC_CLK_GATE
> +	bool
> +	depends on GENERIC_CLK

I see zero documentation on what a "gated clock" is supposed to be or
how it works, and there are zero comments in the code.  It's kind of
hard to review that way, and even harder to use.

g.
