Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab2BFB55 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 20:57:57 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:52847 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab2BFB5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 20:57:55 -0500
X-AuditID: cbfee612-b7cdfae000000146-26-4f2f33a20f3f
Date: Mon, 06 Feb 2012 01:57:54 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] power, max8998: Include linux/module.h just once in
 drivers/power/max8998_charger.c
To: Jesper Juhl <jj@chaosbits.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "trivial@kernel.org" <trivial@kernel.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Axel Lin <axel.lin@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120206014935372@myungjoo.ham
Msgkey: 20120206014935372@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120206014935372@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <32079635.330331328493473417.JavaMail.weblogic@epml22>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q161wcTo016335

> Remove the duplicate.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
>  drivers/power/max8998_charger.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/max8998_charger.c b/drivers/power/max8998_charger.c
> index 9b3f2bf..5c5f281 100644
> --- a/drivers/power/max8998_charger.c
> +++ b/drivers/power/max8998_charger.c
> @@ -21,7 +21,6 @@
>  
>  #include <linux/module.h>
>  #include <linux/err.h>
> -#include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/platform_device.h>
>  #include <linux/power_supply.h>
> -- 
> 1.7.9
> 
> 
> -- 
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
> 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
