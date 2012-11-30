Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031280Ab2K3RLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:11:04 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:46788 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031252Ab2K3RLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:11:00 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 27/32] staging: wlags49_h2: wl_priv: fixes brace placement
Date: Fri, 30 Nov 2012 18:58:52 +0200
Message-Id: <1354294737-5735-27-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes incorrect brace placements in the file, as
indicated by the checkpatch.pl tool.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_priv.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_priv.c b/drivers/staging/wlags49_h2/wl_priv.c
index 093e1ea..b49ef87 100644
--- a/drivers/staging/wlags49_h2/wl_priv.c
+++ b/drivers/staging/wlags49_h2/wl_priv.c
@@ -1158,9 +1158,8 @@ int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp)
 					break;
 				}
 
-				if (ltvAllocated) {
+				if (ltvAllocated)
 					kfree(pLtv);
-				}
 			} else {
 				urq->result = UIL_FAILURE;
 			}
@@ -1490,9 +1489,8 @@ int wvlan_uil_get_info(struct uilreq *urq, struct wl_private *lp)
 			case CFG_CFI_ACT_RANGES_STA:
 			case CFG_CUR_SCALE_THRH:
 			case CFG_AUTHENTICATION_ALGORITHMS:
-				for (i = 0; i < (lp->ltvRecord.len - 1); i++) {
+				for (i = 0; i < (lp->ltvRecord.len - 1); i++)
 					lp->ltvRecord.u.u16[i] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[i]);
-				}
 				break;
 			/* done at init time, and endian handled then */
 			case CFG_PRI_IDENTITY:
@@ -1515,10 +1513,8 @@ int wvlan_uil_get_info(struct uilreq *urq, struct wl_private *lp)
 			// Copy the LTV into the user's buffer.
 			copy_to_user(urq->data, &(lp->ltvRecord), urq->len);
 
-			if (ltvAllocated) {
+			if (ltvAllocated)
 				kfree(&(lp->ltvRecord));
-			}
-
 			urq->result = UIL_SUCCESS;
 		} else {
 			urq->result = UIL_FAILURE;
-- 
1.7.10.4

