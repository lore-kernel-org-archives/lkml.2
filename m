Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab1HPAZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 20:25:22 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43957 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab1HPAZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 20:25:21 -0400
From: Akshay Joshi <me@akshayjoshi.com>
To: Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        Pekka Enberg <penberg@kernel.org>, Akshay Joshi <me@akshayjoshi.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] Staging: Winbond: Fix case statements in wb35reg.c.
Date: Mon, 15 Aug 2011 20:24:27 -0400
Message-Id: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the case statement and the code that is executed if the condition
is met so that it passes checkpatch.pl and conforms to the kernel code
style.

Signed-off-by: Akshay Joshi <me@akshayjoshi.com>
---
 drivers/staging/winbond/wb35reg.c |  105 ++++++++++++++++++++++++------------
 1 files changed, 70 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/winbond/wb35reg.c b/drivers/staging/winbond/wb35reg.c
index da595f1..742636c 100644
--- a/drivers/staging/winbond/wb35reg.c
+++ b/drivers/staging/winbond/wb35reg.c
@@ -76,41 +76,76 @@ void Wb35Reg_Update(struct hw_data *pHwData,  u16 RegisterNo,  u32 RegisterValue
 {
 	struct wb35_reg *reg = &pHwData->reg;
 	switch (RegisterNo) {
-	case 0x3b0: reg->U1B0 = RegisterValue; break;
-	case 0x3bc: reg->U1BC_LEDConfigure = RegisterValue; break;
-	case 0x400: reg->D00_DmaControl = RegisterValue; break;
-	case 0x800: reg->M00_MacControl = RegisterValue; break;
-	case 0x804: reg->M04_MulticastAddress1 = RegisterValue; break;
-	case 0x808: reg->M08_MulticastAddress2 = RegisterValue; break;
-	case 0x824: reg->M24_MacControl = RegisterValue; break;
-	case 0x828: reg->M28_MacControl = RegisterValue; break;
-	case 0x82c: reg->M2C_MacControl = RegisterValue; break;
-	case 0x838: reg->M38_MacControl = RegisterValue; break;
-	case 0x840: reg->M40_MacControl = RegisterValue; break;
-	case 0x844: reg->M44_MacControl = RegisterValue; break;
-	case 0x848: reg->M48_MacControl = RegisterValue; break;
-	case 0x84c: reg->M4C_MacStatus = RegisterValue; break;
-	case 0x860: reg->M60_MacControl = RegisterValue; break;
-	case 0x868: reg->M68_MacControl = RegisterValue; break;
-	case 0x870: reg->M70_MacControl = RegisterValue; break;
-	case 0x874: reg->M74_MacControl = RegisterValue; break;
-	case 0x878: reg->M78_ERPInformation = RegisterValue; break;
-	case 0x87C: reg->M7C_MacControl = RegisterValue; break;
-	case 0x880: reg->M80_MacControl = RegisterValue; break;
-	case 0x884: reg->M84_MacControl = RegisterValue; break;
-	case 0x888: reg->M88_MacControl = RegisterValue; break;
-	case 0x898: reg->M98_MacControl = RegisterValue; break;
-	case 0x100c: reg->BB0C = RegisterValue; break;
-	case 0x102c: reg->BB2C = RegisterValue; break;
-	case 0x1030: reg->BB30 = RegisterValue; break;
-	case 0x103c: reg->BB3C = RegisterValue; break;
-	case 0x1048: reg->BB48 = RegisterValue; break;
-	case 0x104c: reg->BB4C = RegisterValue; break;
-	case 0x1050: reg->BB50 = RegisterValue; break;
-	case 0x1054: reg->BB54 = RegisterValue; break;
-	case 0x1058: reg->BB58 = RegisterValue; break;
-	case 0x105c: reg->BB5C = RegisterValue; break;
-	case 0x1060: reg->BB60 = RegisterValue; break;
+	case 0x3b0:
+		reg->U1B0 = RegisterValue; break;
+	case 0x3bc:
+		reg->U1BC_LEDConfigure = RegisterValue; break;
+	case 0x400:
+		reg->D00_DmaControl = RegisterValue; break;
+	case 0x800:
+		reg->M00_MacControl = RegisterValue; break;
+	case 0x804:
+		reg->M04_MulticastAddress1 = RegisterValue; break;
+	case 0x808:
+		reg->M08_MulticastAddress2 = RegisterValue; break;
+	case 0x824:
+		reg->M24_MacControl = RegisterValue; break;
+	case 0x828:
+		reg->M28_MacControl = RegisterValue; break;
+	case 0x82c:
+		reg->M2C_MacControl = RegisterValue; break;
+	case 0x838:
+		reg->M38_MacControl = RegisterValue; break;
+	case 0x840:
+		reg->M40_MacControl = RegisterValue; break;
+	case 0x844:
+		reg->M44_MacControl = RegisterValue; break;
+	case 0x848:
+		reg->M48_MacControl = RegisterValue; break;
+	case 0x84c:
+		reg->M4C_MacStatus = RegisterValue; break;
+	case 0x860:
+		reg->M60_MacControl = RegisterValue; break;
+	case 0x868:
+		reg->M68_MacControl = RegisterValue; break;
+	case 0x870:
+		reg->M70_MacControl = RegisterValue; break;
+	case 0x874:
+		reg->M74_MacControl = RegisterValue; break;
+	case 0x878:
+		reg->M78_ERPInformation = RegisterValue; break;
+	case 0x87C:
+		reg->M7C_MacControl = RegisterValue; break;
+	case 0x880:
+		reg->M80_MacControl = RegisterValue; break;
+	case 0x884:
+		reg->M84_MacControl = RegisterValue; break;
+	case 0x888:
+		reg->M88_MacControl = RegisterValue; break;
+	case 0x898:
+		reg->M98_MacControl = RegisterValue; break;
+	case 0x100c:
+		reg->BB0C = RegisterValue; break;
+	case 0x102c:
+		reg->BB2C = RegisterValue; break;
+	case 0x1030:
+		reg->BB30 = RegisterValue; break;
+	case 0x103c:
+		reg->BB3C = RegisterValue; break;
+	case 0x1048:
+		reg->BB48 = RegisterValue; break;
+	case 0x104c:
+		reg->BB4C = RegisterValue; break;
+	case 0x1050:
+		reg->BB50 = RegisterValue; break;
+	case 0x1054:
+		reg->BB54 = RegisterValue; break;
+	case 0x1058:
+		reg->BB58 = RegisterValue; break;
+	case 0x105c:
+		reg->BB5C = RegisterValue; break;
+	case 0x1060:
+		reg->BB60 = RegisterValue; break;
 	}
 }
 
-- 
1.7.5.4

