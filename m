Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934624Ab0J1Vem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:34:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760301Ab0J1VdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:33:25 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 18/20] fanotify: Fix FAN_CLOSE comments
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de, tvrtko.ursulin@sophos.com
Date: Thu, 28 Oct 2010 17:33:19 -0400
Message-ID: <20101028213319.24810.7417.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
References: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>

The comments for FAN_CLOSE_WRITE and FAN_CLOSE_NOWRITE do not match
FS_CLOSE_WRITE and FS_CLOSE_NOWRITE, respectively.  WRITE is for
writable files while NOWRITE is for non-writable files.

Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/fanotify.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 5e0400a..0f01214 100644
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
 
 #define FAN_Q_OVERFLOW		0x00004000	/* Event queued overflowed */

