Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab0IYBhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 21:37:16 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42807 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab0IYBhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 21:37:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ga2ZPE4cpRPQfVpzEASl4CNWAe6WRMPqCervzMJWlQPi0dzbLn8ipMFUXPEnr2Prp2
         picWFBat5XPufEajTQ95xu9A9TvCcgQD1KDmyCT22UMb18tj2739GOCR1qO/TlDuLptZ
         Wc2oNwL/ZtKz8cE8uxN+gfM91Ltl5hXfDQ04M=
MIME-Version: 1.0
In-Reply-To: <06e70fe4f8a51f65f3582c353329939a8548d897.1285355033.git.mfm@muteddisk.com>
References: <9968d4260be8850200cc9c7dfe08addf611468b4.1285355033.git.mfm@muteddisk.com>
	<036514b5dd23c5af14303519d79d60d79adccbee.1285355033.git.mfm@muteddisk.com>
	<ffbd189ef2d414ea7c87ffe2b40fce87877dc014.1285355033.git.mfm@muteddisk.com>
	<b3e2061e1e6703f7b84c0484030e07de6000546a.1285355033.git.mfm@muteddisk.com>
	<70fe6b462b3ee22922698a12d62d650cf029033a.1285355033.git.mfm@muteddisk.com>
	<40a2d76d013ad025d08a411992af10f6bbef0a13.1285355033.git.mfm@muteddisk.com>
	<b484ccf548e1700e09ac7f731289503bf3e7b3bf.1285355033.git.mfm@muteddisk.com>
	<2c0fbcaafb18007c5c83823cb33e35120fe15091.1285355033.git.mfm@muteddisk.com>
	<ec9520aca140f253d8bad33cf35b8e668e7e9c9c.1285355033.git.mfm@muteddisk.com>
	<8cea68a58c5ddba79fc96e93fa0b23681e6a7ffe.1285355033.git.mfm@muteddisk.com>
	<e93a3f1af26d2b0fc798b4c15401b3422ae6e2bd.1285355033.git.mfm@muteddisk.com>
	<c2f1ef5590660ae574e9bdaf7136213741081404.1285355033.git.mfm@muteddisk.com>
	<efe88633e146de3e173afea14f777c41c37e5db2.1285355033.git.mfm@muteddisk.com>
	<facbf79cadc81f9043e89160b7b3b8a90926aba1.1285355033.git.mfm@muteddisk.com>
	<f8ffc630c8a56ebd5da0aa2227d63fecc21d4ee7.1285355033.git.mfm@muteddisk.com>
	<0472f95473283ce75285e458b22b86ff791d7a42.1285355033.git.mfm@muteddisk.com>
	<75da5e0e0a547b4acbc7cfbdf35c29a24512ca37.1285355033.git.mfm@muteddisk.com>
	<e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
	<30c1ad7f4200136e00723fd76da1e58200e6e5b0.1285355033.git.mfm@muteddisk.com>
	<06e70fe4f8a51f65f3582c353329939a8548d897.1285355033.git.mfm@muteddisk.com>
Date: Sat, 25 Sep 2010 09:37:11 +0800
Message-ID: <AANLkTinHovm60QmM9gJhreXfbEcsBpDKmtxLSEzx+0uo@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH 20/24] rtc: change to new flag variable
From: Wan ZongShun <mcuos.com@gmail.com>
To: rtc-linux@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-janitors@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/25 matt mooney <mfm@muteddisk.com>:
> Replace EXTRA_CFLAGS with ccflags-y.

Good idea.

Acked-by: Wan ZongShun <mcuos.com@gmail.com>

>
> Signed-off-by: matt mooney <mfm@muteddisk.com>
> ---
>  drivers/rtc/Makefile |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
> index 0f207b3..f2d69d5 100644
> --- a/drivers/rtc/Makefile
> +++ b/drivers/rtc/Makefile
> @@ -2,9 +2,7 @@
>  # Makefile for RTC class/drivers.
>  #
>
> -ifeq ($(CONFIG_RTC_DEBUG),y)
> -       EXTRA_CFLAGS            += -DDEBUG
> -endif
> +ccflags-$(CONFIG_RTC_DEBUG)    := -DDEBUG
>
>  obj-$(CONFIG_RTC_LIB)          += rtc-lib.o
>  obj-$(CONFIG_RTC_HCTOSYS)      += hctosys.o
> --
> 1.7.2.1
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
