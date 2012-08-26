Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab2HZCOA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 22:14:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63509 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737Ab2HZCN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 22:13:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd_QDRHKBybnCtD_K-JJvJG_f4x6wTXczQZqraiLch4wEg@mail.gmail.com>
References: <CAPgLHd_QDRHKBybnCtD_K-JJvJG_f4x6wTXczQZqraiLch4wEg@mail.gmail.com>
Date: Sun, 26 Aug 2012 10:13:58 +0800
Message-ID: <CAAQ0ZWTLES1DtDEaYuhfHZOd-5UUje6xOj06O-GDcHBk4GSgUg@mail.gmail.com>
Subject: Re: [PATCH] ARM: mxs: remove duplicated include from mach-mxs.c
From: Shawn Guo <shawn.guo@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: linux@arm.linux.org.uk, yongjun_wei@trendmicro.com.cn,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 August 2012 09:49, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Remove duplicated include.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks for the patch.  But the duplicated inclusion has been fixed on
branch below, which is queued for 3.7.

 git://git.linaro.org/people/shawnguo/linux-2.6.git mxs/dt-for-3.7

Regards,
Shawn

> ---
>  arch/arm/mach-mxs/mach-mxs.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/arm/mach-mxs/mach-mxs.c b/arch/arm/mach-mxs/mach-mxs.c
> index 8dabfe8..5c91870 100644
> --- a/arch/arm/mach-mxs/mach-mxs.c
> +++ b/arch/arm/mach-mxs/mach-mxs.c
> @@ -14,7 +14,6 @@
>  #include <linux/clkdev.h>
>  #include <linux/err.h>
>  #include <linux/init.h>
> -#include <linux/init.h>
>  #include <linux/irqdomain.h>
>  #include <linux/micrel_phy.h>
>  #include <linux/mxsfb.h>
>
