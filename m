Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906Ab2C2CkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 22:40:06 -0400
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:35944 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758705Ab2C2Cj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 22:39:58 -0400
From: Jett Zhou <jtzhou@marvell.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Haojian Zhuang <hzhuang1@marvell.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 28 Mar 2012 19:39:50 -0700
Subject: RE: [PATCH 1/4] regulator: Set list_voltage callback for 88pm8607
Thread-Topic: [PATCH 1/4] regulator: Set list_voltage callback for 88pm8607
Thread-Index: Ac0MsRvS8quV1AT+RMGG4pz4QzVewgAo+0Kw
Message-ID: <78895A20B3CF7D49B5589B604D36692B1A1B21D21A@SC-VEXCH4.marvell.com>
References: <1332917909.19101.1.camel@phoenix>
In-Reply-To: <1332917909.19101.1.camel@phoenix>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2T2eB8c002303

Tested these patch by jett zhou, it works ok!
Thanks

-----Original Message-----
From: Axel Lin [mailto:axel.lin@gmail.com] 
Sent: Wednesday, March 28, 2012 2:58 PM
To: linux-kernel@vger.kernel.org
Cc: Haojian Zhuang; Liam Girdwood; Mark Brown; Jett Zhou
Subject: [PATCH 1/4] regulator: Set list_voltage callback for 88pm8607

Current code implements pm8607_list_voltage but does not set the list_voltage
callback function in pm8607_regulator_ops. Fix it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/88pm8607.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index 28b81ae..981b47a 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -328,6 +328,7 @@ static int pm8607_is_enabled(struct regulator_dev *rdev)
 }
 
 static struct regulator_ops pm8607_regulator_ops = {
+	.list_voltage	= pm8607_list_voltage,
 	.set_voltage	= pm8607_set_voltage,
 	.get_voltage	= pm8607_get_voltage,
 	.enable		= pm8607_enable,
-- 
1.7.5.4



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
