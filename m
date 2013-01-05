Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab3AEOOS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 09:14:18 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:63333 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab3AEOOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 09:14:16 -0500
From: Lijo Antony <lijo.kernel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Lijo Antony <lijo.kernel@gmail.com>
Subject: [PATCH 2/2] Staging: comedi: addi_common.h: checkpatch.pl fixes
Date: Sat,  5 Jan 2013 18:12:55 +0400
Message-Id: <1357395175-6077-2-git-send-email-lijo.kernel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357395175-6077-1-git-send-email-lijo.kernel@gmail.com>
References: <1357395175-6077-1-git-send-email-lijo.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduced line lengths to 80 chars by removing extra spaces.

Signed-off-by: Lijo Antony <lijo.kernel@gmail.com>
---
 .../staging/comedi/drivers/addi-data/addi_common.h |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.h b/drivers/staging/comedi/drivers/addi-data/addi_common.h
index 6d8b29f94..1996a68 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.h
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.h
@@ -298,7 +298,7 @@ struct addi_private {
 	unsigned char b_AiInitialisation;
 	unsigned int ui_AiActualScan;	/* how many scans we finished */
 	unsigned int ui_AiBufferPtr;	/*  data buffer ptr in samples */
-	unsigned int ui_AiNbrofChannels;	/*  how many channels is measured */
+	unsigned int ui_AiNbrofChannels; /*  how many channels is measured */
 	unsigned int ui_AiScanLength;	/*  Length of actual scanlist */
 	unsigned int ui_AiActualScanPosition;	/*  position in actual scan */
 	unsigned int *pui_AiChannelList;	/*  actual chanlist */
@@ -313,14 +313,14 @@ struct addi_private {
 	short *AiData;	/*  Pointer to sample data */
 	unsigned int ui_AiNbrofScans;	/*  number of scans to do */
 	unsigned short us_UseDma;	/*  To use Dma or not */
-	unsigned char b_DmaDoubleBuffer;	/*  we can use double buffering */
+	unsigned char b_DmaDoubleBuffer; /*  we can use double buffering */
 	unsigned int ui_DmaActualBuffer;	/*  which buffer is used now */
 	/* UPDATE-0.7.57->0.7.68 */
 	/* unsigned int               ul_DmaBufferVirtual[2]; pointers to begin of DMA buffer */
 	short *ul_DmaBufferVirtual[2];	/*  pointers to begin of DMA buffer */
 	unsigned int ul_DmaBufferHw[2];	/*  hw address of DMA buff */
-	unsigned int ui_DmaBufferSize[2];	/*  size of dma buffer in bytes */
-	unsigned int ui_DmaBufferUsesize[2];	/*  which size we may now used for transfer */
+	unsigned int ui_DmaBufferSize[2]; /*  size of dma buffer in bytes */
+	unsigned int ui_DmaBufferUsesize[2]; /* size we may use for transfer */
 	unsigned int ui_DmaBufferSamples[2];	/*  size in samples */
 	unsigned int ui_DmaBufferPages[2];	/*  number of pages in buffer */
 	unsigned char b_DigitalOutputRegister;	/*  Digital Output Register */
@@ -331,13 +331,13 @@ struct addi_private {
 	unsigned char b_ModeSelectRegister;	/*  Contain data written at iobase + 0E */
 	unsigned short us_OutputRegister;	/*  Contain data written at iobase + 0 */
 	unsigned char b_InterruptState;
-	unsigned char b_TimerInit;	/*  Specify if InitTimerWatchdog was load */
-	unsigned char b_TimerStarted;	/*  Specify if timer 2 is running or not */
+	unsigned char b_TimerInit; /*  Specify if InitTimerWatchdog was load */
+	unsigned char b_TimerStarted; /* Specify if timer 2 is running or not */
 	unsigned char b_Timer2Mode;	/*  Specify the timer 2 mode */
 	unsigned char b_Timer2Interrupt;	/* Timer2  interrupt enable or disable */
-	unsigned char b_AiCyclicAcquisition;	/*  indicate cyclic acquisition */
+	unsigned char b_AiCyclicAcquisition; /*  indicate cyclic acquisition */
 	unsigned char b_InterruptMode;	/*  eoc eos or dma */
-	unsigned char b_EocEosInterrupt;	/*  Enable disable eoc eos interrupt */
+	unsigned char b_EocEosInterrupt; /*  Enable disable eoc eos interrupt */
 	unsigned int ui_EocEosConversionTime;
 	unsigned char b_EocEosConversionTimeBase;
 	unsigned char b_SingelDiff;
@@ -353,7 +353,7 @@ struct addi_private {
 		unsigned char b_InterruptNbr;	/* Board interrupt number */
 		unsigned char b_SlotNumber;	/* PCI slot number */
 		unsigned char b_BoardVersion;
-		unsigned int dw_MolduleConfiguration[4];	/* Module config */
+		unsigned int dw_MolduleConfiguration[4];  /* Module config */
 	} s_BoardInfos;
 
 	/* Interrupt infos */
@@ -364,7 +364,7 @@ struct addi_private {
 		unsigned int ui_Write;	/* Write FIFO */
 		struct {
 			unsigned char b_OldModuleMask;
-			unsigned int ul_OldInterruptMask;	/* Interrupt mask */
+			unsigned int ul_OldInterruptMask;  /* Interrupt mask */
 			unsigned int ul_OldCounterLatchValue;	/* Interrupt counter value */
 		} s_FIFOInterruptParameters[APCI1710_SAVE_INTERRUPT];
 	} s_InterruptParameters;
-- 
1.7.10.4

