Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab2LFIiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 03:38:54 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:63818 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab2LFIix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 03:38:53 -0500
Message-ID: <50C05999.9080807@gmail.com>
Date: Thu, 06 Dec 2012 16:38:49 +0800
From: Bin Wang <wbin00@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [PATCH] sysfs: Fixed a trailing white space error
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the trailing white space in fs/sysfs/mount.c.

Signed-off-by: Bin Wang <wbin00@gmail.com>
---
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
