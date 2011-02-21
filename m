Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab1BUEL7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 23:11:59 -0500
Received: from xenotime.net ([184.105.210.51]:56100 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932238Ab1BUELw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 23:11:52 -0500
Date: Sun, 20 Feb 2011 20:08:35 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Cc: Davide Libenzi <davidel@xmailserver.org>
Subject: [PATCH 4/5] Docbook: add fs/eventfd.c and fix typos in it
Message-ID: <12982613151097@xenotime.net>
In-Reply-To: <1298261315935@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add fs/eventfd.c to filesystems docbook.
Make typo corrections in fs/eventfd.c.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
---
 Documentation/DocBook/filesystems.tmpl |    5 +++++
 fs/eventfd.c                           |   12 ++++++------
 2 files changed, 11 insertions(+), 6 deletions(-)

--- lnx-2638-rc3.orig/Documentation/DocBook/filesystems.tmpl
+++ lnx-2638-rc3/Documentation/DocBook/filesystems.tmpl
@@ -82,6 +82,11 @@
      </sect1>
   </chapter>
 
+  <chapter id="fs_events">
+     <title>Events based on file descriptors</title>
+!Efs/eventfd.c
+  </chapter>
+
   <chapter id="sysfs">
      <title>The Filesystem for Exporting Kernel Objects</title>
 !Efs/sysfs/file.c
--- lnx-2638-rc3.orig/fs/eventfd.c
+++ lnx-2638-rc3/fs/eventfd.c
@@ -99,7 +99,7 @@ EXPORT_SYMBOL_GPL(eventfd_ctx_get);
  * @ctx: [in] Pointer to eventfd context.
  *
  * The eventfd context reference must have been previously acquired either
- * with eventfd_ctx_get() or eventfd_ctx_fdget()).
+ * with eventfd_ctx_get() or eventfd_ctx_fdget().
  */
 void eventfd_ctx_put(struct eventfd_ctx *ctx)
 {
@@ -146,9 +146,9 @@ static void eventfd_ctx_do_read(struct e
  * eventfd_ctx_remove_wait_queue - Read the current counter and removes wait queue.
  * @ctx: [in] Pointer to eventfd context.
  * @wait: [in] Wait queue to be removed.
- * @cnt: [out] Pointer to the 64bit conter value.
+ * @cnt: [out] Pointer to the 64-bit counter value.
  *
- * Returns zero if successful, or the following error codes:
+ * Returns %0 if successful, or the following error codes:
  *
  * -EAGAIN      : The operation would have blocked.
  *
@@ -175,11 +175,11 @@ EXPORT_SYMBOL_GPL(eventfd_ctx_remove_wai
  * eventfd_ctx_read - Reads the eventfd counter or wait if it is zero.
  * @ctx: [in] Pointer to eventfd context.
  * @no_wait: [in] Different from zero if the operation should not block.
- * @cnt: [out] Pointer to the 64bit conter value.
+ * @cnt: [out] Pointer to the 64-bit counter value.
  *
- * Returns zero if successful, or the following error codes:
+ * Returns %0 if successful, or the following error codes:
  *
- * -EAGAIN      : The operation would have blocked but @no_wait was nonzero.
+ * -EAGAIN      : The operation would have blocked but @no_wait was non-zero.
  * -ERESTARTSYS : A signal interrupted the wait operation.
  *
  * If @no_wait is zero, the function might sleep until the eventfd internal


-- 

