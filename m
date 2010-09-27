Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595Ab0I0AlK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 20:41:10 -0400
Received: from kroah.org ([198.145.64.141]:41357 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758539Ab0I0AlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 20:41:03 -0400
Date: Sun, 26 Sep 2010 17:36:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.23
Message-ID: <20100927003644.GC20395@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.23 kernel.

All users of the 2.6.32 kernel series must upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 
 arch/alpha/kernel/err_marvel.c           |    6 
 arch/arm/mach-at91/at91sam9g45_devices.c |    2 
 arch/ia64/kernel/fsys.S                  |   30 ++
 arch/mips/include/asm/atomic.h           |   24 +-
 arch/mips/mm/tlbex.c                     |   22 +-
 arch/mips/mm/uasm.c                      |    4 
 arch/mips/mm/uasm.h                      |    1 
 arch/mips/mti-malta/malta-pci.c          |    2 
 arch/mips/nxp/pnx8550/common/pci.c       |    1 
 arch/mips/nxp/pnx8550/common/setup.c     |    2 
 arch/mips/pci/ops-pmcmsp.c               |    1 
 arch/mips/pci/pci-yosemite.c             |    1 
 arch/sparc/include/asm/io_32.h           |    4 
 arch/sparc/include/asm/io_64.h           |    4 
 arch/sparc/include/asm/oplib_64.h        |   27 --
 arch/sparc/prom/cif.S                    |   16 -
 arch/sparc/prom/console_64.c             |   48 +++-
 arch/sparc/prom/devops_64.c              |   36 +++
 arch/sparc/prom/misc_64.c                |  314 +++++++++++++++++++++----------
 arch/sparc/prom/p1275.c                  |  102 ----------
 arch/sparc/prom/tree_64.c                |  210 +++++++++++++++-----
 arch/x86/include/asm/cmpxchg_32.h        |   65 +-----
 arch/x86/include/asm/cmpxchg_64.h        |    4 
 arch/x86/oprofile/nmi_int.c              |    4 
 drivers/acpi/blacklist.c                 |   14 +
 drivers/ata/pata_pdc202xx_old.c          |   15 +
 drivers/char/agp/sis-agp.c               |    8 
 drivers/char/mem.c                       |    3 
 drivers/clocksource/sh_tmu.c             |   20 +
 drivers/input/input.c                    |   86 +++++++-
 drivers/message/fusion/mptscsih.c        |    2 
 drivers/net/3c503.c                      |   41 ++--
 drivers/net/bnx2.c                       |   20 +
 drivers/net/bonding/bond_3ad.c           |    3 
 drivers/net/bonding/bond_alb.c           |    3 
 drivers/net/cxgb3/cxgb3_main.c           |    3 
 drivers/net/eql.c                        |    2 
 drivers/net/r8169.c                      |   11 +
 drivers/net/usb/asix.c                   |   30 ++
 drivers/net/usb/hso.c                    |    2 
 drivers/net/wireless/hostap/hostap_pci.c |    1 
 drivers/pci/intel-iommu.c                |   90 ++++----
 drivers/staging/vt6655/wpactl.c          |   11 -
 drivers/usb/serial/mos7720.c             |    3 
 drivers/usb/serial/mos7840.c             |    3 
 drivers/video/sis/sis_main.c             |    3 
 drivers/video/via/ioctl.c                |    2 
 fs/aio.c                                 |    3 
 fs/char_dev.c                            |    4 
 fs/ext4/inode.c                          |   40 ++-
 fs/notify/inotify/inotify_fsnotify.c     |    3 
 fs/notify/inotify/inotify_user.c         |    7 
 fs/partitions/ibm.c                      |   13 +
 fs/xfs/linux-2.6/xfs_ioctl.c             |    2 
 include/linux/mm.h                       |    8 
 include/linux/mmzone.h                   |   13 +
 include/linux/vmstat.h                   |   22 ++
 include/net/tcp.h                        |   36 ++-
 kernel/exit.c                            |    5 
 kernel/sched.c                           |    4 
 kernel/sys.c                             |    2 
 mm/memory.c                              |   15 +
 mm/mmap.c                                |    3 
 mm/mmzone.c                              |   21 ++
 mm/page_alloc.c                          |   33 ++-
 mm/percpu.c                              |    2 
 mm/vmstat.c                              |   15 +
 net/bridge/br_netfilter.c                |    9 
 net/core/skbuff.c                        |    7 
 net/ipv4/tcp.c                           |   33 +--
 net/ipv4/tcp_timer.c                     |    8 
 net/irda/af_irda.c                       |    4 
 net/llc/af_llc.c                         |    3 
 net/rds/recv.c                           |    2 
 net/sctp/output.c                        |    1 
 net/unix/af_unix.c                       |   15 +
 security/keys/keyctl.c                   |    6 
 78 files changed, 1076 insertions(+), 571 deletions(-)

Alexey Kuznetsov (1):
      tcp: Prevent overzealous packetization by SWS logic.

Andrew Morton (1):
      drivers/pci/intel-iommu.c: fix build with older gcc's

Andy Gospodarek (1):
      bonding: correctly process non-linear skbs

Aurelien Jarno (1):
      clocksource: sh_tmu: compute mult and shift before registration

Bartlomiej Zolnierkiewicz (2):
      pata_pdc202xx_old: fix UDMA mode for Promise UDMA33 cards
      pata_pdc202xx_old: fix UDMA mode for PDC2026x chipsets

Ben Hutchings (3):
      3c503: Fix IRQ probing
      MIPS: Set io_map_base for several PCI bridges lacking it
      sis-agp: Remove SIS 760, handled by amd64-agp

Benjamin Li (1):
      bnx2: Fix netpoll crash.

Christoph Lameter (1):
      mm: page allocator: calculate a better estimate of NR_FREE_PAGES when memory is low and kswapd is awake

Dan Carpenter (2):
      Staging: vt6655: fix buffer overflow
      net/llc: make opt unsigned in llc_ui_setsockopt()

Dan Rosenberg (7):
      USB: serial/mos*: prevent reading uninitialized stack memory
      drivers/net/usb/hso.c: prevent reading uninitialized memory
      drivers/net/cxgb3/cxgb3_main.c: prevent reading uninitialized stack memory
      drivers/net/eql.c: prevent reading uninitialized stack memory
      drivers/video/sis/sis_main.c: prevent reading uninitialized stack memory
      xfs: prevent reading uninitialized stack memory
      drivers/video/via/ioctl.c: prevent reading uninitialized stack memory

Daniel J Blueman (1):
      Fix unprotected access to task credentials in waitid()

David Daney (1):
      MIPS: Quit using undefined behavior of ADDU in 64-bit atomic operations.

David Howells (2):
      KEYS: Fix RCU no-lock warning in keyctl_session_to_parent()
      KEYS: Fix bug in keyctl_session_to_parent() if parent has no session keyring

David S. Miller (5):
      sparc: Provide io{read,write}{16,32}be().
      irda: Correctly clean up self->ias_obj on irda_bind() failure.
      tcp: Combat per-cpu skew in orphan tests.
      bridge: Clear INET control block of SKBs passed into ip_fragment().
      sparc64: Get rid of indirect p1275 PROM call buffer.

Divy Le Ray (1):
      cxgb3: fix hot plug removal crash

Dmitry Monakhov (1):
      ext4: Fix remaining racy updates of EXT4_I(inode)->i_flags

Dmitry Torokhov (1):
      Input: add compat support for sysfs and /proc capabilities output

Eric Dumazet (3):
      gro: fix different skb headrooms
      tcp: fix three tcp sysctls tuning
      rds: fix a leak of kernel memory

Eric Paris (2):
      inotify: send IN_UNMOUNT events
      inotify: fix inotify oneshot support

Greg Kroah-Hartman (1):
      Linux 2.6.32.23

H. Peter Anvin (1):
      x86: Add memory modify constraints to xchg() and cmpxchg()

Herbert Xu (2):
      bridge: Clear IPCB before possible entry into IP stack
      gro: Fix bogus gso_size on the first fraglist entry

Jan Kara (1):
      char: Mark /dev/zero and /dev/kmem as not capable of writeback

Jarek Poplawski (1):
      gro: Re-fix different skb headrooms

Jeff Moyer (1):
      aio: check for multiplication overflow in do_io_submit

John W. Linville (1):
      hostap_pci: set dev->base_addr during probe

Jussi Kivilinna (1):
      asix: fix setting mac address for AX88772

KOSAKI Motohiro (1):
      tcp: select(writefds) don't hang up when a peer close connection

Mel Gorman (2):
      mm: page allocator: drain per-cpu lists after direct reclaim allocation fails
      mm: page allocator: update free page counters after pages are placed on the free list

Michael Chan (1):
      bnx2: Fix hang during rmmod bnx2.

Michael Cree (1):
      alpha: Fix printk format errors

Nicolas Ferre (1):
      AT91: change dma resource index

Patrick Simmons (1):
      oprofile: Add Support for Intel CPU Family 6 / Model 22 (Intel Celeron 540)

Paul E. McKenney (1):
      pid: make setpgid() system call use RCU read-side critical section

Peter Oberparleiter (1):
      dasd: use correct label location for diag fba disks

Petr Tesarik (1):
      IA64: Optimize ticket spinlocks in fsys_rt_sigprocmask

Ralf Baechle (2):
      MIPS: uasm: Add OR instruction.
      MIPS: Sibyte: Fix M3 TLB exception handler workaround.

Ryan Kuester (1):
      SCSI: mptsas: fix hangs caused by ATA pass-through

Stanislaw Gruszka (1):
      sched: Fix user time incorrectly accounted as system time on 32-bit

Steven J. Magnani (1):
      net: Fix oops from tcp_collapse() when using splice()

Tejun Heo (1):
      percpu: fix pcpu_last_unit_cpu

Tetsuo Handa (1):
      UNIX: Do not loop forever at unix_autobind().

Timo Teräs (2):
      r8169: fix random mdio_write failures
      r8169: fix mdio_read and update mdio_write according to hw specs

Tony Luck (2):
      IA64: fix siglock
      guard page for stacks that grow upwards

Vlad Yasevich (1):
      sctp: Do not reset the packet during sctp_packet_config().

Zhang Rui (1):
      ACPI: disable _OSI(Windows 2009) on Asus K50IJ

