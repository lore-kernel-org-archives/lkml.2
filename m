Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab0IOHyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 03:54:35 -0400
Received: from purin.rz.uni-konstanz.de ([134.34.240.45]:10978 "EHLO
	purin.rz.uni-konstanz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab0IOHye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 03:54:34 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Sep 2010 03:54:34 EDT
X-IronPort-AV: E=Sophos;i="4.56,370,1280707200"; 
   d="scan'208";a="9177848"
From: Alexander Holupirek <alex@holupirek.de>
To: john@johnmccutchan.com
Cc: rlove@rlove.org, linux-kernel@vger.kernel.org,
        Alexander Holupirek <alex@holupirek.de>
Subject: [PATCH] include: linux: [fan|fs|i]notify: Fixed typos and a coding style issue
Date: Wed, 15 Sep 2010 09:21:21 +0200
Message-Id: <1284535281-32085-1-git-send-email-alex@holupirek.de>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/Writtable/Writeable
s/Unwrittable/Unwriteable

While there fixed an coding style issue reported by
./scripts/checkpatch.pl --file include/linux/fanotify.h

Signed-off-by: Alexander Holupirek <alex@holupirek.de>
---
 include/linux/fanotify.h         |    6 +++---
 include/linux/fsnotify_backend.h |    4 ++--
 include/linux/inotify.h          |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 63531a6..e36baba 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -6,8 +6,8 @@
 /* the following events that user-space can register for */
 #define FAN_ACCESS		0x00000001	/* File was accessed */
 #define FAN_MODIFY		0x00000002	/* File was modified */
-#define FAN_CLOSE_WRITE		0x00000008	/* Unwrittable file closed */
-#define FAN_CLOSE_NOWRITE	0x00000010	/* Writtable file closed */
+#define FAN_CLOSE_WRITE		0x00000008	/* Unwriteable file closed */
+#define FAN_CLOSE_NOWRITE	0x00000010	/* Writeable file closed */
 #define FAN_OPEN		0x00000020	/* File was opened */
 
 #define FAN_EVENT_ON_CHILD	0x08000000	/* interested in child events */
@@ -88,7 +88,7 @@ struct fanotify_response {
 #define FAN_EVENT_METADATA_LEN (sizeof(struct fanotify_event_metadata))
 
 #define FAN_EVENT_NEXT(meta, len) ((len) -= (meta)->event_len, \
-				   (struct fanotify_event_metadata*)(((char *)(meta)) + \
+				   (struct fanotify_event_metadata *)(((char *)(meta)) + \
 				   (meta)->event_len))
 
 #define FAN_EVENT_OK(meta, len)	((long)(len) >= (long)FAN_EVENT_METADATA_LEN && \
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index e40190d..0403fc4 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -27,8 +27,8 @@
 #define FS_ACCESS		0x00000001	/* File was accessed */
 #define FS_MODIFY		0x00000002	/* File was modified */
 #define FS_ATTRIB		0x00000004	/* Metadata changed */
-#define FS_CLOSE_WRITE		0x00000008	/* Writtable file was closed */
-#define FS_CLOSE_NOWRITE	0x00000010	/* Unwrittable file closed */
+#define FS_CLOSE_WRITE		0x00000008	/* Writeable file was closed */
+#define FS_CLOSE_NOWRITE	0x00000010	/* Unwriteable file closed */
 #define FS_OPEN			0x00000020	/* File was opened */
 #define FS_MOVED_FROM		0x00000040	/* File was moved from X */
 #define FS_MOVED_TO		0x00000080	/* File was moved to Y */
diff --git a/include/linux/inotify.h b/include/linux/inotify.h
index d33041e..134082b 100644
--- a/include/linux/inotify.h
+++ b/include/linux/inotify.h
@@ -29,8 +29,8 @@ struct inotify_event {
 #define IN_ACCESS		0x00000001	/* File was accessed */
 #define IN_MODIFY		0x00000002	/* File was modified */
 #define IN_ATTRIB		0x00000004	/* Metadata changed */
-#define IN_CLOSE_WRITE		0x00000008	/* Writtable file was closed */
-#define IN_CLOSE_NOWRITE	0x00000010	/* Unwrittable file closed */
+#define IN_CLOSE_WRITE		0x00000008	/* Writeable file was closed */
+#define IN_CLOSE_NOWRITE	0x00000010	/* Unwriteable file closed */
 #define IN_OPEN			0x00000020	/* File was opened */
 #define IN_MOVED_FROM		0x00000040	/* File was moved from X */
 #define IN_MOVED_TO		0x00000080	/* File was moved to Y */
-- 
1.7.1

