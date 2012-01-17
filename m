Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab2AQAd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 19:33:57 -0500
Received: from mail2.nsc.com ([12.238.8.132]:45210 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750788Ab2AQAd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 19:33:56 -0500
X-WSS-ID: 0LXX2WH-0A-5WV-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Axel Lin" <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
cc: "Jeong, Daniel" <Daniel.Jeong@nsc.com>,
        "Anton Vorontsov" <cbouatmailru@gmail.com>
Date: Mon, 16 Jan 2012 16:33:43 -0800
Subject: RE: [PATCH] power_supply: lp8727_charger: Add terminating entry
 for i2c_device_id table
Thread-Topic: [PATCH] power_supply: lp8727_charger: Add terminating
 entry for i2c_device_id table
Thread-Index: AczUEntzkbt5oKXGRtCsIrUGdOA4KgAmeM9w
Message-ID: <B567DBAB974C0544994013492B949F8E3812BEF09C@EXMAIL03.scwf.nsc.com>
References: <1326692900.12796.0.camel@phoenix>
In-Reply-To: <1326692900.12796.0.camel@phoenix>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 630A1E561LS9723090-02-01
Content-Type: text/plain;
 charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0H0Y0u0014234

Thanks,

I think Anton will apply this patch.

-----Original Message-----
From: Axel Lin [mailto:axel.lin@gmail.com] 
Sent: Monday, January 16, 2012 2:48 PM
To: linux-kernel@vger.kernel.org
Cc: Kim, Milo; Jeong, Daniel; Anton Vorontsov
Subject: [PATCH] power_supply: lp8727_charger: Add terminating entry for i2c_device_id table

The i2c_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index b15b575..c53dd12 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -464,6 +464,7 @@ static int __devexit lp8727_remove(struct i2c_client *cl)
 
 static const struct i2c_device_id lp8727_ids[] = {
 	{"lp8727", 0},
+	{ }
 };
 
 static struct i2c_driver lp8727_driver = {
-- 
1.7.5.4



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
