Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab2GISde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 14:33:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57878 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752315Ab2GISdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 14:33:19 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] mfd: arizona: Add even more register definitions
Date: Mon,  9 Jul 2012 19:33:15 +0100
Message-Id: <1341858795-27504-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1341858795-27504-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1341858795-27504-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few more registers used on newer devices.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/mfd/arizona/registers.h |  211 ++++++++++++++++++++++++++++++++-
 1 file changed, 210 insertions(+), 1 deletion(-)

diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
index 8f49106d..7671a28 100644
--- a/include/linux/mfd/arizona/registers.h
+++ b/include/linux/mfd/arizona/registers.h
@@ -145,7 +145,7 @@
 #define ARIZONA_IN3R_CONTROL                     0x324
 #define ARIZONA_ADC_DIGITAL_VOLUME_3R            0x325
 #define ARIZONA_DMIC3R_CONTROL                   0x326
-#define ARIZONA_IN4_CONTROL                      0x328
+#define ARIZONA_IN4L_CONTROL                     0x328
 #define ARIZONA_ADC_DIGITAL_VOLUME_4L            0x329
 #define ARIZONA_DMIC4L_CONTROL                   0x32A
 #define ARIZONA_ADC_DIGITAL_VOLUME_4R            0x32D
@@ -2129,6 +2129,14 @@
 /*
  * R768 (0x300) - Input Enables
  */
+#define ARIZONA_IN4L_ENA                         0x0080  /* IN4L_ENA */
+#define ARIZONA_IN4L_ENA_MASK                    0x0080  /* IN4L_ENA */
+#define ARIZONA_IN4L_ENA_SHIFT                        7  /* IN4L_ENA */
+#define ARIZONA_IN4L_ENA_WIDTH                        1  /* IN4L_ENA */
+#define ARIZONA_IN4R_ENA                         0x0040  /* IN4R_ENA */
+#define ARIZONA_IN4R_ENA_MASK                    0x0040  /* IN4R_ENA */
+#define ARIZONA_IN4R_ENA_SHIFT                        6  /* IN4R_ENA */
+#define ARIZONA_IN4R_ENA_WIDTH                        1  /* IN4R_ENA */
 #define ARIZONA_IN3L_ENA                         0x0020  /* IN3L_ENA */
 #define ARIZONA_IN3L_ENA_MASK                    0x0020  /* IN3L_ENA */
 #define ARIZONA_IN3L_ENA_SHIFT                        5  /* IN3L_ENA */
