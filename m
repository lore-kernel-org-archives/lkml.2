Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab2LSUgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 15:36:18 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:50810 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab2LSUgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 15:36:05 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 3/3] gpio: twl4030: TODO comment to remove the PWMA/B (LEDA/B) handling
To: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
In-Reply-To: <1354791127-20545-4-git-send-email-peter.ujfalusi@ti.com>
References: <1354791127-20545-1-git-send-email-peter.ujfalusi@ti.com> <1354791127-20545-4-git-send-email-peter.ujfalusi@ti.com>
Date: Wed, 19 Dec 2012 17:07:37 +0000
Message-Id: <20121219170737.E5DB13E0C56@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2012 11:52:07 +0100, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> This GPIO driver should not configure anything else then GPIOs.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

I'm not sure if this is the right direction. I actually have no problem
with a single driver that registers itself with multiple interfaces (ie.
GPIO and PWM) if it makes sense for it to do so. I suspec that a lot of
the multifunction device drivers break things up more than is strictly
necessary.

I'll still apply this if you think it is the right direction, but I
wanted to throw that though out there for consideration.

g.

> ---
>  drivers/gpio/gpio-twl4030.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/gpio/gpio-twl4030.c b/drivers/gpio/gpio-twl4030.c
> index a38e6e9c..1e9f08c4 100644
> --- a/drivers/gpio/gpio-twl4030.c
> +++ b/drivers/gpio/gpio-twl4030.c
> @@ -47,6 +47,7 @@
>   * intended to support multiple hosts.
>   *
>   * There are also two LED pins used sometimes as output-only GPIOs.
> + * TODO: Handling of PWMA/B (LEDA/B) should be removed from this GPIO driver!
>   */
>  
>  /* genirq interfaces are not available to modules */
> @@ -131,6 +132,7 @@ static inline int gpio_twl4030_read(u8 address)
>  
>  /*----------------------------------------------------------------------*/
>  
> +/* TODO: Handling of PWMA/B (LEDA/B) should be removed from this GPIO driver! */
>  static u8 cached_leden;
>  
>  /* The LED lines are open drain outputs ... a FET pulls to GND, so an
> -- 
> 1.8.0
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
