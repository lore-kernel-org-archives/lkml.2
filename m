Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab2A3QGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:06:44 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:60114
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752672Ab2A3QGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:06:43 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: Larry.Finger@lwfinger.net, wlanfae@realtek.com,
        linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, standby24x7@gmail.com, trivial@kernel.org
Subject: [PATCH] [trivial] rtlwifi: Fix typo in dm.c
Date: Tue, 31 Jan 2012 01:06:08 +0900
Message-Id: <1327939568-15687-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct a spelling "disconnet" to "disconnect" in
drivers/net/wireless/rtlwifi/rtl8192de/dm.c
This is a 2nd post version.
Change subject line as per request.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
index 3cd0736..5087fe4 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
@@ -296,7 +296,7 @@ static void rtl92d_dm_find_minimum_rssi(struct ieee80211_hw *hw)
 		de_digtable.min_undecorated_pwdb_for_dm =
 		    rtlpriv->dm.UNDEC_SM_PWDB;
 		RT_TRACE(rtlpriv, COMP_BB_POWERSAVING, DBG_LOUD,
-			 ("AP Ext Port or disconnet PWDB = 0x%x\n",
+			 ("AP Ext Port or disconnect PWDB = 0x%x\n",
 			  de_digtable.min_undecorated_pwdb_for_dm));
 	}
 
-- 
1.7.6.5

