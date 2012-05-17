Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966250Ab2EQMuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:50:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965094Ab2EQMsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:48:55 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 20/24] GFS2: Update main gfs2 doc
Date: Thu, 17 May 2012 13:23:27 +0100
Message-Id: <1337257411-3173-21-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
References: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various items were a bit out of date, so this is a refresh to the
latest info.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/Documentation/filesystems/gfs2.txt b/Documentation/filesystems/gfs2.txt
index 4cda926..cc4f230 100644
--- a/Documentation/filesystems/gfs2.txt
+++ b/Documentation/filesystems/gfs2.txt
@@ -1,7 +1,7 @@
 Global File System
 ------------------
 
-http://sources.redhat.com/cluster/wiki/
+https://fedorahosted.org/cluster/wiki/HomePage
 
 GFS is a cluster file system. It allows a cluster of computers to
 simultaneously use a block device that is shared between them (with FC,
@@ -30,7 +30,8 @@ needed, simply:
 
 If you are using Fedora, you need to install the gfs2-utils package
 and, for lock_dlm, you will also need to install the cman package
-and write a cluster.conf as per the documentation.
+and write a cluster.conf as per the documentation. For F17 and above
+cman has been replaced by the dlm package.
 
 GFS2 is not on-disk compatible with previous versions of GFS, but it
 is pretty close.
@@ -39,8 +40,6 @@ The following man pages can be found at the URL above:
   fsck.gfs2		to repair a filesystem
   gfs2_grow		to expand a filesystem online
   gfs2_jadd		to add journals to a filesystem online
-  gfs2_tool		to manipulate, examine and tune a filesystem
-  gfs2_quota	to examine and change quota values in a filesystem
+  tunegfs2		to manipulate, examine and tune a filesystem
   gfs2_convert	to convert a gfs filesystem to gfs2 in-place
-  mount.gfs2	to help mount(8) mount a filesystem
   mkfs.gfs2		to make a filesystem
-- 
1.7.4

