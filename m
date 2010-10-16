Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab0JPSus (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 14:50:48 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:56736 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547Ab0JPSur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 14:50:47 -0400
Date: Sat, 16 Oct 2010 20:49:20 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, amit.kucheria@canonical.com,
        linux@arm.linux.org.uk, s.hauer@pengutronix.de,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org,
        daniel@caiaq.de, u.kleine-koenig@pengutronix.de,
        xiao-lizhang@freescale.com, valentin.longchamp@epfl.ch
Subject: Re: [PATCH 1/2] ARM: imx: Add wake functionality to GPIO
Message-ID: <20101016184919.GC6225@tarshish>
References: <1287173908-25758-1-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287173908-25758-1-git-send-email-Dinh.Nguyen@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dinh,

On Fri, Oct 15, 2010 at 03:18:27PM -0500, Dinh.Nguyen@freescale.com wrote:
> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> 
> Add function definition for irq_chip.set_wake to enable GPIO to
> wake-up the system.
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  arch/arm/plat-mxc/gpio.c              |   35 +++++++++++++++++++++++++++++++++
>  arch/arm/plat-mxc/include/mach/gpio.h |    3 ++
>  2 files changed, 38 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/plat-mxc/gpio.c b/arch/arm/plat-mxc/gpio.c
> index 57ec4a8..7647ba3 100644
> --- a/arch/arm/plat-mxc/gpio.c
> +++ b/arch/arm/plat-mxc/gpio.c

[snip]

> diff --git a/arch/arm/plat-mxc/include/mach/gpio.h 
> b/arch/arm/plat-mxc/include/mach/gpio.h
> index af33b74..dba3768 100644
> --- a/arch/arm/plat-mxc/include/mach/gpio.h
> +++ b/arch/arm/plat-mxc/include/mach/gpio.h
> @@ -39,6 +39,9 @@ struct mxc_gpio_port {
>  	struct gpio_chip chip;
>  	u32 both_edges;
>  	spinlock_t lock;
> +	u32 suspend_wakeup;
> +	u32 saved_wakeup;
> +

Unneeded blank line.

>  };
>  
>  int mxc_gpio_init(struct mxc_gpio_port*, int);

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
