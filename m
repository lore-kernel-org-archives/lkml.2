Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149Ab2CIRA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:00:26 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:47788 "EHLO
	new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754557Ab2CIRAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:00:24 -0500
X-Sasl-enc: Me6PfWf8WgtW/NAfk2IQzGdfxhXXQHCZNZ2oB/7gCOmD 1331312423
Message-ID: <4F5A3726.8030505@signal11.us>
Date: Fri, 09 Mar 2012 12:00:22 -0500
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Alan Ott <alan@signal11.us>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] ARM: tegra: export tegra_gpio_{en,dis}able
References: <1330630010-11241-2-git-send-email-alan@signal11.us> <1330727544-11617-1-git-send-email-alan@signal11.us>
In-Reply-To: <1330727544-11617-1-git-send-email-alan@signal11.us>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2012 05:32 PM, Alan Ott wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> These two functions are used in drivers that can be
> modules, so they need to be exported.
>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> Acked-by: Olof Johansson <olof@lixom.net>
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Alan Ott <alan@signal11.us>
> ---
>  drivers/gpio/gpio-tegra.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
> index bdc2937..96662cc 100644
> --- a/drivers/gpio/gpio-tegra.c
> +++ b/drivers/gpio/gpio-tegra.c
> @@ -107,11 +107,13 @@ void tegra_gpio_enable(int gpio)
>  {
>  	tegra_gpio_mask_write(GPIO_MSK_CNF(gpio), gpio, 1);
>  }
> +EXPORT_SYMBOL_GPL(tegra_gpio_enable);
>  
>  void tegra_gpio_disable(int gpio)
>  {
>  	tegra_gpio_mask_write(GPIO_MSK_CNF(gpio), gpio, 0);
>  }
> +EXPORT_SYMBOL_GPL(tegra_gpio_disable);
>  
>  static void tegra_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
>  {

Did this patch ever get picked up into someone's tree?

Alan.