@@ -2373,8 +2381,70 @@
 #define ARIZONA_IN3_DMICR_DLY_WIDTH                   6  /* IN3_DMICR_DLY - [5:0] */
 
 /*
+ * R808 (0x328) - IN4 Control
+ */
+#define ARIZONA_IN4_OSR_MASK                     0x6000  /* IN4_OSR - [14:13] */
+#define ARIZONA_IN4_OSR_SHIFT                        13  /* IN4_OSR - [14:13] */
+#define ARIZONA_IN4_OSR_WIDTH                         2  /* IN4_OSR - [14:13] */
+#define ARIZONA_IN4_DMIC_SUP_MASK                0x1800  /* IN4_DMIC_SUP - [12:11] */
+#define ARIZONA_IN4_DMIC_SUP_SHIFT                   11  /* IN4_DMIC_SUP - [12:11] */
+#define ARIZONA_IN4_DMIC_SUP_WIDTH                    2  /* IN4_DMIC_SUP - [12:11] */
+
+/*
+ * R809 (0x329) - ADC Digital Volume 4L
+ */
+#define ARIZONA_IN_VU                            0x0200  /* IN_VU */
+#define ARIZONA_IN_VU_MASK                       0x0200  /* IN_VU */
+#define ARIZONA_IN_VU_SHIFT                           9  /* IN_VU */
+#define ARIZONA_IN_VU_WIDTH                           1  /* IN_VU */
+#define ARIZONA_IN4L_MUTE                        0x0100  /* IN4L_MUTE */
+#define ARIZONA_IN4L_MUTE_MASK                   0x0100  /* IN4L_MUTE */
+#define ARIZONA_IN4L_MUTE_SHIFT                       8  /* IN4L_MUTE */
+#define ARIZONA_IN4L_MUTE_WIDTH                       1  /* IN4L_MUTE */
+#define ARIZONA_IN4L_DIG_VOL_MASK                0x00FF  /* IN4L_DIG_VOL - [7:0] */
+#define ARIZONA_IN4L_DIG_VOL_SHIFT                    0  /* IN4L_DIG_VOL - [7:0] */
+#define ARIZONA_IN4L_DIG_VOL_WIDTH                    8  /* IN4L_DIG_VOL - [7:0] */
+
+/*
+ * R810 (0x32A) - DMIC4L Control
+ */
+#define ARIZONA_IN4L_DMIC_DLY_MASK               0x003F  /* IN4L_DMIC_DLY - [5:0] */
+#define ARIZONA_IN4L_DMIC_DLY_SHIFT                   0  /* IN4L_DMIC_DLY - [5:0] */
+#define ARIZONA_IN4L_DMIC_DLY_WIDTH                   6  /* IN4L_DMIC_DLY - [5:0] */
+
+/*
+ * R813 (0x32D) - ADC Digital Volume 4R
+ */
+#define ARIZONA_IN_VU                            0x0200  /* IN_VU */
+#define ARIZONA_IN_VU_MASK                       0x0200  /* IN_VU */
+#define ARIZONA_IN_VU_SHIFT                           9  /* IN_VU */
+#define ARIZONA_IN_VU_WIDTH                           1  /* IN_VU */
+#define ARIZONA_IN4R_MUTE                        0x0100  /* IN4R_MUTE */
+#define ARIZONA_IN4R_MUTE_MASK                   0x0100  /* IN4R_MUTE */
+#define ARIZONA_IN4R_MUTE_SHIFT                       8  /* IN4R_MUTE */
+#define ARIZONA_IN4R_MUTE_WIDTH                       1  /* IN4R_MUTE */
+#define ARIZONA_IN4R_DIG_VOL_MASK                0x00FF  /* IN4R_DIG_VOL - [7:0] */
+#define ARIZONA_IN4R_DIG_VOL_SHIFT                    0  /* IN4R_DIG_VOL - [7:0] */
+#define ARIZONA_IN4R_DIG_VOL_WIDTH                    8  /* IN4R_DIG_VOL - [7:0] */
+
+/*
+ * R814 (0x32E) - DMIC4R Control
+ */
+#define ARIZONA_IN4R_DMIC_DLY_MASK               0x003F  /* IN4R_DMIC_DLY - [5:0] */
+#define ARIZONA_IN4R_DMIC_DLY_SHIFT                   0  /* IN4R_DMIC_DLY - [5:0] */
+#define ARIZONA_IN4R_DMIC_DLY_WIDTH                   6  /* IN4R_DMIC_DLY - [5:0] */
+
+/*
  * R1024 (0x400) - Output Enables 1
  */
+#define ARIZONA_OUT6L_ENA                        0x0800  /* OUT6L_ENA */
+#define ARIZONA_OUT6L_ENA_MASK                   0x0800  /* OUT6L_ENA */
+#define ARIZONA_OUT6L_ENA_SHIFT                      11  /* OUT6L_ENA */
+#define ARIZONA_OUT6L_ENA_WIDTH                       1  /* OUT6L_ENA */
+#define ARIZONA_OUT6R_ENA                        0x0400  /* OUT6R_ENA */
+#define ARIZONA_OUT6R_ENA_MASK                   0x0400  /* OUT6R_ENA */
+#define ARIZONA_OUT6R_ENA_SHIFT                      10  /* OUT6R_ENA */
+#define ARIZONA_OUT6R_ENA_WIDTH                       1  /* OUT6R_ENA */
 #define ARIZONA_OUT5L_ENA                        0x0200  /* OUT5L_ENA */
 #define ARIZONA_OUT5L_ENA_MASK                   0x0200  /* OUT5L_ENA */
 #define ARIZONA_OUT5L_ENA_SHIFT                       9  /* OUT5L_ENA */
