Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab1CQP7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 11:59:17 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19364 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab1CQP7O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 11:59:14 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6287"; a="80337495"
From: David Brown <davidb@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Subject: [Git pull] MSM for v2.6.39
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
Date: Thu, 17 Mar 2011 08:59:37 -0700
Message-ID: <8yazkotpwk6.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 054cfaacf88865bff1dd58d305443d5d6c068a08:

  Merge branch 'mnt_devname' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6 (2011-03-16 19:09:57 -0700)

are available in the git repository at:

  git://codeaurora.org/quic/kernel/davidb/linux-msm.git for-linus

Arve Hjønnevåg (1):
      msm_fb: Fix framebuffer console

David Brown (16):
      msm: Add CPU queries
      msm: Generalize timer register mappings
      msm: Generalize QGIC registers
      msm: Add MSM 8960 cpu_is check
      Merge branch 'msm-uart' into for-next
      Merge branch 'msm-8960' into for-next
      Merge branch 'msm-sdcc' into for-next
      Merge branch 'msm-fb' into for-next
      Merge branch 'msm-8960' into msm-core
      msm: Remove broken register definition from trout
      msm: Warning fix in trout gpio board file
      Merge branch 'msm-core' into for-next
      Merge branch 'msm-core' into for-next
      Merge branch 'msm-core' into for-next
      msm: Use explicit GPLv2 licenses
      Merge remote branch 'rmk/for-linus' into for-linus

Dima Zavin (4):
      ARM: msm: 7x30: don't force a gpiomux table for the whole arch
      video: msmfb: Put the partial update magic value into the fix_screen struct.
      msm: mdp: Add support for RGBX 8888 image format.
      msm: mdp: Set the correct pack pattern for XRGB/ARGB

Matt Wagantall (1):
      msm: clock: Move debugfs code from clock.c to clock-debug.c

Sahitya Tummala (2):
      mmc: msm_sdcc: Add gpio handling function to driver
      msm: 8x50: Add initial support for SDCC

Stepan Moskovchenko (20):
      msm: io: I/O register definitions for MSM8960
      msm: Physical offset for MSM8960
      msm: irqs-8960: Interrupt map for MSM8960
      msm: timer: Timer support for MSM8960
      msm: Makefile cleanup
      msm: Support for the MSM8960 Simulator target
      msm: Support for the MSM8960 RUMI3 target
      msm: Add name field to UART resources
      serial: msm: Add support for UARTDM cores
      msm: Clean up useless ifdefs
      msm: serial: Add MSM8960 serial support
      msm: iommu: Create a Kconfig item for the IOMMU driver
      msm: iommu: Generalize platform data for multiple targets
      msm: iommu: Enable IOMMU support for MSM8960
      msm: iommu: Clock control for the IOMMU driver
      msm: iommu: Rework clock logic and add IOMMU bus clock control
      msm: iommu: Use ASID tagging instead of VMID tagging
      msm: iommu: Remove dependency on IDR
      msm: iommu: Don't read from write-only registers
      msm: iommu: Enable HTW L2 redirection on MSM8960

Stephen Boyd (10):
      msm: clock: Remove unused code and definitions
      msm: clock: Remove 7x30 and pcom includes from clock.h
      msm: clock: Invert debugfs directory layout
      msm: clock: Add support for more proc_comm clocks
      msm: headsmp.S: Fix section mismatch
      msm: clock: Remove references to clk_ops_pcom
      msm: clock: Migrate to clkdev
      msm: scm: Mark inline asm as volatile
      msm: scm: Fix improper register assignment
      msm: scm: Check for interruption immediately

