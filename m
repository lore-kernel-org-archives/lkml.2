Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab2JCKuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 06:50:13 -0400
Received: from ra.se.axis.com ([195.60.68.13]:55876 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab2JCKuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 06:50:11 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Oct 2012 06:50:11 EDT
Date: Wed, 3 Oct 2012 12:43:32 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-cris-kernel@axis.com
Subject: [GIT PULL] CRIS updates for 3.7
Message-ID: <20121003104332.GJ1390@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus!

Please pull the below tree for removal of some unused code from
the CRIS port.

Thanks,

/Jesper


The following changes since commit 485802a6c524e62b5924849dd727ddbb1497cc71:

  Linux 3.5-rc3 (2012-06-16 17:25:17 -0700)

are available in the git repository at:

  git://jni.nu/cris.git tags/cris-for-linus-3.7

for you to fetch changes up to d75d806cbbfb9c775e87779cd281c9c408c7aba3:

  CRIS: Remove VCS simulator specific code (2012-10-03 09:57:01 +0200)

----------------------------------------------------------------
CRIS changes for 3.7

----------------------------------------------------------------
Bjorn Helgaas (1):
      cris/PCI: remove pcibios_assign_resources()

Jesper Nilsson (1):
      CRIS: Remove VCS simulator specific code

 arch/cris/Kconfig                                  |   5 -
 arch/cris/arch-v32/drivers/axisflashmap.c          |  29 ------
 arch/cris/arch-v32/drivers/pci/bios.c              |  25 -----
 arch/cris/arch-v32/kernel/head.S                   |  58 +-----------
 arch/cris/arch-v32/kernel/kgdb.c                   |  14 ---
 arch/cris/arch-v32/mach-a3/Makefile                |   2 -
 arch/cris/arch-v32/mach-a3/vcs_hook.c              | 103 ---------------------
 arch/cris/arch-v32/mach-a3/vcs_hook.h              |  58 ------------
 arch/cris/arch-v32/mach-fs/Makefile                |   2 -
 arch/cris/arch-v32/mach-fs/vcs_hook.c              | 100 --------------------
 arch/cris/arch-v32/mach-fs/vcs_hook.h              |  42 ---------
 arch/cris/arch-v32/mm/init.c                       |   8 --
 arch/cris/include/arch-v32/arch/page.h             |   5 -
 arch/cris/include/arch-v32/arch/processor.h        |   6 +-
 .../cris/include/arch-v32/mach-fs/mach/startup.inc |   6 --
 arch/cris/include/asm/pci.h                        |   1 -
 16 files changed, 3 insertions(+), 461 deletions(-)
 delete mode 100644 arch/cris/arch-v32/mach-a3/vcs_hook.c
 delete mode 100644 arch/cris/arch-v32/mach-a3/vcs_hook.h
 delete mode 100644 arch/cris/arch-v32/mach-fs/vcs_hook.c
 delete mode 100644 arch/cris/arch-v32/mach-fs/vcs_hook.h

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
