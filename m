Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447Ab2CBI5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 03:57:12 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:36347
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757570Ab2CBI5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 03:57:10 -0500
X-SpamScore: -6
X-BigFish: VPS-6(zz9371I542Mzz1202hzz8275bh8275dhz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 2 Mar 2012 03:57:00 -0500
Subject: RE: [PATCH 1/3] regulator: ad5398: Use DIV_ROUND_UP macro to
 calculate selector
Thread-Topic: [PATCH 1/3] regulator: ad5398: Use DIV_ROUND_UP macro to
 calculate selector
Thread-Index: Acz4TXRSUnXA1rBjQmCr0+5v5qfepgABNadA
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D16F2417DBB1@NWD2CMBX1.ad.analog.com>
References: <1330676454.31023.0.camel@phoenix>
In-Reply-To: <1330676454.31023.0.camel@phoenix>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q228vIho016090

Acked-by: Sonic Zhang <sonic.zhang@analog.com>

-----Original Message-----
From: Axel Lin [mailto:axel.lin@gmail.com]
Sent: Friday, March 02, 2012 4:21 PM
To: linux-kernel@vger.kernel.org
Cc: Zhang, Sonic; Liam Girdwood; Mark Brown
Subject: [PATCH 1/3] regulator: ad5398: Use DIV_ROUND_UP macro to calculate selector

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/ad5398.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ad5398.c b/drivers/regulator/ad5398.c
index 483c809..26d23ad 100644
--- a/drivers/regulator/ad5398.c
+++ b/drivers/regulator/ad5398.c
@@ -94,8 +94,8 @@ static int ad5398_set_current_limit(struct regulator_dev *rdev, int min_uA, int
        if (max_uA > chip->max_uA || max_uA < chip->min_uA)
                return -EINVAL;

-       selector = ((min_uA - chip->min_uA) * chip->current_level +
-                       range_uA - 1) / range_uA;
+       selector = DIV_ROUND_UP((min_uA - chip->min_uA) * chip->current_level,
+                               range_uA);
        if (ad5398_calc_current(chip, selector) > max_uA)
                return -EINVAL;

--
1.7.5.4




ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
