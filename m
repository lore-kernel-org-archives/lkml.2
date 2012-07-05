Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab2GETgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 15:36:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41976 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755773Ab2GETfi (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Thu, 5 Jul 2012 15:35:38 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/6] mfd: arizona: Add more register definitions
Date: Thu,  5 Jul 2012 20:35:28 +0100
Message-Id: <1341516933-16474-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These registers will be used in future devices.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/mfd/arizona/registers.h |  163 +++++++++++++++++++++++++++++++++
 1 file changed, 163 insertions(+)

diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
index 989c47d..8f49106d 100644
--- a/include/linux/mfd/arizona/registers.h
+++ b/include/linux/mfd/arizona/registers.h
@@ -20,6 +20,9 @@
 #define ARIZONA_DEVICE_REVISION                  0x01
 #define ARIZONA_CTRL_IF_SPI_CFG_1                0x08
 #define ARIZONA_CTRL_IF_I2C1_CFG_1               0x09
+#define ARIZONA_CTRL_IF_I2C2_CFG_1               0x0A
+#define ARIZONA_CTRL_IF_I2C1_CFG_2               0x0B
+#define ARIZONA_CTRL_IF_I2C2_CFG_2               0x0C
 #define ARIZONA_CTRL_IF_STATUS_1                 0x0D
 #define ARIZONA_WRITE_SEQUENCER_CTRL_0           0x16
 #define ARIZONA_WRITE_SEQUENCER_CTRL_1           0x17
@@ -80,6 +83,7 @@
 #define ARIZONA_FLL1_CONTROL_5                   0x175
 #define ARIZONA_FLL1_CONTROL_6                   0x176
 #define ARIZONA_FLL1_LOOP_FILTER_TEST_1          0x177
+#define ARIZONA_FLL1_NCO_TEST_0                  0x178
 #define ARIZONA_FLL1_SYNCHRONISER_1              0x181
 #define ARIZONA_FLL1_SYNCHRONISER_2              0x182
 #define ARIZONA_FLL1_SYNCHRONISER_3              0x183
@@ -95,6 +99,7 @@
 #define ARIZONA_FLL2_CONTROL_5                   0x195
 #define ARIZONA_FLL2_CONTROL_6                   0x196
 #define ARIZONA_FLL2_LOOP_FILTER_TEST_1          0x197
+#define ARIZONA_FLL2_NCO_TEST_0                  0x198
 #define ARIZONA_FLL2_SYNCHRONISER_1              0x1A1
 #define ARIZONA_FLL2_SYNCHRONISER_2              0x1A2
 #define ARIZONA_FLL2_SYNCHRONISER_3              0x1A3
@@ -119,6 +124,7 @@
 #define ARIZONA_ISOLATION_CONTROL                0x2CB
 #define ARIZONA_JACK_DETECT_ANALOGUE             0x2D3
 #define ARIZONA_INPUT_ENABLES                    0x300
+#define ARIZONA_INPUT_ENABLES_STATUS             0x301
 #define ARIZONA_INPUT_RATE                       0x308
 #define ARIZONA_INPUT_VOLUME_RAMP                0x309
 #define ARIZONA_IN1L_CONTROL                     0x310
@@ -139,8 +145,14 @@
 #define ARIZONA_IN3R_CONTROL                     0x324
 #define ARIZONA_ADC_DIGITAL_VOLUME_3R            0x325
 #define ARIZONA_DMIC3R_CONTROL                   0x326
+#define ARIZONA_IN4_CONTROL                      0x328
+#define ARIZONA_ADC_DIGITAL_VOLUME_4L            0x329
+#define ARIZONA_DMIC4L_CONTROL                   0x32A
+#define ARIZONA_ADC_DIGITAL_VOLUME_4R            0x32D
+#define ARIZONA_DMIC4R_CONTROL                   0x32E
 #define ARIZONA_OUTPUT_ENABLES_1                 0x400
 #define ARIZONA_OUTPUT_STATUS_1                  0x401
