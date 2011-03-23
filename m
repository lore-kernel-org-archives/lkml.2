Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab1CWVop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 17:44:45 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:48099 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752063Ab1CWVoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 17:44:44 -0400
Message-ID: <4D8A69BD.3010208@lougher.demon.co.uk>
Date: Wed, 23 Mar 2011 21:44:29 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Squashfs updates for 2.6.39
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling the following Squashfs updates, these
add support for reading compression options out of the filesystem,
plus there are a couple of bug fixes and documentation updates.

Thanks

Phillip


The following changes since commit 100b33c8bd8a3235fd0b7948338d6cbb3db3c63d:

   Linux 2.6.38-rc4 (2011-02-07 16:03:55 -0800)

are available in the git repository at:
   git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git master

Phillip Lougher (8):
       Squashfs: extend decompressor framework to handle compression options
       Squashfs: add compression options support to xz decompressor
       Squashfs: Update Kconfig help text to include xz compression
       Squashfs: Update documentation to include compression options
       Squashfs: xz_wrapper doesn't need to include squashfs_fs_i.h anymore
       Squashfs: wrap squashfs_mount() definition
       Squashfs: handle corruption of directory structure
       Squashfs: Use vmalloc rather than kmalloc for zlib workspace

  Documentation/filesystems/squashfs.txt |   28 +++++++++++-----
  fs/squashfs/Kconfig                    |   12 +++---
  fs/squashfs/decompressor.c             |   34 ++++++++++++++++++++
  fs/squashfs/decompressor.h             |    7 +---
  fs/squashfs/dir.c                      |    9 +++++
  fs/squashfs/lzo_wrapper.c              |    4 +-
  fs/squashfs/namei.c                    |   12 +++++++
  fs/squashfs/squashfs.h                 |    1 +
  fs/squashfs/squashfs_fs.h              |    4 ++
  fs/squashfs/super.c                    |   15 +++++---
  fs/squashfs/xz_wrapper.c               |   53 ++++++++++++++++++++++++++------
  fs/squashfs/zlib_wrapper.c             |   10 +++---
  12 files changed, 145 insertions(+), 44 deletions(-)
