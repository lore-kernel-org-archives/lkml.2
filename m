Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab2B0OSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 09:18:23 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43431 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab2B0OSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 09:18:22 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: nab@linux-iscsi.org, target-devel@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] target: Fix typo in drivers/target
Date: Mon, 27 Feb 2012 23:18:15 +0900
Message-Id: <1330352295-655-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.9.2.262.gba998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "exeeds" to "exceeds" in iscsi/iscsi_target_nego.c
Correct spelling "diabled" to "disabled" in target_core_configfs.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/target/iscsi/iscsi_target_nego.c |    2 +-
 drivers/target/target_core_configfs.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index e89fa74..37a20ba 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -90,7 +90,7 @@ int extract_param(
 		return -1;
 
 	if (len > max_length) {
-		pr_err("Length of input: %d exeeds max_length:"
+		pr_err("Length of input: %d exceeds max_length:"
 			" %d\n", len, max_length);
 		return -1;
 	}
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 6e043ee..44c8749 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2304,7 +2304,7 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_state(
 
 	if (!(tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_IMPLICT_ALUA)) {
 		pr_err("Unable to process implict configfs ALUA"
-			" transition while TPGS_IMPLICT_ALUA is diabled\n");
+			" transition while TPGS_IMPLICT_ALUA is disabled\n");
 		return -EINVAL;
 	}
 
-- 
1.7.9.2.262.gba998

