Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063Ab0HEVO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 17:14:26 -0400
Received: from fep28.mx.upcmail.net ([62.179.121.48]:62440 "EHLO
	fep28.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab0HEVOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 17:14:23 -0400
X-Greylist: delayed 982 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Aug 2010 17:14:22 EDT
X-SourceIP: 62.24.72.246
From: Pavel Pisa <ppisa4lists@pikron.com>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 10/42] drivers/mmc/host: Adjust confusing if indentation
Date: Thu, 5 Aug 2010 22:57:53 +0200
User-Agent: KMail/1.9.9
Cc: Julia Lawall <julia@diku.dk>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.1008052219360.31692@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1008052219360.31692@ask.diku.dk>
Organization: PiKRON Ltd.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008052257.54039.ppisa4lists@pikron.com>
X-Cloudmark-Analysis: v=1.1 cv=K3uBg944YaUT+Qsu6bWO0a0V3uPy4DQNslbdoMCD4tw= c=1 sm=0 a=_QxRSBM50n4A:10 a=8nJEP1OIZ-IA:10 a=JfrnYn6hAAAA:8 a=Hq8N7MYxAAAA:8 a=_DdsVZnbAAAA:8 a=sfedO3ta4UrCDlHuVnoA:9 a=9xGzteWa772asJB_t_sUAsJGnWwA:4 a=wPNLvfGTeEIA:10 a=KAyHu9oVlqoA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 August 2010 22:19:52 Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
...
> Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>

Good catch.

> ---
>  drivers/mmc/host/imxmmc.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/imxmmc.c b/drivers/mmc/host/imxmmc.c
> index 9a68ff4..5a950b1 100644
> --- a/drivers/mmc/host/imxmmc.c
> +++ b/drivers/mmc/host/imxmmc.c
> @@ -148,11 +148,12 @@ static int imxmci_start_clock(struct imxmci_host
> *host)
>
>  		while (delay--) {
>  			reg = readw(host->base + MMC_REG_STATUS);
> -			if (reg & STATUS_CARD_BUS_CLK_RUN)
> +			if (reg & STATUS_CARD_BUS_CLK_RUN) {
>  				/* Check twice before cut */
>  				reg = readw(host->base + MMC_REG_STATUS);
>  				if (reg & STATUS_CARD_BUS_CLK_RUN)
>  					return 0;
> +			}
>
>  			if (test_bit(IMXMCI_PEND_STARTED_b, &host->pending_events))
>  				return 0;
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

--
                Pavel Pisa
    e-mail:     pisa@cmp.felk.cvut.cz
    www:        http://cmp.felk.cvut.cz/~pisa
    university: http://dce.fel.cvut.cz/
    company:    http://www.pikron.com/
