Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964831Ab1GOCxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 22:53:38 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64844 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964799Ab1GOCxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 22:53:35 -0400
Date: Thu, 14 Jul 2011 20:53:32 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Dajun Chen <dchen@diasemi.com>
Subject: Re: [PATCH] gpio: da9052: remove a redundant assignment for
 gpio->da9052
Message-ID: <20110715025332.GM2927@ponder.secretlab.ca>
References: <1310345618.2316.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310345618.2316.0.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 08:53:38AM +0800, Axel Lin wrote:
> We just set it twice in da9052_gpio_probe.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.

g.

> ---
>  drivers/gpio/gpio-da9052.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-da9052.c b/drivers/gpio/gpio-da9052.c
> index c23761f..038f5eb 100644
> --- a/drivers/gpio/gpio-da9052.c
> +++ b/drivers/gpio/gpio-da9052.c
> @@ -219,7 +219,6 @@ static int __devinit da9052_gpio_probe(struct platform_device *pdev)
>  	gpio->da9052 = dev_get_drvdata(pdev->dev.parent);
>  	pdata = gpio->da9052->dev->platform_data;
>  
> -	gpio->da9052 = dev_get_drvdata(pdev->dev.parent);
>  	gpio->gp = reference_gp;
>  	if (pdata && pdata->gpio_base)
>  		gpio->gp.base = pdata->gpio_base;
> -- 
> 1.7.4.1
> 
> 
> 