Tejun Heo (1):
      video/msm_fb: use system_wq instead of dedicated workqueues

 arch/arm/Kconfig                                   |    1 +
 arch/arm/mach-msm/Kconfig                          |   37 +++-
 arch/arm/mach-msm/Makefile                         |   29 +-
 arch/arm/mach-msm/board-halibut.c                  |    2 -
 arch/arm/mach-msm/board-mahimahi.c                 |    2 -
 arch/arm/mach-msm/board-msm7x27.c                  |    8 -
 arch/arm/mach-msm/board-msm7x30.c                  |   29 ++-
 arch/arm/mach-msm/board-msm8960.c                  |   91 +++++++
 arch/arm/mach-msm/board-msm8x60.c                  |    4 -
 arch/arm/mach-msm/board-qsd8x50.c                  |   86 ++++++-
 arch/arm/mach-msm/board-sapphire.c                 |    2 -
 arch/arm/mach-msm/board-trout-gpio.c               |    2 -
 arch/arm/mach-msm/board-trout.c                    |    3 +-
 arch/arm/mach-msm/clock-7x30.h                     |   61 ++---
 arch/arm/mach-msm/clock-debug.c                    |  130 +++++++++
 arch/arm/mach-msm/clock-dummy.c                    |   54 ----
 arch/arm/mach-msm/clock-pcom.c                     |    7 +
 arch/arm/mach-msm/clock-pcom.h                     |   51 ++---
 arch/arm/mach-msm/clock.c                          |  192 +------------
 arch/arm/mach-msm/clock.h                          |   55 +----
 .../{devices-msm8x60-iommu.c => devices-iommu.c}   |   85 +++---
 arch/arm/mach-msm/devices-msm7x00.c                |   36 ++--
 arch/arm/mach-msm/devices-msm7x30.c                |   11 +-
 arch/arm/mach-msm/devices-msm8960.c                |   85 ++++++
 arch/arm/mach-msm/devices-qsd8x50.c                |  213 ++++++++++++++-
 arch/arm/mach-msm/devices.h                        |   11 +-
 arch/arm/mach-msm/gpiomux-7x30.c                   |   38 ---
 arch/arm/mach-msm/gpiomux-8x50.c                   |   23 ++
 arch/arm/mach-msm/headsmp.S                        |    2 +-
 arch/arm/mach-msm/include/mach/board.h             |    4 +-
 arch/arm/mach-msm/include/mach/clk.h               |   31 +--
 arch/arm/mach-msm/include/mach/clkdev.h            |   19 ++
 arch/arm/mach-msm/include/mach/cpu.h               |   54 ++++
 arch/arm/mach-msm/include/mach/io.h                |    1 +
 arch/arm/mach-msm/include/mach/iommu.h             |   18 +-
 arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h     |   32 +--
 arch/arm/mach-msm/include/mach/irqs-7x30.h         |   31 +--
 arch/arm/mach-msm/include/mach/irqs-8960.h         |  277 +++++++++++++++++++
 arch/arm/mach-msm/include/mach/irqs-8x50.h         |   31 +--
 arch/arm/mach-msm/include/mach/irqs.h              |    3 +
 arch/arm/mach-msm/include/mach/memory.h            |    2 +
 arch/arm/mach-msm/include/mach/mmc.h               |   11 +
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h    |   16 +-
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h    |   14 +-
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h    |   48 ++++
 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h    |   22 +-
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h    |   61 +----
 arch/arm/mach-msm/include/mach/msm_iomap.h         |    9 +-
 arch/arm/mach-msm/include/mach/sirc.h              |   31 +--
 arch/arm/mach-msm/include/mach/smp.h               |   30 +--
 arch/arm/mach-msm/io.c                             |   41 ++-
 arch/arm/mach-msm/iommu.c                          |   72 +++++-
 arch/arm/mach-msm/iommu_dev.c                      |  230 ++++++++++-------
 arch/arm/mach-msm/scm-boot.h                       |   30 +--
 arch/arm/mach-msm/scm.c                            |   58 +++--
 arch/arm/mach-msm/scm.h                            |   30 +--
 arch/arm/mach-msm/timer.c                          |   46 ++--
 drivers/mmc/host/msm_sdcc.c                        |   40 +++-
 drivers/mmc/host/msm_sdcc.h                        |    1 +
 drivers/tty/serial/msm_serial.c                    |  286 +++++++++++++++++---
 drivers/tty/serial/msm_serial.h                    |   28 ++-
 drivers/video/msm/mdp_hw.h                         |   11 +-
 drivers/video/msm/mdp_ppp.c                        |    1 +
 drivers/video/msm/msm_fb.c                         |   27 +-
 include/linux/msm_mdp.h                            |    1 +
 65 files changed, 1976 insertions(+), 1021 deletions(-)
 create mode 100644 arch/arm/mach-msm/board-msm8960.c
 create mode 100644 arch/arm/mach-msm/clock-debug.c
 delete mode 100644 arch/arm/mach-msm/clock-dummy.c
 rename arch/arm/mach-msm/{devices-msm8x60-iommu.c => devices-iommu.c} (92%)
 create mode 100644 arch/arm/mach-msm/devices-msm8960.c
 delete mode 100644 arch/arm/mach-msm/gpiomux-7x30.c
 create mode 100644 arch/arm/mach-msm/include/mach/clkdev.h
 create mode 100644 arch/arm/mach-msm/include/mach/cpu.h
 create mode 100644 arch/arm/mach-msm/include/mach/irqs-8960.h
 create mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-8960.h

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
