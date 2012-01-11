Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812Ab2AKLXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 06:23:51 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:57352 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032Ab2AKLXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 06:23:47 -0500
X-AuditID: cbfee60f-b7bceae00000240c-55-4f0d7125cc39
Date: Wed, 11 Jan 2012 11:23:17 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] power_supply: Fix modalias for charger-manager
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        =?euc-kr?Q?=B1=E8=B5=BF=B1=D9?= <dg77.kim@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120111112134771@myungjoo.ham
Msgkey: 20120111112134771@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120111112134771@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <10819991.146571326280997005.JavaMail.weblogic@epml24>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0BBO2YH016801

Written by Axel Lin<axel.lin@gmail.com>
> Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform
> modalias is prefixed with "platform:".
> Current code has the id_table, thus add MODULE_DEVICE_TABLE will
> automatically setup the modalias.
> 
> Also make charger_manager_id static as it is only used in this driver.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Thanks.

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
>  drivers/power/charger-manager.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
> index 0378d01..88fd971 100644
> --- a/drivers/power/charger-manager.c
> +++ b/drivers/power/charger-manager.c
> @@ -974,10 +974,11 @@ static int __devexit charger_manager_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> -const struct platform_device_id charger_manager_id[] = {
> +static const struct platform_device_id charger_manager_id[] = {
>  	{ "charger-manager", 0 },
>  	{ },
>  };
> +MODULE_DEVICE_TABLE(platform, charger_manager_id);
>  
>  static int cm_suspend_prepare(struct device *dev)
>  {
> @@ -1069,4 +1070,3 @@ module_exit(charger_manager_cleanup);
>  MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
>  MODULE_DESCRIPTION("Charger Manager");
>  MODULE_LICENSE("GPL");
> -MODULE_ALIAS("charger-manager");
> -- 
> 1.7.5.4
> 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
