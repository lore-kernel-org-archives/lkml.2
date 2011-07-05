Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab1GEGKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 02:10:19 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:52552 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab1GEGKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 02:10:17 -0400
X-AuditID: cbfee611-b7b4eae0000070f6-7b-4e12a9e5f4ec
Date: Tue, 05 Jul 2011 06:10:15 +0000 (GMT)
From: JinGoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH] backlight: ams369fg06: Staticize ams369fg06_shutdown
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: JinGoo Han <jg1.han@samsung.com>, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20110705060739325@jg1.han
Msgkey: 20110705060739325@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20110705060739325@jg1.han
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <14768860.359471309846214814.JavaMail.weblogic@epml17>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p656ATTU014374

Acked-by: Jingoo Han <jg1.han@samsung.com>

> -----Original Message-----
> From: Axel Lin [mailto:axel.lin@gmail.com]
> Sent: Tuesday, July 05, 2011 2:00 PM
> To: linux-kernel@vger.kernel.org
> Cc: Jingoo Han; Richard Purdie; Andrew Morton
> Subject: [PATCH] backlight: ams369fg06: Staticize ams369fg06_shutdown
> 
> It's only used in ams369fg06.c, no need for it to be in the global
> namespace.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/video/backlight/ams369fg06.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/backlight/ams369fg06.c
> b/drivers/video/backlight/ams369fg06.c
> index 201a593..59fab88 100644
> --- a/drivers/video/backlight/ams369fg06.c
> +++ b/drivers/video/backlight/ams369fg06.c
> @@ -608,7 +608,7 @@ static int ams369fg06_resume(struct spi_device *spi)
>  #define ams369fg06_resume	NULL
>  #endif
> 
> -void ams369fg06_shutdown(struct spi_device *spi)
> +static void ams369fg06_shutdown(struct spi_device *spi)
>  {
>  	struct ams369fg06 *lcd = dev_get_drvdata(&spi->dev);
> 
> --
> 1.7.4.1
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
