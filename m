Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab2ASRDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 12:03:12 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:38248
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751770Ab2ASRDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 12:03:09 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, jkosina@suse.cz
Cc: standby24x7@gmail.com
Subject: [PATCH][trivial]:tty: Fix typo in synclink_gt.c
Date: Fri, 20 Jan 2012 02:00:24 +0900
Message-Id: <1326992424-11602-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix typo "looopback" to "loopback" in synclink_gt.c

Signed-off-by: Masanari Iida<standby24x7@gmail.com>
cc:Jiri Koshina<jkosina@suze.cz>
---
 drivers/tty/synclink_gt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index 18b48cd..01a1ff4 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -3924,7 +3924,7 @@ static void tdma_reset(struct slgt_info *info)
  */
 static void enable_loopback(struct slgt_info *info)
 {
-	/* SCR (serial control) BIT2=looopback enable */
+	/* SCR (serial control) BIT2=loopback enable */
 	wr_reg16(info, SCR, (unsigned short)(rd_reg16(info, SCR) | BIT2));
 
 	if (info->params.mode != MGSL_MODE_ASYNC) {
-- 
1.7.6.5

