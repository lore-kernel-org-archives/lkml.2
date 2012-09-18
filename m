Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105Ab2IRHF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 03:05:27 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64358 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab2IRHF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 03:05:26 -0400
MIME-Version: 1.0
In-Reply-To: <1347951240-11548-1-git-send-email-richard.zhao@freescale.com>
References: <1347951240-11548-1-git-send-email-richard.zhao@freescale.com>
Date: Tue, 18 Sep 2012 15:05:25 +0800
Message-ID: <CAP1dx+z2GGen00meRVge7J+s32mfN8fqawGZJSjq9XkszesR5Q@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: imx: remove duplicated const
From: Dong Aisheng <dong.aisheng@linaro.org>
To: Richard Zhao <richard.zhao@freescale.com>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        shawn.guo@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 September 2012 14:54, Richard Zhao <richard.zhao@freescale.com> wrote:
> fix smatch warning:
> drivers/pinctrl/pinctrl-imx.c:435:21: warning: duplicate const
>
> Signed-off-by: Richard Zhao <richard.zhao@freescale.com>
> ---
>  drivers/pinctrl/pinctrl-imx.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
> index a13b888..b3c994a 100644
> --- a/drivers/pinctrl/pinctrl-imx.c
> +++ b/drivers/pinctrl/pinctrl-imx.c
> @@ -432,7 +432,7 @@ static int __devinit imx_pinctrl_parse_groups(struct device_node *np,
>  {
>         unsigned int pin_func_id;
>         int ret, size;
> -       const const __be32 *list;
> +       const __be32 *list;
A stupid typo. :-)

>         int i, j;
>         u32 config;
>

Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Regards
Dong Aisheng
