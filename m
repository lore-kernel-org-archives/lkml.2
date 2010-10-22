Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab0JVFVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 01:21:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55010 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab0JVFVd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 01:21:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tkdaz2EOoAU2e6WPck9lj3PY3Pj7CRwEwM1vxK/OMrKKYPYuSQkIaUy0tPmzt64ys+
         xHyMN5MuOuQ5sabZTmlWVyZaWGDZXD0+IUYZt0O3ZUaLcvAJB9x343W5N7VsLwoywEFe
         aqFJyVnhyK0RVyIw7RKCotuPJM9G6PQbNQS1g=
MIME-Version: 1.0
In-Reply-To: <4279ee540bfed9c40ba26698bfe7abddb8921ee4.1287724261.git.joe@perches.com>
References: <cover.1287724261.git.joe@perches.com>
	<4279ee540bfed9c40ba26698bfe7abddb8921ee4.1287724261.git.joe@perches.com>
Date: Fri, 22 Oct 2010 13:21:29 +0800
Message-ID: <AANLkTikG+n_Z4gY9i0gpVk5M+MHW46Tzg_xSnjVgih_e@mail.gmail.com>
Subject: Re: [PATCH 4/9] drivers/rtc: typo fix of faild to failed
From: Wan ZongShun <mcuos.com@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Alessandro Zummo <a.zummo@towertech.it>,
        linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Joe,

Thanks for your help.

2010/10/22 Joe Perches <joe@perches.com>:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/rtc/rtc-nuc900.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/rtc/rtc-nuc900.c b/drivers/rtc/rtc-nuc900.c
> index 62de66a..ddb0857 100644
> --- a/drivers/rtc/rtc-nuc900.c
> +++ b/drivers/rtc/rtc-nuc900.c
> @@ -274,7 +274,7 @@ static int __devinit nuc900_rtc_probe(struct platform_device *pdev)
>        nuc900_rtc->rtcdev = rtc_device_register(pdev->name, &pdev->dev,
>                                                &nuc900_rtc_ops, THIS_MODULE);
>        if (IS_ERR(nuc900_rtc->rtcdev)) {
> -               dev_err(&pdev->dev, "rtc device register faild\n");
> +               dev_err(&pdev->dev, "rtc device register failed\n");

Acked-by: Wan ZongShun <mcuos.com@gmail.com>

>                err = PTR_ERR(nuc900_rtc->rtcdev);
>                goto fail3;
>        }
> --
> 1.7.3.1.g432b3.dirty
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
