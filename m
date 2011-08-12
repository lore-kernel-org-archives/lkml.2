Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab1HLIvD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:51:03 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:47867 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317Ab1HLIu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:50:58 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 12/23] mfd/db5500-prcmu: fix defines
Date: Fri, 12 Aug 2011 10:29:10 +0200
Message-ID: <1313137750-30981-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This fixes two erroneous defines for the PLLs and adds new
defines for the reset pin controls.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db5500-prcmu.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/db5500-prcmu.c b/drivers/mfd/db5500-prcmu.c
index dc21587..bb115b2 100644
--- a/drivers/mfd/db5500-prcmu.c
+++ b/drivers/mfd/db5500-prcmu.c
@@ -109,15 +109,18 @@ enum mb5_header {
 #define PRCMU_DSI_CLOCK_SETTING			0x00000128
 /* TVCLK_MGT PLLSW=001 (PLLSOC0) PLLDIV=0x13, = 19.05 MHZ */
 #define PRCMU_DSI_LP_CLOCK_SETTING		0x00000135
-#define PRCMU_PLLDSI_FREQ_SETTING		0x0004013C
+#define PRCMU_PLLDSI_FREQ_SETTING		0x00020121
 #define PRCMU_DSI_PLLOUT_SEL_SETTING		0x00000002
-#define PRCMU_ENABLE_ESCAPE_CLOCK_DIV		0x03000101
+#define PRCMU_ENABLE_ESCAPE_CLOCK_DIV		0x03000201
 #define PRCMU_DISABLE_ESCAPE_CLOCK_DIV		0x00000101
 
 #define PRCMU_ENABLE_PLLDSI			0x00000001
 #define PRCMU_DISABLE_PLLDSI			0x00000000
 
 #define PRCMU_DSI_RESET_SW			0x00000003
+#define PRCMU_RESOUTN0_PIN			0x00000001
+#define PRCMU_RESOUTN1_PIN			0x00000002
+#define PRCMU_RESOUTN2_PIN			0x00000004
 
 #define PRCMU_PLLDSI_LOCKP_LOCKED		0x3
 
-- 
1.7.3.2

