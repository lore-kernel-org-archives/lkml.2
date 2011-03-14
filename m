Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab1CNVjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 17:39:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48247 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020Ab1CNVjO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 17:39:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=e4qtCFo11dbUnSaxZmg2vyOzZ4+GaJzSCFmm4tgw9sJRri3RHWjIcAcLMTOm3omqt3
         zSjOsaO4Dc8/FAe5Il0q2ORlKQocwRXPtYgifhTuQhUo8rAgFEXPYqMTEKShdU9UFqFL
         JFW5N3XgXVTE3SFbYxREt+HgLRIpxFJtat+M4=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
Subject: Re: [PATCH] s3c_adc_battery: Fix method names when PM not set
Date: Mon, 14 Mar 2011 23:38:40 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37-gentoo-r1-anarsoul; KDE/4.6.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>
References: <201103142112.39392.heiko@sntech.de>
In-Reply-To: <201103142112.39392.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103142338.40584.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 March 2011 22:12:39 Heiko Stübner wrote:
> From: Heiko Stuebner <heiko@sntech.de>
> 
> s3c_adc_battery declares wrong method names when CONFIG_PM is not set.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Acked-by: Vasily Khoruzhick <anarsoul@gmail.com>
 
> ---
>  drivers/power/s3c_adc_battery.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/s3c_adc_battery.c
> b/drivers/power/s3c_adc_battery.c index 4255f23..d36c289 100644
> --- a/drivers/power/s3c_adc_battery.c
> +++ b/drivers/power/s3c_adc_battery.c
> @@ -406,8 +406,8 @@ static int s3c_adc_bat_resume(struct platform_device
> *pdev) return 0;
>  }
>  #else
> -#define s3c_adc_battery_suspend NULL
> -#define s3c_adc_battery_resume NULL
> +#define s3c_adc_bat_suspend NULL
> +#define s3c_adc_bat_resume NULL
>  #endif
> 
>  static struct platform_driver s3c_adc_bat_driver = {
