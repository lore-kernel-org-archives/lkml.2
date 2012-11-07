Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab2KGNfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 08:35:19 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:56057 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab2KGNfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 08:35:05 -0500
MIME-Version: 1.0
In-Reply-To: <1352215711.3692.1.camel@phoenix>
References: <1352215711.3692.1.camel@phoenix>
Date: Wed, 7 Nov 2012 22:35:04 +0900
X-Google-Sender-Auth: qgKib4XKd4AtFk-h1wpxE5FjZYc
Message-ID: <CAH9JG2UKuuxg+GdaXNuiOZQDr2mbrbXDzFrxuj8jkTP3QRO+5g@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: samsung: Remove a redundant settting for ctrldesc->npins
From: Kyungmin Park <kmpark@infradead.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

On Wed, Nov 7, 2012 at 12:28 AM, Axel Lin <axel.lin@ingics.com> wrote:
> Set it once is enough.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/pinctrl/pinctrl-samsung.c |    1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
> index fc34cac..1307283 100644
> --- a/drivers/pinctrl/pinctrl-samsung.c
> +++ b/drivers/pinctrl/pinctrl-samsung.c
> @@ -714,7 +714,6 @@ static int __devinit samsung_pinctrl_register(struct platform_device *pdev,
>         }
>         ctrldesc->pins = pindesc;
>         ctrldesc->npins = drvdata->ctrl->nr_pins;
> -       ctrldesc->npins = drvdata->ctrl->nr_pins;
>
>         /* dynamically populate the pin number and pin name for pindesc */
>         for (pin = 0, pdesc = pindesc; pin < ctrldesc->npins; pin++, pdesc++)
> --
> 1.7.9.5
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
