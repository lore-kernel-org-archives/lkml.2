Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab2AaNfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:35:11 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:36657
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753492Ab2AaNfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:35:10 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: larry.finger@lwfinger.net, linux-wireless@vger.kernel.org
Cc: standby24x7@gmail.com, trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] [trivial] rtlwifi: Fix typo in dm.c
Date: Tue, 31 Jan 2012 22:34:35 +0900
Message-Id: <1328016875-1684-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct a spelling "disconnet" to "disconnect" in
drivers/net/wireless/rtlwifi/rtl8192de/dm.c

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

