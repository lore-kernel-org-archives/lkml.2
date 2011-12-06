Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab1LFTN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:13:27 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45409 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab1LFTNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:13:14 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 24/25] dynamic_debug: remove unneeded includes
Date: Tue,  6 Dec 2011 12:11:34 -0700
Message-Id: <1323198694-7186-25-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>, <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
 <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
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
index baed922..25023f1 100644
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

