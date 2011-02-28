Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab1B1XgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 18:36:10 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:53136 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754175Ab1B1XgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 18:36:08 -0500
Message-ID: <4D6C3174.60201@lougher.demon.co.uk>
Date: Mon, 28 Feb 2011 23:36:20 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/6] Squashfs: Update Kconfig help text to include xz compression
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
  fs/squashfs/Kconfig |   12 ++++++------
  1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
index aa68a8a..efc309f 100644
--- a/fs/squashfs/Kconfig
+++ b/fs/squashfs/Kconfig
@@ -5,12 +5,12 @@ config SQUASHFS
  	help
  	  Saying Y here includes support for SquashFS 4.0 (a Compressed
  	  Read-Only File System).  Squashfs is a highly compressed read-only
-	  filesystem for Linux.  It uses zlib/lzo compression to compress both
-	  files, inodes and directories.  Inodes in the system are very small
-	  and all blocks are packed to minimise data overhead. Block sizes
-	  greater than 4K are supported up to a maximum of 1 Mbytes (default
-	  block size 128K).  SquashFS 4.0 supports 64 bit filesystems and files
-	  (larger than 4GB), full uid/gid information, hard links and
+	  filesystem for Linux.  It uses zlib, lzo or xz compression to
+	  compress both files, inodes and directories.  Inodes in the system
+	  are very small and all blocks are packed to minimise data overhead.
+	  Block sizes greater than 4K are supported up to a maximum of 1 Mbytes
+	  (default block size 128K).  SquashFS 4.0 supports 64 bit filesystems
+	  and files (larger than 4GB), full uid/gid information, hard links and
  	  timestamps.

  	  Squashfs is intended for general read-only filesystem use, for
-- 
1.7.1

