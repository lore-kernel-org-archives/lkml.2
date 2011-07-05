Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab1GEBDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 21:03:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:9520 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab1GEBDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 21:03:47 -0400
X-AuditID: cbfee612-b7b41ae000003d1c-0d-4e1262f2bb11
Date: Tue, 05 Jul 2011 01:03:46 +0000 (GMT)
From: JinGoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH] backlight: ams369fg06: unregister backlight device when
 unload the module
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: JinGoo Han <jg1.han@samsung.com>, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20110705010219840@jg1.han
Msgkey: 20110705010219840@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20110705010219840@jg1.han
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <14535912.343501309827824890.JavaMail.weblogic@epml17>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p651YUca013405


Acked-by: Jingoo Han <jg1.han@samsung.com>

> -----Original Message-----
> From: Axel Lin [mailto:axel.lin@gmail.com]
> Sent: Monday, July 04, 2011 11:35 PM
> To: linux-kernel@vger.kernel.org
> Cc: Jingoo Han; Richard Purdie; Andrew Morton
> Subject: [PATCH] backlight: ams369fg06: unregister backlight device when
> unload the module
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/video/backlight/ams369fg06.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/backlight/ams369fg06.c
> b/drivers/video/backlight/ams369fg06.c
> index d1d8237..6462d05 100644
> --- a/drivers/video/backlight/ams369fg06.c
> +++ b/drivers/video/backlight/ams369fg06.c
> @@ -553,6 +553,7 @@ static int __devexit ams369fg06_remove(struct
> spi_device *spi)
>  	struct ams369fg06 *lcd = dev_get_drvdata(&spi->dev);
> 
>  	ams369fg06_power(lcd, FB_BLANK_POWERDOWN);
> +	backlight_device_unregister(lcd->bd);
>  	lcd_device_unregister(lcd->ld);
>  	kfree(lcd);
> 
> --
> 1.7.4.1
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
