Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab0F1BUP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 21:20:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52686 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab0F1BUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 21:20:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FTkY7kX5FZngpMn72z+AfHPYAd9oC9aGxpWOEr9sgjFihbBmwVUWD0UjvchVlP5W6x
         0ByhuVRhmnDW3WqMsvAtca7aB4+5NnAzeky4Q/OuW/ZnN2aNJI3GVoItUAuftmHCAz8+
         lfbHIJyZPiH4X01ydsSL9po1WmXryyhW4t6So=
From: Niadh <neilmunro@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Niadh <neilmunro@gmail.com>
Subject: [PATCH 303/303] Staging: RT2860: Fixed everything in ap.h.
Date: Mon, 28 Jun 2010 02:23:14 +0100
Message-Id: <1277688194-15627-1-git-send-email-neilmunro@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the single two warnings in ap.h which left this file with nothing left to clean.

Signed-off-by: Neil Munro <neilmunro@gmail.com>
---
 drivers/staging/rt2860/ap.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rt2860/ap.h b/drivers/staging/rt2860/ap.h
index 3f744a5..cf94ae8 100644
--- a/drivers/staging/rt2860/ap.h
+++ b/drivers/staging/rt2860/ap.h
@@ -42,7 +42,8 @@

 /* ap_wpa.c */
 void WpaStateMachineInit(struct rt_rtmp_adapter *pAd,
-			 struct rt_state_machine *Sm, OUT STATE_MACHINE_FUNC Trans[]);
+			 struct rt_state_machine *Sm,
+			OUT STATE_MACHINE_FUNC Trans[]);

 #ifdef RTMP_MAC_USB
 void BeaconUpdateExec(void *SystemSpecific1,
@@ -61,6 +62,7 @@ struct rt_mac_table_entry *MacTableInsertEntry(struct rt_rtmp_adapter *pAd,
 BOOLEAN MacTableDeleteEntry(struct rt_rtmp_adapter *pAd,
 			    u16 wcid, u8 *pAddr);

-struct rt_mac_table_entry *MacTableLookup(struct rt_rtmp_adapter *pAd, u8 *pAddr);
+struct rt_mac_table_entry *MacTableLookup(struct rt_rtmp_adapter *pAd,
+								u8 *pAddr);

 #endif /* __AP_H__ */
--
1.7.1

