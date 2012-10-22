Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab2JVISa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 04:18:30 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42358 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab2JVIS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 04:18:28 -0400
MIME-Version: 1.0
In-Reply-To: <1350579503-3100-1-git-send-email-antiroot@gmail.com>
References: <1350579503-3100-1-git-send-email-antiroot@gmail.com>
Date: Mon, 22 Oct 2012 10:18:27 +0200
Message-ID: <CAPDyKFonNQGwQBjM4Tgo7i1q50qRVRTWMYYarqo2=VC9=ExCjw@mail.gmail.com>
Subject: Re: [PATCH 1/6] mmc: core: sdio_io.c: Fixed lines with > 80 chars
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Sangho Yi <antiroot@gmail.com>
Cc: paul.gortmaker@windriver.com, stefan.xk.nilsson@stericsson.com,
        linus.walleij@linaro.org, ulf.hansson@stericsson.com, rjw@sisk.pl,
        girish.shivananjappa@linaro.org, cjb@laptop.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sangho,

If you really must do this kind of clean up patches; from my point of
view I would suggest you to collect them in one "mmc: core: Code
cleanup" patch instead.

Kind regards
Ulf Hansson

On 18 October 2012 18:58, Sangho Yi <antiroot@gmail.com> wrote:
> I fixed lines over 80 characters per line.
>
> Signed-off-by: Sangho Yi <antiroot@gmail.com>
> ---
>  drivers/mmc/core/sdio_io.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/core/sdio_io.c b/drivers/mmc/core/sdio_io.c
> index 8f6f5ac..c5f53d8 100644
> --- a/drivers/mmc/core/sdio_io.c
> +++ b/drivers/mmc/core/sdio_io.c
> @@ -80,7 +80,8 @@ int sdio_enable_func(struct sdio_func *func)
>         timeout = jiffies + msecs_to_jiffies(func->enable_timeout);
>
>         while (1) {
> -               ret = mmc_io_rw_direct(func->card, 0, 0, SDIO_CCCR_IORx, 0, &reg);
> +               ret = mmc_io_rw_direct(func->card, 0, 0, SDIO_CCCR_IORx, 0,
> +                               &reg);
>                 if (ret)
>                         goto err;
>                 if (reg & (1 << func->num))
> @@ -664,7 +665,8 @@ void sdio_f0_writeb(struct sdio_func *func, unsigned char b, unsigned int addr,
>
>         BUG_ON(!func);
>
> -       if ((addr < 0xF0 || addr > 0xFF) && (!mmc_card_lenient_fn0(func->card))) {
> +       if ((addr < 0xF0 || addr > 0xFF) &&
> +           (!mmc_card_lenient_fn0(func->card))) {
>                 if (err_ret)
>                         *err_ret = -EINVAL;
>                 return;
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
