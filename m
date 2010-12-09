Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab0LIPmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:42:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:21506 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab0LIPmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:42:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,320,1288594800"; 
   d="scan'208";a="582146350"
Date: Thu, 9 Dec 2010 16:41:56 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sundar Iyer <sundar.iyer@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, dmitry.torokhov@gmail.com,
        ben-linux@fluff.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/20] mfd/tc35892: rename tc35892 header to tc3589x
Message-ID: <20101209154155.GR8884@sortiz-mobl>
References: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
 <1291388753-14662-7-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291388753-14662-7-git-send-email-sundar.iyer@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sundar,

On Fri, Dec 03, 2010 at 08:35:39PM +0530, Sundar Iyer wrote:
> Rename the header file to include further variants within
> the same mfd core driver

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

> Signed-off-by: Sundar Iyer <sundar.iyer@stericsson.com>
> ---
>  drivers/gpio/tc35892-gpio.c                |    2 +-
>  drivers/mfd/tc35892.c                      |    2 +-
>  include/linux/mfd/{tc35892.h => tc3589x.h} |    0
>  3 files changed, 2 insertions(+), 2 deletions(-)
>  rename include/linux/mfd/{tc35892.h => tc3589x.h} (100%)
> 
> diff --git a/drivers/gpio/tc35892-gpio.c b/drivers/gpio/tc35892-gpio.c
> index 7e10c93..027b857 100644
> --- a/drivers/gpio/tc35892-gpio.c
> +++ b/drivers/gpio/tc35892-gpio.c
> @@ -13,7 +13,7 @@
>  #include <linux/gpio.h>
>  #include <linux/irq.h>
>  #include <linux/interrupt.h>
> -#include <linux/mfd/tc35892.h>
> +#include <linux/mfd/tc3589x.h>
>  
>  /*
>   * These registers are modified under the irq bus lock and cached to avoid
> diff --git a/drivers/mfd/tc35892.c b/drivers/mfd/tc35892.c
> index e619e2a..f230235 100644
> --- a/drivers/mfd/tc35892.c
> +++ b/drivers/mfd/tc35892.c
> @@ -12,7 +12,7 @@
>  #include <linux/slab.h>
>  #include <linux/i2c.h>
>  #include <linux/mfd/core.h>
> -#include <linux/mfd/tc35892.h>
> +#include <linux/mfd/tc3589x.h>
>  
>  /**
>   * tc35892_reg_read() - read a single TC35892 register
> diff --git a/include/linux/mfd/tc35892.h b/include/linux/mfd/tc3589x.h
> similarity index 100%
> rename from include/linux/mfd/tc35892.h
> rename to include/linux/mfd/tc3589x.h
> -- 
> 1.7.2.dirty
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
