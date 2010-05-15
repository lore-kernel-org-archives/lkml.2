Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab0EOImH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 04:42:07 -0400
Received: from penguin.host-ns.co.uk ([213.229.84.196]:55064 "EHLO
	penguin.host-ns.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab0EOImF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 04:42:05 -0400
Subject: Patch for Drivers:Staging:winbond:mds.c
From: Adam Latham <adam.latham@unisontorbay.org.uk>
Reply-To: adam.latham@unisontorbay.org.uk
To: gregkh@suse.de, pavel@ucw.cz, penberg@cs.helsinki.fi, diegoliz@gmail.com,
       mike@mikeasoft.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 May 2010 09:38:44 +0100
Message-ID: <1273912724.3925.2.camel@ubuntu.ubuntu-domain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - penguin.host-ns.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - unisontorbay.org.uk
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 684e3064727e1334d47cb73833205593cd3b1d7d Mon Sep 17 00:00:00 2001
From: Adam Latham <adam.latham@unisontorbay.org.uk>
Date: Sat, 15 May 2010 09:31:01 +0100
Subject: [PATCH] Staging: winbond: Fix for pointer name format issue in mds.c

This patch fixes the unnecessary whitespace found in pointer names in the mds.c
file found by the checkpatch.pl tool

Signed-off-by: Adam Latham <adam.latham@unisontorbay.org.uk>
---
 drivers/staging/winbond/mds.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index 65063c3..e8320a6 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -6,7 +6,7 @@
 #include "wblinux_f.h"
 
 unsigned char
-Mds_initial(struct wbsoft_priv * adapter)
+Mds_initial(struct wbsoft_priv *adapter)
 {
 	struct wb35_mds *pMds = &adapter->Mds;
 
@@ -18,7 +18,7 @@ Mds_initial(struct wbsoft_priv * adapter)
 }
 
 void
-Mds_Destroy(struct wbsoft_priv * adapter)
+Mds_Destroy(struct wbsoft_priv *adapter)
 {
 }
 
@@ -318,7 +318,7 @@ static u16 Mds_BodyCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *pDe
 	return Size;
 }
 
-static void Mds_HeaderCopy(struct wbsoft_priv * adapter, struct wb35_descriptor *pDes, u8 *TargetBuffer)
+static void Mds_HeaderCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *pDes, u8 *TargetBuffer)
 {
 	struct wb35_mds *pMds = &adapter->Mds;
 	u8	*src_buffer = pDes->buffer_address[0]; /* 931130.5.g */
@@ -414,9 +414,9 @@ static void Mds_HeaderCopy(struct wbsoft_priv * adapter, struct wb35_descriptor
 }
 
 void
-Mds_Tx(struct wbsoft_priv * adapter)
+Mds_Tx(struct wbsoft_priv *adapter)
 {
-	struct hw_data *	pHwData = &adapter->sHwData;
+	struct hw_data *pHwData = &adapter->sHwData;
 	struct wb35_mds *pMds = &adapter->Mds;
 	struct wb35_descriptor	TxDes;
 	struct wb35_descriptor *pTxDes = &TxDes;
@@ -550,10 +550,10 @@ Mds_Tx(struct wbsoft_priv * adapter)
 }
 
 void
-Mds_SendComplete(struct wbsoft_priv * adapter, PT02_DESCRIPTOR pT02)
+Mds_SendComplete(struct wbsoft_priv *adapter, PT02_DESCRIPTOR pT02)
 {
 	struct wb35_mds *pMds = &adapter->Mds;
-	struct hw_data *	pHwData = &adapter->sHwData;
+	struct hw_data *pHwData = &adapter->sHwData;
 	u8	PacketId = (u8)pT02->T02_Tx_PktID;
 	unsigned char	SendOK = true;
 	u8	RetryCount, TxRate;
-- 
1.7.0.4



