Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab1GDBQy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 21:16:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31800 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab1GDBQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 21:16:53 -0400
X-AuditID: cbfee60e-b7cc8ae000005af0-7f-4e11147ed9d3
Date: Mon, 04 Jul 2011 01:16:46 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] mfd: remove dead code from
 drivers/mfd/max8997-irq.c:get_i2c()
To: Jesper Juhl <jj@chaosbits.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20110704011038038@myungjoo.ham
Msgkey: 20110704011038038@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20110704011038038@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <1124989.304951309742206025.JavaMail.weblogic@epml27>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p641HAGL009456

Sender : Jesper Juhl<jj@chaosbits.net> Date : 2011-07-03 05:38 (GMT+09:00)
> 
> We either hit one of the case's or the default in the switch statement
> in get_i2c(), so the 'return ERR_PTR(-EINVAL);' at the end of the
> function is just dead code - remove it.
> 
> Signed-off-by: Jesper Juhl 

Looks good.

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
> drivers/mfd/max8997-irq.c |    2 --
> 1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/max8997-irq.c b/drivers/mfd/max8997-irq.c
> index 638bf7e..09274cf 100644
> --- a/drivers/mfd/max8997-irq.c
> +++ b/drivers/mfd/max8997-irq.c
> @@ -58,8 +58,6 @@ static struct i2c_client *get_i2c(struct max8997_dev *max8997,
> default:
> return ERR_PTR(-EINVAL);
> }
> -
> - return ERR_PTR(-EINVAL);
> }
> 
> struct max8997_irq_data {
> -- 
> 1.7.6
> 
> 
> -- 
> Jesper Juhl        http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.

 MyungJoo Ham (ÇÔ¸íÁÖ)
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: +82-10-6714-2858 / office: +82-31-279-8033ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
