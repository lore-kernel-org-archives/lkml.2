Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab1AGXuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 18:50:04 -0500
Received: from kroah.org ([198.145.64.141]:39737 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926Ab1AGXuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 18:50:02 -0500
Date: Fri, 7 Jan 2011 15:49:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.28
Message-ID: <20110107234939.GA18703@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.28 kernel.

All users of the 2.6.32 kernel series must upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                             |    2 
 arch/x86/include/asm/processor.h     |   23 --------
 arch/x86/kernel/apic/apic.c          |    8 ++
 arch/x86/kernel/apic/io_apic.c       |    1 
 arch/x86/kernel/apic/probe_64.c      |    7 --
 arch/x86/kernel/cpu/amd.c            |    3 -
 arch/x86/kernel/smpboot.c            |   85 +++++++++++++++++++++++++++++-
 arch/x86/vdso/Makefile               |    4 -
 block/blk-merge.c                    |    6 +-
 block/blk-settings.c                 |   24 --------
 drivers/acpi/acpica/dswexec.c        |   19 ++++++
 drivers/acpi/ec.c                    |    3 +
 drivers/char/hvc_console.c           |   27 ++++++---
 drivers/char/tty_ldisc.c             |    1 
 drivers/dma/mv_xor.c                 |    2 
 drivers/edac/amd64_edac.c            |    2 
 drivers/gpu/drm/drm_crtc.c           |    8 +-
 drivers/hid/hidraw.c                 |   11 ++-
 drivers/hwmon/adm1026.c              |   20 +++----
 drivers/infiniband/core/uverbs_cmd.c |   99 +++++++++++++++++++----------------
 drivers/md/dm-table.c                |    5 -
 drivers/md/md.c                      |   10 +--
 drivers/net/igb/igb_main.c           |    2 
 drivers/net/wireless/orinoco/main.c  |    6 ++
 drivers/net/wireless/orinoco/wext.c  |    4 -
 drivers/net/wireless/p54/p54usb.c    |    6 ++
 drivers/pci/dmar.c                   |    5 +
 drivers/pci/quirks.c                 |   23 ++++++++
 drivers/scsi/bfa/bfa_core.c          |   22 +++++++
 drivers/scsi/scsi_lib.c              |    3 -
 drivers/usb/misc/uss720.c            |    4 +
 drivers/usb/serial/ftdi_sio.c        |    1 
 drivers/usb/serial/ftdi_sio_ids.h    |    5 +
 drivers/usb/storage/unusual_devs.h   |    7 ++
 fs/exec.c                            |    5 +
 fs/fuse/file.c                       |   72 +++++++++++++++++++++++--
 fs/nfs/file.c                        |    2 
 fs/nfs/mount_clnt.c                  |    4 -
 fs/nfsd/nfs3xdr.c                    |    6 +-
 include/linux/blkdev.h               |    9 ++-
 include/linux/nfsd/xdr4.h            |   21 +++----
 include/net/sctp/sm.h                |    1 
 include/net/sctp/structs.h           |    3 +
 kernel/exit.c                        |    8 ++
 kernel/power/user.c                  |    2 
 kernel/printk.c                      |    2 
 kernel/timer.c                       |    6 ++
 kernel/trace/trace.c                 |   10 +++
 mm/mmap.c                            |   16 ++++-
 net/core/dev.c                       |    8 ++
 net/sctp/input.c                     |   22 ++++++-
 net/sctp/sm_sideeffect.c             |   35 ++++++++++++
 net/sctp/transport.c                 |    2 
 net/sunrpc/svc_xprt.c                |    9 ++-
 security/integrity/ima/ima_policy.c  |    2 
 sound/oss/soundcard.c                |    4 -
 sound/pci/hda/hda_intel.c            |    2 
 sound/pci/hda/patch_realtek.c        |    1 
 58 files changed, 522 insertions(+), 188 deletions(-)

Alex Deucher (1):
      drm/kms: remove spaces from connector names (v2)

Alexander Duyck (1):
      igb: only use vlan_gro_receive if vlans are registered

Alexey Starikovskiy (1):
      ACPI: EC: Add another dmi match entry for MSI hardware

Amit Shah (1):
      hvc_console: Fix race between hvc_close and hvc_remove

Andreas Herrmann (1):
      x86, amd: Fix panic on AMD CPU family 0x15

Anton Blanchard (1):
      hvc_console: Fix race between hvc_close and hvc_remove, again

Ben Hutchings (1):
      TTY: Fix error return from tty_ldisc_open()

Bob Moore (1):
      ACPICA: Fix Scope() op in module level code

Borislav Petkov (1):
      amd64_edac: Fix interleaving check

Christian Lamparter (1):
      p54usb: add 5 more USBIDs

Chuck Lever (1):
      NFS: Fix panic after nfs_umount()

Dan Carpenter (1):
      IB/uverbs: Handle large number of entries in poll CQ

Dan Rosenberg (1):
      sound: Prevent buffer overflow in OSS load_mixer_volumes

Daniel T Chen (3):
      ALSA: hda: Use model=lg quirk for LG P1 Express to enable playback and capture
      ALSA: hda: Use LPIB for Dell Latitude 131L
      ALSA: hda: Use LPIB quirk for Dell Inspiron m101z/1120

David Kilroy (2):
      orinoco: fix TKIP countermeasure behaviour
      orinoco: clear countermeasure setting on commit

Eduardo Costa (1):
      p54usb: New USB ID for Gemtek WUBI-100GW

Florian Faber (1):
      USB: ftdi_sio: Add D.O.Tec PID

Gabriele Gorla (2):
      hwmon: (adm1026) Allow 1 as a valid divider value
      hwmon: (adm1026) Fix setting fan_div

Greg Kroah-Hartman (1):
      Linux 2.6.32.28

H. Peter Anvin (2):
      x86, hotplug: Use mwait to offline a processor, fix the legacy case
      x86, gcc-4.6: Use gcc -m options when building vdso

Heiko Carstens (2):
      nohz: Fix printk_needs_cpu() return value on offline cpus
      nohz: Fix get_next_timer_interrupt() vs cpu hotplug

Jiri Slaby (1):
      HID: hidraw: fix window in hidraw_release

Kenji Kaneshige (2):
      x86: Enable the intr-remap fault handling after local APIC setup
      x86, vt-d: Fix the vt-d fault handling irq migration in the x2apic mode

Krishna Gudipati (1):
      bfa: fix system crash when reading sysfs fc_host statistics

Krishna Kumar (1):
      net: release dst entry while cache-hot for GSO case too

Martin K. Petersen (1):
      block: Deprecate QUEUE_FLAG_CLUSTER and use queue_limits instead

Miklos Szeredi (2):
      fuse: verify ioctl retries
      fuse: fix ioctl when server is 32bit

Mimi Zohar (1):
      ima: fix add LSM rule bug

Neil Brown (1):
      nfsd: Fix possible BUG_ON firing in set_change_info

NeilBrown (2):
      sunrpc: prevent use-after-free on clearing XPT_BUSY
      md: fix bug with re-adding of partially recovered device.

Oleg Nesterov (1):
      posix-cpu-timers: workaround to suppress the problems with mt exec

Saeed Bishara (1):
      mv_xor: fix race in tasklet function

Sergey Vlasov (1):
      NFS: Fix fcntl F_GETLK not reporting some conflicts

Slava Pestov (1):
      tracing: Fix panic when lseek() called on "trace" opened for writing

Suresh Siddha (2):
      x86, vt-d: Handle previous faults after enabling fault handling
      x86, vt-d: Quirk for masking vtd spec errors to platform error handling logic

Takashi Iwai (1):
      PM / Hibernate: Fix PM_POST_* notification with user-space suspend

Tavis Ormandy (1):
      install_special_mapping skips security_file_mmap check.

Thomas Sailer (1):
      USB: misc: uss720.c: add another vendor/product ID

Vitaly Kuznetsov (1):
      USB: usb-storage: unusual_devs entry for the Samsung YP-CP3

Vlad Yasevich (1):
      sctp: Fix a race between ICMP protocol unreachable and connect()

