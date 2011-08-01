Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab1HACQZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 22:16:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27152 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab1HACQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 22:16:21 -0400
X-AuditID: cbfee60f-b7b8eae000004f0f-e7-4e360c735389
Date: Mon, 01 Aug 2011 02:16:19 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] power_supply: max8998_charger: allow full timeout not set,
 leave it unchanged
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        =?euc-kr?Q?=B1=E8=B5=BF=B1=D9?= <dg77.kim@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20110801021453234@myungjoo.ham
Msgkey: 20110801021453234@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20110801021453234@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <7137817.240911312164978364.JavaMail.weblogic@epml15>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p712Gbtd023582

Sender : Axel Lin<axel.lin@gmail.com>
Date : 2011-08-01 08:41 (GMT+09:00)
> Add a missing break for case 0 of pdata->timeout, otherwise it will fall
> through to the default case and return error.
>
> Signed-off-by: Axel Lin 
> ---
> drivers/power/max8998_charger.c |    1 +
> 1 files changed, 1 insertions(+), 0 deletions(-)

Thank you for pointing that out.

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>


 MyungJoo Ham (ÇÔ¸íÁÖ)
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: +82-10-6714-2858 / office: +82-31-279-8033ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
