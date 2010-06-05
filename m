Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab0FEC6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 22:58:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55166 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab0FEC63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 22:58:29 -0400
Date: Sat, 5 Jun 2010 03:58:27 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs/fs for -rc2
Message-ID: <20100605025827.GI31073@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes and two really obvious cleanups; please pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (2):
      mqueue doesn't need make_bad_inode()
      fix the deadlock in qib_fs

Andrew Hendry (1):
      Minix: Clean up left over label

Dan Carpenter (1):
      fcntl: return -EFAULT if copy_to_user fails

Nick Piggin (2):
      fix setattr error handling in sysfs, configfs
      fix truncate inode time modification breakage

Roberto Sassu (1):
      wrong type for 'magic' argument in simple_fill_super()

Diffsstat:
 drivers/infiniband/hw/qib/qib_fs.c |    4 +---
 fs/configfs/inode.c                |    9 ++++-----
 fs/ext2/inode.c                    |    2 +-
 fs/fcntl.c                         |    7 +++++--
 fs/libfs.c                         |    3 ++-
 fs/minix/dir.c                     |    4 ----
 fs/sysfs/inode.c                   |    6 ++++--
 include/linux/fs.h                 |    2 +-
 ipc/mqueue.c                       |    1 -
 mm/shmem.c                         |    5 +++--
 10 files changed, 21 insertions(+), 22 deletions(-)
