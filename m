Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab2GICy0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 22:54:26 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41690 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab2GICyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 22:54:23 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: andriy.shevchenko@linux.intel.com, jj@chaosbits.net,
        forest@alittletooquiet.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 2/6] staging: vt6655: mac.h: Remove all commented macros
Date: Sun,  8 Jul 2012 23:51:22 -0300
Message-Id: <1341802286-28281-3-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341802286-28281-1-git-send-email-marcos.souza.org@gmail.com>
References: <1341802286-28281-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These macros were reported by forgotten-macros tool
(https://github.com/marcosps/forgotten_macros).

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/vt6655/mac.h |   24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/staging/vt6655/mac.h b/drivers/staging/vt6655/mac.h
index b96d27e..e3ccfee 100644
--- a/drivers/staging/vt6655/mac.h
+++ b/drivers/staging/vt6655/mac.h
@@ -292,19 +292,11 @@
 //
 #define EnCFG_BarkerPream   0x00020000
 #define EnCFG_NXTBTTCFPSTR  0x00010000
-//#define EnCFG_TXLMT3UPDATE  0x00008000
-//#define EnCFG_TXLMT2UPDATE  0x00004000
-//#define EnCFG_TXLMT1UPDATE  0x00002000
-//#define EnCFG_TXLMT3EN      0x00001000
-//#define EnCFG_TXLMT2EN      0x00000800
-//#define EnCFG_TXLMT1EN      0x00000400
 #define EnCFG_BcnSusClr     0x00000200
 #define EnCFG_BcnSusInd     0x00000100
-//#define EnCFG_CWOFF1        0x00000080
 #define EnCFG_CFP_ProtectEn 0x00000040
 #define EnCFG_ProtectMd     0x00000020
 #define EnCFG_HwParCFP      0x00000010
-//#define EnCFG_QOS           0x00000008
 #define EnCFG_CFNULRSP      0x00000004
 #define EnCFG_BBType_MASK   0x00000003
 #define EnCFG_BBType_g      0x00000002
@@ -392,14 +384,6 @@
 #define IMR_RADARDETECT     0x10000000      //
 #define IMR_MEASUREEND      0x08000000      //
 #define IMR_SOFTTIMER1      0x00200000      //
-//#define IMR_SYNCFLUSHOK     0x00100000      //
-//#define IMR_ATIMEND         0x00080000      //0000 1000 0000 0000 0000 0000
-//#define IMR_CFPEND          0x00040000      //0000 0100 0000 0000 0000 0000
-//#define IMR_AC3DMA          0x00020000      //0000 0010 0000 0000 0000 0000
-//#define IMR_AC2DMA          0x00010000      //0000 0001 0000 0000 0000 0000
-//#define IMR_AC1DMA          0x00008000      //0000 0000 1000 0000 0000 0000
-//#define IMR_SYNCTX          0x00004000      //0000 0000 0100 0000 0000 0000
-//#define IMR_ATIMTX          0x00002000      //0000 0000 0010 0000 0000 0000
 #define IMR_RXDMA1          0x00001000      //0000 0000 0001 0000 0000 0000
 #define IMR_RXNOBUF         0x00000800      //
 #define IMR_MIBNEARFULL     0x00000400      //
@@ -424,14 +408,6 @@
 #define ISR_RADARDETECT     0x10000000      //
 #define ISR_MEASUREEND      0x08000000      //
 #define ISR_SOFTTIMER1      0x00200000      //
-//#define ISR_SYNCFLUSHOK     0x00100000      //0001 0000 0000 0000 0000 0000
-//#define ISR_ATIMEND         0x00080000      //0000 1000 0000 0000 0000 0000
-//#define ISR_CFPEND          0x00040000      //0000 0100 0000 0000 0000 0000
-//#define ISR_AC3DMA          0x00020000      //0000 0010 0000 0000 0000 0000
-//#define ISR_AC2DMA          0x00010000      //0000 0001 0000 0000 0000 0000
-//#define ISR_AC1DMA          0x00008000      //0000 0000 1000 0000 0000 0000
-//#define ISR_SYNCTX          0x00004000      //0000 0000 0100 0000 0000 0000
-//#define ISR_ATIMTX          0x00002000      //0000 0000 0010 0000 0000 0000
 #define ISR_RXDMA1          0x00001000      //0000 0000 0001 0000 0000 0000
 #define ISR_RXNOBUF         0x00000800      //0000 0000 0000 1000 0000 0000
 #define ISR_MIBNEARFULL     0x00000400      //0000 0000 0000 0100 0000 0000
-- 
1.7.10.4

