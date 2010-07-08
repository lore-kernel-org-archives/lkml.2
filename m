Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab0GHMJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 08:09:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40291 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756410Ab0GHMJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 08:09:46 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Add additional WM8994 GPIO functions
Date: Thu,  8 Jul 2010 21:09:51 +0900
Message-Id: <1278590991-9406-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Later revisions of the WM8994 add some more GPIO functions, define them
in the header file.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/mfd/wm8994/gpio.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/wm8994/gpio.h b/include/linux/mfd/wm8994/gpio.h
index b4d4c22..0c79b5f 100644
--- a/include/linux/mfd/wm8994/gpio.h
+++ b/include/linux/mfd/wm8994/gpio.h
@@ -36,6 +36,10 @@
 #define WM8994_GP_FN_WSEQ_STATUS    16
 #define WM8994_GP_FN_FIFO_ERROR     17
 #define WM8994_GP_FN_OPCLK          18
+#define WM8994_GP_FN_THW	    19
+#define WM8994_GP_FN_DCS_DONE	    20
+#define WM8994_GP_FN_FLL1_OUT       21
+#define WM8994_GP_FN_FLL2_OUT       22
 
 #define WM8994_GPN_DIR                          0x8000  /* GPN_DIR */
 #define WM8994_GPN_DIR_MASK                     0x8000  /* GPN_DIR */
-- 
1.7.1

