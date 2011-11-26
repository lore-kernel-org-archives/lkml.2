Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab1KZAjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 19:39:22 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:14017
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753937Ab1KZAjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 19:39:20 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Sat, 26 Nov 2011 08:51:30 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Mike Turquette <mturquette@ti.com>
CC: <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <jeremy.kerr@canonical.com>, <broonie@opensource.wolfsonmicro.com>,
        <tglx@linutronix.de>, <linus.walleij@stericsson.com>,
        <amit.kucheria@linaro.org>, <dsaxena@linaro.org>, <patches@linaro.org>,
        <linaro-dev@lists.linaro.org>, <aul@pwsan.com>,
        <grant.likely@secretlab.ca>, <sboyd@quicinc.com>,
        <skannan@quicinc.com>, <magnus.damm@gmail.com>,
        <arnd.bergmann@linaro.org>, <eric.miao@linaro.org>,
        <richard.zhao@linaro.org>, Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH v3 1/5] clk: Kconfig: add entry for HAVE_CLK_PREPARE
Message-ID: <20111126005128.GA19025@S2100-06.ap.freescale.net>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
 <1321926047-14211-2-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1321926047-14211-2-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 05:40:43PM -0800, Mike Turquette wrote:
> The common clk framework provides clk_prepare and clk_unprepare
> implementations.  Create an entry for HAVE_CLK_PREPARE so that
> GENERIC_CLK can select it.
> 
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> ---

Acked-by: Shawn Guo <shawn.guo@linaro.org>

Regards,
Shawn

>  drivers/clk/Kconfig |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index 3530927..7a9899bd 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -5,3 +5,6 @@ config CLKDEV_LOOKUP
>  
>  config HAVE_MACH_CLKDEV
>  	bool
> +
> +config HAVE_CLK_PREPARE
> +	bool
> -- 
> 1.7.4.1

