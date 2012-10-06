Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab2JFIQQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:16:16 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36953 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab2JFIQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:16:11 -0400
Message-ID: <506FE73A.9080406@gmail.com>
Date: Sat, 06 Oct 2012 10:09:30 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 00/22 v2]  drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I send the vmtruncate cleaning patches. With theses patches we remove 
the now deprecated vmtruncate and ->truncate() inode operations. The 
patches are now rebased against Linus tree and I add the cleaning of 
documentation. Please, consider this series for merge window of 3.7.

Thanks.

Marco Stornelli (22):
   ufs: drop vmtruncate
   sysv: drop vmtruncate
   reiserfs: drop vmtruncate
   procfs: drop vmtruncate
   omfs: drop vmtruncate
   ocfs2: drop vmtruncate
   adfs: drop vmtruncate
   affs: drop vmtruncate
   bfs: drop vmtruncate
   hfs: drop vmtruncate
   hpfs: drop vmtruncate
   jfs: drop vmtruncate
   hfsplus: drop vmtruncate
   hostfs: drop vmtruncate
   logfs: drop vmtruncate
   minix: drop vmtruncate
   ncpfs: drop vmtruncate
   nilfs2: drop vmtruncate
   ntfs: drop vmtruncate
   vfs: drop vmtruncate
   mm: drop vmtruncate
   documentation: drop vmtruncate

  Documentation/filesystems/Locking |    6 ------
  Documentation/filesystems/porting |   13 +------------
  Documentation/filesystems/vfs.txt |   11 -----------
  fs/adfs/inode.c                   |    5 +++--
  fs/affs/file.c                    |    8 +++++---
  fs/affs/inode.c                   |    5 ++++-
  fs/bfs/file.c                     |    5 +++--
  fs/hfs/inode.c                    |   19 +++++++++++++------
  fs/hfsplus/inode.c                |   19 +++++++++++++------
  fs/hostfs/hostfs_kern.c           |    8 +++++---
  fs/hpfs/file.c                    |    8 +++++---
  fs/hpfs/inode.c                   |    5 ++++-
  fs/jfs/file.c                     |    6 ++++--
  fs/jfs/inode.c                    |   13 +++++++++----
  fs/libfs.c                        |    2 --
  fs/logfs/readwrite.c              |   10 ++++++++--
  fs/minix/file.c                   |    6 ++++--
  fs/minix/inode.c                  |    7 +++++--
  fs/ncpfs/inode.c                  |    4 +++-
  fs/nilfs2/file.c                  |    1 -
  fs/nilfs2/inode.c                 |   18 +++++++++++++-----
  fs/nilfs2/recovery.c              |    7 +++++--
  fs/ntfs/file.c                    |    8 +++++---
  fs/ntfs/inode.c                   |   11 +++++++++--
  fs/ntfs/inode.h                   |    4 ++++
  fs/ocfs2/file.c                   |    3 ++-
  fs/omfs/file.c                    |   12 ++++++++----
  fs/proc/base.c                    |    3 ++-
  fs/proc/generic.c                 |    3 ++-
  fs/proc/proc_sysctl.c             |    3 ++-
  fs/reiserfs/file.c                |    3 +--
  fs/reiserfs/inode.c               |   15 +++++++++++----
  fs/reiserfs/reiserfs.h            |    1 +
  fs/sysv/file.c                    |    5 +++--
  fs/sysv/itree.c                   |    7 +++++--
  fs/ufs/inode.c                    |    5 +++--
  include/linux/fs.h                |    1 -
  include/linux/mm.h                |    1 -
  mm/truncate.c                     |   23 -----------------------
  39 files changed, 165 insertions(+), 129 deletions(-)

-- 
1.7.3.4
---

