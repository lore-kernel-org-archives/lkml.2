Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab2FWW4j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 18:56:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55492 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab2FWW4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 18:56:37 -0400
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: [PATCH] Fix typo in printed messages
Date: Sat, 23 Jun 2012 15:54:34 -0700
Message-Id: <1340492074-13664-2-git-send-email-anatol.pomozov@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340492074-13664-1-git-send-email-anatol.pomozov@gmail.com>
References: <1340492074-13664-1-git-send-email-anatol.pomozov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coult -> Could
---
 arch/sparc/kernel/vio.c               |    2 +-
 drivers/net/wireless/b43/main.c       |    2 +-
 drivers/net/wireless/b43legacy/main.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/kernel/vio.c b/arch/sparc/kernel/vio.c
index 5cffdc5..3e244f3 100644
--- a/arch/sparc/kernel/vio.c
+++ b/arch/sparc/kernel/vio.c
@@ -443,7 +443,7 @@ static int __init vio_init(void)
 	root_vdev = vio_create_one(hp, root, NULL);
 	err = -ENODEV;
 	if (!root_vdev) {
-		printk(KERN_ERR "VIO: Coult not create root device.\n");
+		printk(KERN_ERR "VIO: Could not create root device.\n");
 		goto out_release;
 	}
 
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index acd03a4..1b988f2 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3767,7 +3767,7 @@ static int b43_switch_band(struct b43_wl *wl, struct ieee80211_channel *chan)
 	if (prev_status >= B43_STAT_STARTED) {
 		err = b43_wireless_core_start(up_dev);
 		if (err) {
-			b43err(wl, "Fatal: Coult not start device for "
+			b43err(wl, "Fatal: Could not start device for "
 			       "selected %s-GHz band\n",
 			       band_to_string(chan->band));
 			b43_wireless_core_exit(up_dev);
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index cd9c9bc..eae691e 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -2633,7 +2633,7 @@ static int b43legacy_switch_phymode(struct b43legacy_wl *wl,
 	if (prev_status >= B43legacy_STAT_STARTED) {
 		err = b43legacy_wireless_core_start(up_dev);
 		if (err) {
-			b43legacyerr(wl, "Fatal: Coult not start device for "
+			b43legacyerr(wl, "Fatal: Could not start device for "
 			       "newly selected %s-PHY mode\n",
 			       phymode_to_string(new_mode));
 			b43legacy_wireless_core_exit(up_dev);
-- 
1.7.9.5

