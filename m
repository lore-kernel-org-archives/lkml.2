Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab1GIE7i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 00:59:38 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51982 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab1GIE7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 00:59:37 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] debugfs: fix documentation
Date: Sat,  9 Jul 2011 14:01:17 +0900
Message-Id: <1310187677-2415-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debugfs_create_x64() exists.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/filesystems/debugfs.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/debugfs.txt b/Documentation/filesystems/debugfs.txt
index ed52af6..742cc06 100644
--- a/Documentation/filesystems/debugfs.txt
+++ b/Documentation/filesystems/debugfs.txt
@@ -73,8 +73,8 @@ the following functions can be used instead:
 				      struct dentry *parent, u16 *value);
     struct dentry *debugfs_create_x32(const char *name, mode_t mode,
 				      struct dentry *parent, u32 *value);
-
-Note that there is no debugfs_create_x64().
+    struct dentry *debugfs_create_x64(const char *name, mode_t mode,
+				      struct dentry *parent, u64 *value);
 
 These functions are useful as long as the developer knows the size of the
 value to be exported.  Some types can have different widths on different
-- 
1.7.4.4