+#define ARIZONA_RAW_OUTPUT_STATUS_1              0x406
 #define ARIZONA_OUTPUT_RATE_1                    0x408
 #define ARIZONA_OUTPUT_VOLUME_RAMP               0x409
 #define ARIZONA_OUTPUT_PATH_CONFIG_1L            0x410
@@ -166,6 +178,7 @@
 #define ARIZONA_OUTPUT_PATH_CONFIG_3R            0x424
 #define ARIZONA_DAC_DIGITAL_VOLUME_3R            0x425
 #define ARIZONA_DAC_VOLUME_LIMIT_3R              0x426
+#define ARIZONA_NOISE_GATE_SELECT_3R             0x427
 #define ARIZONA_OUTPUT_PATH_CONFIG_4L            0x428
 #define ARIZONA_DAC_DIGITAL_VOLUME_4L            0x429
 #define ARIZONA_OUT_VOLUME_4L                    0x42A
@@ -182,10 +195,20 @@
 #define ARIZONA_DAC_DIGITAL_VOLUME_5R            0x435
 #define ARIZONA_DAC_VOLUME_LIMIT_5R              0x436
 #define ARIZONA_NOISE_GATE_SELECT_5R             0x437
+#define ARIZONA_OUTPUT_PATH_CONFIG_6L            0x438
+#define ARIZONA_DAC_DIGITAL_VOLUME_6L            0x439
+#define ARIZONA_DAC_VOLUME_LIMIT_6L              0x43A
+#define ARIZONA_NOISE_GATE_SELECT_6L             0x43B
+#define ARIZONA_OUTPUT_PATH_CONFIG_6R            0x43C
+#define ARIZONA_DAC_DIGITAL_VOLUME_6R            0x43D
+#define ARIZONA_DAC_VOLUME_LIMIT_6R              0x43E
+#define ARIZONA_NOISE_GATE_SELECT_6R             0x43F
 #define ARIZONA_DAC_AEC_CONTROL_1                0x450
 #define ARIZONA_NOISE_GATE_CONTROL               0x458
 #define ARIZONA_PDM_SPK1_CTRL_1                  0x490
 #define ARIZONA_PDM_SPK1_CTRL_2                  0x491
+#define ARIZONA_PDM_SPK2_CTRL_1                  0x492
+#define ARIZONA_PDM_SPK2_CTRL_2                  0x493
 #define ARIZONA_DAC_COMP_1                       0x4DC
 #define ARIZONA_DAC_COMP_2                       0x4DD
 #define ARIZONA_DAC_COMP_3                       0x4DE
@@ -335,6 +358,14 @@
 #define ARIZONA_OUT3LMIX_INPUT_3_VOLUME          0x6A5
 #define ARIZONA_OUT3LMIX_INPUT_4_SOURCE          0x6A6
 #define ARIZONA_OUT3LMIX_INPUT_4_VOLUME          0x6A7
+#define ARIZONA_OUT3RMIX_INPUT_1_SOURCE          0x6A8
+#define ARIZONA_OUT3RMIX_INPUT_1_VOLUME          0x6A9
+#define ARIZONA_OUT3RMIX_INPUT_2_SOURCE          0x6AA
+#define ARIZONA_OUT3RMIX_INPUT_2_VOLUME          0x6AB
+#define ARIZONA_OUT3RMIX_INPUT_3_SOURCE          0x6AC
+#define ARIZONA_OUT3RMIX_INPUT_3_VOLUME          0x6AD
+#define ARIZONA_OUT3RMIX_INPUT_4_SOURCE          0x6AE
+#define ARIZONA_OUT3RMIX_INPUT_4_VOLUME          0x6AF
 #define ARIZONA_OUT4LMIX_INPUT_1_SOURCE          0x6B0
 #define ARIZONA_OUT4LMIX_INPUT_1_VOLUME          0x6B1
 #define ARIZONA_OUT4LMIX_INPUT_2_SOURCE          0x6B2
