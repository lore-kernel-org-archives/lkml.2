Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab1FUKOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 06:14:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49056 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751516Ab1FUKOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 06:14:22 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Add WM831x clock control register definitions
Date: Tue, 21 Jun 2011 11:12:23 +0100
Message-Id: <1308651143-23450-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20110621130331.368aaf74.sfr@canb.auug.org.au>
References: <20110621130331.368aaf74.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/mfd/wm831x/core.h |  101 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 101 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/wm831x/core.h b/include/linux/mfd/wm831x/core.h
index ebead1c..1d93cbe 100644
--- a/include/linux/mfd/wm831x/core.h
+++ b/include/linux/mfd/wm831x/core.h
@@ -234,6 +234,107 @@
 #define WM831X_ON_PIN_TO_SHIFT                       0  /* ON_PIN_TO - [1:0] */
 #define WM831X_ON_PIN_TO_WIDTH                       2  /* ON_PIN_TO - [1:0] */
 
+/*
+ * R16528 (0x4090) - Clock Control 1
+ */
+#define WM831X_CLKOUT_ENA                       0x8000  /* CLKOUT_ENA */
+#define WM831X_CLKOUT_ENA_MASK                  0x8000  /* CLKOUT_ENA */
+#define WM831X_CLKOUT_ENA_SHIFT                     15  /* CLKOUT_ENA */
+#define WM831X_CLKOUT_ENA_WIDTH                      1  /* CLKOUT_ENA */
+#define WM831X_CLKOUT_OD                        0x2000  /* CLKOUT_OD */
+#define WM831X_CLKOUT_OD_MASK                   0x2000  /* CLKOUT_OD */
+#define WM831X_CLKOUT_OD_SHIFT                      13  /* CLKOUT_OD */
+#define WM831X_CLKOUT_OD_WIDTH                       1  /* CLKOUT_OD */
+#define WM831X_CLKOUT_SLOT_MASK                 0x0700  /* CLKOUT_SLOT - [10:8] */
+#define WM831X_CLKOUT_SLOT_SHIFT                     8  /* CLKOUT_SLOT - [10:8] */
+#define WM831X_CLKOUT_SLOT_WIDTH                     3  /* CLKOUT_SLOT - [10:8] */
+#define WM831X_CLKOUT_SLPSLOT_MASK              0x0070  /* CLKOUT_SLPSLOT - [6:4] */
+#define WM831X_CLKOUT_SLPSLOT_SHIFT                  4  /* CLKOUT_SLPSLOT - [6:4] */
+#define WM831X_CLKOUT_SLPSLOT_WIDTH                  3  /* CLKOUT_SLPSLOT - [6:4] */
+#define WM831X_CLKOUT_SRC                       0x0001  /* CLKOUT_SRC */
+#define WM831X_CLKOUT_SRC_MASK                  0x0001  /* CLKOUT_SRC */
+#define WM831X_CLKOUT_SRC_SHIFT                      0  /* CLKOUT_SRC */
+#define WM831X_CLKOUT_SRC_WIDTH                      1  /* CLKOUT_SRC */
+
+/*
+ * R16529 (0x4091) - Clock Control 2
+ */
+#define WM831X_XTAL_INH                         0x8000  /* XTAL_INH */
+#define WM831X_XTAL_INH_MASK                    0x8000  /* XTAL_INH */
+#define WM831X_XTAL_INH_SHIFT                       15  /* XTAL_INH */
+#define WM831X_XTAL_INH_WIDTH                        1  /* XTAL_INH */
+#define WM831X_XTAL_ENA                         0x2000  /* XTAL_ENA */
+#define WM831X_XTAL_ENA_MASK                    0x2000  /* XTAL_ENA */
+#define WM831X_XTAL_ENA_SHIFT                       13  /* XTAL_ENA */
+#define WM831X_XTAL_ENA_WIDTH                        1  /* XTAL_ENA */
+#define WM831X_XTAL_BKUPENA                     0x1000  /* XTAL_BKUPENA */
+#define WM831X_XTAL_BKUPENA_MASK                0x1000  /* XTAL_BKUPENA */
+#define WM831X_XTAL_BKUPENA_SHIFT                   12  /* XTAL_BKUPENA */
+#define WM831X_XTAL_BKUPENA_WIDTH                    1  /* XTAL_BKUPENA */
+#define WM831X_FLL_AUTO                         0x0080  /* FLL_AUTO */
+#define WM831X_FLL_AUTO_MASK                    0x0080  /* FLL_AUTO */
+#define WM831X_FLL_AUTO_SHIFT                        7  /* FLL_AUTO */
+#define WM831X_FLL_AUTO_WIDTH                        1  /* FLL_AUTO */
+#define WM831X_FLL_AUTO_FREQ_MASK               0x0007  /* FLL_AUTO_FREQ - [2:0] */
+#define WM831X_FLL_AUTO_FREQ_SHIFT                   0  /* FLL_AUTO_FREQ - [2:0] */
+#define WM831X_FLL_AUTO_FREQ_WIDTH                   3  /* FLL_AUTO_FREQ - [2:0] */
+
+/*
+ * R16530 (0x4092) - FLL Control 1
+ */
+#define WM831X_FLL_FRAC                         0x0004  /* FLL_FRAC */
+#define WM831X_FLL_FRAC_MASK                    0x0004  /* FLL_FRAC */
+#define WM831X_FLL_FRAC_SHIFT                        2  /* FLL_FRAC */
+#define WM831X_FLL_FRAC_WIDTH                        1  /* FLL_FRAC */
+#define WM831X_FLL_OSC_ENA                      0x0002  /* FLL_OSC_ENA */
+#define WM831X_FLL_OSC_ENA_MASK                 0x0002  /* FLL_OSC_ENA */
+#define WM831X_FLL_OSC_ENA_SHIFT                     1  /* FLL_OSC_ENA */
+#define WM831X_FLL_OSC_ENA_WIDTH                     1  /* FLL_OSC_ENA */
+#define WM831X_FLL_ENA                          0x0001  /* FLL_ENA */
+#define WM831X_FLL_ENA_MASK                     0x0001  /* FLL_ENA */
+#define WM831X_FLL_ENA_SHIFT                         0  /* FLL_ENA */
+#define WM831X_FLL_ENA_WIDTH                         1  /* FLL_ENA */
+
+/*
+ * R16531 (0x4093) - FLL Control 2
+ */
+#define WM831X_FLL_OUTDIV_MASK                  0x3F00  /* FLL_OUTDIV - [13:8] */
+#define WM831X_FLL_OUTDIV_SHIFT                      8  /* FLL_OUTDIV - [13:8] */
+#define WM831X_FLL_OUTDIV_WIDTH                      6  /* FLL_OUTDIV - [13:8] */
+#define WM831X_FLL_CTRL_RATE_MASK               0x0070  /* FLL_CTRL_RATE - [6:4] */
+#define WM831X_FLL_CTRL_RATE_SHIFT                   4  /* FLL_CTRL_RATE - [6:4] */
+#define WM831X_FLL_CTRL_RATE_WIDTH                   3  /* FLL_CTRL_RATE - [6:4] */
+#define WM831X_FLL_FRATIO_MASK                  0x0007  /* FLL_FRATIO - [2:0] */
+#define WM831X_FLL_FRATIO_SHIFT                      0  /* FLL_FRATIO - [2:0] */
+#define WM831X_FLL_FRATIO_WIDTH                      3  /* FLL_FRATIO - [2:0] */
+
+/*
+ * R16532 (0x4094) - FLL Control 3
+ */
+#define WM831X_FLL_K_MASK                       0xFFFF  /* FLL_K - [15:0] */
+#define WM831X_FLL_K_SHIFT                           0  /* FLL_K - [15:0] */
+#define WM831X_FLL_K_WIDTH                          16  /* FLL_K - [15:0] */
+
+/*
+ * R16533 (0x4095) - FLL Control 4
+ */
+#define WM831X_FLL_N_MASK                       0x7FE0  /* FLL_N - [14:5] */
+#define WM831X_FLL_N_SHIFT                           5  /* FLL_N - [14:5] */
+#define WM831X_FLL_N_WIDTH                          10  /* FLL_N - [14:5] */
+#define WM831X_FLL_GAIN_MASK                    0x000F  /* FLL_GAIN - [3:0] */
+#define WM831X_FLL_GAIN_SHIFT                        0  /* FLL_GAIN - [3:0] */
+#define WM831X_FLL_GAIN_WIDTH                        4  /* FLL_GAIN - [3:0] */
+
+/*
+ * R16534 (0x4096) - FLL Control 5
+ */
+#define WM831X_FLL_CLK_REF_DIV_MASK             0x0018  /* FLL_CLK_REF_DIV - [4:3] */
+#define WM831X_FLL_CLK_REF_DIV_SHIFT                 3  /* FLL_CLK_REF_DIV - [4:3] */
+#define WM831X_FLL_CLK_REF_DIV_WIDTH                 2  /* FLL_CLK_REF_DIV - [4:3] */
+#define WM831X_FLL_CLK_SRC_MASK                 0x0003  /* FLL_CLK_SRC - [1:0] */
+#define WM831X_FLL_CLK_SRC_SHIFT                     0  /* FLL_CLK_SRC - [1:0] */
+#define WM831X_FLL_CLK_SRC_WIDTH                     2  /* FLL_CLK_SRC - [1:0] */
+
 struct regulator_dev;
 
 #define WM831X_NUM_IRQ_REGS 5
-- 
1.7.5.4

