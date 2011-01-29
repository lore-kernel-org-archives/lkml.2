Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab1A2HJr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 02:09:47 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43092 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab1A2HJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 02:09:46 -0500
From: Adam Thompson <adam@lotpblog.com>
To: gregk@suse.de, ehames@gmail.com, svenne@krap.dk, johanmeiring@gmail.com,
        julia@diku.dk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        adam@lotpblog.com
Subject: [PATCH] Staging: wlan-ng: fix 2 space coding style issues This patch to p80211conv.c fixes to space coding style warnings found with checkpatch.pl Signed-off-by: Adam Thompson <adam@lotpblog.com>
Date: Sat, 29 Jan 2011 02:08:50 -0500
Message-Id: <1296284930-8396-1-git-send-email-adam@lotpblog.com>
X-Mailer: git-send-email 1.7.3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/wlan-ng/p80211conv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211conv.c b/drivers/staging/wlan-ng/p80211conv.c
index 146f365..f53a27a 100644
--- a/drivers/staging/wlan-ng/p80211conv.c
+++ b/drivers/staging/wlan-ng/p80211conv.c
@@ -379,7 +379,7 @@ int skb_p80211_to_ether(wlandevice_t *wlandev, u32 ethconv,
 
 	} else if ((payload_length >= sizeof(struct wlan_llc) +
 		sizeof(struct wlan_snap))
-		&&(e_llc->dsap == 0xaa)
+		&& (e_llc->dsap == 0xaa)
 		&& (e_llc->ssap == 0xaa)
 		&& (e_llc->ctl == 0x03)
 		   &&
@@ -415,7 +415,7 @@ int skb_p80211_to_ether(wlandevice_t *wlandev, u32 ethconv,
 
 	} else if ((payload_length >= sizeof(struct wlan_llc) +
 		sizeof(struct wlan_snap))
-		&&(e_llc->dsap == 0xaa)
+		&& (e_llc->dsap == 0xaa)
 		&& (e_llc->ssap == 0xaa)
 		&& (e_llc->ctl == 0x03)) {
 		pr_debug("802.1h/RFC1042 len: %d\n", payload_length);
-- 
1.7.3.5

