Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab0INXU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 19:20:56 -0400
Received: from trinity.fluff.org ([89.16.178.74]:53528 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755830Ab0INXUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 19:20:55 -0400
Date: Wed, 15 Sep 2010 00:20:26 +0100
From: Ben Dooks <ben-i2c@fluff.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Tejun Heo <tj@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] I2C-GPIO: Don't include the asm/gpio.h directly
Message-ID: <20100914232026.GB7494@trinity.fluff.org>
References: <20100914073053.GA15611@july>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100914073053.GA15611@july>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 04:30:53PM +0900, Kyungmin Park wrote:
> Don't include asm/gpio.h directly. Use the linux/gpio.h.
> 
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

will merge this, unless Jean wants to do it, at the next merge window.

> ---
> diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
> index d9aa9a6..0c1cc37 100644
> --- a/drivers/i2c/busses/i2c-gpio.c
> +++ b/drivers/i2c/busses/i2c-gpio.c
> @@ -15,7 +15,7 @@
>  #include <linux/slab.h>
>  #include <linux/platform_device.h>
>  
> -#include <asm/gpio.h>
> +#include <linux/gpio.h>
>  
>  /* Toggle SDA by changing the direction of the pin */
>  static void i2c_gpio_setsda_dir(void *data, int state)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

