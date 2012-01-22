Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab2AVO12 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 09:27:28 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:48717
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751918Ab2AVO10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 09:27:26 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: reiserfs-devel@vger.kernel.org
Cc: standby24x7@gmail.com, linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] [trivial] reiserfs : Fix typo in lbalance.c
Date: Sun, 22 Jan 2012 23:27:00 +0900
Message-Id: <1327242420-3178-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "entry_cout" to "entry_count" in
fs/reiserfs/lbalance.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 fs/reiserfs/lbalance.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/lbalance.c b/fs/reiserfs/lbalance.c
index 03d85cb..b43d015 100644
--- a/fs/reiserfs/lbalance.c
+++ b/fs/reiserfs/lbalance.c
@@ -975,7 +975,7 @@ static int leaf_cut_entries(struct buffer_head *bh,
 	   remove */
 	RFALSE(!is_direntry_le_ih(ih), "10180: item is not directory item");
 	RFALSE(I_ENTRY_COUNT(ih) < from + del_count,
-	       "10185: item contains not enough entries: entry_cout = %d, from = %d, to delete = %d",
+	       "10185: item contains not enough entries: entry_count = %d, from = %d, to delete = %d",
 	       I_ENTRY_COUNT(ih), from, del_count);
 
 	if (del_count == 0)
-- 
1.7.6.5

