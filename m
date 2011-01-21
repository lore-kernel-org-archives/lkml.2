Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab1AUPVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:21:45 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:38975 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752998Ab1AUPVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:21:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:X-Identified-User;
	b=MCGh4UoO31T1/j6S4Hxmi9issDTHwbL/sIa8W9zipKiafHkvxhZVP596PTpcwvo/dvscmXkCIYg55nnsK0VbkcS9Pre61cGDJAgOSl1KAu+o9lulLhCQNUfjEUIvgIQo;
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, Tao Ma <boyu.mt@taobao.com>
Subject: [PATCH] ext4/trivial: Fix comment typo "especiially".
Date: Fri, 21 Jan 2011 23:21:31 +0800
Message-Id: <1295623291-10909-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 111.193.12.95 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

Change "especiially" to "especially".

Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/extents.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 63a7581..353b387 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -131,7 +131,7 @@ static ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
 		 * fragmenting the file system's free space.  Maybe we
 		 * should have some hueristics or some way to allow
 		 * userspace to pass a hint to file system,
-		 * especiially if the latter case turns out to be
+		 * especially if the latter case turns out to be
 		 * common.
 		 */
 		ex = path[depth].p_ext;
-- 
1.7.1

