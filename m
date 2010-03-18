Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437Ab0CRIAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 04:00:00 -0400
Received: from smtprelay-h12.telenor.se ([62.127.194.5]:57475 "EHLO
	smtprelay-h12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab0CRH76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 03:59:58 -0400
X-SENDER-IP: [83.226.250.86]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AocvACJ6oUtT4vpWPGdsb2JhbACHYJNKDAEBAQE3LalqjWeEeAQ
X-IronPort-AV: E=Sophos;i="4.51,265,1267398000"; 
   d="scan'208";a="52389810"
From: Lars Lindley <lindley@coyote.org>
To: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH] staging: winbond: mds_f.h whitespace corrections.
Date: Thu, 18 Mar 2010 08:59:53 +0100
Message-Id: <1268899193-16034-1-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed the whitespaces and the C99 comment.

Signed-off-by: Lars Lindley <lindley@coyote.org>
---
 drivers/staging/winbond/mds_f.h |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/winbond/mds_f.h b/drivers/staging/winbond/mds_f.h
index e09dd4b..0d2bccf 100644
--- a/drivers/staging/winbond/mds_f.h
+++ b/drivers/staging/winbond/mds_f.h
@@ -4,17 +4,17 @@
 #include "wbhal_s.h"
 #include "core.h"
 
-unsigned char Mds_initial(  struct wbsoft_priv *adapter );
-void Mds_Destroy(  struct wbsoft_priv *adapter );
-void Mds_Tx(  struct wbsoft_priv *adapter );
-void Mds_SendComplete(  struct wbsoft_priv *adapter,  PT02_DESCRIPTOR pT02 );
-void Mds_MpduProcess(  struct wbsoft_priv *adapter,  struct wb35_descriptor *pRxDes );
+unsigned char Mds_initial(struct wbsoft_priv *adapter);
+void Mds_Destroy(struct wbsoft_priv *adapter);
+void Mds_Tx(struct wbsoft_priv *adapter);
+void Mds_SendComplete(struct wbsoft_priv *adapter, PT02_DESCRIPTOR pT02);
+void Mds_MpduProcess(struct wbsoft_priv *adapter, struct wb35_descriptor *pRxDes);
 extern void DataDmp(u8 *pdata, u32 len, u32 offset);
 
-// For data frame sending 20060802
-u16 MDS_GetPacketSize(  struct wbsoft_priv *adapter );
-void MDS_GetNextPacket(  struct wbsoft_priv *adapter,  struct wb35_descriptor *pDes );
-void MDS_GetNextPacketComplete(  struct wbsoft_priv *adapter,  struct wb35_descriptor *pDes );
-void MDS_SendResult(  struct wbsoft_priv *adapter,  u8 PacketId,  unsigned char SendOK );
+/* For data frame sending */
+u16 MDS_GetPacketSize(struct wbsoft_priv *adapter);
+void MDS_GetNextPacket(struct wbsoft_priv *adapter, struct wb35_descriptor *pDes);
+void MDS_GetNextPacketComplete(struct wbsoft_priv *adapter, struct wb35_descriptor *pDes);
+void MDS_SendResult(struct wbsoft_priv *adapter, u8 PacketId, unsigned char SendOK);
 
 #endif
-- 
1.7.0.2

