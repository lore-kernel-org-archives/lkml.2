Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab1H1NWt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 09:22:49 -0400
Received: from mta21.charter.net ([216.33.127.81]:40693 "EHLO
	mta21.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab1H1NWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 09:22:45 -0400
X-Authority-Analysis: v=1.1 cv=L1BYdMBFPEvrb1U4o1gj35Y72n0OWZIL8AeNhXtfs6g=
 c=1 sm=1 a=Vf8cZDdO_eoA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=nJi8-eznS81EM7dbCzUA:9 a=ZgSVEvT6e5zXbNYqKw8A:7
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: wey-yi.w.guy@intel.com, linville@tuxdriver.com
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH] iwlwifi: iwl-agn-rs.c: remove old comment
Date: Sun, 28 Aug 2011 08:22:38 -0500
Message-Id: <1314537758-19159-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this comment refers to some code that was removed.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 3789ff4..733bd38 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2209,7 +2209,6 @@ static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search)
 
 /*
  * setup rate table in uCode
- * return rate_n_flags as used in the table
  */
 static void rs_update_rate_tbl(struct iwl_priv *priv,
 			       struct iwl_rxon_context *ctx,
-- 
1.7.5.4

