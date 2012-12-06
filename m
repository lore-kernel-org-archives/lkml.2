Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab2LFJdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:33:50 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51504 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379Ab2LFJds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:33:48 -0500
From: Bin Wang <wbin00@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        Bin Wang <wbin00@gmail.com>
Subject: [PATCH 1/1] sysfs: Fixed a trailing white space error
Date: Thu,  6 Dec 2012 17:08:56 +0800
Message-Id: <1354784936-5647-1-git-send-email-wbin00@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the trailing white space in fs/sysfs/mount.c.

Signed-off-by: Bin Wang <wbin00@gmail.com>
---
 fs/sysfs/mount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 71eb7e2..24bfcb4 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -10,7 +10,7 @@
  * Please see Documentation/filesystems/sysfs.txt for more information.
  */
 
-#define DEBUG 
+#define DEBUG
 
 #include <linux/fs.h>
 #include <linux/mount.h>
-- 
1.7.11.7

