Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab1GYQcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 12:32:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54381 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab1GYQb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 12:31:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] arm-soc platform removal for 3.1
Date: Mon, 25 Jul 2011 18:31:45 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <201107251822.10265.arnd@arndb.de> <201107251828.55180.arnd@arndb.de>
In-Reply-To: <201107251828.55180.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107251831.45463.arnd@arndb.de>
X-Provags-ID: V02:K0:Ox6nsnLFDFr6QA+LJaDRfeuHRi9U7lrzVJOKxsj5EB9
 kHofPLMCnvYNtf4kTYs3NR3UwnKDxAVaTy41nyIzDmQPm1UA0j
 IfgJgF2J3vejmryE3VjqGPeewVWal4QHrOWSzlP32UkFIYb92U
 l4UUyqFdqhPY12oauX7hFcj7VUEKG+D2G9r6eFJwAK9v0Q4fq5
 2K1tS4/nPxCCuKPsEtu7w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This branch of arm-soc removes three platforms from the arm architecture
that have been abandoned and were either never working or not for a long
time.

	Arnd

The following changes since commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe:

  Linux 3.0 (2011-07-21 19:17:23 -0700)

are available in the git repository at:
  git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arm/linux-arm-soc.git next/deletion

Nicolas Pitre (3):
      ARM: mach-s3c24a0: delete
      ARM: mach-s3c2400: delete
      ARM: mach-loki: delete

 Documentation/arm/Samsung-S3C24XX/Overview.txt     |    7 +-
 arch/arm/Kconfig                                   |   11 -
 arch/arm/Makefile                                  |    4 +-
 arch/arm/configs/loki_defconfig                    |  120 ----------
 arch/arm/mach-loki/Kconfig                         |   13 -
 arch/arm/mach-loki/Makefile                        |    3 -
 arch/arm/mach-loki/Makefile.boot                   |    3 -
 arch/arm/mach-loki/addr-map.c                      |  122 ----------
 arch/arm/mach-loki/common.c                        |  162 -------------
 arch/arm/mach-loki/common.h                        |   37 ---
 arch/arm/mach-loki/include/mach/bridge-regs.h      |   28 ---
 arch/arm/mach-loki/include/mach/debug-macro.S      |   19 --
 arch/arm/mach-loki/include/mach/entry-macro.S      |   30 ---
 arch/arm/mach-loki/include/mach/hardware.h         |   15 --
 arch/arm/mach-loki/include/mach/io.h               |   26 --
 arch/arm/mach-loki/include/mach/irqs.h             |   58 -----
 arch/arm/mach-loki/include/mach/loki.h             |   83 -------
 arch/arm/mach-loki/include/mach/memory.h           |   10 -
 arch/arm/mach-loki/include/mach/system.h           |   36 ---
 arch/arm/mach-loki/include/mach/timex.h            |   11 -
 arch/arm/mach-loki/include/mach/uncompress.h       |   47 ----
 arch/arm/mach-loki/include/mach/vmalloc.h          |    5 -
 arch/arm/mach-loki/irq.c                           |   22 --
 arch/arm/mach-loki/lb88rc8480-setup.c              |   99 --------
 arch/arm/mach-s3c2400/Kconfig                      |    7 -
 arch/arm/mach-s3c2400/Makefile                     |   15 --
 arch/arm/mach-s3c2400/gpio.c                       |   42 ----
 arch/arm/mach-s3c2400/include/mach/map.h           |   66 ------
 arch/arm/mach-s3c2410/include/mach/gpio-fns.h      |    6 -
 arch/arm/mach-s3c2410/include/mach/regs-gpio.h     |  241 --------------------
 arch/arm/mach-s3c2410/include/mach/regs-mem.h      |   28 ---
 arch/arm/mach-s3c2412/Kconfig                      |    2 +-
 arch/arm/mach-s3c24a0/include/mach/debug-macro.S   |   27 ---
 arch/arm/mach-s3c24a0/include/mach/io.h            |   18 --
 arch/arm/mach-s3c24a0/include/mach/irqs.h          |  117 ----------
 arch/arm/mach-s3c24a0/include/mach/map.h           |   86 -------
 arch/arm/mach-s3c24a0/include/mach/memory.h        |   21 --
 arch/arm/mach-s3c24a0/include/mach/regs-clock.h    |   88 -------
 arch/arm/mach-s3c24a0/include/mach/regs-irq.h      |   25 --
 arch/arm/mach-s3c24a0/include/mach/system.h        |   25 --
 arch/arm/mach-s3c24a0/include/mach/tick.h          |   15 --
 arch/arm/mach-s3c24a0/include/mach/timex.h         |   18 --
 arch/arm/mach-s3c24a0/include/mach/vmalloc.h       |   17 --
 arch/arm/plat-s3c24xx/Kconfig                      |    2 +-
 arch/arm/plat-s3c24xx/cpu.c                        |   15 --
 arch/arm/plat-s3c24xx/include/plat/regs-iis.h      |    9 -
 arch/arm/plat-s3c24xx/include/plat/regs-spi.h      |    1 -
 arch/arm/plat-s3c24xx/include/plat/s3c2400.h       |   31 ---
 .../plat-samsung/include/plat/gpio-cfg-helpers.h   |    2 +-
 arch/arm/plat-samsung/include/plat/regs-serial.h   |    8 -
 drivers/tty/serial/Kconfig                         |   15 --
 drivers/tty/serial/Makefile                        |    2 -
 drivers/tty/serial/s3c2400.c                       |  105 ---------
 drivers/tty/serial/s3c24a0.c                       |  117 ----------
 54 files changed, 9 insertions(+), 2133 deletions(-)
 delete mode 100644 arch/arm/configs/loki_defconfig
 delete mode 100644 arch/arm/mach-loki/Kconfig
 delete mode 100644 arch/arm/mach-loki/Makefile
 delete mode 100644 arch/arm/mach-loki/Makefile.boot
 delete mode 100644 arch/arm/mach-loki/addr-map.c
 delete mode 100644 arch/arm/mach-loki/common.c
 delete mode 100644 arch/arm/mach-loki/common.h
 delete mode 100644 arch/arm/mach-loki/include/mach/bridge-regs.h
 delete mode 100644 arch/arm/mach-loki/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-loki/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-loki/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-loki/include/mach/io.h
 delete mode 100644 arch/arm/mach-loki/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-loki/include/mach/loki.h
 delete mode 100644 arch/arm/mach-loki/include/mach/memory.h
 delete mode 100644 arch/arm/mach-loki/include/mach/system.h
 delete mode 100644 arch/arm/mach-loki/include/mach/timex.h
 delete mode 100644 arch/arm/mach-loki/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-loki/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-loki/irq.c
 delete mode 100644 arch/arm/mach-loki/lb88rc8480-setup.c
 delete mode 100644 arch/arm/mach-s3c2400/Kconfig
 delete mode 100644 arch/arm/mach-s3c2400/Makefile
 delete mode 100644 arch/arm/mach-s3c2400/gpio.c
 delete mode 100644 arch/arm/mach-s3c2400/include/mach/map.h
 delete mode 100644 arch/arm/mach-s3c24a0/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-s3c24a0/include/mach/io.h
 delete mode 100644 arch/arm/mach-s3c24a0/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-s3c24a0/include/mach/map.h
 delete mode 100644 arch/arm/mach-s3c24a0/include/mach/memory.h
 delete mode 100644 arch/arm/mach-s3c24a0/include/mach/regs-clock.h
 delete mode 100644 arch/arm/mach-s3c24a0/include/mach/regs-irq.h
 delete mode 100644 arch/arm/mach-s3c24a0/include/mach/system.h
 delete mode 100644 arch/arm/mach-s3c24a0/include/mach/tick.h
 delete mode 100644 arch/arm/mach-s3c24a0/include/mach/timex.h
 delete mode 100644 arch/arm/mach-s3c24a0/include/mach/vmalloc.h
 delete mode 100644 arch/arm/plat-s3c24xx/include/plat/s3c2400.h
 delete mode 100644 drivers/tty/serial/s3c2400.c
 delete mode 100644 drivers/tty/serial/s3c24a0.c
