Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab1IERdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 13:33:09 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:40958 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab1IER1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 13:27:17 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: agruen@kernel.org, bfields@fieldses.org, akpm@linux-foundation.org,
        dhowells@redhat.com
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -V6 01/26] vfs: Indicate that the permission functions take all the MAY_* flags
Date: Mon,  5 Sep 2011 22:55:23 +0530
Message-Id: <1315243548-18664-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315243548-18664-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1315243548-18664-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
x-cbid: 11090517-2674-0000-0000-00000042DAC7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@kernel.org>

Signed-off-by: Andreas Gruenbacher <agruen@kernel.org>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namei.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 2826db3..9efc638 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -257,7 +257,7 @@ other_perms:
 /**
  * generic_permission -  check for access rights on a Posix-like filesystem
  * @inode:	inode to check access rights for
- * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
+ * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC, ...)
  *
  * Used to check for read/write/execute permissions on a file.
  * We use "fsuid" for this, letting us set arbitrary permissions
@@ -331,7 +331,7 @@ static inline int do_inode_permission(struct inode *inode, int mask)
 /**
  * inode_permission  -  check for access rights to a given inode
  * @inode:	inode to check permission on
- * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
+ * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC, ...)
  *
  * Used to check for read/write/execute permissions on an inode.
  * We use "fsuid" for this, letting us set arbitrary permissions
-- 
1.7.4.1

