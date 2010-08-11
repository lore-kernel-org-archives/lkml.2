Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0HKQCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 12:02:43 -0400
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:34151 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754179Ab0HKQCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 12:02:42 -0400
Message-ID: <4C62C93A.2010504@lougher.demon.co.uk>
Date: Wed, 11 Aug 2010 17:00:58 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Squashfs updates for 2.6.36
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling the following Squashfs update which adds
LZO decompression support.  In addition to this there's various
minor updates which fix compiler warnings and whitespace/typos.

Thanks

Phillip

----------------

The following changes since commit 899f4530334da9292556e1f8f5791468e0136ff1:
   Phillip Lougher (1):
         squashfs: update documentation to include description of xattr layout

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git master

Chan Jeong (1):
       Squashfs: Add LZO compression support

Phillip Lougher (7):
       squashfs: fix compiler inline warning
       Squashfs: Make XATTR config name consistent with other file systems
       squashfs: fix filename in header comment
       Squashfs: fix block size use in LZO decompressor
       Squashfs: update Kconfig and documentation for LZO
       Squashfs: fix filename typo
       Squashfs: fix checkpatch.pl warnings

  Documentation/filesystems/squashfs.txt |    2 +-
  fs/squashfs/Kconfig                    |   25 +++++-
  fs/squashfs/Makefile                   |    4 +-
  fs/squashfs/decompressor.c             |    6 ++
  fs/squashfs/lzo_wrapper.c              |  136 ++++++++++++++++++++++++++++++++
  fs/squashfs/squashfs.h                 |    3 +
  fs/squashfs/squashfs_fs.h              |   20 +++---
  fs/squashfs/xattr.c                    |    4 +-
  fs/squashfs/xattr.h                    |    2 +-
  9 files changed, 181 insertions(+), 21 deletions(-)
  create mode 100644 fs/squashfs/lzo_wrapper.c
