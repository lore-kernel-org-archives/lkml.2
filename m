Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab2ATUgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 15:36:39 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:57386 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755376Ab2ATUgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 15:36:35 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/5] MAINTAINERS: Update partitions block F: patterns
Date: Fri, 20 Jan 2012 12:36:17 -0800
Message-Id: <8b5d9fde4f85dc5c4037e6c4fea7bd9427864f5b.1327091633.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1327091633.git.joe@perches.com>
References: <cover.1327091633.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9be96f3fd101 ("move fs/partitions to block/")
moved the files, update the patterns.

cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 56818fe..a37165b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4122,7 +4122,7 @@ L:	linux-ntfs-dev@lists.sourceforge.net
 W:	http://www.linux-ntfs.org/content/view/19/37/
 S:	Maintained
 F:	Documentation/ldm.txt
-F:	fs/partitions/ldm.*
+F:	block/partitions/ldm.*
 
 LogFS
 M:	Joern Engel <joern@logfs.org>
@@ -5647,7 +5647,7 @@ W:	http://www.ibm.com/developerworks/linux/linux390/
 S:	Supported
 F:	arch/s390/
 F:	drivers/s390/
-F:	fs/partitions/ibm.c
+F:	block/partitions/ibm.c
 F:	Documentation/s390/
 F:	Documentation/DocBook/s390*
 
-- 
1.7.8.111.gad25c.dirty

