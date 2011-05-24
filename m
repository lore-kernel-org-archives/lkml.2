Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab1EXLgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 07:36:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43446 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab1EXLgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 07:36:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=qNBg8Ks/jzUn/aVXSpbm6BI8PRJ0Uc3S4loM6yQaR2WJJxwtEdI+evAu/MublwLD3L
         bAJkIeLwSGm+R73KyU+g2huiMsY8bXo/XfR4h+DpdmqOw9jrcmNNcVm7ummyr02Q0vbG
         68LgQpAZ84wTOO1wezgX1EN6aTEMlxouKxk5s=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] power_supply: Fix annotation for s3c_adc_battery_probe()
Date: Tue, 24 May 2011 14:36:00 +0300
User-Agent: KMail/1.13.6 (Linux/2.6.38-gentoo-r5-anarsoul; KDE/4.6.2; i686; ; )
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org
References: <1306233962-7283-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1306233962-7283-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105241436.01179.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 May 2011 13:46:02 Mark Brown wrote:
> A probe() function is used at device init time rather than system init
> time.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Vasily Khoruzhick <anarsoul@gmail.com>

> ---
>  drivers/power/s3c_adc_battery.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/s3c_adc_battery.c
> b/drivers/power/s3c_adc_battery.c index d36c289..a675e31 100644
> --- a/drivers/power/s3c_adc_battery.c
> +++ b/drivers/power/s3c_adc_battery.c
> @@ -266,7 +266,7 @@ static irqreturn_t s3c_adc_bat_charged(int irq, void
> *dev_id) return IRQ_HANDLED;
>  }
> 
> -static int __init s3c_adc_bat_probe(struct platform_device *pdev)
> +static int __devinit s3c_adc_bat_probe(struct platform_device *pdev)
>  {
>  	struct s3c_adc_client	*client;
>  	struct s3c_adc_bat_pdata *pdata = pdev->dev.platform_data;
