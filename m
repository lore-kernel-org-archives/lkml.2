Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab2B0Shd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 13:37:33 -0500
Received: from que31.charter.net ([209.225.8.23]:47153 "EHLO que31.charter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab2B0Shb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 13:37:31 -0500
X-Greylist: delayed 514 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Feb 2012 13:37:31 EST
X-Authority-Analysis: v=1.1 cv=JYQIUidRAECiNa+jsiaNMIhYElg3H2WoMKCJIGO75f4=
 c=1 sm=1 a=loFRCyl7yhIA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=-adrFfunblZo6f30Qg4A:9 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: sgruszka@redhat.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH 4/4] iwlegacy: remove unused enum il4965_calib_enabled_state
Date: Mon, 27 Feb 2012 12:25:33 -0600
Message-Id: <1330367133-26465-5-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1330367133-26465-1-git-send-email-Gregory.Dietsche@cuw.edu>
References: <1330367133-26465-1-git-send-email-Gregory.Dietsche@cuw.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the enum il4965_calib_enabled_state because it is not used.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 drivers/net/wireless/iwlegacy/common.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index d0de922..5f50177 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -956,11 +956,6 @@ enum il4965_chain_noise_state {
 	IL_CHAIN_NOISE_DONE,
 };
 
-enum il4965_calib_enabled_state {
-	IL_CALIB_DISABLED = 0,	/* must be 0 */
-	IL_CALIB_ENABLED = 1,
-};
-
 enum ucode_type {
 	UCODE_NONE = 0,
 	UCODE_INIT,
-- 
1.7.6.4

