Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab1HRKWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 06:22:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57724 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab1HRKWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 06:22:13 -0400
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Ian <ian@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] Added #include of module.h to s3c_adc_battery.c
Date: Thu, 18 Aug 2011 13:21:10 +0300
User-Agent: KMail/1.13.7 (Linux/3.0.1-gentoo-anarsoul; KDE/4.6.3; i686; ; )
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, u.kleine-koenig@pengutronix.de,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
References: <1313662449.18176.18.camel@Tapajos>
In-Reply-To: <1313662449.18176.18.camel@Tapajos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108181321.11293.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 August 2011 13:14:09 Ian wrote:
> s3c_adc_battery.c will not compile without moule.h as it contains the
> definitions of: MODULE_AUTHOR, MODULE_DESCRIPTION & MODULE_LICENSE.

I've already sent pretty same patch a ~week ago, here it is:
https://patchwork.kernel.org/patch/1061302/

Regards
Vasily

> 
> Signed-off-by: Ian Lartey <ian@opensource.wolfsonmicro.com>
> ---
>  drivers/power/s3c_adc_battery.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/s3c_adc_battery.c
> b/drivers/power/s3c_adc_battery.c index a675e31..20770ba 100644
> --- a/drivers/power/s3c_adc_battery.c
> +++ b/drivers/power/s3c_adc_battery.c
> @@ -9,6 +9,7 @@
>   *
>   */
> 
> +#include <linux/module.h>
>  #include <linux/interrupt.h>
>  #include <linux/platform_device.h>
>  #include <linux/power_supply.h>
