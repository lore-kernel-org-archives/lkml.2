Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab1BUEL4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 23:11:56 -0500
Received: from xenotime.net ([184.105.210.51]:59277 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932255Ab1BUELw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 23:11:52 -0500
Date: Sun, 20 Feb 2011 20:08:35 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Subject: [PATCH 3/5] Documentation: log_buf_len uses [KMG] suffix
Message-ID: <1298261315973@xenotime.net>
In-Reply-To: <1298261315935@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Update the "log_buf_len" description to use [KMG] syntax for the
buffer size.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kernel-parameters.txt |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- lnx-2638-rc3.orig/Documentation/kernel-parameters.txt
+++ lnx-2638-rc3/Documentation/kernel-parameters.txt
@@ -1271,10 +1271,9 @@ bytes respectively. Such letter suffixes
 			6 (KERN_INFO)		informational
 			7 (KERN_DEBUG)		debug-level messages
 
-	log_buf_len=n	Sets the size of the printk ring buffer, in bytes.
-			Format: { n | nk | nM }
-			n must be a power of two.  The default size
-			is set in the kernel config file.
+	log_buf_len=n[KMG]	Sets the size of the printk ring buffer,
+			in bytes.  n must be a power of two.  The default
+			size is set in the kernel config file.
 
 	logo.nologo	[FB] Disables display of the built-in Linux logo.
 			This may be used to provide more screen space for


-- 

