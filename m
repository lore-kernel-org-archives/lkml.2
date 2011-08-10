Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab1HJOgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:36:40 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40710 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab1HJOgj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:36:39 -0400
MIME-Version: 1.0
In-Reply-To: <1312978689-18539-1-git-send-email-linus.walleij@stericsson.com>
References: <1312978689-18539-1-git-send-email-linus.walleij@stericsson.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 10 Aug 2011 22:36:19 +0800
Message-ID: <CAMPhdO9qsP4UrpkFzCy2jLey8ZxioMjuLbJAzT29y+RsBpGd-w@mail.gmail.com>
Subject: Re: [PATCH 14/19] plat-pxa: move PXA GPIO driver to GPIO subsystem
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 8:18 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>
> As per example from the other ARM boards, push the PXA
> GPIO driver down to the GPIO subsystem so it can be consolidated.
>
> Cc: Eric Miao <eric.y.miao@gmail.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

This one looks OK.

> ---
>  arch/arm/plat-pxa/Makefile                         |    1 -
>  drivers/gpio/Makefile                              |    1 +
>  .../arm/plat-pxa/gpio.c => drivers/gpio/gpio-pxa.c |    0
>  3 files changed, 1 insertions(+), 1 deletions(-)
>  rename arch/arm/plat-pxa/gpio.c => drivers/gpio/gpio-pxa.c (100%)
>
> diff --git a/arch/arm/plat-pxa/Makefile b/arch/arm/plat-pxa/Makefile
> index 3aca5ba..f302d04 100644
> --- a/arch/arm/plat-pxa/Makefile
> +++ b/arch/arm/plat-pxa/Makefile
> @@ -4,7 +4,6 @@
>
>  obj-y  := dma.o
>
> -obj-$(CONFIG_GENERIC_GPIO)     += gpio.o
>  obj-$(CONFIG_PXA3xx)           += mfp.o
>  obj-$(CONFIG_PXA95x)           += mfp.o
>  obj-$(CONFIG_ARCH_MMP)         += mfp.o
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index 33e095bd..6640e1d 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -40,6 +40,7 @@ obj-$(CONFIG_GPIO_PCA953X)    += gpio-pca953x.o
>  obj-$(CONFIG_GPIO_PCF857X)     += gpio-pcf857x.o
>  obj-$(CONFIG_GPIO_PCH)         += gpio-pch.o
>  obj-$(CONFIG_GPIO_PL061)       += gpio-pl061.o
> +obj-$(CONFIG_PLAT_PXA)         += gpio-pxa.o
>  obj-$(CONFIG_GPIO_RDC321X)     += gpio-rdc321x.o
>
>  obj-$(CONFIG_GPIO_PLAT_SAMSUNG)        += gpio-plat-samsung.o
> diff --git a/arch/arm/plat-pxa/gpio.c b/drivers/gpio/gpio-pxa.c
> similarity index 100%
> rename from arch/arm/plat-pxa/gpio.c
> rename to drivers/gpio/gpio-pxa.c
> --
> 1.7.3.2
>
>
