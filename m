Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab1AUNNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 08:13:18 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63220 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab1AUNNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 08:13:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jqAx5GG1PlnbNNfsFJVjI3ax5sv3MFNDRWckqaSQX6NRRnCl10LxzDnP1+1tOj5WLS
         tB1oUCsNocWw5uaRNQpr7MM9TcMSPdgGp0BkzHLtbyXCqPT23E1LYBI7pXvxk+iHdp0U
         fJXKl1QMRVSgCdzEdgzpHf5fjPBGXup2n2utc=
From: Radu Voicilas <rvoicilas@gmail.com>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, Radu Voicilas <rvoicilas@gmail.com>
Subject: [PATCH] fsnotify_backend.h: Fixed spelling mistakes.
Date: Fri, 21 Jan 2011 15:12:52 +0200
Message-Id: <1295615572-18596-1-git-send-email-rvoicilas@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whilst going through fsnotify's internals I came up over some trivial
spelling mistakes that got fixed with this patch.

Signed-off-by: Radu Voicilas <rvoicilas@gmail.com>
---
 include/linux/fsnotify_backend.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 69ad89b..5e34383 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -19,7 +19,7 @@
 #include <asm/atomic.h>
 
 /*
- * IN_* from inotfy.h lines up EXACTLY with FS_*, this is so we can easily
+ * IN_* from inotify.h lines up EXACTLY with FS_*, this is so we can easily
  * convert between them.  dnotify only needs conversion at watch creation
  * so no perf loss there.  fanotify isn't defined yet, so it can use the
  * wholes if it needs more events.
@@ -55,7 +55,7 @@
  * dnotify and inotify. */
 #define FS_EVENT_ON_CHILD	0x08000000
 
-/* This is a list of all events that may get sent to a parernt based on fs event
+/* This is a list of all events that may get sent to a parent based on fs event
  * happening to inodes inside that directory */
 #define FS_EVENTS_POSS_ON_CHILD   (FS_ACCESS | FS_MODIFY | FS_ATTRIB |\
 				   FS_CLOSE_WRITE | FS_CLOSE_NOWRITE | FS_OPEN |\
@@ -81,7 +81,7 @@ struct fsnotify_mark;
 struct fsnotify_event_private_data;
 
 /*
- * Each group much define these ops.  The fsnotify infrastructure will call
+ * Each group must define these ops.  The fsnotify infrastructure will call
  * these operations for each relevant group.
  *
  * should_send_event - given a group, inode, and mask this function determines
-- 
1.7.0

