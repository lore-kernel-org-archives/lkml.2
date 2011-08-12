Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab1HLHDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 03:03:15 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:7800 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab1HLHDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 03:03:14 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275dhz2dh87h2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Jason Liu <jason.hui@linaro.org>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <David.Woodhouse@intel.com>, <dedekind1@gmail.com>,
        <patches@linaro.org>
Subject: [PATCH] mtd: mxc_nand: Add mx53 NFC driver support
Date: Fri, 12 Aug 2011 15:07:59 +0800
Message-ID: <1313132879-10531-1-git-send-email-jason.hui@linaro.org>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has already been tested with Samsung NAND: K9LAG08U0M
on MX53EVK board, ubi/ubifs has already been tested OK too.

Signed-off-by: Jason Liu <jason.hui@linaro.org>
---
 drivers/mtd/nand/mxc_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index 90df34c..a3f1b50 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -41,7 +41,7 @@
 
 #define nfc_is_v21()		(cpu_is_mx25() || cpu_is_mx35())
 #define nfc_is_v1()		(cpu_is_mx31() || cpu_is_mx27() || cpu_is_mx21())
-#define nfc_is_v3_2()		cpu_is_mx51()
+#define nfc_is_v3_2()		(cpu_is_mx51() || cpu_is_mx53())
 #define nfc_is_v3()		nfc_is_v3_2()
 
 /* Addresses for NFC registers */
-- 
1.7.4.1


