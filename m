Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab2EYNCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:02:33 -0400
Received: from anubis.se.axis.com ([195.60.68.12]:44071 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab2EYNCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:02:31 -0400
Date: Fri, 25 May 2012 15:02:27 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jespern@axis.com
Subject: [GIT PULL] CRIS updates for v3.5
Message-ID: <20120525130227.GB19174@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tjo!

I've tried the signed tag approach for this pull-request,
I hope I did it right.

No major changes here, but fixes some compile errors for CRIS,
some small style issues, some documentation and as a
bonus nukes a couple of obsolete rtc-files and related code.


Best regards,

/Jesper


The following changes since commit 7d6e1cb7aed231b58acd71bdbe67fc03221373e4:

  Merge branch 'drm-prime-dmabuf-initial' of git://people.freedesktop.org/~airlied/linux (2012-04-02 17:58:04 -0700)

are available in the git repository at:


  git://jni.nu/cris.git tags/cris-for-linus

for you to fetch changes up to 7b91747d42a1012e3781dd09fa638d113809e3fd:

  cris: Remove old legacy "-traditional" flag from arch-v10/lib/Makefile (2012-04-19 11:17:04 +0200)

----------------------------------------------------------------
CRIS changes for 3.5

----------------------------------------------------------------
Jesper Nilsson (5):
      CRISv32: Correct name of read_mostly section.
      cris/arch-v32: cryptocop: Use kzalloc
      CRIS: Update documentation
      CRIS: Add _sdata to vmlinux.lds.S
      CRIS: Remove legacy RTC drivers

Jiri Slaby (1):
      cris: posix_types.h, include asm-generic/posix_types.h

Kautuk Consul (1):
      cris/mm/fault.c: Port OOM changes to do_page_fault

Paul Gortmaker (1):
      cris: Remove old legacy "-traditional" flag from arch-v10/lib/Makefile

Wanlong Gao (3):
      cris:removed the unused variable
      net:removed the unused variable
      cris:fix the wrong function declear

 Documentation/cris/README               |   62 ++--
 arch/cris/arch-v10/drivers/ds1302.c     |  515 -------------------------------
 arch/cris/arch-v10/drivers/pcf8563.c    |  380 -----------------------
 arch/cris/arch-v10/kernel/fasttimer.c   |    2 -
 arch/cris/arch-v10/kernel/kgdb.c        |    2 +-
 arch/cris/arch-v10/kernel/time.c        |    9 -
 arch/cris/arch-v10/lib/Makefile         |    3 -
 arch/cris/arch-v32/drivers/cryptocop.c  |    6 +-
 arch/cris/arch-v32/kernel/ptrace.c      |    2 -
 arch/cris/arch-v32/kernel/time.c        |    7 -
 arch/cris/include/arch-v32/arch/cache.h |    2 +-
 arch/cris/include/asm/Kbuild            |    1 -
 arch/cris/include/asm/posix_types.h     |    2 +
 arch/cris/include/asm/rtc.h             |  107 -------
 arch/cris/kernel/time.c                 |   76 +----
 arch/cris/kernel/vmlinux.lds.S          |    1 +
 arch/cris/mm/fault.c                    |   31 +-
 drivers/net/cris/eth_v10.c              |    1 -
 18 files changed, 71 insertions(+), 1138 deletions(-)
 delete mode 100644 arch/cris/arch-v10/drivers/ds1302.c
 delete mode 100644 arch/cris/arch-v10/drivers/pcf8563.c
 delete mode 100644 arch/cris/include/asm/rtc.h


/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
