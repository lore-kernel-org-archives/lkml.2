Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab3AGFq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 00:46:56 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:46914 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3AGFqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 00:46:54 -0500
X-AuditID: cbfee61b-b7f616d00000319b-cf-50ea614cbf6c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Axel Lin'" <axel.lin@ingics.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Alberto Panizzo'" <maramaopercheseimorto@gmail.com>,
        "'Richard Purdie'" <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1357535807.14526.1.camel@phoenix>
In-reply-to: <1357535807.14526.1.camel@phoenix>
Subject: Re: [PATCH] backlight: l4f00242t03: Convert to devm_regulator_get
Date: Mon, 07 Jan 2013 14:46:51 +0900
Message-id: <000601cdec9a$64663130$2d329390$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3sljfbDgsmusBcTpabK5g+OXCsPgAA+nZw
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t8zY12fxFcBBpOfMVtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6ME2u5Cp4LVuy8c4G5gXEGXxcjJ4eEgInEki/NjBC2mMSFe+vZ
	uhi5OIQEljFKHD/XzAZTNHnRR1aIxHRGidcHHzBBOLOZJFae/s8KUsUmoCbx5cthdhBbREBF
	4k3/K7AiZoFLjBJLFx8CKxIS0JNYtew12FhOAX2Ju30dYLuFBbwk7j7rA4uzCKhK3Nr6FmwQ
	r4CtxJWvH9kgbEGJH5PvsXQxcgANVZeYMiUXJMwsIC+xec1bZpCwBFD40V9diBOMJB7O3sEI
	USIise/FO0aI6QIS3yYfYoEol5XYdIAZ4sdF7BL3bopA2JISB1fcYJnAKDELyd5ZCHtnIdk7
	C8mCBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzFCokp6B+OqBotDjAIcjEo8vBcNXgUI
	sSaWFVfmHmKU4GBWEuHlsQcK8aYkVlalFuXHF5XmpBYfYvQBunsis5Rocj4w4vNK4g2NjU3M
	TExNzC1NzU1xCCuJ8zKeehIgJJCeWJKanZpakFoEM46Jg1OqgTF0A8NUQaVq1UrDqUnLUxrT
	DyW5Ov5vblR09VgXorl1ToD7gctlK1zeMeUHl8S7VDFsk3gfbOT749bno3czkzQr6wylnA82
	iyzddq51Q/+Lc7tW/vzg5Ptc7D3TDoFlt2d+Cchujyjn0z1Zv2ZutIe0nqLQ/sqo+RenKfiE
	avPeZlCvlIlqV2Ipzkg01GIuKk4EAJ8KYifXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jQV2fxFcBBqdELC7vmsPmwOjxeZNc
	AGNUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPGibVcBc8FK3beucDcwDiD
	r4uRk0NCwERi8qKPrBC2mMSFe+vZuhi5OIQEpjNKvD74gAnCmc0ksfL0f7AqNgE1iS9fDrOD
	2CICKhJv+l+BFTELXGKUWLr4EFiRkICexKplr9lAbE4BfYm7fR2MILawgJfE3Wd9YHEWAVWJ
	W1vfgg3iFbCVuPL1IxuELSjxY/I9li5GDqCh6hJTpuSChJkF5CU2r3nLDBKWAAo/+qsLcYKR
	xMPZOxghSkQk9r14xziBUWgWkkGzEAbNQjJoFpKOBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1
	kvNzNzGCY/aZ9A7GVQ0WhxgFOBiVeHgvGrwKEGJNLCuuzD3EKMHBrCTCy2MPFOJNSaysSi3K
	jy8qzUktPsToA/TmRGYp0eR8YDrJK4k3NDYxM7I0MrMwMjE3xyGsJM7LeOpJgJBAemJJanZq
	akFqEcw4Jg5OqQZGtfCnTAfk0orllYV/yX4RLl7R5c32wblUPqfZp2zvC3bj485cRZ7mVhu3
	7vtyenmnQwvXhqRbkTcWTf2/s1VxekuF1Tl2ly9OhUHPWb5P+Krusy5r6sxk68d6VeuSf/3g
	ErzIdsL5mOOaKaVRx9Z4qLEUMrHavBR0/BGS81vc9vPmOWoblxgrsRRnJBpqMRcVJwIAu6W4
	bAYDAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 07, 2013 2:17 PM, Axel Lin wrote
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

It looks good.

Acked-by: Jingoo Han <jg1.han@samsung.com>


Best regards,
Jingoo Han

> ---
>  drivers/video/backlight/l4f00242t03.c |   24 +++++-------------------
>  1 file changed, 5 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
> index 9bef9cf..fb61557 100644
> --- a/drivers/video/backlight/l4f00242t03.c
> +++ b/drivers/video/backlight/l4f00242t03.c
> @@ -190,27 +190,24 @@ static int l4f00242t03_probe(struct spi_device *spi)
>  		return ret;
>  	}
> 
> -	priv->io_reg = regulator_get(&spi->dev, "vdd");
> +	priv->io_reg = devm_regulator_get(&spi->dev, "vdd");
>  	if (IS_ERR(priv->io_reg)) {
>  		dev_err(&spi->dev, "%s: Unable to get the IO regulator\n",
>  		       __func__);
>  		return PTR_ERR(priv->io_reg);
>  	}
> 
> -	priv->core_reg = regulator_get(&spi->dev, "vcore");
> +	priv->core_reg = devm_regulator_get(&spi->dev, "vcore");
>  	if (IS_ERR(priv->core_reg)) {
> -		ret = PTR_ERR(priv->core_reg);
>  		dev_err(&spi->dev, "%s: Unable to get the core regulator\n",
>  		       __func__);
> -		goto err1;
> +		return PTR_ERR(priv->core_reg);
>  	}
> 
>  	priv->ld = lcd_device_register("l4f00242t03",
>  					&spi->dev, priv, &l4f_ops);
> -	if (IS_ERR(priv->ld)) {
> -		ret = PTR_ERR(priv->ld);
> -		goto err2;
> -	}
> +	if (IS_ERR(priv->ld))
> +		return PTR_ERR(priv->ld);
> 
>  	/* Init the LCD */
>  	l4f00242t03_lcd_init(spi);
> @@ -220,13 +217,6 @@ static int l4f00242t03_probe(struct spi_device *spi)
>  	dev_info(&spi->dev, "Epson l4f00242t03 lcd probed.\n");
> 
>  	return 0;
> -
> -err2:
> -	regulator_put(priv->core_reg);
> -err1:
> -	regulator_put(priv->io_reg);
> -
> -	return ret;
>  }
> 
>  static int l4f00242t03_remove(struct spi_device *spi)
> @@ -235,12 +225,8 @@ static int l4f00242t03_remove(struct spi_device *spi)
> 
>  	l4f00242t03_lcd_power_set(priv->ld, FB_BLANK_POWERDOWN);
>  	lcd_device_unregister(priv->ld);
> -
>  	spi_set_drvdata(spi, NULL);
> 
> -	regulator_put(priv->io_reg);
> -	regulator_put(priv->core_reg);
> -
>  	return 0;
>  }
> 
> --
> 1.7.9.5
> 


