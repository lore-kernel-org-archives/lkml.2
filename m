Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab2ANXfo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 18:35:44 -0500
Received: from nautica.notk.org ([91.121.71.147]:53082 "EHLO nautica.notk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab2ANXfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 18:35:43 -0500
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Jan 2012 18:35:43 EST
From: Dominique Martinet <asmadeus@codewreck.org>
To: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH] fs/ubifs: fix dbg_{jnlk,tnck,mntk} not defined in debug.h if debug is disabled
Date: Sun, 15 Jan 2012 00:28:03 +0100
Message-Id: <1326583683-17066-1-git-send-email-asmadeus@codewreck.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/ubifs/debug.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ubifs/debug.h b/fs/ubifs/debug.h
index 307ab1d..741dfa5 100644
--- a/fs/ubifs/debug.h
+++ b/fs/ubifs/debug.h
@@ -350,10 +350,13 @@ void dbg_debugfs_exit_fs(struct ubifs_info *c);
 #define dbg_msg(fmt, ...)   ubifs_dbg_msg(fmt, ##__VA_ARGS__)
 #define dbg_gen(fmt, ...)   ubifs_dbg_msg(fmt, ##__VA_ARGS__)
 #define dbg_jnl(fmt, ...)   ubifs_dbg_msg(fmt, ##__VA_ARGS__)
+#define dbg_jnlk(key, fmt, ...) ubifs_dbg_msg(fmt, ##__VA_ARGS__)
 #define dbg_tnc(fmt, ...)   ubifs_dbg_msg(fmt, ##__VA_ARGS__)
+#define dbg_tnck(key, fmt, ...) ubifs_dbg_msg(fmt, ##__VA_ARGS__)
 #define dbg_lp(fmt, ...)    ubifs_dbg_msg(fmt, ##__VA_ARGS__)
 #define dbg_find(fmt, ...)  ubifs_dbg_msg(fmt, ##__VA_ARGS__)
 #define dbg_mnt(fmt, ...)   ubifs_dbg_msg(fmt, ##__VA_ARGS__)
+#define dbg_mntk(key, fmt, ...) ubifs_dbg_msg(fmt, ##__VA_ARGS__)
 #define dbg_io(fmt, ...)    ubifs_dbg_msg(fmt, ##__VA_ARGS__)
 #define dbg_cmt(fmt, ...)   ubifs_dbg_msg(fmt, ##__VA_ARGS__)
 #define dbg_budg(fmt, ...)  ubifs_dbg_msg(fmt, ##__VA_ARGS__)
-- 
1.7.3.2

