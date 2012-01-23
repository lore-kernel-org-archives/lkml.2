Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab2AWC3D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 21:29:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58351 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab2AWC3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 21:29:01 -0500
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, swetland@google.com,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 2/3] drivers/staging/android/pmem.c: Cleanups
Date: Sun, 22 Jan 2012 21:28:45 -0500
Message-Id: <1327285726-1949-2-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.9.rc2
In-Reply-To: <1327285726-1949-1-git-send-email-tdent48227@gmail.com>
References: <1327285726-1949-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor cleanups that consist of including a space and removal
of braces when there not needed.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/android/pmem.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/pmem.c b/drivers/staging/android/pmem.c
index 7d97032..b57cdce 100644
--- a/drivers/staging/android/pmem.c
+++ b/drivers/staging/android/pmem.c
@@ -92,7 +92,7 @@ struct pmem_region_node {
 
 #define PMEM_DEBUG_MSGS 0
 #if PMEM_DEBUG_MSGS
-#define DLOG(fmt,args...) \
+#define DLOG(fmt, args...) \
 	do { printk(KERN_INFO "[%s:%s:%d] "fmt, __FILE__, __func__, __LINE__, \
 		    ##args); } \
 	while (0)
@@ -708,9 +708,9 @@ int get_pmem_addr(struct file *file, unsigned long *start,
 	struct pmem_data *data;
 	int id;
 
-	if (!is_pmem_file(file) || !has_allocation(file)) {
+	if (!is_pmem_file(file) || !has_allocation(file))
 		return -1;
-	}
+
 
 	data = (struct pmem_data *)file->private_data;
 	if (data->index == -1) {
@@ -789,9 +789,9 @@ void flush_pmem_file(struct file *file, unsigned long offset, unsigned long len)
 	struct list_head *elt;
 	void *flush_start, *flush_end;
 
-	if (!is_pmem_file(file) || !has_allocation(file)) {
+	if (!is_pmem_file(file) || !has_allocation(file))
 		return;
-	}
+
 
 	id = get_id(file);
 	data = (struct pmem_data *)file->private_data;
-- 
1.7.9.rc2

