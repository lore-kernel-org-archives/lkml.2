Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760326Ab0J1WCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 18:02:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48380 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760452Ab0J1WCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 18:02:35 -0400
Date: Fri, 29 Oct 2010 00:02:31 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: andy.shevchenko@gmail.com, brueckner@linux.vnet.ibm.com, mika@grml.org,
        mmarek@suse.cz, sakiwit@gmail.com, vapier.adi@gmail.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild core changes for 2.6.37-rc1
Message-ID: <20101028220231.GA29698@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these kbuild changes for 2.6.37-rc1:
* usr/initramfs cleanup and fix (and a fix to build Blackfin again)
* 'make clean' cleanup and fix
* two more minor fixes

Nothing really exciting this time, I have three more branches that will
follow.

Michal

The following changes since commit da5cabf80e2433131bf0ed8993abc0f7ea618c73:

  Linux 2.6.36-rc1 (2010-08-15 17:41:37 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git kbuild

Andy Shevchenko (1):
      scripts/mod/modpost.c: fix commentary accordingly to last changes

Hendrik Brueckner (2):
      initramfs: generalize initramfs_data.xxx.S variants
      initramfs: fix initramfs size calculation

Jean Sacren (1):
      scripts/kallsyms: Enable error messages while hush up unnecessary warnings

Michael Prokop (1):
      scripts/setlocalversion: update comment

Michal Marek (4):
      kbuild: Really don't clean bounds.h and asm-offsets.h
      kbuild: Do not run make clean in $(srctree)
      kbuild: Use a single clean rule for kernel and external modules
      Merge branch 'kbuild/clean' into kbuild/kbuild

Mike Frysinger (1):
      initramfs: Fix build break on symbol-prefixed archs

 Documentation/kbuild/makefiles.txt |    7 +++++++
 Kbuild                             |    4 ++--
 Makefile                           |   33 +++++++++++++--------------------
 include/asm-generic/vmlinux.lds.h  |    3 ++-
 init/initramfs.c                   |    9 ++++-----
 scripts/Makefile.clean             |    2 ++
 scripts/Makefile.lib               |    4 +++-
 scripts/kallsyms.c                 |    8 ++------
 scripts/mod/modpost.c              |    5 ++++-
 scripts/setlocalversion            |    6 ++++--
 usr/Makefile                       |    6 ++++--
 usr/initramfs_data.S               |   21 ++++++++++++++-------
 usr/initramfs_data.bz2.S           |   29 -----------------------------
 usr/initramfs_data.gz.S            |   29 -----------------------------
 usr/initramfs_data.lzma.S          |   29 -----------------------------
 usr/initramfs_data.lzo.S           |   29 -----------------------------
 16 files changed, 61 insertions(+), 163 deletions(-)
 delete mode 100644 usr/initramfs_data.bz2.S
 delete mode 100644 usr/initramfs_data.gz.S
 delete mode 100644 usr/initramfs_data.lzma.S
 delete mode 100644 usr/initramfs_data.lzo.S
