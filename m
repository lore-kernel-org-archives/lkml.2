Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab2FSVPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 17:15:25 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:44112 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab2FSVPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 17:15:24 -0400
From: Marek Vasut <marex@denx.de>
To: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH] clk: mxs: Fix the GPMI clock name
Date: Tue, 19 Jun 2012 23:13:07 +0200
User-Agent: KMail/1.13.7 (Linux/3.4-trunk-amd64; KDE/4.8.3; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        shawn.guo@linaro.org, kernel@pengutronix.de,
        Fabio Estevam <fabio.estevam@freescale.com>
References: <1340137652-2227-1-git-send-email-festevam@gmail.com>
In-Reply-To: <1340137652-2227-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201206192313.07458.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Fabio Estevam,

> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> The correct name for the GPMI clock is 'gpmi-nand'.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Marek Vasut <marex@denx.de>

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

Best regards,
Marek Vasut
