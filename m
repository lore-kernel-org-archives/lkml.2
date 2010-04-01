Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844Ab0DAXSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 19:18:45 -0400
Received: from kroah.org ([198.145.64.141]:35346 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316Ab0DAXSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 19:18:39 -0400
Date: Thu, 1 Apr 2010 16:11:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.46
Message-ID: <20100401231141.GA11167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.46 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/tmpfs.txt     |    6 ++-
 Makefile                                |    2 -
 arch/x86/ia32/ia32_aout.c               |    1 
 arch/x86/kvm/vmx.c                      |    3 +
 arch/x86/kvm/x86.c                      |   21 ++++++++++-
 arch/x86/kvm/x86_emulate.c              |    5 ++
 drivers/char/mem.c                      |    3 +
 drivers/char/tty_io.c                   |    4 +-
 drivers/gpu/drm/r128/r128_cce.c         |   18 +++++++--
 drivers/gpu/drm/r128/r128_drv.h         |    8 ++++
 drivers/gpu/drm/r128/r128_state.c       |   36 +++++++++---------
 drivers/hwmon/coretemp.c                |    2 -
 drivers/hwmon/lm78.c                    |   23 ++++++++----
 drivers/i2c/i2c-core.c                  |    5 +-
 drivers/media/video/em28xx/em28xx-dvb.c |    1 
 drivers/mtd/ubi/cdev.c                  |    1 
 drivers/net/b44.c                       |    3 -
 drivers/net/bonding/bond_main.c         |    8 ++++
 drivers/net/r8169.c                     |    4 +-
 drivers/net/sky2.c                      |    4 +-
 drivers/parisc/eisa_eeprom.c            |    2 -
 drivers/serial/8250.c                   |    7 ++-
 drivers/usb/core/devio.c                |   61 ++++++++++++++++++++++----------
 drivers/usb/host/ehci-hub.c             |    7 ++-
 drivers/usb/host/ehci-q.c               |   11 ++---
 drivers/usb/host/ehci-sched.c           |    1 
 fs/exec.c                               |    3 +
 fs/ext4/super.c                         |    3 +
 fs/fcntl.c                              |    6 +--
 fs/namei.c                              |   14 ++++++-
 include/asm-x86/checksum_32.h           |    3 +
 include/asm-x86/kvm_host.h              |    1 
 include/asm-x86/kvm_x86_emulate.h       |    2 -
 include/linux/sched.h                   |   24 ++++++++++++
 include/linux/topology.h                |    4 +-
 kernel/futex.c                          |   28 +++++++++++++-
 kernel/printk.c                         |    2 -
 kernel/sched.c                          |   12 +++---
 kernel/sched_fair.c                     |   13 +++++-
 kernel/sched_features.h                 |    1 
 kernel/sched_idletask.c                 |    6 +--
 kernel/sched_rt.c                       |    2 -
 mm/mempolicy.c                          |   34 +++++++++++------
 mm/migrate.c                            |    3 +
 net/ax25/af_ax25.c                      |    2 -
 net/ipv4/tcp_minisocks.c                |    2 -
 net/ipv6/sit.c                          |    2 -
 net/sched/sch_api.c                     |    2 +
 net/unix/af_unix.c                      |    5 ++
 49 files changed, 301 insertions(+), 120 deletions(-)

Al Viro (1):
      fix LOOKUP_FOLLOW on automount "symlinks"

Alan Stern (3):
      EHCI: fix bug in keeping track of resuming ports
      USB: EHCI: fix counting of transaction error retries
      USB: fix usbfs regression

Avi Kivity (2):
      KVM: x86 emulator: limit instructions to 15 bytes
      KVM: VMX: Check cpl before emulating debug register access

Ben Hutchings (1):
      drm/r128: Add test for initialisation to all ioctls that require it

Dean Nelson (1):
      hwmon: (coretemp) Add missing newline to dev_warn() message

Dick Hollenbeck (1):
      serial: 8250: add serial transmitter fully empty test

Eric Dumazet (1):
      tc: Fix unitialized kernel memory leak

Francesco Lavra (1):
      V4L/DVB (13961): em28xx-dvb: fix memleak in dvb_fini()

Greg Kroah-Hartman (2):
      USB: usbfs: only copy the actual data received
      Linux 2.6.27.46

Ingo Molnar (1):
      sched: fine-tune SD_SIBLING_INIT

Jarek Poplawski (1):
      ax25: Fix possible oops in ax25_make_new

Jean Delvare (1):
      hwmon: (lm78) Fix I/O resource conflict with PNP

Jiri Pirko (1):
      bonding: ignore updelay param when there is no active slave

Jiri Slaby (2):
      resource: add helpers for fetching rlimits
      x86, ia32_aout: do not kill argument mapping

KOSAKI Motohiro (4):
      tmpfs: mpol=bind:0 don't cause mount error.
      tmpfs: handle MPOL_LOCAL mount option properly
      doc: add the documentation for mpol=local
      tmpfs: cleanup mpol_parse_str()

Linus Torvalds (3):
      Fix potential crash with sys_move_pages
      Fix race in tty_fasync() properly
      USB: usbfs: properly clean up the as structure on error paths

Marcelo Tosatti (1):
      KVM: x86: check for cr3 validity in ioctl_set_sregs

Michael Buesch (1):
      parisc: isa-eeprom - Fix loff_t usage

Mika Westerberg (1):
      UBI: fix volume creation input checking

Mike Galbraith (1):
      sched: fine-tune SD_MC_INIT

Mike McCormack (1):
      sky2: Set SKY2_HW_RAM_BUFFER in sky2_init

Miklos Szeredi (1):
      net: unix: fix sending fds in multiple buffers

Neil Horman (1):
      coredump: suppress uid comparison test if core output files are pipes

Peter Zijlstra (2):
      printk: robustify printk, fix #2
      sched: wakeup preempt when small overlap

Raimonds Cicans (1):
      r8169: Fix receive buffer length when MTU is between 1515 and 1536

Ravikiran G Thirumalai (1):
      tmpfs: fix oops on mounts with mpol=default

Robert Varga (1):
      tcp: fix CONFIG_TCP_MD5SIG + CONFIG_PREEMPT timer BUG()

Salman Qazi (1):
      drivers/char/mem.c: avoid OOM lockup during large reads from /dev/zero

Samuel Thibault (1):
      x86: fix csum_ipv6_magic asm memory clobber

Sascha Hlusiak (1):
      sit: fix off-by-one in ipip6_tunnel_get_prl

Stanislav Brabec (1):
      b44 WOL setup: one-bit-off stack corruption kernel panic fix

Thadeu Lima de Souza Cascardo (1):
      i2c: Do not use device name after device_unregister

Theodore Ts'o (1):
      ext4: Avoid null pointer dereference when decoding EROFS w/o a journal

Thomas Gleixner (2):
      futex: Handle futex value corruption gracefully
      futex: Handle user space corruption gracefully

