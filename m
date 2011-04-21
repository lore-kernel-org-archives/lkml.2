Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1DUVij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 17:38:39 -0400
Received: from kroah.org ([198.145.64.141]:56879 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab1DUVih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 17:38:37 -0400
Date: Thu, 21 Apr 2011 14:39:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.38.4
Message-ID: <20110421213926.GA19721@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.38.4 kernel.

All users of the 2.6.38 kernel series must upgrade.

The updated 2.6.38.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.38.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.38.y.git;a=summary

thanks,

greg k-h

------------

 MAINTAINERS                                            |    1 
 Makefile                                               |    2 
 arch/arm/kernel/hw_breakpoint.c                        |    7 
 arch/ia64/kernel/mca.c                                 |    3 
 arch/ia64/sn/pci/tioca_provider.c                      |    2 
 arch/powerpc/kernel/perf_event.c                       |   37 
 arch/powerpc/kernel/time.c                             |    3 
 arch/sparc/kernel/entry.S                              |    2 
 arch/sparc/kernel/iommu.c                              |    3 
 arch/sparc/kernel/ldc.c                                |   28 
 arch/sparc/kernel/pci.c                                |    1 
 arch/sparc/kernel/pci_common.c                         |   11 
 arch/sparc/kernel/pci_fire.c                           |    2 
 arch/sparc/kernel/pci_schizo.c                         |    4 
 arch/sparc/kernel/pci_sun4v.c                          |    3 
 arch/sparc/kernel/pcr.c                                |    2 
 arch/sparc/kernel/ptrace_64.c                          |    3 
 arch/sparc/kernel/smp_64.c                             |   11 
 arch/sparc/kernel/traps_64.c                           |    3 
 arch/sparc/kernel/una_asm_64.S                         |    2 
 arch/sparc/mm/fault_32.c                               |    3 
 arch/x86/include/asm/msr-index.h                       |    4 
 arch/x86/kernel/cpu/amd.c                              |   23 
 arch/x86/lib/semaphore_32.S                            |    2 
 drivers/gpu/drm/radeon/atom.c                          |    6 
 drivers/gpu/drm/radeon/atombios_crtc.c                 |    6 
 drivers/gpu/drm/radeon/radeon_fence.c                  |    2 
 drivers/gpu/drm/radeon/radeon_ring.c                   |    2 
 drivers/i2c/algos/i2c-algo-bit.c                       |   22 
 drivers/media/video/sn9c102/sn9c102_core.c             |    6 
 drivers/net/gianfar.c                                  |   16 
 drivers/net/gianfar.h                                  |    1 
 drivers/net/pppoe.c                                    |    2 
 drivers/net/usb/cdc-phonet.c                           |    9 
 drivers/rtc/rtc-bfin.c                                 |    2 
 drivers/usb/core/devices.c                             |   10 
 drivers/usb/core/hcd.c                                 |    2 
 drivers/usb/host/ehci-q.c                              |   15 
 drivers/usb/host/xhci-mem.c                            |   90 +-
 drivers/usb/host/xhci.c                                |   16 
 drivers/usb/host/xhci.h                                |    6 
 drivers/usb/musb/Kconfig                               |    6 
 drivers/usb/serial/ftdi_sio.c                          |    5 
 drivers/usb/serial/ftdi_sio_ids.h                      |   12 
 drivers/usb/serial/option.c                            |    5 
 drivers/usb/serial/qcserial.c                          |   31 
 drivers/video/via/viafbdev.h                           |    3 
 fs/binfmt_elf.c                                        |    6 
 fs/cifs/cifsencrypt.c                                  |   15 
 fs/cifs/cifsfs.c                                       |    1 
 fs/cifs/connect.c                                      |    2 
 fs/cifs/file.c                                         |    6 
 fs/namei.c                                             |    1 
 fs/proc/base.c                                         |    9 
 fs/ramfs/file-nommu.c                                  |    1 
 fs/ubifs/debug.c                                       |    6 
 fs/ubifs/file.c                                        |    3 
 fs/ubifs/super.c                                       |    3 
 include/linux/kernel.h                                 |   70 +
 include/linux/perf_event.h                             |    2 
 include/linux/pid.h                                    |    2 
 include/linux/sched.h                                  |    3 
 include/net/bluetooth/hci.h                            |    2 
 kernel/futex.c                                         |    2 
 kernel/pid.c                                           |    5 
 kernel/sched_fair.c                                    |   11 
 lib/Kconfig.debug                                      |    3 
 lib/Makefile                                           |    2 
 lib/kstrtox.c                                          |  227 +++++
 lib/test-kstrtox.c                                     |  739 +++++++++++++++++
 lib/vsprintf.c                                         |  141 ---
 mm/huge_memory.c                                       |   24 
 mm/memory.c                                            |   26 
 mm/mlock.c                                             |   13 
 mm/mmap.c                                              |   15 
 mm/oom_kill.c                                          |   27 
 mm/vmscan.c                                            |   24 
 net/8021q/vlan_dev.c                                   |    1 
 net/bluetooth/hci_core.c                               |    5 
 net/bluetooth/hci_event.c                              |    4 
 net/bridge/br_multicast.c                              |    2 
 net/bridge/br_netfilter.c                              |    9 
 net/ipv4/fib_frontend.c                                |    2 
 net/ipv4/ip_options.c                                  |    6 
 net/ipv4/route.c                                       |    2 
 net/ipv4/tcp_input.c                                   |   12 
 net/ipv6/sysctl_net_ipv6.c                             |   18 
 net/l2tp/l2tp_eth.c                                    |    2 
 net/sctp/protocol.c                                    |    4 
 net/xfrm/xfrm_policy.c                                 |    2 
 scripts/checkpatch.pl                                  |    4 
 sound/pci/hda/patch_realtek.c                          |   21 
 tools/perf/bench/sched-pipe.c                          |    2 
 tools/perf/builtin-sched.c                             |   12 
 tools/perf/builtin-top.c                               |    5 
 tools/perf/util/header.c                               |    2 
 tools/perf/util/hist.c                                 |    3 
 tools/perf/util/scripting-engines/trace-event-python.c |    3 
 tools/perf/util/symbol.c                               |    4 
 tools/perf/util/trace-event-parse.c                    |    2 
 tools/perf/util/ui/browsers/map.c                      |    2 
 101 files changed, 1527 insertions(+), 430 deletions(-)

Alan Stern (1):
      USB: EHCI: unlink unused QHs when the controller is stopped

Alex Deucher (3):
      drm/radeon/kms: pll tweaks for rv6xx
      drm/radeon/kms: fix suspend on rv530 asics
      i2c-algo-bit: Call pre/post_xfer for bit_test

Alex Dubov (1):
      gianfar: Fall back to software tcp/udp checksum on older controllers

Alexey Dobriyan (1):
      kstrto*: converting strings to integers done (hopefully) right

Anton Blanchard (1):
      powerpc: Fix oops if scan_dispatch_log is called too early

Artem Bityutskiy (2):
      UBIFS: fix assertion warnings
      UBIFS: fix oops when R/O file-system is fsync'ed

Ben Hutchings (2):
      sparc: Fix .size directive for do_int_load
      mm/thp: use conventional format for boolean attributes

Bob Liu (1):
      ramfs: fix memleak on no-mmu arch

Boris Ostrovsky (1):
      x86, AMD: Set ARAT feature on AMD processors

Christian Simon (1):
      USB: ftdi_sio: Added IDs for CTI USB Serial Devices

Dan Siemon (1):
      net_sched: fix ip_tos2prio

Darren Hart (1):
      futex: Set FLAGS_HAS_TIMEOUT during futex_wait restart setup

David S. Miller (3):
      sctp: Pass __GFP_NOWARN to hash table allocation attempts.
      sparc32: Fix might-be-used-uninitialized warning in do_sparc_fault().
      sparc64: Fix build errors with gcc-4.6.0

Dmitry Torokhov (4):
      USB: fix formatting of SuperSpeed endpoints in /proc/bus/usb/devices
      USB: xhci - fix unsafe macro definitions
      USB: xhci - fix math in xhci_get_endpoint_interval()
      USB: xhci - also free streams when resetting devices

Eric B Munson (1):
      powerpc/perf_event: Skip updating kernel counters if register value shrinks

Eric Dumazet (4):
      fib: add rtnl locking in ip_fib_net_exit
      vlan: should take into account needed_headroom
      bridge: reset IPCB in br_parse_ip_options
      ip: ip_options_compile() resilient to NULL skb route

Eric W. Biederman (1):
      net ipv6: Fix duplicate /proc/sys/net/ipv6/neigh directory entries.

Felipe Balbi (1):
      usb: musb: temporarily make it bool

Greg Kroah-Hartman (1):
      Linux 2.6.38.4

Gustavo F. Padovan (1):
      Bluetooth: Fix HCI_RESET command synchronization

Herbert Xu (1):
      bridge: Reset IPCB when entering IP stack on NF_FORWARD

James Chapman (1):
      l2tp: fix possible oops on l2tp_eth module unload

Jan Beulich (1):
      x86: Fix a bogus unwind annotation in lib/semaphore_32.S

Jeff Layton (4):
      cifs: always do is_path_accessible check in cifs_mount
      cifs: check for private_data before trying to put it
      cifs: set ra_pages in backing_dev_info
      cifs: wrap received signature check in srv_mutex

Jeff Mahoney (2):
      tioca: Fix assignment from incompatible pointer warnings
      mca.c: Fix cast from integer to pointer warning

Jiri Kosina (1):
      brk: COMPAT_BRK: fix detection of randomized brk

Jiri Slaby (1):
      NET: cdc-phonet, handle empty phonet header

Joerg Roedel (1):
      x86, amd: Disable GartTlbWlkErr when BIOS forgets it

Johan Hovold (1):
      USB: ftdi_sio: add PID for OCT DK201 docking station

KOSAKI Motohiro (2):
      oom-kill: remove boost_dying_task_prio()
      vmscan: all_unreclaimable() use zone->all_unreclaimable as a name

Ken Chen (1):
      sched: Fix erroneous all_pinned logic

Kyle McMartin (1):
      perf tool: Fix gcc 4.6.0 issues

Linus Lüssing (1):
      bridge: Fix possibly wrong MLD queries' ethernet source address

Linus Torvalds (4):
      vm: fix vm_pgoff wrap in stack expansion
      vm: fix mlock() on stack guard page
      next_pidmap: fix overflow condition
      proc: do proper range check on readdir offset

Marius B. Kotsbak (1):
      USB: option: Added support for Samsung GT-B3730/GT-B3710 LTE USB modem.

Matthew Wilcox (1):
      USB: Fix unplug of device with active streams

Michel Dänzer (1):
      radeon: Fix KMS CP writeback on big endian machines.

Mike Frysinger (1):
      RTC: add missing "return 0" in new alarm func for rtc-bfin.c

Paul Friedrich (1):
      USB: ftdi_sio: add ids for Hameg HO720 and HO730

Peter Zijlstra (1):
      perf: Fix task context scheduling

Randy Dunlap (1):
      MAINTAINERS: update STABLE BRANCH info

Steffen Klassert (1):
      xfrm: Refcount destination entry on xfrm_lookup

Steven Hardy (3):
      usb: Fix qcserial memory leak on rmmod
      usb: qcserial avoid pointing to freed memory
      usb: qcserial add missing errorpath kfrees

Takashi Iwai (1):
      ALSA: hda - Fix pin-config of Gigabyte mobo

Tim Chen (1):
      vfs: Fix absolute RCU path walk failures due to uninitialized seq number

Tkhai Kirill (1):
      sparc32: Pass task_struct to schedule_tail() in ret_from_fork

Ulrich Weber (1):
      pppoe: drop PPPOX_ZOMBIEs in pppoe_flush_dev

Vasiliy Kulikov (2):
      video: sn9c102: world-wirtable sysfs files
      UBIFS: restrict world-writable debugfs files

Will Deacon (1):
      ARM: 6864/1: hw_breakpoint: clear DBGVCR out of reset

Yuchung Cheng (1):
      tcp: avoid cwnd moderation in undo

