Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab0KFQXC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 12:23:02 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63689 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab0KFQXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 12:23:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jIRlvCgsEq/d8QHTpI6q1EdE9ONRSZrrDXRyluuRWzjlZgselbz6A4by90KOqQIZDv
         7ASDMpuSn1uY6yqe0ezMZTvuPgG7PJPfdDPPbP81QEcupliUJtkrePDERPm1hG4Yx9lY
         iD/wmjoHvBV8xDdSkyL0osbNifD4BpH2raYcM=
From: Johan Meiring <johanmeiring@gmail.com>
To: gregkh@suse.de, greg@kroah.com, johanmeiring@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] Staging: wlan-ng: fixed coding style issues in p80211netdev.h
Date: Sat,  6 Nov 2010 18:22:42 +0200
Message-Id: <1289060562-13776-1-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the p80211netdev.h file that fixes up warnings found by the checkpatch.pl tool. The typedefs have been left in place as they seem necessary.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlan-ng/p80211netdev.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211netdev.h b/drivers/staging/wlan-ng/p80211netdev.h
index 1ec3374..8588417 100644
--- a/drivers/staging/wlan-ng/p80211netdev.h
+++ b/drivers/staging/wlan-ng/p80211netdev.h
@@ -94,11 +94,11 @@ typedef struct net_device netdevice_t;
 #endif
 
 /*--- NSD Capabilities Flags ------------------------------*/
-#define P80211_NSDCAP_HARDWAREWEP           0x01	/* hardware wep engine */
-#define P80211_NSDCAP_SHORT_PREAMBLE        0x10	/* hardware supports */
-#define P80211_NSDCAP_HWFRAGMENT            0x80	/* nsd handles frag/defrag */
-#define P80211_NSDCAP_AUTOJOIN              0x100	/* nsd does autojoin */
-#define P80211_NSDCAP_NOSCAN                0x200	/* nsd can scan */
+#define P80211_NSDCAP_HARDWAREWEP           0x01  /* hardware wep engine */
+#define P80211_NSDCAP_SHORT_PREAMBLE        0x10  /* hardware supports */
+#define P80211_NSDCAP_HWFRAGMENT            0x80  /* nsd handles frag/defrag */
+#define P80211_NSDCAP_AUTOJOIN              0x100 /* nsd does autojoin */
+#define P80211_NSDCAP_NOSCAN                0x200 /* nsd can scan */
 
 /* Received frame statistics */
 typedef struct p80211_frmrx_t {
-- 
1.7.1

