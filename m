Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab2LJC1W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 21:27:22 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52805 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999Ab2LJC1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 21:27:21 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] regulator: lp8788-buck: Remove val array in
 lp8788_init_dvs
Thread-Topic: [PATCH 1/2] regulator: lp8788-buck: Remove val array in
 lp8788_init_dvs
Thread-Index: AQHN1Fx7h6YX3SDIO0e/AJrjM0LiqZgRUXtg
Date: Mon, 10 Dec 2012 02:27:13 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0574C@DQHE02.ent.ti.com>
References: <1354872181.15243.1.camel@phoenix>
In-Reply-To: <1354872181.15243.1.camel@phoenix>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBA2RV4Z002818

> All elements of val array are zero.
> Simply set data argument to be 0 in lp8788_update_bits call and remove
> the val
> array.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Axel, sorry I disagree with this patch because DVS_PIN is meaningful.
In this case, explicit bit description is more important than code simplicity.
So I would keep it.

Thanks,
Milo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
