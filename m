Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab2LJKNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:13:10 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53277 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab2LJKNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:13:07 -0500
MIME-Version: 1.0
In-Reply-To: <1355103317.4166.1.camel@phoenix>
References: <1355103317.4166.1.camel@phoenix>
Date: Mon, 10 Dec 2012 11:13:06 +0100
Message-ID: <CACRpkdY=yoYi71MLC=7iktFMTTQWmk4iLwrKqOnuuJEz43K74g@mail.gmail.com>
Subject: Re: [PATCH] gpio: samsung: Add terminating entry for exynos_pinctrl_ids
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 2:35 AM, Axel Lin <axel.lin@ingics.com> wrote:

> The of_device_id table is supposed to be zero-terminated.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/gpio/gpio-samsung.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
> index 01f7fe9..9e251be 100644
> --- a/drivers/gpio/gpio-samsung.c
> +++ b/drivers/gpio/gpio-samsung.c
> @@ -3026,6 +3026,7 @@ static __init int samsung_gpiolib_init(void)
>         static const struct of_device_id exynos_pinctrl_ids[] = {
>                 { .compatible = "samsung,pinctrl-exynos4210", },
>                 { .compatible = "samsung,pinctrl-exynos4x12", },
> +               { }

Wasn't somebody complaining that this was unnecessary recently?

Ohwell, I'll let the Samsung people comment first...

Yours,
Linus Walleij
