Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab2KMQUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:20:14 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:35108 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab2KMQUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:20:12 -0500
From: Syam Sidhardhan <syamsidhardh@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk
Subject: [PATCH 3/3] proc_devtree: Replace include linux/module.h with linux/export.h
Date: Tue, 13 Nov 2012 21:48:35 +0530
Message-Id: <1352823515-6938-1-git-send-email-s.syam@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since it uses only THIS_MODULE macro, include <linux/export.h>
is the right to go here.

Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
---
 fs/proc/proc_devtree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/proc_devtree.c b/fs/proc/proc_devtree.c
index df7dd08..0e9df31 100644
--- a/fs/proc/proc_devtree.c
+++ b/fs/proc/proc_devtree.c
@@ -11,7 +11,7 @@
 #include <linux/stat.h>
 #include <linux/string.h>
 #include <linux/of.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/slab.h>
 #include <asm/prom.h>
 #include <asm/uaccess.h>
-- 
1.7.4.1

