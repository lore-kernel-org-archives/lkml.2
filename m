Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab1LIRX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:23:56 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50453 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751338Ab1LIRXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:23:52 -0500
X-Sasl-enc: WSYhO1onk9XZQCK60BKhKnQR7gsI+dmgwi8/6Lmd+vkN 1323451431
Date: Fri, 9 Dec 2011 09:18:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.13
Message-ID: <20111209171847.GA22458@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.13 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                  |    2=20
 arch/arm/Kconfig                          |   12 +++
 arch/arm/configs/ezx_defconfig            |    2=20
 arch/arm/configs/imote2_defconfig         |    2=20
 arch/arm/configs/magician_defconfig       |    2=20
 arch/arm/configs/zeus_defconfig           |    2=20
 arch/arm/kernel/process.c                 |    3=20
 arch/arm/mach-mxs/clock-mx28.c            |    2=20
 arch/arm/mach-omap2/Kconfig               |    1=20
 arch/arm/mach-omap2/smartreflex.c         |    2=20
 arch/arm/mach-pxa/balloon3.c              |    2=20
 arch/arm/mach-pxa/colibri-pxa320.c        |    2=20
 arch/arm/mach-pxa/gumstix.c               |    2=20
 arch/arm/mach-pxa/include/mach/palm27x.h  |    4 -
 arch/arm/mach-pxa/palm27x.c               |    4 -
 arch/arm/mach-pxa/palmtc.c                |    2=20
 arch/arm/mach-pxa/vpac270.c               |    2=20
 arch/s390/kernel/ptrace.c                 |   18 +++++
 arch/x86/include/asm/timer.h              |   23 +++++++
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    6 +
 arch/x86/kernel/mpparse.c                 |    2=20
 arch/x86/kernel/reboot.c                  |   13 +++-
 arch/x86/mm/highmem_32.c                  |    2=20
 arch/x86/oprofile/init.c                  |    7 +-
 drivers/crypto/mv_cesa.c                  |   12 ++-
 drivers/firmware/sigma.c                  |   81 ++++++++++++++++++-------
 drivers/gpu/drm/drm_crtc.c                |    4 +
 drivers/gpu/drm/i915/i915_irq.c           |    1=20
 drivers/gpu/drm/i915/i915_reg.h           |    4 +
 drivers/gpu/drm/i915/i915_suspend.c       |    2=20
 drivers/gpu/drm/i915/intel_display.c      |   16 ++++-
 drivers/gpu/drm/radeon/evergreen.c        |    7 +-
 drivers/gpu/drm/radeon/r100.c             |    7 +-
 drivers/gpu/drm/radeon/radeon_atombios.c  |   24 +++++++
 drivers/gpu/drm/radeon/rs600.c            |    7 +-
 drivers/gpu/drm/radeon/rv770.c            |    7 +-
 drivers/gpu/drm/ttm/ttm_bo.c              |    3=20
 drivers/hid/hid-core.c                    |    2=20
 drivers/hid/hid-ids.h                     |    2=20
 drivers/hwmon/coretemp.c                  |    2=20
 drivers/i2c/algos/i2c-algo-bit.c          |    4 -
 drivers/mfd/twl-core.c                    |    2=20
 drivers/net/wireless/p54/p54spi.c         |    5 -
 drivers/net/wireless/rt2x00/rt2800lib.c   |    2=20
 drivers/oprofile/oprof.c                  |   29 +++++++--
 drivers/oprofile/timer_int.c              |    1=20
 drivers/pci/hotplug/shpchp_core.c         |    4 -
 drivers/pci/hotplug/shpchp_hpc.c          |    4 -
 drivers/rtc/interface.c                   |   44 ++++++++++----
 drivers/scsi/scsi_lib.c                   |    3=20
 drivers/staging/comedi/comedi_fops.c      |   94 ++++++++++++++++++++++---=
