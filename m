Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab1AFVZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:25:30 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:57633 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753908Ab1AFVZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:25:29 -0500
Message-ID: <4D263342.2090107@lougher.demon.co.uk>
Date: Thu, 06 Jan 2011 21:25:22 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
CC: linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/5] Squashfs: get rid of default n in Kconfig
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As pointed out by Geert Uytterhoeven, "default n" is the default,
no reason to specify it.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
  fs/squashfs/Kconfig |    3 ---
  1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
index e5f63da..7c22188 100644
--- a/fs/squashfs/Kconfig
+++ b/fs/squashfs/Kconfig
@@ -29,7 +29,6 @@ config SQUASHFS
  config SQUASHFS_XATTR
  	bool "Squashfs XATTR support"
  	depends on SQUASHFS
-	default n
  	help
  	  Saying Y here includes support for extended attributes (xattrs).
  	  Xattrs are name:value pairs associated with inodes by
@@ -40,7 +39,6 @@ config SQUASHFS_XATTR
  config SQUASHFS_LZO
  	bool "Include support for LZO compressed file systems"
  	depends on SQUASHFS
-	default n
  	select LZO_DECOMPRESS
  	help
  	  Saying Y here includes support for reading Squashfs file systems
@@ -56,7 +54,6 @@ config SQUASHFS_LZO
  config SQUASHFS_EMBEDDED
  	bool "Additional option for memory-constrained systems"
  	depends on SQUASHFS
-	default n
  	help
  	  Saying Y here allows you to specify cache size.

-- 
1.6.3.3

