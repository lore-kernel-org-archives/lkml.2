Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab2BOSIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 13:08:39 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61828 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab2BOSIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 13:08:37 -0500
From: Alexandru Guduleasa <alexandru.guduleasa@gmail.com>
To: greg@kroah.com
Cc: swetland@google.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Alexandru Guduleasa <gulyan89@yahoo.com>
Subject: [PATCH] Staging: android: ashmem: fixed coding style isue
Date: Wed, 15 Feb 2012 20:08:19 +0200
Message-Id: <1329329299-5138-1-git-send-email-gulyan89@yahoo.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove trailing whitespace.
Add const keyword.

Signed-off-by: Alexandru Guduleasa <gulyan89@yahoo.com>
---
 drivers/staging/android/ashmem.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index 99052bf..9f1f27e 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -315,7 +315,7 @@ static int ashmem_mmap(struct file *file, struct vm_area_struct *vma)
 	get_file(asma->file);
 
 	/*
-	 * XXX - Reworked to use shmem_zero_setup() instead of 
+	 * XXX - Reworked to use shmem_zero_setup() instead of
 	 * shmem_set_file while we're in staging. -jstultz
 	 */
 	if (vma->vm_flags & VM_SHARED) {
@@ -680,7 +680,7 @@ static long ashmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return ret;
 }
 
-static struct file_operations ashmem_fops = {
+static const struct file_operations ashmem_fops = {
 	.owner = THIS_MODULE,
 	.open = ashmem_open,
 	.release = ashmem_release,
-- 
1.7.5.4