-----
 drivers/staging/usbip/vhci_rx.c           |   10 +--
 drivers/usb/host/ehci-sched.c             |   22 ++++---
 drivers/usb/host/whci/qset.c              |    2=20
 drivers/usb/host/xhci.c                   |    5 +
 drivers/usb/serial/ftdi_sio.c             |    1=20
 drivers/usb/serial/ftdi_sio_ids.h         |    1=20
 drivers/usb/serial/option.c               |    4 +
 drivers/usb/storage/unusual_devs.h        |    7 ++
 drivers/video/via/share.h                 |    4 -
 fs/ecryptfs/crypto.c                      |    4 -
 fs/ecryptfs/file.c                        |   23 +++++++
 fs/nfs/nfs4filelayout.c                   |    8 ++
 fs/nfs/pnfs.c                             |    3=20
 fs/xfs/linux-2.6/xfs_acl.c                |    2=20
 fs/xfs/linux-2.6/xfs_sync.c               |   11 +++
 fs/xfs/xfs_attr_leaf.c                    |   64 ++++++++++++--------
 fs/xfs/xfs_inode.c                        |   21 ++++++
 fs/xfs/xfs_inode.h                        |    1=20
 include/drm/drm_mode.h                    |    2=20
 include/drm/drm_pciids.h                  |    8 ++
 include/linux/sigma.h                     |   13 +---
 kernel/cgroup_freezer.c                   |   11 ++-
 kernel/hrtimer.c                          |    6 +
 kernel/irq/manage.c                       |    5 +
 kernel/irq/spurious.c                     |    4 -
 kernel/jump_label.c                       |    3=20
 kernel/time/clockevents.c                 |    1=20
 kernel/time/clocksource.c                 |    4 -
 kernel/time/tick-broadcast.c              |    2=20
 kernel/time/timekeeping.c                 |    4 +
 kernel/trace/trace_events.c               |    1=20
 kernel/trace/trace_events_filter.c        |    6 -
 mm/hugetlb.c                              |    2=20
 net/mac80211/agg-tx.c                     |   24 +++++++
 net/sunrpc/xprtsock.c                     |    3=20
 net/wireless/nl80211.c                    |    4 -
 net/wireless/reg.c                        |   49 ++++++++++-----
 sound/pci/lx6464es/lx_core.c              |   16 +++--
 sound/soc/codecs/wm8731.c                 |    1=20
 sound/soc/codecs/wm8753.c                 |    3=20
 sound/soc/fsl/fsl_ssi.c                   |    1=20
 tools/perf/util/trace-event-parse.c       |    2=20
 93 files changed, 659 insertions(+), 201 deletions(-)

Alex Deucher (4):
      drm/radeon/kms: fix up gpio i2c mask bits for r4xx for real
      drm/radeon/kms: fix up gpio i2c mask bits for r4xx
      drm/radeon/kms: add some new pci ids
      drm/radeon/kms: add some loop timeouts in pageflip code

Andiry Xu (1):
      xHCI: fix bug in xhci_clear_command_ring()

Bart Westgeest (1):
      staging: usbip: bugfix for deadlock

Ben Skeggs (1):
      drm/ttm: request zeroed system memory pages for new TT buffer objects

Benjamin Tissoires (1):
      HID: Correct General touch PID

Bernd Porr (1):
      staging: comedi: fix oops for USB DAQ devices.

Bjorn Helgaas (2):
      PCI hotplug: shpchp: don't blindly claim non-AMD 0x7450 device IDs
      x86/mpparse: Account for bus types other than ISA and PCI

Christoph Hellwig (3):
      xfs: validate acl count
      xfs: force buffer writeback before blocking on the ilock in inode rec=
laim
      xfs: fix attr2 vs large data fork assert

Dan Carpenter (1):
      USB: whci-hcd: fix endian conversion in qset_clear()

Daniel Drake (1):
      viafb: correct sync polarity for OLPC DCON

Daniel Vetter (1):
      drm/i915: Ivybridge still has fences!

Dirk Nehring (1):
      usb: option: add Huawei E353 controlling interfaces

Edward Donovan (1):
      genirq: fix regression in irqfixup, irqpoll

Eliad Peller (1):
      nl80211: fix MAC address validation

Emmanuel Grumbach (1):
      mac80211: fix race between the AGG SM and the Tx data path

Eric Anholt (2):
      drm/i915: Turn on a required 3D clock gating bit on Sandybridge.
      drm/i915: Turn on another required clock gating bit on gen6.

Federico Vaga (2):
      Staging: comedi: fix mmap_count
      Staging: comedi: fix signal handling in read and write

Felipe Balbi (1):
      ARM: OMAP: smartreflex: fix IRQ handling bug

Gertjan van Wingerde (1):
      rt2x00: Fix efuse EEPROM reading on PPC32.

Gleb Natapov (1):
      jump_label: jump_label_inc may return before the code is patched

Greg Kroah-Hartman (2):
      revert "mfd: Fix twl4030 dependencies for audio codec"
      Linux 3.0.13

Hannes Reinecke (1):
      SCSI: Silencing 'killing requests for dead queue'

Haojian Zhuang (1):
      ARM: pxa: fix inconsistent CONFIG_USB_PXA27X

Hector Palacios (1):
      timekeeping: add arch_offset hook to ktime_get functions

Hillf Danton (1):
      hugetlb: release pages in the error path of hugetlb_cow()

Ido Yariv (1):
      genirq: Fix race condition when stopping the irq thread

Ilya Dryomov (1):
      tracing: fix event_subsystem ref counting

Jean Delvare (1):
      hwmon: (coretemp) Fix oops on driver load

Jeff Ohlstein (1):
      hrtimer: Fix extra wakeups from __remove_hrtimer()

Jeffrey (Sheng-Hui) Chu (1):
      i2c-algo-bit: Generate correct i2c address sequence for 10-bit target

Jesse Barnes (1):
      drm/i915: fix CB tuning check for ILK+

Johannes Berg (2):
      cfg80211: fix regulatory NULL dereference
      mac80211: don't stop a single aggregation session twice

Konrad Rzeszutek Wilk (1):
      x86/paravirt: PTE updates in k(un)map_atomic need to be synchronous, =
regardless of lazy_mmu mode

