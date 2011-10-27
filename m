Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab1J0LyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 07:54:18 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50771 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab1J0LyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 07:54:16 -0400
Date: Thu, 27 Oct 2011 13:54:11 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: Mike Turquette <mturquette@ti.com>
Cc: jeremy.kerr@canonical.com, paul@pwsan.com, linaro-dev@lists.linaro.org,
        linus.walleij@stericsson.com, patches@linaro.org,
        broonie@opensource.wolfsonmicro.com, magnus.damm@gmail.com,
        linux-kernel@vger.kernel.org, eric.miao@linaro.org,
        grant.likely@secretlab.ca, dsaxena@linaro.org, tglx@linutronix.de,
        amit.kucheria@linaro.org, skannan@quicinc.com, linux@arm.linux.org.uk,
        arnd.bergmann@linaro.org, sboyd@quiinc.com, richard.zhao@linaro.org,
        shawn.guo@freescale.com, linux-arm-kernel@lists.infradead.org,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v2 1/7] clk: Add a generic clock infrastructure
Message-ID: <20111027115411.GA4713@glitch>
Mail-Followup-To: Mike Turquette <mturquette@ti.com>,
	jeremy.kerr@canonical.com, paul@pwsan.com,
	linaro-dev@lists.linaro.org, linus.walleij@stericsson.com,
	patches@linaro.org, broonie@opensource.wolfsonmicro.com,
	magnus.damm@gmail.com, linux-kernel@vger.kernel.org,
	eric.miao@linaro.org, grant.likely@secretlab.ca, dsaxena@linaro.org,
	tglx@linutronix.de, amit.kucheria@linaro.org, skannan@quicinc.com,
	linux@arm.linux.org.uk, arnd.bergmann@linaro.org, sboyd@quiinc.com,
	richard.zhao@linaro.org, shawn.guo@freescale.com,
	linux-arm-kernel@lists.infradead.org,
	Rob Herring <robherring2@gmail.com>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-2-git-send-email-mturquette@ti.com>
 <4E89C3FA.9020206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E89C3FA.9020206@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/22/2011 05:26 PM, Mike Turquette wrote:
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index 3530927..c53ed59 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -5,3 +5,6 @@ config CLKDEV_LOOKUP
>  
>  config HAVE_MACH_CLKDEV
>  	bool
> +
> +config GENERIC_CLK
> +	bool

Now that Russel's prepare/unprepare patch is mainlined, I think you
want to select HAVE_CLK_PREPARE here (and remove your prepare/unprepare
function declarations in clk.h).

Regards,
Domenico
