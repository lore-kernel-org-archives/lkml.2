Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab2DYPXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:23:10 -0400
Received: from fieldses.org ([174.143.236.118]:51424 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078Ab2DYPWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:22:14 -0400
From: bfields@fieldses.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 1/5] vfs: fix outdated i_mutex_lock_class documentation
Date: Wed, 25 Apr 2012 11:22:05 -0400
Message-Id: <1335367329-929-1-git-send-email-bfields@fieldses.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20120418215238.GA11959@fieldses.org>
References: <20120418215238.GA11959@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
---
 include/linux/fs.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8de6755..f31e45c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -860,7 +860,8 @@ static inline int inode_unhashed(struct inode *inode)
  * 0: the object of the current VFS operation
  * 1: parent
  * 2: child/target
- * 3: quota file
+ * 3: xattr
+ * 4: quota file
  *
  * The locking order between these classes is
  * parent -> child -> normal -> xattr -> quota
-- 
1.7.5.4