@@ -367,6 +398,22 @@
 #define ARIZONA_OUT5RMIX_INPUT_3_VOLUME          0x6CD
 #define ARIZONA_OUT5RMIX_INPUT_4_SOURCE          0x6CE
 #define ARIZONA_OUT5RMIX_INPUT_4_VOLUME          0x6CF
+#define ARIZONA_OUT6LMIX_INPUT_1_SOURCE          0x6D0
+#define ARIZONA_OUT6LMIX_INPUT_1_VOLUME          0x6D1
+#define ARIZONA_OUT6LMIX_INPUT_2_SOURCE          0x6D2
+#define ARIZONA_OUT6LMIX_INPUT_2_VOLUME          0x6D3
+#define ARIZONA_OUT6LMIX_INPUT_3_SOURCE          0x6D4
+#define ARIZONA_OUT6LMIX_INPUT_3_VOLUME          0x6D5
+#define ARIZONA_OUT6LMIX_INPUT_4_SOURCE          0x6D6
+#define ARIZONA_OUT6LMIX_INPUT_4_VOLUME          0x6D7
+#define ARIZONA_OUT6RMIX_INPUT_1_SOURCE          0x6D8
+#define ARIZONA_OUT6RMIX_INPUT_1_VOLUME          0x6D9
+#define ARIZONA_OUT6RMIX_INPUT_2_SOURCE          0x6DA
+#define ARIZONA_OUT6RMIX_INPUT_2_VOLUME          0x6DB
+#define ARIZONA_OUT6RMIX_INPUT_3_SOURCE          0x6DC
+#define ARIZONA_OUT6RMIX_INPUT_3_VOLUME          0x6DD
+#define ARIZONA_OUT6RMIX_INPUT_4_SOURCE          0x6DE
+#define ARIZONA_OUT6RMIX_INPUT_4_VOLUME          0x6DF
 #define ARIZONA_AIF1TX1MIX_INPUT_1_SOURCE        0x700
 #define ARIZONA_AIF1TX1MIX_INPUT_1_VOLUME        0x701
 #define ARIZONA_AIF1TX1MIX_INPUT_2_SOURCE        0x702
@@ -645,18 +692,106 @@
 #define ARIZONA_DSP1AUX4MIX_INPUT_1_SOURCE       0x968
 #define ARIZONA_DSP1AUX5MIX_INPUT_1_SOURCE       0x970
 #define ARIZONA_DSP1AUX6MIX_INPUT_1_SOURCE       0x978
