Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab2ECR6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 13:58:04 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47037 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758001Ab2ECR6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 13:58:00 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: jbaron@redhat.com, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 3/3] dynamic_debug: remove unneeded includes
Date: Thu,  3 May 2012 11:57:39 -0600
Message-Id: <1336067860-19953-3-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.8.1
In-Reply-To: <1336067860-19953-1-git-send-email-jim.cromie@gmail.com>
References: <1336067860-19953-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These arent currently needed, so drop them.  Some will probably get
re-added when static-branches are added, but include loops prevent
that at present.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 7ca29a0..fc5d270 100644
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
1.7.8.1

