Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab1H1NcX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 09:32:23 -0400
Received: from mta21.charter.net ([216.33.127.81]:43834 "EHLO
	mta21.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab1H1NcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 09:32:16 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Aug 2011 09:32:15 EDT
X-Authority-Analysis: v=1.1 cv=aYgz8SUnD4PtGxommIm5uNbVBOPq3891h1gxsHlFGpI=
 c=1 sm=1 a=_Z_ZN0_UnWcA:10 a=HnXbG3lm2xYA:10 a=lDGNyK2vIvEA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=hgMy1ACtQgpcaOTsRH0A:9
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <RpYE1h00E3pHlLY05pYEzN@farmergreg.com>
From: y@farmergreg.com
To: sgruszka@redhat.com, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH 2/2 v2] iwlegacy: change IWL_ERR to IWL_DEBUG_HT in iwl4965_rs_tl_turn_on_agg_for_tid
Date: Sun, 28 Aug 2011 08:32:10 -0500
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1314537977-20097-2-git-send-email-Gregory.Dietsche@cuw.edu>
References: <1314537977-20097-2-git-send-email-Gregory.Dietsche@cuw.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Dietsche <Gregory.Dietsche@cuw.edu>

This message should be a debug message and not an error. So
change it from IWL_ERR to IWL_DEBUG_HT.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
index 9b65153..a0b60ee 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
@@ -373,7 +373,7 @@ static int iwl4965_rs_tl_turn_on_agg_for_tid(struct iwl_priv *priv,
 			ieee80211_stop_tx_ba_session(sta, tid);
 		}
 	} else {
-		IWL_ERR(priv, "Aggregation not enabled for tid %d "
+		IWL_DEBUG_HT(priv, "Aggregation not enabled for tid %d "
 			"because load = %u\n", tid, load);
 	}
 	return ret;
-- 
1.7.5.4