+#define ARIZONA_DSP2LMIX_INPUT_1_SOURCE          0x980
+#define ARIZONA_DSP2LMIX_INPUT_1_VOLUME          0x981
+#define ARIZONA_DSP2LMIX_INPUT_2_SOURCE          0x982
+#define ARIZONA_DSP2LMIX_INPUT_2_VOLUME          0x983
+#define ARIZONA_DSP2LMIX_INPUT_3_SOURCE          0x984
+#define ARIZONA_DSP2LMIX_INPUT_3_VOLUME          0x985
+#define ARIZONA_DSP2LMIX_INPUT_4_SOURCE          0x986
+#define ARIZONA_DSP2LMIX_INPUT_4_VOLUME          0x987
+#define ARIZONA_DSP2RMIX_INPUT_1_SOURCE          0x988
+#define ARIZONA_DSP2RMIX_INPUT_1_VOLUME          0x989
+#define ARIZONA_DSP2RMIX_INPUT_2_SOURCE          0x98A
+#define ARIZONA_DSP2RMIX_INPUT_2_VOLUME          0x98B
+#define ARIZONA_DSP2RMIX_INPUT_3_SOURCE          0x98C
+#define ARIZONA_DSP2RMIX_INPUT_3_VOLUME          0x98D
+#define ARIZONA_DSP2RMIX_INPUT_4_SOURCE          0x98E
+#define ARIZONA_DSP2RMIX_INPUT_4_VOLUME          0x98F
+#define ARIZONA_DSP2AUX1MIX_INPUT_1_SOURCE       0x990
+#define ARIZONA_DSP2AUX2MIX_INPUT_1_SOURCE       0x998
+#define ARIZONA_DSP2AUX3MIX_INPUT_1_SOURCE       0x9A0
+#define ARIZONA_DSP2AUX4MIX_INPUT_1_SOURCE       0x9A8
+#define ARIZONA_DSP2AUX5MIX_INPUT_1_SOURCE       0x9B0
+#define ARIZONA_DSP2AUX6MIX_INPUT_1_SOURCE       0x9B8
+#define ARIZONA_DSP3LMIX_INPUT_1_SOURCE          0x9C0
+#define ARIZONA_DSP3LMIX_INPUT_1_VOLUME          0x9C1
+#define ARIZONA_DSP3LMIX_INPUT_2_SOURCE          0x9C2
+#define ARIZONA_DSP3LMIX_INPUT_2_VOLUME          0x9C3
+#define ARIZONA_DSP3LMIX_INPUT_3_SOURCE          0x9C4
+#define ARIZONA_DSP3LMIX_INPUT_3_VOLUME          0x9C5
+#define ARIZONA_DSP3LMIX_INPUT_4_SOURCE          0x9C6
+#define ARIZONA_DSP3LMIX_INPUT_4_VOLUME          0x9C7
+#define ARIZONA_DSP3RMIX_INPUT_1_SOURCE          0x9C8
+#define ARIZONA_DSP3RMIX_INPUT_1_VOLUME          0x9C9
+#define ARIZONA_DSP3RMIX_INPUT_2_SOURCE          0x9CA
+#define ARIZONA_DSP3RMIX_INPUT_2_VOLUME          0x9CB
+#define ARIZONA_DSP3RMIX_INPUT_3_SOURCE          0x9CC
+#define ARIZONA_DSP3RMIX_INPUT_3_VOLUME          0x9CD
+#define ARIZONA_DSP3RMIX_INPUT_4_SOURCE          0x9CE
+#define ARIZONA_DSP3RMIX_INPUT_4_VOLUME          0x9CF
+#define ARIZONA_DSP3AUX1MIX_INPUT_1_SOURCE       0x9D0
+#define ARIZONA_DSP3AUX2MIX_INPUT_1_SOURCE       0x9D8
+#define ARIZONA_DSP3AUX3MIX_INPUT_1_SOURCE       0x9E0
+#define ARIZONA_DSP3AUX4MIX_INPUT_1_SOURCE       0x9E8
+#define ARIZONA_DSP3AUX5MIX_INPUT_1_SOURCE       0x9F0
+#define ARIZONA_DSP3AUX6MIX_INPUT_1_SOURCE       0x9F8
+#define ARIZONA_DSP4LMIX_INPUT_1_SOURCE          0xA00
+#define ARIZONA_DSP4LMIX_INPUT_1_VOLUME          0xA01
+#define ARIZONA_DSP4LMIX_INPUT_2_SOURCE          0xA02
+#define ARIZONA_DSP4LMIX_INPUT_2_VOLUME          0xA03
+#define ARIZONA_DSP4LMIX_INPUT_3_SOURCE          0xA04
+#define ARIZONA_DSP4LMIX_INPUT_3_VOLUME          0xA05
+#define ARIZONA_DSP4LMIX_INPUT_4_SOURCE          0xA06
+#define ARIZONA_DSP4LMIX_INPUT_4_VOLUME          0xA07
+#define ARIZONA_DSP4RMIX_INPUT_1_SOURCE          0xA08
+#define ARIZONA_DSP4RMIX_INPUT_1_VOLUME          0xA09
+#define ARIZONA_DSP4RMIX_INPUT_2_SOURCE          0xA0A
+#define ARIZONA_DSP4RMIX_INPUT_2_VOLUME          0xA0B
+#define ARIZONA_DSP4RMIX_INPUT_3_SOURCE          0xA0C
+#define ARIZONA_DSP4RMIX_INPUT_3_VOLUME          0xA0D
+#define ARIZONA_DSP4RMIX_INPUT_4_SOURCE          0xA0E
+#define ARIZONA_DSP4RMIX_INPUT_4_VOLUME          0xA0F
+#define ARIZONA_DSP4AUX1MIX_INPUT_1_SOURCE       0xA10
+#define ARIZONA_DSP4AUX2MIX_INPUT_1_SOURCE       0xA18
+#define ARIZONA_DSP4AUX3MIX_INPUT_1_SOURCE       0xA20
+#define ARIZONA_DSP4AUX4MIX_INPUT_1_SOURCE       0xA28
+#define ARIZONA_DSP4AUX5MIX_INPUT_1_SOURCE       0xA30
+#define ARIZONA_DSP4AUX6MIX_INPUT_1_SOURCE       0xA38
 #define ARIZONA_ASRC1LMIX_INPUT_1_SOURCE         0xA80
 #define ARIZONA_ASRC1RMIX_INPUT_1_SOURCE         0xA88
 #define ARIZONA_ASRC2LMIX_INPUT_1_SOURCE         0xA90
 #define ARIZONA_ASRC2RMIX_INPUT_1_SOURCE         0xA98
 #define ARIZONA_ISRC1DEC1MIX_INPUT_1_SOURCE      0xB00
 #define ARIZONA_ISRC1DEC2MIX_INPUT_1_SOURCE      0xB08
