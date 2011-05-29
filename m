Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab1E2CfF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 22:35:05 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49969 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab1E2CfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 22:35:02 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Pull request blackfin.git (for-linus branch)
Date: Sat, 28 May 2011 22:40:02 -0400
Message-Id: <1306636802-9523-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.rc3
In-Reply-To: <1306636724-9314-1-git-send-email-vapier@gentoo.org>
References: <1306636724-9314-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 36947a76826111e661a26cb0f668a5be6cc3ddb4:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6 (2011-05-28 13:03:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git for-linus

Mike Frysinger (8):
      Blackfin: bfin_serial.h: turn default port wrappers into stubs
      Blackfin: mach/bfin_serial_5xx.h: punt now-unused header
      Blackfin: wire up new sendmmsg syscall
      Blackfin: gptimers: add structure for hardware register layout
      Blackfin: debug-mmrs: fix typos with gptimers/mdma/ppi
      Blackfin: bf52x/bf54x: fix up usb MMR defines
      Blackfin: bf51x: fix up RSI_PID# MMR defines
      Blackfin: debug-mmrs: include RSI_PID[4567] MMRs

 arch/blackfin/include/asm/bfin_serial.h            |    6 +-
 arch/blackfin/include/asm/gptimers.h               |   18 ++++
 arch/blackfin/include/asm/unistd.h                 |    3 +-
 arch/blackfin/kernel/debug-mmrs.c                  |   36 ++++----
 .../mach-bf518/include/mach/bfin_serial_5xx.h      |   79 ----------------
 arch/blackfin/mach-bf518/include/mach/defBF514.h   |   16 ++--
 .../mach-bf527/include/mach/bfin_serial_5xx.h      |   79 ----------------
 arch/blackfin/mach-bf527/include/mach/defBF525.h   |    4 +-
 .../mach-bf533/include/mach/bfin_serial_5xx.h      |   52 -----------
 .../mach-bf537/include/mach/bfin_serial_5xx.h      |   79 ----------------
 .../mach-bf538/include/mach/bfin_serial_5xx.h      |   93 -------------------
 .../mach-bf548/include/mach/bfin_serial_5xx.h      |   94 --------------------
 arch/blackfin/mach-bf548/include/mach/defBF547.h   |   19 ++--
 .../mach-bf561/include/mach/bfin_serial_5xx.h      |   52 -----------
 arch/blackfin/mach-common/entry.S                  |    1 +
 15 files changed, 62 insertions(+), 569 deletions(-)
 delete mode 100644 arch/blackfin/mach-bf518/include/mach/bfin_serial_5xx.h
 delete mode 100644 arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h
 delete mode 100644 arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
 delete mode 100644 arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h
 delete mode 100644 arch/blackfin/mach-bf538/include/mach/bfin_serial_5xx.h
 delete mode 100644 arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h
 delete mode 100644 arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
