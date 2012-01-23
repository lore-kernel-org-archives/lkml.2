Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab2AWC3B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 21:29:01 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58351 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab2AWC3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 21:29:00 -0500
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, swetland@google.com,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 1/3] drivers/staging/android/ashmem.c: Cleanups
Date: Sun, 22 Jan 2012 21:28:44 -0500
Message-Id: <1327285726-1949-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.9.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor cleanups that consist of removal of a whitespace and
make file_operations const.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
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
1.7.9.rc2

