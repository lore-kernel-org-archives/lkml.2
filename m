Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030790Ab2CQNJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 09:09:59 -0400
Received: from 1wt.eu ([62.212.114.60]:63415 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965084Ab2CQNJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 09:09:55 -0400
Date: Sat, 17 Mar 2012 14:09:53 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Linux 2.6.32.59
Message-ID: <20120317130953.GA16926@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've just released Linux 2.6.32.59.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/2.6.32/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/2.6.32/patch-2.6.32.59.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/2.6.32/patch-2.6.32.59.xz
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/2.6.32/patch-2.6.32.59.gz
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/2.6.32/ChangeLog-2.6.32.59

The updated 2.6.32.y git tree can be found at:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.32.y
  http://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.32.y

The tree can be browsed on the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=shortlog;h=refs/heads/linux-2.6.32.y


  Testing status (build/boot, OK/FAIL, otherwise not tested) :

         ARCH  |         CONFIGURATION
       --------+-----------------------------------
               |  allmodconfig     other-config
        x86_64 |    build:OK            -
          i386 |    build:OK         boot:OK

Thanks to all reviewers, and to Greg for the final packaging.
Willy

---------
 Makefile                      |    2 +-
 arch/ia64/Kconfig             |   17 -----------------
 arch/s390/Kconfig             |    3 +++
 arch/s390/kernel/setup.c      |    1 +
 block/bsg.c                   |    3 ++-
 drivers/block/xen-blkfront.c  |    4 ++--
 drivers/net/usb/usbnet.c      |    2 ++
 drivers/watchdog/hpwdt.c      |    5 +++--
 fs/binfmt_elf.c               |    2 +-
 fs/cifs/dir.c                 |   20 ++++++++++++++++++--
 fs/ecryptfs/crypto.c          |   21 +++++++++++++++++++++
 fs/ecryptfs/ecryptfs_kernel.h |    2 ++
 fs/ecryptfs/file.c            |    3 ++-
 fs/ecryptfs/inode.c           |   18 +++---------------
 include/linux/backing-dev.h   |    1 +
 include/linux/regset.h        |   10 ++++++++--
 mm/backing-dev.c              |   15 ++++++++++-----
 mm/page-writeback.c           |    1 +
 18 files changed, 81 insertions(+), 49 deletions(-)

Summary of changes from 2.6.32.58 to 2.6.32.59
==============================================
Ben Hutchings (1):
      IA64: Remove COMPAT_IA32 support

David Howells (1):
      KEYS: Enable the compat keyctl wrapper on s390x

David Vrabel (1):
      blkfront: Fix backtrace in del_gendisk

H. Peter Anvin (2):
      regset: Prevent null pointer reference on readonly regsets
      regset: Return -EFAULT, not -EIO, on host-side memory fault

Heiko Carstens (1):
      compat: Re-add missing asm/compat.h include to fix compile breakage on s390

Jeff Layton (1):
      cifs: fix dentry refcount leak when opening a FIFO on lookup

Jens Axboe (1):
      writeback: fixups for !dirty_writeback_centisecs

Maxim Uvarov (1):
      watchdog: hpwdt: clean up set_memory_x call for 32 bit

Sebastian Siewior (1):
      net/usbnet: avoid recursive locking in usbnet_stop()

Stanislaw Gruszka (1):
      bsg: fix sysfs link remove warning

Tyler Hicks (1):
      eCryptfs: Handle failed metadata read in lookup

Willy Tarreau (1):
      Linux 2.6.32.59

