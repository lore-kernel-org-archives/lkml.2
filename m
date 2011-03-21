Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab1CUQTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:19:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43386 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab1CUQTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:19:02 -0400
Date: Mon, 21 Mar 2011 16:18:59 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] assorted vfs/fs patches
Message-ID: <20110321161859.GU22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Misc patches from the last cycle + fix for nfs_path() braino +
sys_syncfs().  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Tomorrow: procfs piles...

Shortlog:
Akinobu Mita (1):
      bfs: fix bitmap size argument to find_first_zero_bit()

Andrey Vagin (1):
      fs: devpts_pty_new() return -ENOMEM if dentry allocation failed

Ben Hutchings (1):
      fs/inode: Fix kernel-doc format for inode_init_owner

Dan Carpenter (1):
      nfs: lock() vs unlock() typo

David Howells (1):
      FS: lookup_mnt() is only used in the core fs routines now

David Jenni (1):
      Filesystem: fifo: Fixed coding style issue.

Holger Hans Peter Freyther (1):
      Small typo fix...

Namhyung Kim (2):
      vfs: cleanup do_vfs_ioctl()
      select: remove unused MAX_SELECT_SECONDS

Sage Weil (1):
      introduce sys_syncfs to sync a single file system

Tetsuo Handa (1):
      fs: Use BUG_ON(!mnt) at dentry_open().

Tony Luck (1):
      pstore: fix leaking ->i_private

Diffstat:
 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/include/asm/unistd_32.h   |    3 ++-
 arch/x86/include/asm/unistd_64.h   |    2 ++
 arch/x86/kernel/syscall_table_32.S |    1 +
 fs/bfs/dir.c                       |    2 +-
 fs/compat.c                        |    3 ---
 fs/devpts/inode.c                  |   19 +++++++++----------
 fs/exec.c                          |    2 +-
 fs/fifo.c                          |    3 +--
 fs/inode.c                         |    2 +-
 fs/internal.h                      |    1 +
 fs/ioctl.c                         |   21 ++++++++-------------
 fs/nfs/namespace.c                 |    4 ++--
 fs/open.c                          |   13 ++-----------
 fs/pstore/inode.c                  |    8 +++++++-
 fs/select.c                        |    3 ---
 fs/sync.c                          |   24 ++++++++++++++++++++++++
 include/asm-generic/unistd.h       |    4 +++-
 include/linux/dcache.h             |    1 -
 include/linux/syscalls.h           |    1 +
 20 files changed, 67 insertions(+), 51 deletions(-)

