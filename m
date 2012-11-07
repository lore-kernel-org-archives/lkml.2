Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab2KGSuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 13:50:46 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:48016 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab2KGSum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 13:50:42 -0500
From: Adil Mujeeb <mujeeb.adil@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: [PATCH 2/4] Staging: winbond: mds: Fixed coding style issues
Date: Thu,  8 Nov 2012 00:20:01 +0530
Message-Id: <1352314203-8092-3-git-send-email-mujeeb.adil@gmail.com>
X-Mailer: git-send-email 1.7.6.msysgit.0
In-Reply-To: <1352314203-8092-1-git-send-email-mujeeb.adil@gmail.com>
References: <1352314203-8092-1-git-send-email-mujeeb.adil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed printk tracing call

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 drivers/staging/winbond/mds.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index 43990e8..faa93f0 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -476,11 +476,8 @@ Mds_Tx(struct wbsoft_priv *adapter)
 			/* 931130.5.b */
 			FragmentCount = PacketSize/FragmentThreshold + 1;
 			stmp = PacketSize + FragmentCount*32 + 8; /* 931130.5.c 8:MIC */
-			if ((XmitBufSize + stmp) >= MAX_USB_TX_BUFFER) {
-				printk("[Mds_Tx] Excess max tx buffer.\n");
+			if ((XmitBufSize + stmp) >= MAX_USB_TX_BUFFER)
 				break; /* buffer is not enough */
-			}
-
 
 			/*
 			 * Start transmitting
-- 
1.7.10.2

