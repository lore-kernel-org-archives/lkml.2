Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab0EQM6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 08:58:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab0EQM6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 08:58:06 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 02/11] GFS2: docs update
Date: Mon, 17 May 2010 13:40:16 +0100
Message-Id: <1274100025-26629-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1274100025-26629-2-git-send-email-swhiteho@redhat.com>
References: <1274100025-26629-1-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-2-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Gelmini <andrea.gelmini@gelma.net>

Now http://sources.redhat.com/cluster/ is redirected to
http://sources.redhat.com/cluster/wiki/

Also fixed tabs in the end.

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
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
1.6.2.5

