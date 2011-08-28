Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab1H1N0y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 09:26:54 -0400
Received: from mta11.charter.net ([216.33.127.80]:54362 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab1H1N0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 09:26:49 -0400
X-Authority-Analysis: v=1.1 cv=qtFpkpLoq1h6Rzh6To4jlydEWOxnTDhhQmDAOJLAbB0=
 c=1 sm=1 a=JW9IQIGCzBMA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=5fEM237k82IO9X-WsBAA:9 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: sgruszka@redhat.com, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH 1/2] iwlegacy: change IWL_WARN to IWL_DEBUG_HT in iwl4965_tx_agg_start
Date: Sun, 28 Aug 2011 08:26:16 -0500
Message-Id: <1314537977-20097-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message should be a debug message and not a warning. So
change it from IWL_WARN to IWL_DEBUG_HT.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
index ac4f64d..f8c7eab 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
@@ -877,7 +877,7 @@ int iwl4965_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	if (unlikely(tx_fifo < 0))
 		return tx_fifo;
 
-	IWL_WARN(priv, "%s on ra = %pM tid = %d\n",
+	IWL_DEBUG_HT(priv, "%s on ra = %pM tid = %d\n",
 			__func__, sta->addr, tid);
 
 	sta_id = iwl_legacy_sta_id(sta);
-- 
1.7.5.4