@@ -2877,6 +2947,82 @@
 #define ARIZONA_OUT5R_NGATE_SRC_WIDTH                12  /* OUT5R_NGATE_SRC - [11:0] */
 
 /*
+ * R1080 (0x438) - Output Path Config 6L
+ */
+#define ARIZONA_OUT6_OSR                         0x2000  /* OUT6_OSR */
+#define ARIZONA_OUT6_OSR_MASK                    0x2000  /* OUT6_OSR */
+#define ARIZONA_OUT6_OSR_SHIFT                       13  /* OUT6_OSR */
+#define ARIZONA_OUT6_OSR_WIDTH                        1  /* OUT6_OSR */
+#define ARIZONA_OUT6L_ANC_SRC_MASK               0x0C00  /* OUT6L_ANC_SRC - [11:10] */
+#define ARIZONA_OUT6L_ANC_SRC_SHIFT                  10  /* OUT6L_ANC_SRC - [11:10] */
+#define ARIZONA_OUT6L_ANC_SRC_WIDTH                   2  /* OUT6L_ANC_SRC - [11:10] */
+
+/*
+ * R1081 (0x439) - DAC Digital Volume 6L
+ */
+#define ARIZONA_OUT_VU                           0x0200  /* OUT_VU */
+#define ARIZONA_OUT_VU_MASK                      0x0200  /* OUT_VU */
+#define ARIZONA_OUT_VU_SHIFT                          9  /* OUT_VU */
+#define ARIZONA_OUT_VU_WIDTH                          1  /* OUT_VU */
+#define ARIZONA_OUT6L_MUTE                       0x0100  /* OUT6L_MUTE */
+#define ARIZONA_OUT6L_MUTE_MASK                  0x0100  /* OUT6L_MUTE */
+#define ARIZONA_OUT6L_MUTE_SHIFT                      8  /* OUT6L_MUTE */
+#define ARIZONA_OUT6L_MUTE_WIDTH                      1  /* OUT6L_MUTE */
+#define ARIZONA_OUT6L_VOL_MASK                   0x00FF  /* OUT6L_VOL - [7:0] */
+#define ARIZONA_OUT6L_VOL_SHIFT                       0  /* OUT6L_VOL - [7:0] */
+#define ARIZONA_OUT6L_VOL_WIDTH                       8  /* OUT6L_VOL - [7:0] */
+
+/*
+ * R1082 (0x43A) - DAC Volume Limit 6L
+ */
+#define ARIZONA_OUT6L_VOL_LIM_MASK               0x00FF  /* OUT6L_VOL_LIM - [7:0] */
+#define ARIZONA_OUT6L_VOL_LIM_SHIFT                   0  /* OUT6L_VOL_LIM - [7:0] */
+#define ARIZONA_OUT6L_VOL_LIM_WIDTH                   8  /* OUT6L_VOL_LIM - [7:0] */
+
+/*
+ * R1083 (0x43B) - Noise Gate Select 6L
+ */
+#define ARIZONA_OUT6L_NGATE_SRC_MASK             0x0FFF  /* OUT6L_NGATE_SRC - [11:0] */
+#define ARIZONA_OUT6L_NGATE_SRC_SHIFT                 0  /* OUT6L_NGATE_SRC - [11:0] */
+#define ARIZONA_OUT6L_NGATE_SRC_WIDTH                12  /* OUT6L_NGATE_SRC - [11:0] */
+
+/*
+ * R1084 (0x43C) - Output Path Config 6R
+ */
+#define ARIZONA_OUT6R_ANC_SRC_MASK               0x0C00  /* OUT6R_ANC_SRC - [11:10] */
+#define ARIZONA_OUT6R_ANC_SRC_SHIFT                  10  /* OUT6R_ANC_SRC - [11:10] */
+#define ARIZONA_OUT6R_ANC_SRC_WIDTH                   2  /* OUT6R_ANC_SRC - [11:10] */
+
+/*
+ * R1085 (0x43D) - DAC Digital Volume 6R
+ */
+#define ARIZONA_OUT_VU                           0x0200  /* OUT_VU */
+#define ARIZONA_OUT_VU_MASK                      0x0200  /* OUT_VU */
+#define ARIZONA_OUT_VU_SHIFT                          9  /* OUT_VU */
+#define ARIZONA_OUT_VU_WIDTH                          1  /* OUT_VU */
+#define ARIZONA_OUT6R_MUTE                       0x0100  /* OUT6R_MUTE */
+#define ARIZONA_OUT6R_MUTE_MASK                  0x0100  /* OUT6R_MUTE */
+#define ARIZONA_OUT6R_MUTE_SHIFT                      8  /* OUT6R_MUTE */
+#define ARIZONA_OUT6R_MUTE_WIDTH                      1  /* OUT6R_MUTE */
+#define ARIZONA_OUT6R_VOL_MASK                   0x00FF  /* OUT6R_VOL - [7:0] */
+#define ARIZONA_OUT6R_VOL_SHIFT                       0  /* OUT6R_VOL - [7:0] */
+#define ARIZONA_OUT6R_VOL_WIDTH                       8  /* OUT6R_VOL - [7:0] */
+
+/*
+ * R1086 (0x43E) - DAC Volume Limit 6R
+ */
+#define ARIZONA_OUT6R_VOL_LIM_MASK               0x00FF  /* OUT6R_VOL_LIM - [7:0] */
+#define ARIZONA_OUT6R_VOL_LIM_SHIFT                   0  /* OUT6R_VOL_LIM - [7:0] */
+#define ARIZONA_OUT6R_VOL_LIM_WIDTH                   8  /* OUT6R_VOL_LIM - [7:0] */
+
+/*
+ * R1087 (0x43F) - Noise Gate Select 6R
+ */
+#define ARIZONA_OUT6R_NGATE_SRC_MASK             0x0FFF  /* OUT6R_NGATE_SRC - [11:0] */
+#define ARIZONA_OUT6R_NGATE_SRC_SHIFT                 0  /* OUT6R_NGATE_SRC - [11:0] */
+#define ARIZONA_OUT6R_NGATE_SRC_WIDTH                12  /* OUT6R_NGATE_SRC - [11:0] */
+
+/*
  * R1104 (0x450) - DAC AEC Control 1
  */
 #define ARIZONA_AEC_LOOPBACK_SRC_MASK            0x003C  /* AEC_LOOPBACK_SRC - [5:2] */
