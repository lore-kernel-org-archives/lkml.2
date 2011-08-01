Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab1HACTk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 22:19:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52624 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab1HACTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 22:19:34 -0400
X-AuditID: cbfee611-b7bfbae000007b1f-3d-4e360c0fb0b1
Date: Mon, 01 Aug 2011 02:19:33 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH -next] power: max8997_charger.c needs module.h
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        =?euc-kr?Q?=B1=E8=B5=BF=B1=D9?= <dg77.kim@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20110801021812626@myungjoo.ham
Msgkey: 20110801021812626@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20110801021812626@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <25829605.241141312165173236.JavaMail.weblogic@epml15>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p712JkKA023594

Sender : Axel Lin<axel.lin@gmail.com>
Date : 2011-08-01 08:29 (GMT+09:00)
>
> power/max8997_charger.c uses interfaces from linux/module.h,
> so it should include that file.  This fixes build errors.
>
> Signed-off-by: Axel Lin 
> ---
> drivers/power/max8997_charger.c |    1 +
> 1 files changed, 1 insertions(+), 0 deletions(-)

Whoops. Wondering how that was missed... :(

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>



 MyungJoo Ham (ÇÔ¸íÁÖ)
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: +82-10-6714-2858 / office: +82-31-279-8033ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
