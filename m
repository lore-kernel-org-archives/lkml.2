Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab2AWRaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 12:30:20 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:41031
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751779Ab2AWRaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 12:30:19 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-ntfs-dev@lists.sourceforge.net, anton@tuxera.com
Cc: standby24x7@gmail.com, linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH 2/2] [trivial] ntfs: Fix typo in mft.c
Date: Tue, 24 Jan 2012 02:29:36 +0900
Message-Id: <1327339776-3560-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct two spelling errors "dealocate" to "deallocate"
in fs/ntfs/mft.c
---
 fs/ntfs/mft.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index 382857f..862f7ff 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -1367,7 +1367,7 @@ static int ntfs_mft_bitmap_extend_allocation_nolock(ntfs_volume *vol)
 			ntfs_error(vol->sb, "Failed to merge runlists for mft "
 					"bitmap.");
 			if (ntfs_cluster_free_from_rl(vol, rl2)) {
-				ntfs_error(vol->sb, "Failed to dealocate "
+				ntfs_error(vol->sb, "Failed to deallocate "
 						"allocated cluster.%s", es);
 				NVolSetErrors(vol);
 			}
@@ -1805,7 +1805,7 @@ static int ntfs_mft_data_extend_allocation_nolock(ntfs_volume *vol)
 		ntfs_error(vol->sb, "Failed to merge runlists for mft data "
 				"attribute.");
 		if (ntfs_cluster_free_from_rl(vol, rl2)) {
-			ntfs_error(vol->sb, "Failed to dealocate clusters "
+			ntfs_error(vol->sb, "Failed to deallocate clusters "
 					"from the mft data attribute.%s", es);
 			NVolSetErrors(vol);
 		}
-- 
1.7.6.5

