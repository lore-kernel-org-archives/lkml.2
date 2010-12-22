Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab0LVAEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 19:04:31 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:63483 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab0LVAEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 19:04:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XXAE5REORsiuWwC018pGwFUx/H7Ru7m+S3FMUcy8/qwYal8BojwfVzATb7DAa8VNgW
         Q+oCbvrf6F/XWaqUhcSRxSKcWeJkzfVFHG2XPm9K+CUQ+uUtJxG58dIbT6a3IxR59hKx
         VvsEqZ3lqVxLFDUnX/Sn036Wn0WR3YSLoDb5s=
Date: Wed, 22 Dec 2010 03:04:26 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] POWER: gpio-chager: Provide default name for the
 power_supply
Message-ID: <20101222000426.GA24834@oksana.dev.rtsoft.ru>
References: <1290118119-16468-1-git-send-email-lars@metafoo.de>
 <1290118119-16468-3-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1290118119-16468-3-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 11:08:39PM +0100, Lars-Peter Clausen wrote:
> This patch sets a default name for the power_supply in case there was no name
> supplied through the platform_data.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---

Applied, thanks!

>  drivers/power/gpio-charger.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
> index 016d5c0..27b8520 100644
> --- a/drivers/power/gpio-charger.c
> +++ b/drivers/power/gpio-charger.c
> @@ -94,7 +94,7 @@ static int __devinit gpio_charger_probe(struct platform_device *pdev)
>  
>  	charger = &gpio_charger->charger;
>  
> -	charger->name = pdata->name;
> +	charger->name = pdata->name ?: "gpio-charger";
>  	charger->type = pdata->type;
>  	charger->properties = gpio_charger_properties;
>  	charger->num_properties = ARRAY_SIZE(gpio_charger_properties);
