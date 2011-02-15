Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab1BOMsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 07:48:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49740 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754652Ab1BOMsM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 07:48:12 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 15 Feb 2011 12:48:09 +0000
Message-ID: <1297774089.17283.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 2/2] fs/inode: Fix kernel-doc format for inode_init_owner
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index ae2727a..72b5e40 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1690,7 +1690,7 @@ void init_special_inode(struct inode *inode, umode_t mode, dev_t rdev)
 EXPORT_SYMBOL(init_special_inode);
 
 /**
- * Init uid,gid,mode for new inode according to posix standards
+ * inode_init_owner - Init uid,gid,mode for new inode according to posix standards
  * @inode: New inode
  * @dir: Directory inode
  * @mode: mode of the new inode
-- 
1.7.2.3


