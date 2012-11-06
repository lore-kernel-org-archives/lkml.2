Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab2KFA2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 19:28:32 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40830 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2KFA2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 19:28:31 -0500
MIME-Version: 1.0
In-Reply-To: <1352123068.14769.6.camel@phoenix>
References: <1352123068.14769.6.camel@phoenix>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 6 Nov 2012 08:28:09 +0800
Message-ID: <CAGsJ_4wZVAE49fqpZz-+YSZQK0ZDS=ANtDgg3vJhj5vEL95v-A@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: sirf: Staticize non-exported symbol
To: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Barry Song <baohua.song@csr.com>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/5 Axel Lin <axel.lin@ingics.com>:
> Staticize sirfsoc_gpio_irq_map() function.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Barry Song <Baohua.Song@csr.com>

> ---
>  drivers/pinctrl/pinctrl-sirf.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/pinctrl/pinctrl-sirf.c b/drivers/pinctrl/pinctrl-sirf.c
> index 9ecacf3..e3b2c53 100644
> --- a/drivers/pinctrl/pinctrl-sirf.c
> +++ b/drivers/pinctrl/pinctrl-sirf.c
> @@ -1621,8 +1621,8 @@ static void sirfsoc_gpio_set_value(struct gpio_chip *chip, unsigned offset,
>         spin_unlock_irqrestore(&bank->lock, flags);
>  }
>
> -int sirfsoc_gpio_irq_map(struct irq_domain *d, unsigned int irq,
> -       irq_hw_number_t hwirq)
> +static int sirfsoc_gpio_irq_map(struct irq_domain *d, unsigned int irq,
> +                               irq_hw_number_t hwirq)
>  {
>         struct sirfsoc_gpio_bank *bank = d->host_data;
>
> --
> 1.7.9.5
>
-barry