@@ -2933,6 +3079,33 @@
 #define ARIZONA_SPK1_FMT_WIDTH                        1  /* SPK1_FMT */
 
 /*
+ * R1170 (0x492) - PDM SPK2 CTRL 1
+ */
+#define ARIZONA_SPK2R_MUTE                       0x2000  /* SPK2R_MUTE */
+#define ARIZONA_SPK2R_MUTE_MASK                  0x2000  /* SPK2R_MUTE */
+#define ARIZONA_SPK2R_MUTE_SHIFT                     13  /* SPK2R_MUTE */
+#define ARIZONA_SPK2R_MUTE_WIDTH                      1  /* SPK2R_MUTE */
+#define ARIZONA_SPK2L_MUTE                       0x1000  /* SPK2L_MUTE */
+#define ARIZONA_SPK2L_MUTE_MASK                  0x1000  /* SPK2L_MUTE */
+#define ARIZONA_SPK2L_MUTE_SHIFT                     12  /* SPK2L_MUTE */
+#define ARIZONA_SPK2L_MUTE_WIDTH                      1  /* SPK2L_MUTE */
+#define ARIZONA_SPK2_MUTE_ENDIAN                 0x0100  /* SPK2_MUTE_ENDIAN */
+#define ARIZONA_SPK2_MUTE_ENDIAN_MASK            0x0100  /* SPK2_MUTE_ENDIAN */
+#define ARIZONA_SPK2_MUTE_ENDIAN_SHIFT                8  /* SPK2_MUTE_ENDIAN */
+#define ARIZONA_SPK2_MUTE_ENDIAN_WIDTH                1  /* SPK2_MUTE_ENDIAN */
+#define ARIZONA_SPK2_MUTE_SEQ_MASK               0x00FF  /* SPK2_MUTE_SEQ - [7:0] */
+#define ARIZONA_SPK2_MUTE_SEQ_SHIFT                   0  /* SPK2_MUTE_SEQ - [7:0] */
+#define ARIZONA_SPK2_MUTE_SEQ_WIDTH                   8  /* SPK2_MUTE_SEQ - [7:0] */
+
+/*
+ * R1171 (0x493) - PDM SPK2 CTRL 2
+ */
+#define ARIZONA_SPK2_FMT                         0x0001  /* SPK2_FMT */
+#define ARIZONA_SPK2_FMT_MASK                    0x0001  /* SPK2_FMT */
+#define ARIZONA_SPK2_FMT_SHIFT                        0  /* SPK2_FMT */
+#define ARIZONA_SPK2_FMT_WIDTH                        1  /* SPK2_FMT */
+
+/*
  * R1244 (0x4DC) - DAC comp 1
  */
 #define ARIZONA_OUT_COMP_COEFF_MASK              0xFFFF  /* OUT_COMP_COEFF - [15:0] */
