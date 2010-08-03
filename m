Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0HCEGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 00:06:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38832 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab0HCEGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 00:06:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=W5rRwKcMEtRj7lhKHFlhCk7RKUzm2FRJubj14FBJL70ZMOU9PkHJEK0lsTjjXVCpZj
         oWLqbnFN8AOQgYCtGWYY87yblXEzqUPI2zgTQ51GLRgcDz1TqGnfcfbfQ7kkjplukSJC
         sq/Pzx0kS3/0dDWCU9tT+UQaUMTGcX88nbXfA=
From: tarinaky@gmail.com
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rt2860: rtmp: Fixed coding style issue in rtmp.h
Date: Tue,  3 Aug 2010 05:06:40 +0100
Message-Id: <1280808400-14300-1-git-send-email-tarinaky@gmail.com>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tarinaky <tarinaky@Tartarus.(none)>

This patch fixes a whitespace issue detected by checkpatch.pl

Signed-off-by: Jacob Smith <tarinaky@gmail.com>
---
 drivers/staging/rt2860/rtmp.h |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rt2860/rtmp.h b/drivers/staging/rt2860/rtmp.h
index 82b6e78..4c7c107 100644
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -2239,15 +2239,15 @@ struct rt_tx_blk {
 	unsigned long Priv;		/* Hardware specific value saved in here. */
 };
 
-#define fTX_bRtsRequired		0x0001	/* Indicate if need send RTS frame for protection. Not used in RT2860/RT2870. */
-#define fTX_bAckRequired       	0x0002	/* the packet need ack response */
-#define fTX_bPiggyBack     		0x0004	/* Legacy device use Piggback or not */
-#define fTX_bHTRate         	0x0008	/* allow to use HT rate */
-#define fTX_bForceNonQoS       	0x0010	/* force to transmit frame without WMM-QoS in HT mode */
-#define fTX_bAllowFrag       	0x0020	/* allow to fragment the packet, A-MPDU, A-MSDU, A-Ralink is not allowed to fragment */
-#define fTX_bMoreData			0x0040	/* there are more data packets in PowerSave Queue */
-#define fTX_bWMM				0x0080	/* QOS Data */
-#define fTX_bClearEAPFrame		0x0100
+#define fTX_bRtsRequired	0x0001	/* Indicate if need send RTS frame for protection. Not used in RT2860/RT2870. */
+#define fTX_bAckRequired	0x0002	/* the packet need ack response */
+#define fTX_bPiggyBack		0x0004	/* Legacy device use Piggback or not */
+#define fTX_bHTRate		0x0008	/* allow to use HT rate */
+#define fTX_bForceNonQoS	0x0010	/* force to transmit frame without WMM-QoS in HT mode */
+#define fTX_bAllowFrag		0x0020	/* allow to fragment the packet, A-MPDU, A-MSDU, A-Ralink is not allowed to fragment */
+#define fTX_bMoreData		0x0040	/* there are more data packets in PowerSave Queue */
+#define fTX_bWMM		0x0080	/* QOS Data */
+#define fTX_bClearEAPFrame	0x0100
 
 #define TX_BLK_SET_FLAG(_pTxBlk, _flag)		(_pTxBlk->Flags |= _flag)
 #define TX_BLK_TEST_FLAG(_pTxBlk, _flag)	(((_pTxBlk->Flags & _flag) == _flag) ? 1 : 0)
-- 
1.7.2

