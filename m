Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab0JNIa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 04:30:28 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:60228 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab0JNIa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 04:30:27 -0400
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>, Andreas Gruenbacher <agruen@suse.de>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: [PATCH] fanotify: Fix FAN_CLOSE comments
Date: Thu, 14 Oct 2010 09:30:11 +0100
Message-Id: <1287045011-3134-1-git-send-email-stefanha@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comments for FAN_CLOSE_WRITE and FAN_CLOSE_NOWRITE do not match
FS_CLOSE_WRITE and FS_CLOSE_NOWRITE, respectively.  WRITE is for
writable files while NOWRITE is for non-writable files.

Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
---
 include/linux/fanotify.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 63531a6..7f4db08 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -6,8 +6,8 @@
 /* the following events that user-space can register for */
 #define FAN_ACCESS		0x00000001	/* File was accessed */
 #define FAN_MODIFY		0x00000002	/* File was modified */
-#define FAN_CLOSE_WRITE		0x00000008	/* Unwrittable file closed */
-#define FAN_CLOSE_NOWRITE	0x00000010	/* Writtable file closed */
+#define FAN_CLOSE_WRITE		0x00000008	/* Writtable file closed */
+#define FAN_CLOSE_NOWRITE	0x00000010	/* Unwrittable file closed */
 #define FAN_OPEN		0x00000020	/* File was opened */
 
 #define FAN_EVENT_ON_CHILD	0x08000000	/* interested in child events */
-- 
1.7.1

