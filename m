Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894Ab2JLQiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:38:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50829 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759739Ab2JLQiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:38:03 -0400
From: Adil Mujeeb <mujeeb.adil@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: [PATCH 3/9] Staging: winbond: mds: Fixed coding style issues
Date: Fri, 12 Oct 2012 22:07:09 +0530
Message-Id: <1350059835-5408-4-git-send-email-mujeeb.adil@gmail.com>
X-Mailer: git-send-email 1.7.6.msysgit.0
In-Reply-To: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
References: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed printk tracing call

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 linux-3.6-rc7/drivers/staging/winbond/mds.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/linux-3.6-rc7/drivers/staging/winbond/mds.c b/linux-3.6-rc7/drivers/staging/winbond/mds.c
index c9f0e8f..d76172e 100644
--- a/linux-3.6-rc7/drivers/staging/winbond/mds.c
+++ b/linux-3.6-rc7/drivers/staging/winbond/mds.c
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
1.7.7.3