@@ -4028,10 +4201,46 @@
 /*
  * R3329 (0xD01) - Interrupt Status 2
  */
+#define ARIZONA_DSP4_RAM_RDY_EINT1               0x0800  /* DSP4_RAM_RDY_EINT1 */
+#define ARIZONA_DSP4_RAM_RDY_EINT1_MASK          0x0800  /* DSP4_RAM_RDY_EINT1 */
+#define ARIZONA_DSP4_RAM_RDY_EINT1_SHIFT             11  /* DSP4_RAM_RDY_EINT1 */
+#define ARIZONA_DSP4_RAM_RDY_EINT1_WIDTH              1  /* DSP4_RAM_RDY_EINT1 */
+#define ARIZONA_DSP3_RAM_RDY_EINT1               0x0400  /* DSP3_RAM_RDY_EINT1 */
+#define ARIZONA_DSP3_RAM_RDY_EINT1_MASK          0x0400  /* DSP3_RAM_RDY_EINT1 */
+#define ARIZONA_DSP3_RAM_RDY_EINT1_SHIFT             10  /* DSP3_RAM_RDY_EINT1 */
+#define ARIZONA_DSP3_RAM_RDY_EINT1_WIDTH              1  /* DSP3_RAM_RDY_EINT1 */
+#define ARIZONA_DSP2_RAM_RDY_EINT1               0x0200  /* DSP2_RAM_RDY_EINT1 */
+#define ARIZONA_DSP2_RAM_RDY_EINT1_MASK          0x0200  /* DSP2_RAM_RDY_EINT1 */
+#define ARIZONA_DSP2_RAM_RDY_EINT1_SHIFT              9  /* DSP2_RAM_RDY_EINT1 */
+#define ARIZONA_DSP2_RAM_RDY_EINT1_WIDTH              1  /* DSP2_RAM_RDY_EINT1 */
 #define ARIZONA_DSP1_RAM_RDY_EINT1               0x0100  /* DSP1_RAM_RDY_EINT1 */
 #define ARIZONA_DSP1_RAM_RDY_EINT1_MASK          0x0100  /* DSP1_RAM_RDY_EINT1 */
 #define ARIZONA_DSP1_RAM_RDY_EINT1_SHIFT              8  /* DSP1_RAM_RDY_EINT1 */
 #define ARIZONA_DSP1_RAM_RDY_EINT1_WIDTH              1  /* DSP1_RAM_RDY_EINT1 */
