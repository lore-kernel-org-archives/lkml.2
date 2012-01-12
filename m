Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab2ALWzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 17:55:18 -0500
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:37157 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753503Ab2ALWzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 17:55:15 -0500
Message-ID: <4F0F64CF.8090502@lougher.demon.co.uk>
Date: Thu, 12 Jan 2012 22:55:11 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Squashfs updates for 3.3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling the following Squashfs updates, these
consist of a couple of bug fixes and a small optimisation.

There's a signed tag squashfs for this update.

Thanks

Phillip


The following changes since commit 5f0a6e2d503896062f641639dacfe5055c2f593b:

   Linux 3.2-rc7 (2011-12-23 21:51:06 -0800)

are available in the git repository at:
   git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-next.git master

Ajeet Yadav (1):
       Squashfs: optimise squashfs_cache_get entry search

Phillip Lougher (4):
       Squashfs: add missing block release on error condition
       Squashfs: Update documentation to include xattrs
       Squashfs: fix mount time sanity check for corrupted superblock
       Squashfs: fix i_blocks calculation with extended regular files

  Documentation/filesystems/squashfs.txt |    6 +++---
  fs/squashfs/cache.c                    |   30 +++++++++++++++++++++---------
  fs/squashfs/inode.c                    |    4 ++--
  fs/squashfs/squashfs_fs_sb.h           |    1 +
  fs/squashfs/super.c                    |    2 +-
  5 files changed, 28 insertions(+), 15 deletions(-)
