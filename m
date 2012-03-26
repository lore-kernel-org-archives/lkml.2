Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab2CZD2m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 23:28:42 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19244 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757046Ab2CZD2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 23:28:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 25 Mar 2012 20:28:34 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 26 Mar 2012 08:58:29 +0530
Subject: RE: [PATCH 1/2] regulator: tps65090: Use IS_ERR to check return
 value of regulator_register
Thread-Topic: [PATCH 1/2] regulator: tps65090: Use IS_ERR to check return
 value of regulator_register
Thread-Index: Ac0Jaa0dbWg+prIgRCe4B5K6YM49fwBlogVw
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD3128165@BGMAIL02.nvidia.com>
References: <1332557760.10528.0.camel@phoenix>
In-Reply-To: <1332557760.10528.0.camel@phoenix>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2Q3TPAK011394

>  	rdev = regulator_register(&ri->desc, &pdev->dev,
>  				&tps_pdata->regulator, ri, NULL);
> -	if (IS_ERR_OR_NULL(rdev)) {
> +	if (IS_ERR(rdev)) {
Thanks Axel, for this patch.
Just today I saw Mark's mail and about to make this change.

Acked-by: Venu Byravarasu <vbyravarasu@nvidia.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
