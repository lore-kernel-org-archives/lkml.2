Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884Ab2JLQiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:38:24 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63725 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab2JLQiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:38:20 -0400
From: Adil Mujeeb <mujeeb.adil@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: [PATCH 5/9] Staging: winbond: wb35reg: Fixed coding style issues
Date: Fri, 12 Oct 2012 22:07:11 +0530
Message-Id: <1350059835-5408-6-git-send-email-mujeeb.adil@gmail.com>
X-Mailer: git-send-email 1.7.6.msysgit.0
In-Reply-To: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
References: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some of checkpatch.pl reported ERRORs and WARNING of similar types:
1. trailing statements should be on next line
2. no spaces at the start of a line

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 linux-3.6-rc7/drivers/staging/winbond/wb35reg.c |  142 +++++++++++++++++------
 1 files changed, 106 insertions(+), 36 deletions(-)

diff --git a/linux-3.6-rc7/drivers/staging/winbond/wb35reg.c b/linux-3.6-rc7/drivers/staging/winbond/wb35reg.c
index da595f1..476f4db 100644
--- a/linux-3.6-rc7/drivers/staging/winbond/wb35reg.c
+++ b/linux-3.6-rc7/drivers/staging/winbond/wb35reg.c
@@ -69,48 +69,118 @@ unsigned char Wb35Reg_BurstWrite(struct hw_data *pHwData, u16 RegisterNo, u32 *p
 		kfree(reg_queue);
 		return false;
 	}
-   return false;
+	return false;
 }
 
 void Wb35Reg_Update(struct hw_data *pHwData,  u16 RegisterNo,  u32 RegisterValue)
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
+		reg->U1B0 = RegisterValue;
+		break;
+	case 0x3bc:
+		reg->U1BC_LEDConfigure = RegisterValue;
+		break;
+	case 0x400:
+		reg->D00_DmaControl = RegisterValue;
+		break;
+	case 0x800:
+		reg->M00_MacControl = RegisterValue;
+		break;
+	case 0x804:
+		reg->M04_MulticastAddress1 = RegisterValue;
+		break;
+	case 0x808:
+		reg->M08_MulticastAddress2 = RegisterValue;
+		break;
+	case 0x824:
+		reg->M24_MacControl = RegisterValue;
+		break;
+	case 0x828:
+		reg->M28_MacControl = RegisterValue;
+		break;
+	case 0x82c:
+		reg->M2C_MacControl = RegisterValue;
+		break;
+	case 0x838:
+		reg->M38_MacControl = RegisterValue;
+		break;
+	case 0x840:
+		reg->M40_MacControl = RegisterValue;
+		break;
+	case 0x844:
+		reg->M44_MacControl = RegisterValue;
+		break;
+	case 0x848:
+		reg->M48_MacControl = RegisterValue;
+		break;
+	case 0x84c:
+		reg->M4C_MacStatus = RegisterValue;
+		break;
+	case 0x860:
+		reg->M60_MacControl = RegisterValue;
+		break;
+	case 0x868:
+		reg->M68_MacControl = RegisterValue;
+		break;
+	case 0x870:
+		reg->M70_MacControl = RegisterValue;
+		break;
+	case 0x874:
+		reg->M74_MacControl = RegisterValue;
+		break;
+	case 0x878:
+		reg->M78_ERPInformation = RegisterValue;
+		break;
+	case 0x87C:
+		reg->M7C_MacControl = RegisterValue;
+		break;
+	case 0x880:
+		reg->M80_MacControl = RegisterValue;
+		break;
+	case 0x884:
+		reg->M84_MacControl = RegisterValue;
+		break;
+	case 0x888:
+		reg->M88_MacControl = RegisterValue;
+		break;
+	case 0x898:
+		reg->M98_MacControl = RegisterValue;
+		break;
+	case 0x100c:
+		reg->BB0C = RegisterValue;
+		break;
+	case 0x102c:
+		reg->BB2C = RegisterValue;
+		break;
+	case 0x1030:
+		reg->BB30 = RegisterValue;
+		break;
+	case 0x103c:
+		reg->BB3C = RegisterValue;
+		break;
+	case 0x1048:
+		reg->BB48 = RegisterValue;
+		break;
+	case 0x104c:
+		reg->BB4C = RegisterValue;
+		break;
+	case 0x1050:
+		reg->BB50 = RegisterValue;
+		break;
+	case 0x1054:
+		reg->BB54 = RegisterValue;
+		break;
+	case 0x1058:
+		reg->BB58 = RegisterValue;
+		break;
+	case 0x105c:
+		reg->BB5C = RegisterValue;
+		break;
+	case 0x1060:
+		reg->BB60 = RegisterValue;
+		break;
 	}
 }
 
-- 
1.7.7.3