+#define ARIZONA_ISRC1DEC3MIX_INPUT_1_SOURCE      0xB10
+#define ARIZONA_ISRC1DEC4MIX_INPUT_1_SOURCE      0xB18
 #define ARIZONA_ISRC1INT1MIX_INPUT_1_SOURCE      0xB20
 #define ARIZONA_ISRC1INT2MIX_INPUT_1_SOURCE      0xB28
+#define ARIZONA_ISRC1INT3MIX_INPUT_1_SOURCE      0xB30
+#define ARIZONA_ISRC1INT4MIX_INPUT_1_SOURCE      0xB38
 #define ARIZONA_ISRC2DEC1MIX_INPUT_1_SOURCE      0xB40
 #define ARIZONA_ISRC2DEC2MIX_INPUT_1_SOURCE      0xB48
 #define ARIZONA_ISRC2INT1MIX_INPUT_1_SOURCE      0xB60
 #define ARIZONA_ISRC2INT2MIX_INPUT_1_SOURCE      0xB68
+#define ARIZONA_ISRC1INT3MIX_INPUT_1_SOURCE      0xB30
+#define ARIZONA_ISRC1INT4MIX_INPUT_1_SOURCE      0xB38
+#define ARIZONA_ISRC2DEC1MIX_INPUT_1_SOURCE      0xB40
+#define ARIZONA_ISRC2DEC2MIX_INPUT_1_SOURCE      0xB48
+#define ARIZONA_ISRC2DEC3MIX_INPUT_1_SOURCE      0xB50
+#define ARIZONA_ISRC2DEC4MIX_INPUT_1_SOURCE      0xB58
+#define ARIZONA_ISRC2INT1MIX_INPUT_1_SOURCE      0xB60
+#define ARIZONA_ISRC2INT2MIX_INPUT_1_SOURCE      0xB68
+#define ARIZONA_ISRC2INT3MIX_INPUT_1_SOURCE      0xB70
+#define ARIZONA_ISRC2INT4MIX_INPUT_1_SOURCE      0xB78
+#define ARIZONA_ISRC3DEC1MIX_INPUT_1_SOURCE      0xB80
+#define ARIZONA_ISRC3DEC2MIX_INPUT_1_SOURCE      0xB88
+#define ARIZONA_ISRC3DEC3MIX_INPUT_1_SOURCE      0xB90
+#define ARIZONA_ISRC3DEC4MIX_INPUT_1_SOURCE      0xB98
+#define ARIZONA_ISRC3INT1MIX_INPUT_1_SOURCE      0xBA0
+#define ARIZONA_ISRC3INT2MIX_INPUT_1_SOURCE      0xBA8
+#define ARIZONA_ISRC3INT3MIX_INPUT_1_SOURCE      0xBB0
+#define ARIZONA_ISRC3INT4MIX_INPUT_1_SOURCE      0xBB8
 #define ARIZONA_GPIO1_CTRL                       0xC00
 #define ARIZONA_GPIO2_CTRL                       0xC01
 #define ARIZONA_GPIO3_CTRL                       0xC02
