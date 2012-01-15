Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab2AOIkr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 03:40:47 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:41993 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750986Ab2AOIko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 03:40:44 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Brett Rudley <brudley@broadcom.com>, Henry Ptasinski <henryp@broadcom.com>,
        Roland Vossen <rvossen@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Kan Yan <kanyan@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] brcmfmac: Trivial typo of "couldn" to "could" fix
Date: Sun, 15 Jan 2012 00:38:45 -0800
Message-Id: <ba93c08a06e5e5993d2a29aaec8174cdf73ab95a.1326616556.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1326616556.git.joe@perches.com>
References: <cover.1326616556.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 271ca85..5b6b9e8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2785,7 +2785,7 @@ static struct wireless_dev *brcmf_alloc_wdev(s32 sizeof_iface,
 	    wiphy_new(&wl_cfg80211_ops,
 		      sizeof(struct brcmf_cfg80211_priv) + sizeof_iface);
 	if (!wdev->wiphy) {
-		WL_ERR("Couldn not allocate wiphy device\n");
+		WL_ERR("Could not allocate wiphy device\n");
 		err = -ENOMEM;
 		goto wiphy_new_out;
 	}
@@ -2811,7 +2811,7 @@ static struct wireless_dev *brcmf_alloc_wdev(s32 sizeof_iface,
 								 */
 	err = wiphy_register(wdev->wiphy);
 	if (err < 0) {
-		WL_ERR("Couldn not register wiphy device (%d)\n", err);
+		WL_ERR("Could not register wiphy device (%d)\n", err);
 		goto wiphy_register_out;
 	}
 	return wdev;
-- 
1.7.8.111.gad25c.dirty

