Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab2A0P26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 10:28:58 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:53580
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755872Ab2A0P25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 10:28:57 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org
Cc: standby24x7@gmail.com, trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [trivial] jffs2: Fix typo in scan.c
Date: Sat, 28 Jan 2012 00:17:28 +0900
Message-Id: <1327677448-2732-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "scaning" to scanning" in
fs/jffs2/scan.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 fs/jffs2/scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/jffs2/scan.c b/fs/jffs2/scan.c
index f994648..c59a026 100644
--- a/fs/jffs2/scan.c
+++ b/fs/jffs2/scan.c
@@ -368,7 +368,7 @@ static int jffs2_scan_xattr_node(struct jffs2_sb_info *c, struct jffs2_erasebloc
 
 	if (jffs2_sum_active())
 		jffs2_sum_add_xattr_mem(s, rx, ofs - jeb->offset);
-	dbg_xattr("scaning xdatum at %#08x (xid=%u, version=%u)\n",
+	dbg_xattr("scanning xdatum at %#08x (xid=%u, version=%u)\n",
 		  ofs, xd->xid, xd->version);
 	return 0;
 }
-- 
1.7.6.5

