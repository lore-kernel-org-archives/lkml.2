Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab2KTMMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:12:19 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55427 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2KTMMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:12:16 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 08/16] staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_module.c
Date: Tue, 20 Nov 2012 21:12:11 +0900
Message-Id: <1353413531-24684-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353413395-24444-1-git-send-email-yamanetoshi@gmail.com>
References: <1353413395-24444-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following errors and warnings fixed.
- ERROR: space required after that ',' (ctx:VxV)
- ERROR: code indent should use tabs where possible
- WARNING: please, no space before tabs
- WARNING: please, no spaces at the start of a line
- WARNING: suspect code indent for conditional statements (8, 10)

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 .../staging/rtl8187se/ieee80211/ieee80211_module.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c
index 66b4833..4358c4b 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c
@@ -99,7 +99,7 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
 {
 	struct ieee80211_device *ieee;
 	struct net_device *dev;
-	int i,err;
+	int i, err;
 
 	IEEE80211_DEBUG_INFO("Initializing...\n");
 
@@ -139,11 +139,11 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
 	spin_lock_init(&ieee->wpax_suitlist_lock);
 
 	ieee->wpax_type_set = 0;
- 	ieee->wpa_enabled = 0;
- 	ieee->tkip_countermeasures = 0;
- 	ieee->drop_unencrypted = 0;
- 	ieee->privacy_invoked = 0;
- 	ieee->ieee802_1x = 1;
+	ieee->wpa_enabled = 0;
+	ieee->tkip_countermeasures = 0;
+	ieee->drop_unencrypted = 0;
+	ieee->privacy_invoked = 0;
+	ieee->ieee802_1x = 1;
 	ieee->raw_tx = 0;
 
 	ieee80211_softmac_init(ieee);
@@ -152,9 +152,9 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
 		INIT_LIST_HEAD(&ieee->ibss_mac_hash[i]);
 
 	for (i = 0; i < 17; i++) {
-	  ieee->last_rxseq_num[i] = -1;
-	  ieee->last_rxfrag_num[i] = -1;
-	  ieee->last_packet_time[i] = 0;
+		ieee->last_rxseq_num[i] = -1;
+		ieee->last_rxfrag_num[i] = -1;
+		ieee->last_packet_time[i] = 0;
 	}
 //These function were added to load crypte module autoly
 	ieee80211_tkip_null();
-- 
1.7.9.5