+#define ARIZONA_DSP_IRQ8_EINT1                   0x0080  /* DSP_IRQ8_EINT1 */
+#define ARIZONA_DSP_IRQ8_EINT1_MASK              0x0080  /* DSP_IRQ8_EINT1 */
+#define ARIZONA_DSP_IRQ8_EINT1_SHIFT                  7  /* DSP_IRQ8_EINT1 */
+#define ARIZONA_DSP_IRQ8_EINT1_WIDTH                  1  /* DSP_IRQ8_EINT1 */
+#define ARIZONA_DSP_IRQ7_EINT1                   0x0040  /* DSP_IRQ7_EINT1 */
+#define ARIZONA_DSP_IRQ7_EINT1_MASK              0x0040  /* DSP_IRQ7_EINT1 */
+#define ARIZONA_DSP_IRQ7_EINT1_SHIFT                  6  /* DSP_IRQ7_EINT1 */
+#define ARIZONA_DSP_IRQ7_EINT1_WIDTH                  1  /* DSP_IRQ7_EINT1 */
+#define ARIZONA_DSP_IRQ6_EINT1                   0x0020  /* DSP_IRQ6_EINT1 */
+#define ARIZONA_DSP_IRQ6_EINT1_MASK              0x0020  /* DSP_IRQ6_EINT1 */
+#define ARIZONA_DSP_IRQ6_EINT1_SHIFT                  5  /* DSP_IRQ6_EINT1 */
+#define ARIZONA_DSP_IRQ6_EINT1_WIDTH                  1  /* DSP_IRQ6_EINT1 */
+#define ARIZONA_DSP_IRQ5_EINT1                   0x0010  /* DSP_IRQ5_EINT1 */
+#define ARIZONA_DSP_IRQ5_EINT1_MASK              0x0010  /* DSP_IRQ5_EINT1 */
+#define ARIZONA_DSP_IRQ5_EINT1_SHIFT                  4  /* DSP_IRQ5_EINT1 */
+#define ARIZONA_DSP_IRQ5_EINT1_WIDTH                  1  /* DSP_IRQ5_EINT1 */
+#define ARIZONA_DSP_IRQ4_EINT1                   0x0008  /* DSP_IRQ4_EINT1 */
+#define ARIZONA_DSP_IRQ4_EINT1_MASK              0x0008  /* DSP_IRQ4_EINT1 */
+#define ARIZONA_DSP_IRQ4_EINT1_SHIFT                  3  /* DSP_IRQ4_EINT1 */
+#define ARIZONA_DSP_IRQ4_EINT1_WIDTH                  1  /* DSP_IRQ4_EINT1 */
+#define ARIZONA_DSP_IRQ3_EINT1                   0x0004  /* DSP_IRQ3_EINT1 */
+#define ARIZONA_DSP_IRQ3_EINT1_MASK              0x0004  /* DSP_IRQ3_EINT1 */
+#define ARIZONA_DSP_IRQ3_EINT1_SHIFT                  2  /* DSP_IRQ3_EINT1 */
+#define ARIZONA_DSP_IRQ3_EINT1_WIDTH                  1  /* DSP_IRQ3_EINT1 */
 #define ARIZONA_DSP_IRQ2_EINT1                   0x0002  /* DSP_IRQ2_EINT1 */
 #define ARIZONA_DSP_IRQ2_EINT1_MASK              0x0002  /* DSP_IRQ2_EINT1 */
 #define ARIZONA_DSP_IRQ2_EINT1_SHIFT                  1  /* DSP_IRQ2_EINT1 */
-- 
1.7.10

