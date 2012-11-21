Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab2KUFln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 00:41:43 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48589 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab2KUFlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 00:41:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAPgLHd8Vba4HSf4czzKKkaWUzch1gBpLi2C_=9gBmZNCFVwO3Q@mail.gmail.com>
References: <CAPgLHd8Vba4HSf4czzKKkaWUzch1gBpLi2C_=9gBmZNCFVwO3Q@mail.gmail.com>
Date: Wed, 21 Nov 2012 11:11:41 +0530
Message-ID: <CAK9yfHy8SzHse7toWdfr=CxXAOOaavkiknOLapBFW92Pm2fTHA@mail.gmail.com>
Subject: Re: [PATCH -next] mfd: twl6040: remove duplicated include from twl6040.c
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: sameo@linux.intel.com, peter.ujfalusi@ti.com,
        yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

Similar patch already submitted:
http://www.spinics.net/lists/kernel/msg1439539.html

Thanks,
Sachin

On 21 November 2012 11:01, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Remove duplicated include.
>
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/mfd/twl6040.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
> index e5f7b79..583be76 100644
> --- a/drivers/mfd/twl6040.c
> +++ b/drivers/mfd/twl6040.c
> @@ -37,7 +37,6 @@
>  #include <linux/delay.h>
>  #include <linux/i2c.h>
>  #include <linux/regmap.h>
> -#include <linux/err.h>
>  #include <linux/mfd/core.h>
>  #include <linux/mfd/twl6040.h>
>  #include <linux/regulator/consumer.h>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
