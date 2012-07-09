Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab2GICAP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 22:00:15 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:54236 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab2GIB7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 21:59:31 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: andriy.shevchenko@linux.intel.com, jj@chaosbits.net,
        forest@alittletooquiet.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 1/5] staging: vt6656: desc.h: Remove commented macros and useless comments
Date: Sun,  8 Jul 2012 22:55:46 -0300
Message-Id: <1341798950-11215-2-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341798950-11215-1-git-send-email-marcos.souza.org@gmail.com>
References: <1341798950-11215-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commented macros are reported by forgotten-macros
tool(https://github.com/marcosps/forgotten_macros).

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/vt6656/desc.h |   19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/staging/vt6656/desc.h b/drivers/staging/vt6656/desc.h
index 767112b..b68b2ec 100644
--- a/drivers/staging/vt6656/desc.h
+++ b/drivers/staging/vt6656/desc.h
@@ -36,8 +36,6 @@
 #include "ttype.h"
 #include "tether.h"
 
-/*---------------------  Export Definitions -------------------------*/
-
 // max transmit or receive buffer size
 #define CB_MAX_BUF_SIZE     2900U       // max buffer size
                                         // NOTE: must be multiple of 4
@@ -120,17 +118,11 @@
 #define FRAGCTL_TKIP        0x0200 // 0000 0010 0000 0000
 #define FRAGCTL_LEGACY      0x0100 // 0000 0001 0000 0000
 #define FRAGCTL_NONENCRYPT  0x0000 // 0000 0000 0000 0000
-//#define FRAGCTL_AC3         0x000C // 0000 0000 0000 1100
-//#define FRAGCTL_AC2         0x0008 // 0000 0000 0000 1000
-//#define FRAGCTL_AC1         0x0004 // 0000 0000 0000 0100
-//#define FRAGCTL_AC0         0x0000 // 0000 0000 0000 0000
 #define FRAGCTL_ENDFRAG     0x0003 // 0000 0000 0000 0011
 #define FRAGCTL_MIDFRAG     0x0002 // 0000 0000 0000 0010
 #define FRAGCTL_STAFRAG     0x0001 // 0000 0000 0000 0001
 #define FRAGCTL_NONFRAG     0x0000 // 0000 0000 0000 0000
 
-//#define TYPE_AC0DMA     0
-//#define TYPE_TXDMA0     1
 #define TYPE_TXDMA0     0
 #define TYPE_AC0DMA     1
 #define TYPE_ATIMDMA    2
@@ -147,9 +139,6 @@
 #define TD_FLAGS_NETIF_SKB               0x01       // check if need release skb
 #define TD_FLAGS_PRIV_SKB                0x02       // check if called from private skb(hostap)
 #define TD_FLAGS_PS_RETRY                0x04       // check if PS STA frame re-transmit
-//#define TD_FLAGS_NETIF_SKB                0x04
-
-/*---------------------  Export Types  ------------------------------*/
 
 //
 // RsvTime buffer header
@@ -268,7 +257,6 @@ SRTS_a_FB, *PSRTS_a_FB;
 
 typedef const SRTS_a_FB *PCSRTS_a_FB;
 
-
 //
 // CTS buffer header
 //
@@ -421,12 +409,5 @@ typedef struct tagSKeyEntry {
     DWORD dwKey4[4];
 } __attribute__ ((__packed__))
 SKeyEntry;
-/*---------------------  Export Macros ------------------------------*/
-
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
 
 #endif /* __DESC_H__ */
-- 
1.7.10.4

