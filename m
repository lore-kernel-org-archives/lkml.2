Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab2ASEvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 23:51:48 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:24776 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab2ASEvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 23:51:47 -0500
X-AuditID: cbfee610-b7bb1ae000002563-19-4f17a161ec59
Date: Thu, 19 Jan 2012 04:51:45 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] devfreq: Remove MODULE_ALIAS for exynos4 busfreq driver
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120119044410454@myungjoo.ham
Msgkey: 20120119044410454@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120119044410454@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <33002890.231221326948704680.JavaMail.weblogic@epml01>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0J4qSM7028564

> This driver can only be built-in, it does not make sense to add modalias for
> it (in addition to being incorrect, the platform modalias needs to be prefixed
> with "platform:").
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Thanks. I've added this in the devfreq-next tree, which will be published in git.infradead.org for now. (I'll setup a git repository either at github or git.kernel.org soon.)

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
>  drivers/devfreq/exynos4_bus.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
> index 489ccfa..590d686 100644
> --- a/drivers/devfreq/exynos4_bus.c
> +++ b/drivers/devfreq/exynos4_bus.c
> @@ -1124,4 +1124,3 @@ module_exit(exynos4_busfreq_exit);
>  MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("EXYNOS4 busfreq driver with devfreq framework");
>  MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
> -MODULE_ALIAS("exynos4-busfreq");
> -- 
> 1.7.5.4
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
