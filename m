Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336Ab1CWUgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:36:23 -0400
Received: from kroah.org ([198.145.64.141]:56306 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932901Ab1CWUgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:36:21 -0400
Date: Wed, 23 Mar 2011 13:34:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.34
Message-ID: <20110323203426.GC7709@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.34 kernel.

All users of the 2.6.32 kernel series must upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/i2c/instantiating-devices |    2 
 Makefile                                |    2 
 arch/mips/alchemy/mtx-1/platform.c      |    9 ++
 arch/parisc/kernel/irq.c                |    2 
 arch/powerpc/include/asm/kexec.h        |    4 +
 arch/powerpc/include/asm/paca.h         |    3 
 arch/powerpc/include/asm/reg.h          |    1 
 arch/powerpc/kernel/asm-offsets.c       |    1 
 arch/powerpc/kernel/crash.c             |   27 +++++++
 arch/powerpc/kernel/machine_kexec_64.c  |   48 +++++++++----
 arch/powerpc/kernel/misc_64.S           |    8 +-
 arch/powerpc/kernel/paca.c              |    2 
 arch/powerpc/kernel/perf_event.c        |   24 ++++++
 arch/powerpc/kernel/rtas_flash.c        |   39 +++++------
 arch/x86/include/asm/pgtable-3level.h   |   11 ---
 arch/x86/kernel/e820.c                  |   10 ++
 arch/x86/kernel/early-quirks.c          |    7 +
 arch/x86/kernel/entry_64.S              |    2 
 arch/x86/mm/fault.c                     |    7 +
 arch/x86/mm/pgtable.c                   |    3 
 drivers/ata/ahci.c                      |    5 +
 drivers/ata/libata-core.c               |   24 ++++--
 drivers/hwmon/f71882fg.c                |    2 
 drivers/hwmon/sht15.c                   |    4 -
 drivers/infiniband/core/cm.c            |    1 
 drivers/infiniband/core/cma.c           |   15 ++++
 drivers/isdn/i4l/isdn_tty.c             |    6 -
 drivers/mmc/core/sdio.c                 |    8 ++
 drivers/mtd/nand/omap2.c                |    2 
 drivers/mtd/onenand/generic.c           |    2 
 drivers/mtd/onenand/omap2.c             |    2 
 drivers/net/wireless/ath/ath9k/hw.c     |    4 -
 drivers/pci/pci-sysfs.c                 |    2 
 drivers/pci/quirks.c                    |  113 +++++++++++++++-----------------
 drivers/usb/host/xhci-ring.c            |   14 +++
 drivers/usb/serial/ch341.c              |    1 
 drivers/usb/serial/kobil_sct.c          |    2 
 fs/ext3/namei.c                         |    2 
 include/linux/ftrace.h                  |    2 
 kernel/perf_event.c                     |    2 
 kernel/sched.c                          |    2 
 kernel/smp.c                            |   55 ++++++++++++---
 kernel/trace/ftrace.c                   |   52 ++++++++++++--
 net/sunrpc/sched.c                      |   14 +--
 sound/pci/ctxfi/ctatc.c                 |    2 
 sound/pci/ctxfi/ctdaio.c                |    2 
 sound/pci/ctxfi/ctmixer.c               |   19 +----
 sound/pci/hda/patch_sigmatel.c          |   11 ++-
 48 files changed, 397 insertions(+), 185 deletions(-)

Alexander van Heukelum (1):
      x86, binutils, xen: Fix another wrong size directive

Andreas Herrmann (1):
      x86, quirk: Fix SB600 revision check

Andrey Vagin (1):
      x86/mm: Handle mm_fault_error() in kernel space

Anton Blanchard (1):
      perf, powerpc: Handle events that raise an exception without overflowing

Axel Lin (1):
      mtd: add "platform:" prefix for platform modalias

Ben Hutchings (1):
      PCI: sysfs: Fix failure path for addition of "vpd" attribute

Brandeburg, Jesse (1):
      PCI: remove quirk for pre-production systems

Eric Sandeen (1):
      ext3: Always set dx_node's fake_dirent explicitly.

Florian Fainelli (1):
      MIPS: MTX-1: Make au1000_eth probe all PHY addresses

Frederic Weisbecker (1):
      perf: Handle stopped state with tracepoints

Greg Kroah-Hartman (1):
      Linux 2.6.32.34

Hans de Goede (1):
      hwmon/f71882fg: Set platform drvdata to NULL later

Jiri Slaby (3):
      USB: serial/kobil_sct, fix potential tty NULL dereference
      PCI: add more checking to ICH region quirks
      PCI: do not create quirk I/O regions below PCIBIOS_MIN_IO for ICH

Kamal Mostafa (2):
      x86: Fix panic when handling "mem={invalid}" param
      x86: Emit "mem=nopentium ignored" warning when not supported

Michael Neuling (2):
      powerpc/kexec: Fix race in kexec shutdown
      powerpc/kdump: Fix race in kdump shutdown

Milton Miller (4):
      call_function_many: fix list delete vs add race
      call_function_many: add missing ordering
      smp_call_function_many: handle concurrent clearing of mask
      powerpc: rtas_flash needs to use rtas_data_buf

Przemyslaw Bruski (3):
      ALSA: ctxfi - Fix incorrect SPDIF status bit mask
      ALSA: ctxfi - Fix SPDIF status retrieval
      ALSA: ctxfi - Clear input settings before initialization

Roman Fietze (1):
      i2c: Fix typo in instantiating-devices document

Sarah Sharp (1):
      xhci: Fix cycle bit calculation during stall handling.

Sean Hefty (2):
      RDMA/cma: Fix crash in request handlers
      IB/cm: Bump reference count on cm_id before invoking callback

Senthil Balasubramanian (1):
      ath9k_hw: Fix incorrect macversion and macrev checks

Seth Heasley (3):
      ahci: AHCI and RAID mode SATA patch for Intel Patsburg DeviceIDs
      ahci: AHCI mode SATA patch for Intel DH89xxCC DeviceIDs
      ahci: AHCI mode SATA patch for Intel Patsburg SATA RAID controller

Shaohua Li (1):
      x86: Flush TLB if PGD entry is changed in i386 PAE mode

Stefan Nilsson XK (1):
      mmc: sdio: remember new card RCA when redetecting card

Steven Rostedt (1):
      ftrace: Fix memory leak with function graph and cpu hotplug

Tejun Heo (1):
      libata: no special completion processing for EH commands

Thomas Gleixner (1):
      fix per-cpu flag problem in the cpu affinity checkers

Tilman Schmidt (1):
      isdn: avoid calling tty_ldisc_flush() in atomic context

Trond Myklebust (1):
      SUNRPC: Ensure we always run the tk_callback before tk_action

Vitaliy Kulikov (1):
      ALSA: hda - fix digital mic selection in mixer on 92HD8X codecs

Vivien Didelot (1):
      hwmon: (sht15) Fix integer overflow in humidity calculation

wangyanqing (1):
      USB: serial: ch341: add new id

