Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab0CYKE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 06:04:58 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:39482 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab0CYKE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 06:04:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=SfCZWEfm3yVMpeyVbe712Qko//gZSUrQMeZ6KUCZ2j2IdiKKBefysHarpGu46xiNpO
         A47jh6vsUVC/sL5W6Aq12hsj9zrbZp4+e9ZBF6qTv9TRKwlDj0j7Frk5dlTvzfj0+vtz
         Gtf0g0mtLBZki+VDK2mPe2+mRmHKLB0E6p0mk=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-doc@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Steven Whitehouse <swhiteho@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] GFS2 docs update
Date: Thu, 25 Mar 2010 11:04:49 +0100
Message-Id: <1269511489-22000-1-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.3.296.g9776a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now http://sources.redhat.com/cluster/ is redirected to
http://sources.redhat.com/cluster/wiki/

Also fixed tabs in the end.

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 Documentation/filesystems/gfs2.txt |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/gfs2.txt b/Documentation/filesystems/gfs2.txt
index 5e3ab8f..0b59c02 100644
--- a/Documentation/filesystems/gfs2.txt
+++ b/Documentation/filesystems/gfs2.txt
@@ -1,7 +1,7 @@
 Global File System
 ------------------
 
-http://sources.redhat.com/cluster/
+http://sources.redhat.com/cluster/wiki/
 
 GFS is a cluster file system. It allows a cluster of computers to
 simultaneously use a block device that is shared between them (with FC,
@@ -36,11 +36,11 @@ GFS2 is not on-disk compatible with previous versions of GFS, but it
 is pretty close.
 
 The following man pages can be found at the URL above:
-  fsck.gfs2	to repair a filesystem
-  gfs2_grow	to expand a filesystem online
-  gfs2_jadd	to add journals to a filesystem online
-  gfs2_tool	to manipulate, examine and tune a filesystem
+  fsck.gfs2		to repair a filesystem
+  gfs2_grow		to expand a filesystem online
+  gfs2_jadd		to add journals to a filesystem online
+  gfs2_tool		to manipulate, examine and tune a filesystem
   gfs2_quota	to examine and change quota values in a filesystem
   gfs2_convert	to convert a gfs filesystem to gfs2 in-place
   mount.gfs2	to help mount(8) mount a filesystem
-  mkfs.gfs2	to make a filesystem
+  mkfs.gfs2		to make a filesystem
-- 
1.7.0.2.326.gd00f

