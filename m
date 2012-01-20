Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab2ATWbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 17:31:09 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43143 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708Ab2ATWau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 17:30:50 -0500
From: Kashyap Gada <gada.kashyap@gmail.com>
To: gregkh@suse.de
Cc: rebecca@android.com, rschultz@google.com, jgennis@google.com,
        dima@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Kashyap Gada <gada.kashyap@gmail.com>
Subject: [PATCH 3/3] Staging: android: Fix brace coding style issue in pmem.c This is a patch to the pmem.c that fixes up two brace warnings found by checkpatch.pl tool
Date: Fri, 20 Jan 2012 22:30:42 +0000
Message-Id: <1327098642-16309-1-git-send-email-gada.kashyap@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Signed-off-by: Kashyap Gada <gada.kashyap@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/drivers/staging/android/pmem.c b/drivers/staging/android/pmem.c
index 7d97032..65ba61a 100644
--- a/drivers/staging/android/pmem.c
+++ b/drivers/staging/android/pmem.c
@@ -708,9 +708,8 @@ int get_pmem_addr(struct file *file, unsigned long *start,
 	struct pmem_data *data;
 	int id;
 
-	if (!is_pmem_file(file) || !has_allocation(file)) {
+	if (!is_pmem_file(file) || !has_allocation(file))
 		return -1;
-	}
 
 	data = (struct pmem_data *)file->private_data;
 	if (data->index == -1) {
@@ -789,9 +788,8 @@ void flush_pmem_file(struct file *file, unsigned long offset, unsigned long len)
 	struct list_head *elt;
 	void *flush_start, *flush_end;
 
-	if (!is_pmem_file(file) || !has_allocation(file)) {
+	if (!is_pmem_file(file) || !has_allocation(file))
 		return;
-	}
 
 	id = get_id(file);
 	data = (struct pmem_data *)file->private_data;
-- 
1.7.5.4

