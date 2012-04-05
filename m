Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab2DEEP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 00:15:59 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:36993
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978Ab2DEEP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 00:15:58 -0400
X-SpamScore: -6
X-BigFish: VPS-6(zz9371I542Mzz1202hzz8275bh8275dhz2dh2a8h668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 5 Apr 2012 00:15:59 -0400
Subject: RE: [PATCH 1/6] regulator: ad5398: Constify regulator_desc
Thread-Topic: [PATCH 1/6] regulator: ad5398: Constify regulator_desc
Thread-Index: Ac0S4C/9JucumqQkTdWWJX3C2q5/3QAAo0cw
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D16F25B9528F@NWD2CMBX1.ad.analog.com>
References: <1333598216.10597.3.camel@phoenix>
In-Reply-To: <1333598216.10597.3.camel@phoenix>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q354GRC2024046

Acked-by: Sonic Zhang <sonic.zhang@analog.com>

-----Original Message-----
From: Axel Lin [mailto:axel.lin@gmail.com]
Sent: Thursday, April 05, 2012 11:57 AM
To: linux-kernel@vger.kernel.org
Cc: Zhang, Sonic; Liam Girdwood; Mark Brown
Subject: [PATCH 1/6] regulator: ad5398: Constify regulator_desc

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/ad5398.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/ad5398.c b/drivers/regulator/ad5398.c
index 7d51793..9ba69c4 100644
--- a/drivers/regulator/ad5398.c
+++ b/drivers/regulator/ad5398.c
@@ -184,7 +184,7 @@ static struct regulator_ops ad5398_ops = {
        .is_enabled = ad5398_is_enabled,
 };

-static struct regulator_desc ad5398_reg = {
+static const struct regulator_desc ad5398_reg = {
        .name = "isink",
        .id = 0,
        .ops = &ad5398_ops,
--
1.7.5.4




ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
