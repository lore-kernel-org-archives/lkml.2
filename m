Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab2FTO1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 10:27:01 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:29984
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754576Ab2FTO1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 10:27:00 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1202hzz8275bhz2dh87h2a8h668h839h944hd25he96hf0ah)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 20 Jun 2012 22:26:45 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <marex@denx.de>, <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] clk: mxs: Fix the GPMI clock name
Message-ID: <20120620142643.GD2253@S2101-09.ap.freescale.net>
References: <1340137652-2227-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1340137652-2227-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 05:27:32PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> The correct name for the GPMI clock is 'gpmi-nand'.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Applied, thanks.

Regards,
Shawn

> ---
>  drivers/clk/mxs/clk-imx23.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/clk/mxs/clk-imx23.c b/drivers/clk/mxs/clk-imx23.c
> index f7be225..40ad638 100644
> --- a/drivers/clk/mxs/clk-imx23.c
> +++ b/drivers/clk/mxs/clk-imx23.c
> @@ -106,7 +106,7 @@ static struct clk_lookup lcdif_lookups[] __initdata = {
>  
>  static struct clk_lookup gpmi_lookups[] __initdata = {
>  	{ .dev_id = "imx23-gpmi-nand", },
> -	{ .dev_id = "8000c000.gpmi", },
> +	{ .dev_id = "8000c000.gpmi-nand", },
>  };
>  
>  static const char *sel_pll[]  __initconst = { "pll", "ref_xtal", };
> -- 
> 1.7.1
> 

