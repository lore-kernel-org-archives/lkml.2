Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398Ab0FJBrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 21:47:17 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35647 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab0FJBrP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 21:47:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Fhefi5i5XeVqOpiyYRSq89DANDC6rSC93ajAfpakJvme6WxYAmAN9nMz3kV7yvPxJQ
         n60w+TAH5lP3NcdcS8MnB+nYBmega/JS+oWe18ITIEM26ERHCN6RIAY5CP4UlPuUtLp+
         hW4kP1zUkZ35Z8/jNX8uRDYseJWd59L/KZjf8=
MIME-Version: 1.0
In-Reply-To: <6d429f15de979525b295a490c68004a9ac2551a0.1276112117.git.joe@perches.com>
References: <cover.1276112117.git.joe@perches.com>
	<6d429f15de979525b295a490c68004a9ac2551a0.1276112117.git.joe@perches.com>
Date: Thu, 10 Jun 2010 09:47:14 +0800
Message-ID: <AANLkTinXm_hO--jxGhHDnTsW_93uuqR4S5-HTzXU1Hvj@mail.gmail.com>
Subject: Re: [PATCH 02/12] MAINTAINERS: Update ARM/NUVOTON W90X900 ARM 
	ARCHITECTURE file patterns
From: Wan ZongShun <mcuos.com@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

2010/6/10 Joe Perches <joe@perches.com>:
> Signed-off-by: Joe Perches <joe@perches.com>
> Cc:  Wan ZongShun <mcuos.com@gmail.com>
> ---
>  MAINTAINERS |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2af46b6..9046e97 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -974,12 +974,11 @@ F:        drivers/input/keyboard/w90p910_keypad.c
>  F:     drivers/input/touchscreen/w90p910_ts.c
>  F:     drivers/watchdog/nuc900_wdt.c
>  F:     drivers/net/arm/w90p910_ether.c
> -F:     drivers/mtd/nand/w90p910_nand.c
> +F:     drivers/mtd/nand/nuc900_nand.c
>  F:     drivers/rtc/rtc-nuc900.c
>  F:     drivers/spi/spi_nuc900.c
>  F:     drivers/usb/host/ehci-w90x900.c
>  F:     drivers/video/nuc900fb.c
> -F:     drivers/sound/soc/nuc900/

The NUC900 audio driver has been applied by Mark.
It seems not to have been merged into mainline tree yet.

so, thanks for your patch.

Acked-by: Wan ZongShun <mcuos.com@gmail.com>

>
>  ARM/U300 MACHINE SUPPORT
>  M:     Linus Walleij <linus.walleij@stericsson.com>
> --
> 1.7.1.244.gbdc4
>
>



-- 
*linux-arm-kernel mailing list
mail addr:linux-arm-kernel@lists.infradead.org
you can subscribe by:
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

* linux-arm-NUC900 mailing list
mail addr:NUC900@googlegroups.com
main web: https://groups.google.com/group/NUC900
you can subscribe it by sending me mail:
mcuos.com@gmail.com
