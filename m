Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab1FCCMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 22:12:12 -0400
Received: from mta11.charter.net ([216.33.127.80]:59592 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab1FCCMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 22:12:08 -0400
X-Authority-Analysis: v=1.1 cv=1b2X7W/SifksZeClH/haT1SUt4udqxFGF00pZw2/jJk=
 c=1 sm=1 a=VsugKzRVNSIA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=yH5ieTsJy4pCuhNqiHcA:9 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: sgruszka@redhat.com, linville@tuxdriver.com
Cc: kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH 2/5] iwlegacy: remove unecessary if statement
Date: Thu,  2 Jun 2011 21:06:07 -0500
Message-Id: <1307066770-27309-2-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1307066770-27309-1-git-send-email-Gregory.Dietsche@cuw.edu>
References: <1307066770-27309-1-git-send-email-Gregory.Dietsche@cuw.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the code always returns ret regardless, so if(ret) check is unecessary.
Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 drivers/net/wireless/iwlegacy/iwl-4965.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.c b/drivers/net/wireless/iwlegacy/iwl-4965.c
index f5433c7..ffda05c 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -1185,8 +1185,6 @@ static int iwl4965_send_rxon_assoc(struct iwl_priv *priv,
 
 	ret = iwl_legacy_send_cmd_pdu_async(priv, REPLY_RXON_ASSOC,
 				     sizeof(rxon_assoc), &rxon_assoc, NULL);
-	if (ret)
-		return ret;
 
 	return ret;
 }
-- 
1.7.2.5

