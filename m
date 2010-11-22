Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab0KVA0b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 19:26:31 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:44820 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540Ab0KVA0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 19:26:30 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] romfs: have romfs_fs.h pull in necessary headers
Date: Sun, 21 Nov 2010 19:24:21 -0500
Message-Id: <1290385461-29831-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This header uses things like __be32, so pull in linux/types.h.

Further, it uses BLOCK_SIZE, so pull in linux/fs.h.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/romfs_fs.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/romfs_fs.h b/include/linux/romfs_fs.h
index c490fbc..5f57f93 100644
--- a/include/linux/romfs_fs.h
+++ b/include/linux/romfs_fs.h
@@ -1,6 +1,9 @@
 #ifndef __LINUX_ROMFS_FS_H
 #define __LINUX_ROMFS_FS_H
 
+#include <linux/types.h>
+#include <linux/fs.h>
+
 /* The basic structures of the romfs filesystem */
 
 #define ROMBSIZE BLOCK_SIZE
-- 
1.7.3.1