@@ -670,6 +805,18 @@
 #define ARIZONA_MISC_PAD_CTRL_4                  0xC23
 #define ARIZONA_MISC_PAD_CTRL_5                  0xC24
 #define ARIZONA_MISC_PAD_CTRL_6                  0xC25
+#define ARIZONA_MISC_PAD_CTRL_7                  0xC30
+#define ARIZONA_MISC_PAD_CTRL_8                  0xC31
+#define ARIZONA_MISC_PAD_CTRL_9                  0xC32
+#define ARIZONA_MISC_PAD_CTRL_10                 0xC33
+#define ARIZONA_MISC_PAD_CTRL_11                 0xC34
+#define ARIZONA_MISC_PAD_CTRL_12                 0xC35
+#define ARIZONA_MISC_PAD_CTRL_13                 0xC36
+#define ARIZONA_MISC_PAD_CTRL_14                 0xC37
+#define ARIZONA_MISC_PAD_CTRL_15                 0xC38
+#define ARIZONA_MISC_PAD_CTRL_16                 0xC39
+#define ARIZONA_MISC_PAD_CTRL_17                 0xC3A
+#define ARIZONA_MISC_PAD_CTRL_18                 0xC3B
 #define ARIZONA_INTERRUPT_STATUS_1               0xD00
 #define ARIZONA_INTERRUPT_STATUS_2               0xD01
 #define ARIZONA_INTERRUPT_STATUS_3               0xD02
@@ -813,6 +960,7 @@
 #define ARIZONA_HPLPF4_1                         0xECC
 #define ARIZONA_HPLPF4_2                         0xECD
 #define ARIZONA_ASRC_ENABLE                      0xEE0
+#define ARIZONA_ASRC_STATUS                      0xEE1
 #define ARIZONA_ASRC_RATE1                       0xEE2
 #define ARIZONA_ASRC_RATE2                       0xEE3
 #define ARIZONA_ISRC_1_CTRL_1                    0xEF0
@@ -824,10 +972,25 @@
 #define ARIZONA_ISRC_3_CTRL_1                    0xEF6
 #define ARIZONA_ISRC_3_CTRL_2                    0xEF7
 #define ARIZONA_ISRC_3_CTRL_3                    0xEF8
+#define ARIZONA_CLOCK_CONTROL                    0xF00
+#define ARIZONA_ANC_SRC                          0xF01
+#define ARIZONA_DSP_STATUS                       0xF02
 #define ARIZONA_DSP1_CONTROL_1                   0x1100
 #define ARIZONA_DSP1_CLOCKING_1                  0x1101
 #define ARIZONA_DSP1_STATUS_1                    0x1104
 #define ARIZONA_DSP1_STATUS_2                    0x1105
+#define ARIZONA_DSP2_CONTROL_1                   0x1200
+#define ARIZONA_DSP2_CLOCKING_1                  0x1201
+#define ARIZONA_DSP2_STATUS_1                    0x1204
+#define ARIZONA_DSP2_STATUS_2                    0x1205
+#define ARIZONA_DSP3_CONTROL_1                   0x1300
+#define ARIZONA_DSP3_CLOCKING_1                  0x1301
+#define ARIZONA_DSP3_STATUS_1                    0x1304
+#define ARIZONA_DSP3_STATUS_2                    0x1305
+#define ARIZONA_DSP4_CONTROL_1                   0x1400
+#define ARIZONA_DSP4_CLOCKING_1                  0x1401
+#define ARIZONA_DSP4_STATUS_1                    0x1404
+#define ARIZONA_DSP4_STATUS_2                    0x1405
 
 /*
  * Field Definitions.
-- 
1.7.10

