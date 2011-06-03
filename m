Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602Ab1FCCMC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 22:12:02 -0400
Received: from mta11.charter.net ([216.33.127.80]:59503 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab1FCCMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 22:12:00 -0400
X-Authority-Analysis: v=1.1 cv=vT9vkN3vVXssH3Ov7r/wQUs/sfIFjNPEFFf4aeKIi4A=
 c=1 sm=1 a=9kOIy2HcnO8A:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=JMiTLOZU66LkKzfM0kMA:9 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: sgruszka@redhat.com, linville@tuxdriver.com
Cc: kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH 1/5] iwlegacy: remove unreachable code
Date: Thu,  2 Jun 2011 21:06:06 -0500
Message-Id: <1307066770-27309-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

return; at the end of the function is unecessary.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 drivers/net/wireless/iwlegacy/iwl-eeprom.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-eeprom.c b/drivers/net/wireless/iwlegacy/iwl-eeprom.c
index cb346d1..5bf3f49 100644
--- a/drivers/net/wireless/iwlegacy/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlegacy/iwl-eeprom.c
@@ -316,7 +316,6 @@ static void iwl_legacy_init_band_reference(const struct iwl_priv *priv,
 		break;
 	default:
 		BUG();
-		return;
 	}
 }
 
-- 
1.7.2.5

