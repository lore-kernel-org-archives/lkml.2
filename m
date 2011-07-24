Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab1GXWz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 18:55:28 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:57406 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752503Ab1GXWz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 18:55:26 -0400
Message-ID: <4E2CA2F0.9090202@lougher.demon.co.uk>
Date: Sun, 24 Jul 2011 23:55:44 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
CC: linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/2] Squashfs: Update documentation for XZ and add squashfs-tools
 devel tree
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
---
  Documentation/filesystems/squashfs.txt |    4 +++-
  1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/squashfs.txt b/Documentation/filesystems/squashfs.txt
index d4d4146..7db3ebd 100644
--- a/Documentation/filesystems/squashfs.txt
+++ b/Documentation/filesystems/squashfs.txt
@@ -2,7 +2,7 @@ SQUASHFS 4.0 FILESYSTEM
  =======================

  Squashfs is a compressed read-only filesystem for Linux.
-It uses zlib/lzo compression to compress files, inodes and directories.
+It uses zlib/lzo/xz compression to compress files, inodes and directories.
  Inodes in the system are very small and all blocks are packed to minimise
  data overhead. Block sizes greater than 4K are supported up to a maximum
  of 1Mbytes (default block size 128K).
@@ -55,6 +55,8 @@ create populated squashfs filesystems.  This and other squashfs utilities
  can be obtained from http://www.squashfs.org.  Usage instructions can be
  obtained from this site also.

+The squashfs-tools development tree is now located on kernel.org
+	git://git.kernel.org/pub/scm/fs/squashfs/squashfs-tools.git

  3. SQUASHFS FILESYSTEM DESIGN
  -----------------------------
-- 
1.7.1

