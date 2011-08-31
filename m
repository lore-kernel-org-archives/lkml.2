Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab1HaMEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 08:04:34 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:64993 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab1HaMEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 08:04:32 -0400
From: Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
Subject: [PATCH 3/3] Staging: comedi: fix line over 80 character issue in cb_pcidas64.c
Date: Wed, 31 Aug 2011 17:34:18 +0530
Message-Id: <1314792258-3099-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH 3/3]Staging: comedi: fix line over 80 character issue in cb_pcidas64.c>
References: <[PATCH 3/3]Staging: comedi: fix line over 80 character issue in cb_pcidas64.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidas64.c file that fixes up a line over 80 character warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidas64.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 3a8a8ea..e4c37cb 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -104,7 +104,8 @@ TODO:
 #endif
 
 #define TIMER_BASE 25		/*  40MHz master clock */
-#define PRESCALED_TIMER_BASE	10000	/*  100kHz 'prescaled' clock for slow acquisition, maybe I'll support this someday */
+/* 100kHz 'prescaled' clock for slow acquisition maybe I'll support this someday */
+#define PRESCALED_TIMER_BASE    10000
 #define DMA_BUFFER_SIZE 0x1000
 
 #define PCI_VENDOR_ID_COMPUTERBOARDS	0x1307
@@ -141,7 +142,9 @@ enum write_only_registers {
 	ADC_QUEUE_CLEAR_REG = 0x26,	/*  clears adc queue */
 	ADC_QUEUE_LOAD_REG = 0x28,	/*  loads adc queue */
 	ADC_BUFFER_CLEAR_REG = 0x2a,
-	ADC_QUEUE_HIGH_REG = 0x2c,	/*  high channel for internal queue, use adc_chan_bits() inline above */
+	ADC_QUEUE_HIGH_REG = 0x2c,	/*  high channel for internal queue, use
+					 *  adc_chan_bits() inline above
+					 */
 	DAC_CONTROL0_REG = 0x50,	/*  dac control register 0 */
 	DAC_CONTROL1_REG = 0x52,	/*  dac control register 0 */
 	DAC_SAMPLE_INTERVAL_LOWER_REG = 0x54,	/*  lower 16 bits of dac sample interval counter */
@@ -166,7 +169,9 @@ static inline unsigned int dac_msb_4020_reg(unsigned int channel)
 }
 
 enum read_only_registers {
-	HW_STATUS_REG = 0x0,	/*  hardware status register, reading this apparently clears pending interrupts as well */
+	HW_STATUS_REG = 0x0,	/*  hardware status register, reading this
+				 *  apparently clears pending interrupts as well
+				 */
 	PIPE1_READ_REG = 0x4,
 	ADC_READ_PNTR_REG = 0x8,
 	LOWER_XFER_REG = 0x10,
@@ -197,7 +202,9 @@ enum intr_enable_contents {
 	ADC_INTR_QFULL_BITS = 0x0,	/*  interrupt fifo quater full */
 	ADC_INTR_EOC_BITS = 0x1,	/*  interrupt end of conversion */
 	ADC_INTR_EOSCAN_BITS = 0x2,	/*  interrupt end of scan */
-	ADC_INTR_EOSEQ_BITS = 0x3,	/*  interrupt end of sequence (probably wont use this it's pretty fancy) */
+	ADC_INTR_EOSEQ_BITS = 0x3,	/*  interrupt end of sequence (probably wont use this
+					 *  it's pretty fancy)
+					 */
 	EN_ADC_INTR_SRC_BIT = 0x4,	/*  enable adc interrupt source */
 	EN_ADC_DONE_INTR_BIT = 0x8,	/*  enable adc acquisition done interrupt */
 	DAC_INTR_SRC_MASK = 0x30,
-- 
1.6.5.2

