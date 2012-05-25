Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab2EZNME (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:12:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34164 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab2EZNMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:12:03 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v4 1/6] gpio: fix a typo of comment message
To: Dong Aisheng <b29396@freescale.com>, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com,
        swarren@wwwdotorg.org, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com, b29396@freescale.com
In-Reply-To: <1337952980-14621-1-git-send-email-b29396@freescale.com>
References: <1337952980-14621-1-git-send-email-b29396@freescale.com>
Date: Fri, 25 May 2012 17:57:15 -0600
Message-Id: <20120525235715.CE8223E0C7F@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2012 21:36:15 +0800, Dong Aisheng <b29396@freescale.com> wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

Applied, thanks.

g.

> ---
>  drivers/gpio/gpiolib-of.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
> index d18068a..8389d4a 100644
> --- a/drivers/gpio/gpiolib-of.c
> +++ b/drivers/gpio/gpiolib-of.c
> @@ -21,7 +21,7 @@
>  #include <linux/of_gpio.h>
>  #include <linux/slab.h>
>  
> -/* Private data structure for of_gpiochip_is_match */
> +/* Private data structure for of_gpiochip_find_and_xlate */
>  struct gg_data {
>  	enum of_gpio_flags *flags;
>  	struct of_phandle_args gpiospec;
> -- 
> 1.7.0.4
> 
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
