Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438Ab2GAOIl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 10:08:41 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:9492 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932402Ab2GAOIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 10:08:40 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1202hzz8275bh8275dhz2dh87h2a8h668h839h944hd25he96hf0ah)
X-FB-DOMAIN-IP-MATCH: fail
Date: Sun, 1 Jul 2012 22:09:16 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] pwm: pwm-mxs: Return proper error if
 pwmchip_remove() fails
Message-ID: <20120701140914.GB21595@S2101-09.ap.freescale.net>
References: <1341118620.8998.1.camel@phoenix>
 <1341118680.8998.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1341118680.8998.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2012 at 12:58:00PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> ---
>  drivers/pwm/pwm-mxs.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/pwm/pwm-mxs.c b/drivers/pwm/pwm-mxs.c
> index 269d7c2..e585264 100644
> --- a/drivers/pwm/pwm-mxs.c
> +++ b/drivers/pwm/pwm-mxs.c
> @@ -178,9 +178,7 @@ static int __devexit mxs_pwm_remove(struct platform_device *pdev)
>  {
>  	struct mxs_pwm_chip *mxs = platform_get_drvdata(pdev);
>  
> -	pwmchip_remove(&mxs->chip);
> -
> -	return 0;
> +	return pwmchip_remove(&mxs->chip);
>  }
>  
>  static struct of_device_id mxs_pwm_dt_ids[] = {
> -- 
> 1.7.9.5
> 
> 
> 

