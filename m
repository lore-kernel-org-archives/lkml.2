Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab0LIMBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 07:01:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:38570 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530Ab0LIMBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 07:01:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,319,1288594800"; 
   d="scan'208";a="866306091"
Date: Thu, 9 Dec 2010 13:01:41 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-geode@lists.infradead.org, linux-kernel@vger.kernel.org,
        cjb@laptop.org, dsd@laptop.org
Subject: Re: [PATCH] mfd/gpio/misc: add MODULE_ALIAS entries for CS5535
 functions
Message-ID: <20101209120140.GC8884@sortiz-mobl>
References: <20101201195510.3a50d8b6@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101201195510.3a50d8b6@queued.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

On Wed, Dec 01, 2010 at 07:55:10PM -0800, Andres Salomon wrote:
> 
> This adds MODULE_ALIAS entries to the various cs5535 subdevice modules; this
> allows the modules to automatically be loaded when cs5535-mfd loads.
Patch applied, thanks.

Cheers,
Samuel.


> Signed-off-by: Andres Salomon <dilinger@queued.net>
> ---
>  drivers/gpio/cs5535-gpio.c  |    1 +
>  drivers/misc/cs5535-mfgpt.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/cs5535-gpio.c b/drivers/gpio/cs5535-gpio.c
> index cc49687..90df6c5 100644
> --- a/drivers/gpio/cs5535-gpio.c
> +++ b/drivers/gpio/cs5535-gpio.c
> @@ -388,3 +388,4 @@ module_exit(cs5535_gpio_exit);
>  MODULE_AUTHOR("Andres Salomon <dilinger@queued.net>");
>  MODULE_DESCRIPTION("AMD CS5535/CS5536 GPIO driver");
>  MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:" DRV_NAME);
> diff --git a/drivers/misc/cs5535-mfgpt.c b/drivers/misc/cs5535-mfgpt.c
> index 499bd64..2669306 100644
> --- a/drivers/misc/cs5535-mfgpt.c
> +++ b/drivers/misc/cs5535-mfgpt.c
> @@ -349,3 +349,4 @@ module_init(cs5535_mfgpt_init);
>  MODULE_AUTHOR("Andres Salomon <dilinger@queued.net>");
>  MODULE_DESCRIPTION("CS5535/CS5536 MFGPT timer driver");
>  MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:" DRV_NAME);
> -- 
> 1.7.2.3
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
