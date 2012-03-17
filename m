Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030988Ab2CQNPb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 09:15:31 -0400
Received: from 1wt.eu ([62.212.114.60]:63416 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965084Ab2CQNP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 09:15:26 -0400
Date: Sat, 17 Mar 2012 14:15:24 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Linux 2.6.27.62
Message-ID: <20120317131524.GA16943@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've just released Linux 2.6.27.62.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/2.6.27/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/2.6.27/patch-2.6.27.62.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/2.6.27/patch-2.6.27.62.xz
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/2.6.27/patch-2.6.27.62.gz
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/2.6.27/ChangeLog-2.6.27.62

The updated 2.6.27.y git tree can be found at:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.27.y
  http://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.27.y

The tree can be browsed on the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=shortlog;h=refs/heads/linux-2.6.27.y


  Testing status (build/boot, OK/FAIL, otherwise not tested) :

         ARCH  |         CONFIGURATION
       --------+-----------------------------------
               |  allmodconfig     other-config
        x86_64 |       -                -
          i386 |       -             build:OK

Thanks to all reviewers, and to Greg for the final packaging.
Willy

---------
 Makefile                           |    2 +-
 arch/powerpc/include/asm/ppc_asm.h |    1 +
 arch/powerpc/include/asm/reg.h     |   45 +++++++++++++++++++++++++++++++++++-
 drivers/cdrom/cdrom.c              |    8 +-----
 drivers/infiniband/hw/mlx4/mad.c   |    7 +----
 drivers/video/atmel_lcdfb.c        |    2 +-
 fs/ecryptfs/file.c                 |    2 +-
 fs/ecryptfs/inode.c                |    4 +-
 fs/ecryptfs/read_write.c           |    4 +-
 fs/udf/super.c                     |    6 ++++
 include/linux/proportions.h        |    4 +++
 kernel/relay.c                     |   10 ++++++-
 mm/filemap_xip.c                   |    7 ++++-
 13 files changed, 79 insertions(+), 23 deletions(-)

Summary of changes from 2.6.27.61 to 2.6.27.62
==============================================
Andy Whitcroft (1):
      ecryptfs: read on a directory should return EISDIR if not supported

Carsten Otte (1):
      mm/filemap_xip.c: fix race condition in xip_file_fault()

Dan Carpenter (2):
      relay: prevent integer overflow in relay_open()
      cdrom: use copy_to_user() without the underscores

Hubert Feurstein (1):
      atmel_lcdfb: fix usage of CONTRAST_CTR in suspend/resume

Jack Morgenstein (1):
      IB/mlx4: pass SMP vendor-specific attribute MADs to firmware

Jan Kara (1):
      udf: Mark LVID buffer as uptodate before marking it dirty

Li Wang (1):
      eCryptfs: Infinite loop due to overflow in ecryptfs_write()

Michael Neuling (1):
      powerpc: Add more Power7 specific definitions

Tyler Hicks (3):
      eCryptfs: Remove mmap from directory operations
      eCryptfs: Remove extra d_delete in ecryptfs_rmdir
      eCryptfs: Clear i_nlink in rmdir

Willy Tarreau (1):
      Linux 2.6.27.62

Wu Fengguang (1):
      lib: proportion: lower PROP_MAX_SHIFT to 32 on 64-bit kernel

