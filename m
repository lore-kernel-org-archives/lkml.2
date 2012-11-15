Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946029Ab2KOAqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 19:46:13 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:28040 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab2KOAqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 19:46:12 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-87-50a43b511106
From: Jingoo Han <jg1.han@samsung.com>
To: "'Peter Ujfalusi'" <peter.ujfalusi@ti.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Grazvydas Ignotas'" <notasas@gmail.com>
References: <1352891761-29561-1-git-send-email-peter.ujfalusi@ti.com>
In-reply-to: <1352891761-29561-1-git-send-email-peter.ujfalusi@ti.com>
Subject: RE: [PATCH] backlight: pandora_bl: Change TWL4030_MODULE_PWM0 to
 TWL_MODULE_PWM
Date: Thu, 15 Nov 2012 09:46:09 +0900
Message-id: <003f01cdc2ca$9a9bb350$cfd319f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3CWXVVxi7wG1UfTsmCxb9Cddbd3wAcJ6aw
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zI91A6yUBBmvfWlic6PvAanF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDIW3DjBWPBHoOLXrM0sDYy/ebsYOTkkBEwkvs5tZISw
	xSQu3FvP1sXIxSEksIxR4vWcN2wwRQ/P7GKGSCxilPi3az6U84tRYtW96ewgVWwCahJfvhwG
	s0UEoiUWLX7KBFLELHCKUeL08RVADgdQh6vEmTvuIDWcAm4SPQ8WsoLYwgJREgcuz2ACsVkE
	VCWOHp4FNodXwFZi0fkNbBC2oMSPyfdYQGxmAS2J9TuPM0HY8hKb17xlBhkvIaAu8eivLogp
	ImAk8XKKF0SFiMS+F+8YIaYLSHybfIgFolpWYtMBsE8kBNaxS0w8PokZ4l9JiYMrbrBMYJSY
	hWTxLCSLZyFZPAvJigWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxQmJMagfjygaLQ4wC
	HIxKPLwOPxYHCLEmlhVX5h5ilOBgVhLhfXEQKMSbklhZlVqUH19UmpNafIjRB+jyicxSosn5
	wPjPK4k3NDY2MTMxNTG3NDU3xSGsJM7b7JESICSQnliSmp2aWpBaBDOOiYNTqoFxhUXVxQVr
	PsRLvs3oDpyWtMn1WYprhFv33UI7hxyDA263j/z48FQv9/huj19TOiqfeaWbVLKUuM2R/muy
	UNSk8Vi66qPqyg0K4Snfyt5+rG6vP9a8SD6w6P4pzjM9S5UvyTTOf8L9NtB72dPlwYWilenf
	F5d7bnCseXXo1qSF+kmOFyQsmXiVWIozEg21mIuKEwGLWeVk3gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jAd1A6yUBBkvfGVuc6PvAanF51xw2
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzFtw4wVjwR6Di
	16zNLA2Mv3m7GDk5JARMJB6e2cUMYYtJXLi3nq2LkYtDSGARo8S/XfOZIZxfjBKr7k1nB6li
	E1CT+PLlMJgtIhAtsWjxUyaQImaBU4wSp4+vAHI4gDpcJc7ccQep4RRwk+h5sJAVxBYWiJI4
	cHkGE4jNIqAqcfTwLLA5vAK2EovOb2CDsAUlfky+xwJiMwtoSazfeZwJwpaX2LzmLTPIeAkB
	dYlHf3VBTBEBI4mXU7wgKkQk9r14xziBUWgWkkGzkAyahWTQLCQtCxhZVjGKphYkFxQnpeca
	6hUn5haX5qXrJefnbmIER/AzqR2MKxssDjEKcDAq8fA6/FgcIMSaWFZcmXuIUYKDWUmE98VB
	oBBvSmJlVWpRfnxRaU5q8SFGH6A/JzJLiSbnA5NLXkm8obGJmZGlkZmFkYm5OQ5hJXHeZo+U
	ACGB9MSS1OzU1ILUIphxTBycUg2ME1NE70n+sVK9V/Shu7R0PkMqz79N3w2tav3jZ3p0MhZm
	+jNWZUcetObYrqHDc8TotSVb5W73CPVp72rOyCycdDmi4ctvtorbmeu22qy+4PR/15QjigpX
	5MM+xTCWp93VKb/Xw5+S27++ea0j1xJGDzPlY2WFAfwzN3ElK7FopgULFJxwOaHEUpyRaKjF
	XFScCADJe1n9DQMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 14, 2012 8:16 PM Peter Ujfalusi wrote
> 
> TWL_MODULE_PWM is defined as:
> #define TWL_MODULE_PWM		TWL4030_MODULE_PWM0
> 
> Use the common module ID define here which will facilitate the upcoming
> twl-core cleanup.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

CC'ed Andrew Morton

It looks good.

Acked-by: Jingoo Han <jg1.han@samsung.com>


> ---
>  drivers/video/backlight/pandora_bl.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/video/backlight/pandora_bl.c b/drivers/video/backlight/pandora_bl.c
> index 4ec3074..633b0a2 100644
> --- a/drivers/video/backlight/pandora_bl.c
> +++ b/drivers/video/backlight/pandora_bl.c
> @@ -71,8 +71,7 @@ static int pandora_backlight_update_status(struct backlight_device *bl)
>  		 * set PWM duty cycle to max. TPS61161 seems to use this
>  		 * to calibrate it's PWM sensitivity when it starts.
>  		 */
> -		twl_i2c_write_u8(TWL4030_MODULE_PWM0, MAX_VALUE,
> -					TWL_PWM0_OFF);
> +		twl_i2c_write_u8(TWL_MODULE_PWM, MAX_VALUE, TWL_PWM0_OFF);
> 
>  		/* first enable clock, then PWM0 out */
>  		twl_i2c_read_u8(TWL4030_MODULE_INTBR, &r, TWL_INTBR_GPBR1);
> @@ -90,8 +89,7 @@ static int pandora_backlight_update_status(struct backlight_device *bl)
>  		usleep_range(2000, 10000);
>  	}
> 
> -	twl_i2c_write_u8(TWL4030_MODULE_PWM0, MIN_VALUE + brightness,
> -				TWL_PWM0_OFF);
> +	twl_i2c_write_u8(TWL_MODULE_PWM, MIN_VALUE + brightness, TWL_PWM0_OFF);
> 
>  done:
>  	if (brightness != 0)
> @@ -132,7 +130,7 @@ static int pandora_backlight_probe(struct platform_device *pdev)
>  	platform_set_drvdata(pdev, bl);
> 
>  	/* 64 cycle period, ON position 0 */
> -	twl_i2c_write_u8(TWL4030_MODULE_PWM0, 0x80, TWL_PWM0_ON);
> +	twl_i2c_write_u8(TWL_MODULE_PWM, 0x80, TWL_PWM0_ON);
> 
>  	bl->props.state |= PANDORABL_WAS_OFF;
>  	bl->props.brightness = MAX_USER_VALUE;
> --
> 1.8.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

