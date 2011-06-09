Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab1FIV6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 17:58:12 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:57853 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756529Ab1FIV6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 17:58:10 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/3] mfd: clean-up ab8500 register file
Date: Thu, 9 Jun 2011 23:57:57 +0200
Message-ID: <1307656677-6889-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This adds a previously undefined test register and removed a
number of double-defined accessory detect registers (they are
already defined higher up in the file.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 include/linux/mfd/ab8500.h |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/include/linux/mfd/ab8500.h b/include/linux/mfd/ab8500.h
index b318430..838c6b4 100644
--- a/include/linux/mfd/ab8500.h
+++ b/include/linux/mfd/ab8500.h
@@ -28,6 +28,7 @@
 #define AB8500_INTERRUPT	0xE
 #define AB8500_RTC		0xF
 #define AB8500_MISC		0x10
+#define AB8500_DEVELOPMENT	0x11
 #define AB8500_DEBUG		0x12
 #define AB8500_PROD_TEST	0x13
 #define AB8500_OTP_EMUL		0x15
@@ -74,13 +75,6 @@
 #define AB8500_INT_ACC_DETECT_21DB_F	37
 #define AB8500_INT_ACC_DETECT_21DB_R	38
 #define AB8500_INT_GP_SW_ADC_CONV_END	39
-#define AB8500_INT_ACC_DETECT_1DB_F	33
-#define AB8500_INT_ACC_DETECT_1DB_R	34
-#define AB8500_INT_ACC_DETECT_22DB_F	35
-#define AB8500_INT_ACC_DETECT_22DB_R	36
-#define AB8500_INT_ACC_DETECT_21DB_F	37
-#define AB8500_INT_ACC_DETECT_21DB_R	38
-#define AB8500_INT_GP_SW_ADC_CONV_END	39
 #define AB8500_INT_GPIO6R		40
 #define AB8500_INT_GPIO7R		41
 #define AB8500_INT_GPIO8R		42
-- 
1.7.3.2