Lars-Peter Clausen (3):
      firmware: Sigma: Prevent out of bounds memory access
      firmware: Sigma: Skip header during CRC generation
      firmware: Sigma: Fix endianess issues

Luis R. Rodriguez (2):
      cfg80211: fix race on init and driver registration
      cfg80211: amend regulatory NULL dereference fix

Marcin Ko=C5=9Bcielnicki (1):
      usb: ftdi_sio: add PID for Propox ISPcable III

Mark Brown (1):
      ASoC: Ensure WM8731 register cache is synced when resuming from disab=
led

Martin Schwidefsky (1):
      add missing .set function for NT_S390_LAST_BREAK regset

Matthieu CASTET (1):
      EHCI : Fix a regression in the ISO scheduler

Michael B=C3=BCsch (2):
      p54spi: Add missing spin_lock_init
      p54spi: Fix workqueue deadlock

Michal Hocko (1):
      cgroup_freezer: fix freezing groups with stopped tasks

Ming Lei (1):
      ARM: OMAP2: select ARM_AMBA if OMAP3_EMU is defined

Peter Chubb (1):
      x86: Fix "Acer Aspire 1" reboot hang

Peter Zijlstra (1):
      perf/x86: Fix PEBS instruction unwind

Phil Sutter (1):
      crypto: mv_cesa - fix hashing of chunks > 1920 bytes

Qinglin Ye (1):
      USB: usb-storage: unusual_devs entry for Kingston DT 101 G2

Rabin Vincent (1):
      rtc: Disable the alarm in the hardware

Robert Richter (2):
      oprofile, x86: Fix crash when unloading module (nmi timer mode)
      oprofile: Fix crash when unloading module (hr timer mode)

Salman Qazi (1):
      sched, x86: Avoid unnecessary overflow in sched_clock

Steven Rostedt (1):
      perf: Fix parsing of __print_flags() in TP_printk()

Tejun Heo (1):
      trace_events_filter: Use rcu_assign_pointer() when setting ftrace_eve=
nt_call->filter

Thomas Gleixner (2):
      tick-broadcast: Stop active broadcast device when replacing it
      clockevents: Set noop handler in clockevents_exchange_device()

Thomas Poussevin (1):
      USB: EHCI: fix HUB TT scheduling issue with iso transfer

Tim Blechmann (1):
      ALSA: lx6464es - fix device communication via command bus

Timo Juhani Lindfors (1):
      ASoC: wm8753: Skip noop reconfiguration of DAI mode

Timur Tabi (1):
      ASoC: fsl_ssi: properly initialize the sysfs attribute object

Trond Myklebust (2):
      SUNRPC: Ensure we return EAGAIN in xs_nospace if congestion is cleared
      NFS: Prevent 3.0 from crashing if it receives a partial layout

Tyler Hicks (2):
      eCryptfs: Flush file in vma close
      eCryptfs: Extend array bounds for all filename chars

Veli-Pekka Peltola (1):
      usb: option: add SIMCom SIM5218

Will Deacon (1):
      ARM: 7161/1: errata: no automatic store buffer drain

Wolfram Sang (1):
      arm: mx28: fix bit operation in clock setting

Xi Wang (1):
      drm: integer overflow in drm_mode_dirtyfb_ioctl()

Yang Honggang (Joseph) (1):
      clocksource: Fix bug with max_deferment margin calculation


--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJO4kL3AAoJEDjbvchgkmk+llkP/iPOMe0owUqnnRYH4vrYEM9U
cFyvxm7hYKYv4pW0ndSpCrPmKZWs596VrfMucNCuU7Jc93v6n6reNYUmXTXZ4Iid
3xkWL7HihgnVx9YuvWcMO3F9C5AecZ4rKe8sYaC9uCV1gsZdWG7HXxB2rMdpzNoG
nop0yWjbSMKZL+TxcLw8zWzlqznNeQjUY2lQxOKtGm2QzejQ6dqHECW3P5yZaFJP
jRWLk4d2obCxa4qdS9vH8FSXplvCr39F/TGBSp1ojwYU+jxOGEg0W/c8Z7RC4yfM
f443KODq8C/FOY4t4hL8ElUVo4pINXRykshvUNHaLXGnbvkCXIGzGyNaMjTqQQd/
SoPeUMz8XFDWpZl+d6CatVoOOGOeOGxQcNl5DlLBHMVr/mhpoi97OLn7mBG9WU0T
sqErz6S894Z40SgCaC47APscH0tn4TLlFmvMQTgR024RXtl2hW5GjY4/1U1PZZM7
Wbmqc4Sf4MAXPZEcZll+/3ouLvV45hgoK30jPi0ciAaP1ga6YfhJIV6OEdgz8gl8
2lKTtjDi4cQvBTYMMyiwJbgm88cqy70Dlc5M5a/dXWllqApGkSqW8t6+u9oTcYJK
lhHp4q8bVdybS6Vb/vufg02DwLpaT8WbE869++DIQ4Rl07H/15GpHBmgl7dO0G+b
ZsuKojTsbYluj2TUtgnm
=8SP6
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
