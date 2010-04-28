Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab0D1V4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 17:56:00 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:47804 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab0D1Vz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 17:55:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=p9CdtdQzGflIe0hzime8TmT6onjXHCLtZODvsA3ej0N2qr1mr/hx/I2iHB8G7mLK+t
         IXmD0kBC8LPiB1SL9YmrGviagnDs39g98UuXNwuvbEGp1BAbfTuTzBBzkvmG+MiDC/wh
         SdbhwSKLowK8UHceVZsG+boYstmwyeJ5CQpwI=
From: Roel Van Nyen <roel.vannyen@gmail.com>
To: gregkh@suse.de
Cc: hjanssen@microsoft.com, haiyangz@microsoft.com,
       linux-kernel@vger.kernel.org, Roel Van Nyen <roel.vannyen@gmail.com>
Subject: [PATCH] Staging: hv: Fix coding style errors in NetVsc.c
Date: Wed, 28 Apr 2010 23:55:48 +0200
Message-Id: <1272491748-12516-1-git-send-email-roel.vannyen@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style issues

Signed-of-by: Roel Van Nyen <roel.vannyen@gmail.com>
---
 drivers/staging/hv/NetVsc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/NetVsc.c b/drivers/staging/hv/NetVsc.c
index e1ca343..f84942d 100644
--- a/drivers/staging/hv/NetVsc.c
+++ b/drivers/staging/hv/NetVsc.c
@@ -1087,7 +1087,7 @@ static void NetVscOnReceive(struct hv_device *Device,
 	}
 
 	/* Remove the 1st packet to represent the xfer page packet itself */
-	xferpagePacket = (struct xferpage_packet*)listHead.next;
+	xferpagePacket = (struct xferpage_packet *)listHead.next;
 	list_del(&xferpagePacket->ListEntry);
 
 	/* This is how much we can satisfy */
@@ -1103,7 +1103,7 @@ static void NetVscOnReceive(struct hv_device *Device,
 
 	/* Each range represents 1 RNDIS pkt that contains 1 ethernet frame */
 	for (i = 0; i < (count - 1); i++) {
-		netvscPacket = (struct hv_netvsc_packet*)listHead.next;
+		netvscPacket = (struct hv_netvsc_packet *)listHead.next;
 		list_del(&netvscPacket->ListEntry);
 
 		/* Initialize the netvsc packet */
-- 
1.6.3.3

