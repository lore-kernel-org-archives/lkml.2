Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933844Ab0EZBCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 21:02:10 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:42700 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933008Ab0EZBCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 21:02:08 -0400
Message-ID: <4BFC7269.3070309@lougher.demon.co.uk>
Date: Wed, 26 May 2010 01:59:21 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: [GIT PULL] Squashfs updates for 2.6.35
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please consider pulling the following Squashfs updates which add
file system support for extended attributes.

Thanks

Phillip

----------
The following changes since commit b57f95a38233a2e73b679bea4a5453a1cc2a1cc9:
   Linus Torvalds (1):
         Linux 2.6.34-rc7

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git master

Phillip Lougher (7):
       squashfs: add xattr id support
       squashfs: add support for xattr reading
       squashfs: add new extended inode types
       squashfs: add xattr support configure option
       squashfs: constify xattr handlers
       squashfs: fix name reading in squashfs_xattr_get
       squashfs: update documentation to include description of xattr layout

Stephen Hemminger (2):
       squashfs: xattr_lookup sparse fix
       squashfs: xattr fix sparse warnings

  Documentation/filesystems/squashfs.txt |   32 +++-
  fs/squashfs/Kconfig                    |   11 +
  fs/squashfs/Makefile                   |    2 +
  fs/squashfs/inode.c                    |   92 +++++++++-
  fs/squashfs/namei.c                    |    6 +-
  fs/squashfs/squashfs.h                 |   12 +-
  fs/squashfs/squashfs_fs.h              |   76 ++++++++-
  fs/squashfs/squashfs_fs_i.h            |    3 +
  fs/squashfs/squashfs_fs_sb.h           |    3 +
  fs/squashfs/super.c                    |   30 ++-
  fs/squashfs/symlink.c                  |   11 +
  fs/squashfs/xattr.c                    |  323 ++++++++++++++++++++++++++++++++
  fs/squashfs/xattr.h                    |   46 +++++
  fs/squashfs/xattr_id.c                 |  100 ++++++++++
  14 files changed, 723 insertions(+), 24 deletions(-)
  create mode 100644 fs/squashfs/xattr.c
  create mode 100644 fs/squashfs/xattr.h
  create mode 100644 fs/squashfs/xattr_id.c
