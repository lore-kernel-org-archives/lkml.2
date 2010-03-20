Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab0CTGHz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 02:07:55 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:47497 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab0CTGHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 02:07:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=X8alLiENZla1Gw5rNOs/+/c+ZczOEFeiBvOHuUfxW73S8lL3aPnv7+N14G8DxETJve
         Bd79a/Zt0cODiyNpGcss3U4CXumTT3NigXYHcHGYD5U5XHg1g6YlpYn44ISMXDgkRAxV
         61b3/TM+PY/YG5+QvJRpDyOYxgSxjTxT/yquk=
From: Vikram Dhillon <opensolarisdev@gmail.com>
To: gregkh@suse.de
Cc: wfp5p@virginia.edu, npalix@diku.dk, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, Vikram Dhillon <opensolarisdev@gmail.com>
Subject: [PATCH 3/3] Staging: hv: NetVsc.c: Fixed a spacing issue
Date: Sat, 20 Mar 2010 02:07:28 -0400
Message-Id: <1269065248-10575-1-git-send-email-opensolarisdev@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed spacing issues in 2 pointers.

Signed-off-by: Vikram Dhillon <opensolarisdev@gmail.com>

---
 drivers/staging/hv/NetVsc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/NetVsc.c b/drivers/staging/hv/NetVsc.c
index 1c717f9..e57b70f 100644
--- a/drivers/staging/hv/NetVsc.c
+++ b/drivers/staging/hv/NetVsc.c
@@ -1086,7 +1086,7 @@ static void NetVscOnReceive(struct hv_device *Device,
 	}
 
 	/* Remove the 1st packet to represent the xfer page packet itself */
-	xferpagePacket = (struct xferpage_packet*)listHead.next;
+	xferpagePacket = (struct xferpage_packet *)listHead.next;
 	list_del(&xferpagePacket->ListEntry);
 
 	/* This is how much we can satisfy */
@@ -1102,7 +1102,7 @@ static void NetVscOnReceive(struct hv_device *Device,
 
 	/* Each range represents 1 RNDIS pkt that contains 1 ethernet frame */
 	for (i = 0; i < (count - 1); i++) {
-		netvscPacket = (struct hv_netvsc_packet*)listHead.next;
+		netvscPacket = (struct hv_netvsc_packet *)listHead.next;
 		list_del(&netvscPacket->ListEntry);
 
 		/* Initialize the netvsc packet */
-- 
1.6.3.3

