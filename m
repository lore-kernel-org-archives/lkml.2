Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab1GGWjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 18:39:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63332 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab1GGWji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 18:39:38 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 3/4] staging: et131x: Remove spaces between tabs inserted in patch 7b7fb34d3ffa
Date: Thu,  7 Jul 2011 23:38:57 +0100
Message-Id: <1310078338-25896-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I must remember to run checkpatch on 'trivial' patches too...

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_address_map.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/et131x/et1310_address_map.h b/drivers/staging/et131x/et1310_address_map.h
index a02335a..410677e 100644
--- a/drivers/staging/et131x/et1310_address_map.h
+++ b/drivers/staging/et131x/et1310_address_map.h
@@ -1225,7 +1225,7 @@ struct macstat_regs {			/* Location: */
 	u32 txrx_1519_1522_gvln_frames;	/*  0x6098 */
 
 	/* Rx Byte Counter */
-	u32 rx_bytes;	 		/*  0x609C */
+	u32 rx_bytes;			/*  0x609C */
 
 	/* Rx Packet Counter */
 	u32 rx_packets;			/*  0x60A0 */
@@ -1240,7 +1240,7 @@ struct macstat_regs {			/* Location: */
 	u32 rx_broadcast_packets;	/*  0x60AC */
 
 	/* Rx Control Frame Packet Counter */
-	u32 rx_control_frames; 		/*  0x60B0 */
+	u32 rx_control_frames;		/*  0x60B0 */
 
 	/* Rx Pause Frame Packet Counter */
 	u32 rx_pause_frames;		/*  0x60B4 */
@@ -1276,7 +1276,7 @@ struct macstat_regs {			/* Location: */
 	u32 rx_drops;			/*  0x60DC */
 
 	/* Tx Byte Counter */
-	u32 tx_bytes;	 		/*  0x60E0 */
+	u32 tx_bytes;			/*  0x60E0 */
 
 	/* Tx Packet Counter */
 	u32 tx_packets;			/*  0x60E4 */
@@ -1339,7 +1339,7 @@ struct macstat_regs {			/* Location: */
 	u32 carry_reg1;			/*  0x6130 */
 
 	/* Carry Register Two Register */
-	u32 carry_reg2;	 		/*  0x6134 */
+	u32 carry_reg2;			/*  0x6134 */
 
 	/* Carry Register One Mask Register */
 	u32 carry_reg1_mask;		/*  0x6138 */
-- 
1.7.4.4

