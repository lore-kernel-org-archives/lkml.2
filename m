Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888Ab1KBCYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 22:24:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56393 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698Ab1KBCXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 22:23:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 6/13] arm-soc platform removal
Date: Tue, 1 Nov 2011 04:27:33 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <201111010348.13214.arnd@arndb.de>
In-Reply-To: <201111010348.13214.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111010427.33236.arnd@arndb.de>
X-Provags-ID: V02:K0:PQQrABuTezDtPcxLAjXn0YNZ4CKY+O2Vni5PCr4kes8
 1My8l2ZAUwdjE1METf+8VkYNTqFioK+mCHzAoTtXTZS7AznZMg
 0fukVDcgGwGTeMA/R9ZLKo+GhxkbMhmMLbH3XCcGTsyoEq6UHH
 RB5qTadHl43FvTpGflEwd+qi5Htu5vRvZAWnuBqFpaAy32Iu68
 yNqo27Nx9DWM6mZINHEiyKvl4Ds77h5SKUWUUKG9iUVP+Cnl2t
 E4deTe4ODtgZaAMkvRfwFGsP5xjTLK/CMBFMkdj2r2kIFDdngN
 Ry7Ckys3GMF3EBO56wttMP5cP6bRBDD2j7rNPpI3b4q3jCWvQq
 vzEsa9/SFF7sSkY4VC6o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre has identified another obviously broken and unused subarchitecture,
This single patch removes the entire platform. The patch causes conflicts against
later patches, but the resolution for these is obvious.

	Arnd

The following changes since commit 41270313d21d82b4fbac3a733b1f24cc7793b5b1:

  Merge branch 'next/pm' into for-next (2011-11-01 00:37:45 +0100)

are available in the git repository at:

  git://git.linaro.org/people/arnd/arm-soc.git next/deletion

Nicolas Pitre (1):
      ARM: mach-nuc93x: delete

 arch/arm/Kconfig                                |   10 --
 arch/arm/Makefile                               |    1 -
 arch/arm/mach-nuc93x/Kconfig                    |   19 ---
 arch/arm/mach-nuc93x/Makefile                   |   14 ---
 arch/arm/mach-nuc93x/Makefile.boot              |    3 -
 arch/arm/mach-nuc93x/clock.c                    |   83 --------------
 arch/arm/mach-nuc93x/clock.h                    |   36 ------
 arch/arm/mach-nuc93x/cpu.c                      |  135 ----------------------
 arch/arm/mach-nuc93x/cpu.h                      |   48 --------
 arch/arm/mach-nuc93x/dev.c                      |   42 -------
 arch/arm/mach-nuc93x/include/mach/entry-macro.S |   32 -----
 arch/arm/mach-nuc93x/include/mach/hardware.h    |   22 ----
 arch/arm/mach-nuc93x/include/mach/io.h          |   28 -----
 arch/arm/mach-nuc93x/include/mach/irqs.h        |   59 ----------
 arch/arm/mach-nuc93x/include/mach/map.h         |  139 -----------------------
 arch/arm/mach-nuc93x/include/mach/memory.h      |   21 ----
 arch/arm/mach-nuc93x/include/mach/regs-clock.h  |   53 ---------
 arch/arm/mach-nuc93x/include/mach/regs-ebi.h    |   33 ------
 arch/arm/mach-nuc93x/include/mach/regs-irq.h    |   42 -------
 arch/arm/mach-nuc93x/include/mach/regs-serial.h |   52 ---------
 arch/arm/mach-nuc93x/include/mach/regs-timer.h  |   28 -----
 arch/arm/mach-nuc93x/include/mach/system.h      |   28 -----
 arch/arm/mach-nuc93x/include/mach/timex.h       |   25 ----
 arch/arm/mach-nuc93x/include/mach/uncompress.h  |   50 --------
 arch/arm/mach-nuc93x/include/mach/vmalloc.h     |   23 ----
 arch/arm/mach-nuc93x/irq.c                      |   66 -----------
 arch/arm/mach-nuc93x/mach-nuc932evb.c           |   43 -------
 arch/arm/mach-nuc93x/nuc932.c                   |   65 -----------
 arch/arm/mach-nuc93x/nuc932.h                   |   29 -----
 arch/arm/mach-nuc93x/time.c                     |  100 ----------------
 30 files changed, 0 insertions(+), 1329 deletions(-)
 delete mode 100644 arch/arm/mach-nuc93x/Kconfig
 delete mode 100644 arch/arm/mach-nuc93x/Makefile
 delete mode 100644 arch/arm/mach-nuc93x/Makefile.boot
 delete mode 100644 arch/arm/mach-nuc93x/clock.c
 delete mode 100644 arch/arm/mach-nuc93x/clock.h
 delete mode 100644 arch/arm/mach-nuc93x/cpu.c
 delete mode 100644 arch/arm/mach-nuc93x/cpu.h
 delete mode 100644 arch/arm/mach-nuc93x/dev.c
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/io.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/map.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/memory.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/regs-clock.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/regs-ebi.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/regs-irq.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/regs-serial.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/regs-timer.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/system.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/timex.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-nuc93x/irq.c
 delete mode 100644 arch/arm/mach-nuc93x/mach-nuc932evb.c
 delete mode 100644 arch/arm/mach-nuc93x/nuc932.c
 delete mode 100644 arch/arm/mach-nuc93x/nuc932.h
 delete mode 100644 arch/arm/mach-nuc93x/time.c

