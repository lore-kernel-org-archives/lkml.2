Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab2ATU47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 15:56:59 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:52892 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab2ATU45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 15:56:57 -0500
From: Kashyap Gada <gada.kashyap@gmail.com>
To: gregkh@suse.de
Cc: john.stultz@linaro.org, arve@android.com, ccross@android.com,
        bringert@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Kashyap Gada <gada.kashyap@gmail.com>
Subject: [PATCH] Staging: android: fix trailing whitespace issue in ashmem.c
Date: Fri, 20 Jan 2012 20:56:36 +0000
Message-Id: <1327092996-15059-1-git-send-email-gada.kashyap@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Signed-off-by: Kashyap Gada <gada.kashyap@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index 99052bf..b4bc03e 100644
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
-- 
1.7.5.4

