Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab1LLXON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:14:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42879 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab1LLXNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:13:50 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 23/25] dynamic_debug: remove unneeded includes
Date: Mon, 12 Dec 2011 16:12:49 -0700
Message-Id: <1323731569-20644-23-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com>
References: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

These arent currently needed, so drop them.  Some will get re-added
when jump-label is re-introduced.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 5711628..cb97432 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -14,24 +14,14 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/kallsyms.h>
-#include <linux/types.h>
 #include <linux/mutex.h>
-#include <linux/proc_fs.h>
 #include <linux/seq_file.h>
-#include <linux/list.h>
-#include <linux/sysctl.h>
 #include <linux/ctype.h>
-#include <linux/string.h>
-#include <linux/uaccess.h>
 #include <linux/dynamic_debug.h>
 #include <linux/debugfs.h>
 #include <linux/slab.h>
-#include <linux/jump_label.h>
 #include <linux/hardirq.h>
 #include <linux/sched.h>
-#include <linux/device.h>
 #include <linux/netdevice.h>
 
 extern struct _ddebug __start___verbose[];
-- 
1.7.7.3

