Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589Ab2GPIPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 04:15:06 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60029 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab2GPIPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 04:15:03 -0400
MIME-Version: 1.0
In-Reply-To: <1342426322-7809-1-git-send-email-yamanetoshi@gmail.com>
References: <1342426322-7809-1-git-send-email-yamanetoshi@gmail.com>
Date: Mon, 16 Jul 2012 10:15:02 +0200
Message-ID: <CAAfyv35EGx=sFMTdzkwZNw0TLwEf7to_QLkveWf_JZSZMTricA@mail.gmail.com>
Subject: Re: [PATCH] staging/cptm1217: fix checkpatch warnings
From: Belisko Marek <marek.belisko@gmail.com>
To: Toshiaki Yamane <yamanetoshi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 10:12 AM, Toshiaki Yamane <yamanetoshi@gmail.com> wrote:
> The below checkpatch warns was fixed,
>
> drivers/staging/cptm1217/clearpad_tm1217.c:400: WARNING: quoted string split across lines
> drivers/staging/cptm1217/cp_tm1217.h:5: ERROR: open brace '{' following struct go on the same line
>
> Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
> ---
>  drivers/staging/cptm1217/clearpad_tm1217.c |    4 ++--
>  drivers/staging/cptm1217/cp_tm1217.h       |    3 +--
>  2 files changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/cptm1217/clearpad_tm1217.c b/drivers/staging/cptm1217/clearpad_tm1217.c
> index 5456f82..59e7e87 100644
> --- a/drivers/staging/cptm1217/clearpad_tm1217.c
> +++ b/drivers/staging/cptm1217/clearpad_tm1217.c
> @@ -396,8 +396,8 @@ static int cp_tm1217_setup_gpio_irq(struct cp_tm1217_device *ts)
>
>         retval = gpio_to_irq(ts->gpio);
>         if (retval < 0) {
> -               dev_err(ts->dev, "cp_tm1217: GPIO to IRQ failedi,"
> -               " error %d\n", retval);
> +               dev_err(ts->dev, "cp_tm1217: GPIO to IRQ failedi, error %d\n",
there is also typo (you can fix that as well)                           ^^^^
> +                       retval);
>                 gpio_free(ts->gpio);
>         }
>         dev_dbg(ts->dev,
> diff --git a/drivers/staging/cptm1217/cp_tm1217.h b/drivers/staging/cptm1217/cp_tm1217.h
> index a0ce31d..30bad35 100644
> --- a/drivers/staging/cptm1217/cp_tm1217.h
> +++ b/drivers/staging/cptm1217/cp_tm1217.h
> @@ -1,8 +1,7 @@
>  #ifndef __LINUX_I2C_CP_TM1217_H
>  #define __LINUX_I2C_CP_TM1217_H
>
> -struct cp_tm1217_platform_data
> -{
> +struct cp_tm1217_platform_data {
>         int gpio;               /* If not set uses the IRQ resource 0 */
>  };
>
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
