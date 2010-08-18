Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab0HRUKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 16:10:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40080 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab0HRUKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 16:10:20 -0400
From: Gunnar Gudvardarson <gunni@wave.is>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Gunnar Gudvardarson <gunni@wave.is>
Subject: [PATCH] Staging: crystalhd: crystalhd_cmds: fixed a brace issue
Date: Wed, 18 Aug 2010 20:10:06 +0000
Message-Id: <1282162206-9524-1-git-send-email-gunni@wave.is>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a brace issue.

Note: checkpatch was clean until i ran format-patch, which added 3
trailing whitespaces.

Signed-off-by: Gunnar Gudvardarson <gunni@wave.is>
---
 drivers/staging/crystalhd/crystalhd_cmds.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_cmds.c b/drivers/staging/crystalhd/crystalhd_cmds.c
index 1429608..d423775 100644
--- a/drivers/staging/crystalhd/crystalhd_cmds.c
+++ b/drivers/staging/crystalhd/crystalhd_cmds.c
@@ -309,9 +309,9 @@ static enum BC_STATUS bc_cproc_download_fw(struct crystalhd_cmd *ctx,
 	sts = crystalhd_download_fw(ctx->adp, (uint8_t *)idata->add_cdata,
 				  idata->add_cdata_sz);
 
-	if (sts != BC_STS_SUCCESS) {
+	if (sts != BC_STS_SUCCESS)
 		BCMLOG_ERR("Firmware Download Failure!! - %d\n", sts);
-	} else
+	else
 		ctx->state |= BC_LINK_INIT;
 
 	return sts;
-- 
1.7.0.4

