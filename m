Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0HJBpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 21:45:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60065 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab0HJBpv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 21:45:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hV0n+p32SA+7GiYX1+++tCI+OwFCnBXIEQB+nU60KWkAml2eU8CK00p/6vB+Lcg5+l
         t4v01q4CM7xbm30/2pd8SOANsTvHgzIMurgdxbN066B6xFGTOT2QfRdOyoa20ZoES5D5
         SW++wByLo6AkBWZLWtjHdlJ6IZP7jua4Y/c74=
MIME-Version: 1.0
In-Reply-To: <1281370650-29520-3-git-send-email-wellsk40@gmail.com>
References: <1281370650-29520-1-git-send-email-wellsk40@gmail.com>
	<1281370650-29520-3-git-send-email-wellsk40@gmail.com>
Date: Tue, 10 Aug 2010 09:45:49 +0800
Message-ID: <AANLkTim5HDRi7+ONM4kxKeKda3gZziUiuuK_ohnrwrAP@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH 2/2] rtc: Add support in Makefile/Kconfig for 
	the LPC32XX RTC
From: Wan ZongShun <mcuos.com@gmail.com>
To: rtc-linux@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kevin Wells <wellsk40@gmail.com>,
        Durgesh Pattamatta <durgesh.pattamatta@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin ,

2010/8/10  <wellsk40@gmail.com>:
> From: Kevin Wells <wellsk40@gmail.com>
>
> Enable build RTC support for the LPC32XX in makefile/Kconfig
>

I think you can intergrate two patches [PATCH 1/2 2/2] into one rtc
driver patch.

> Signed-off-by: Kevin Wells <wellsk40@gmail.com>
> Signed-off-by: Durgesh Pattamatta <durgesh.pattamatta@nxp.com>
> ---
>  drivers/rtc/Kconfig  |    9 +++++++++
>  drivers/rtc/Makefile |    1 +
>  2 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> index 4301a6c..8452788 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -916,4 +916,13 @@ config RTC_DRV_JZ4740
>          This driver can also be buillt as a module. If so, the module
>          will be called rtc-jz4740.
>
> +config RTC_DRV_LPC32XX
> +        depends on ARCH_LPC32XX
> +        tristate "NXP LPC32XX RTC"
> +        help
> +          This enables support for the NXP RTC in the LPC32XX
> +
> +         This driver can also be buillt as a module. If so, the module
> +         will be called rtc-lpc32xx.
> +
>  endif # RTC_CLASS
> diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
> index fedf9bb..3b8af95 100644
> --- a/drivers/rtc/Makefile
> +++ b/drivers/rtc/Makefile
> @@ -48,6 +48,7 @@ obj-$(CONFIG_RTC_DRV_FM3130)  += rtc-fm3130.o
>  obj-$(CONFIG_RTC_DRV_GENERIC)  += rtc-generic.o
>  obj-$(CONFIG_RTC_DRV_ISL1208)  += rtc-isl1208.o
>  obj-$(CONFIG_RTC_DRV_JZ4740)   += rtc-jz4740.o
> +obj-$(CONFIG_RTC_DRV_LPC32XX)   += rtc-lpc32xx.o
>  obj-$(CONFIG_RTC_DRV_M41T80)   += rtc-m41t80.o
>  obj-$(CONFIG_RTC_DRV_M41T94)   += rtc-m41t94.o
>  obj-$(CONFIG_RTC_DRV_M48T35)   += rtc-m48t35.o
> --
> 1.7.1.1
>
> --
> You received this message because you are subscribed to "rtc-linux".
> Membership options at http://groups.google.com/group/rtc-linux .
> Please read http://groups.google.com/group/rtc-linux/web/checklist
> before submitting a driver.



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
