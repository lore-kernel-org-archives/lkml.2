Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab1HACSJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 22:18:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51649 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab1HACSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 22:18:04 -0400
X-AuditID: cbfee60c-b7c93ae000000826-6c-4e360cd7d37a
Date: Mon, 01 Aug 2011 02:17:59 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] power_supply: fix unterminated platform_device_id table
 for max8997_charger and max8998_charger
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20110801021654765@myungjoo.ham
Msgkey: 20110801021654765@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20110801021654765@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <25685223.241031312165079264.JavaMail.weblogic@epml15>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p712IKHp023587

Sender : Axel Lin<axel.lin@gmail.com>
Date : 2011-08-01 08:23 (GMT+09:00)
> The platform_device_id table is supposed to be zero-terminated.
>
> Signed-off-by: Axel Lin 
> ---
> drivers/power/max8997_charger.c |    1 +
> drivers/power/max8998_charger.c |    1 +
> 2 files changed, 2 insertions(+), 0 deletions(-)

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

 MyungJoo Ham (ÇÔ¸íÁÖ)
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: +82-10-6714-2858 / office: +82-31-279-8033ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
