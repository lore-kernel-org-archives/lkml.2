Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab1LIRYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:24:03 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48065 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752683Ab1LIRXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:23:55 -0500
X-Sasl-enc: Onc/YSYXa46bAnMnZNJlh0MTCp0yTY3cL1ftcxEe5wiW 1323451434
Date: Fri, 9 Dec 2011 09:23:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.1.5
Message-ID: <20111209172316.GA24144@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.1.5 kernel.

All users of the 3.1 kernel series must upgrade.

The updated 3.1.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.1.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                       |    2=20
 arch/arm/Kconfig                               |   12 +
 arch/arm/configs/ezx_defconfig                 |    2=20
 arch/arm/configs/imote2_defconfig              |    2=20
 arch/arm/configs/magician_defconfig            |    2=20
 arch/arm/configs/zeus_defconfig                |    2=20
 arch/arm/kernel/process.c                      |    3=20
 arch/arm/mach-mxs/clock-mx28.c                 |    2=20
 arch/arm/mach-omap2/Kconfig                    |    1=20
 arch/arm/mach-omap2/omap_hwmod.c               |    6=20
 arch/arm/mach-omap2/pm.c                       |    6=20
 arch/arm/mach-omap2/smartreflex.c              |    2=20
 arch/arm/mach-omap2/twl-common.c               |   11 +
 arch/arm/mach-omap2/twl-common.h               |    3=20
 arch/arm/mach-pxa/balloon3.c                   |    2=20
 arch/arm/mach-pxa/colibri-pxa320.c             |    2=20
 arch/arm/mach-pxa/gumstix.c                    |    2=20
 arch/arm/mach-pxa/include/mach/palm27x.h       |    4=20
 arch/arm/mach-pxa/palm27x.c                    |    4=20
 arch/arm/mach-pxa/palmtc.c                     |    2=20
 arch/arm/mach-pxa/vpac270.c                    |    2=20
 arch/s390/kernel/ptrace.c                      |   18 ++
 arch/x86/include/asm/timer.h                   |   23 +++
 arch/x86/kernel/cpu/perf_event_intel_ds.c      |    6=20
 arch/x86/kernel/mpparse.c                      |    2=20
 arch/x86/kernel/reboot.c                       |   13 +-
 arch/x86/mm/highmem_32.c                       |    2=20
 arch/x86/oprofile/init.c                       |    7 -
 drivers/crypto/mv_cesa.c                       |   12 +
 drivers/firmware/sigma.c                       |   81 +++++++++----
 drivers/gpu/drm/drm_crtc.c                     |    4=20
 drivers/gpu/drm/i915/i915_irq.c                |    1=20
 drivers/gpu/drm/i915/i915_reg.h                |    4=20
 drivers/gpu/drm/i915/i915_suspend.c            |    2=20
 drivers/gpu/drm/i915/intel_display.c           |   14 ++
 drivers/gpu/drm/i915/intel_panel.c             |    3=20
 drivers/gpu/drm/radeon/evergreen.c             |    7 -
 drivers/gpu/drm/radeon/r100.c                  |    7 -
 drivers/gpu/drm/radeon/radeon_atombios.c       |   24 +++
 drivers/gpu/drm/radeon/rs600.c                 |    7 -
 drivers/gpu/drm/radeon/rv770.c                 |    7 -
 drivers/hid/hid-core.c                         |    2=20
 drivers/hid/hid-ids.h                          |    2=20
 drivers/i2c/algos/i2c-algo-bit.c               |    4=20
 drivers/infiniband/core/addr.c                 |    9 -
 drivers/infiniband/hw/cxgb3/iwch_cm.c          |    4=20
 drivers/infiniband/hw/cxgb4/cm.c               |    4=20
 drivers/infiniband/hw/mlx4/qp.c                |    2=20
 drivers/infiniband/hw/nes/nes_cm.c             |    6=20
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   18 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    6=20
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c    |   36 +++--
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c     |    5=20
 drivers/net/wireless/iwlwifi/iwl-agn.c         |   29 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.h         |    2=20
 drivers/net/wireless/iwlwifi/iwl-pci.c         |    8 -
 drivers/net/wireless/p54/p54spi.c              |    5=20
 drivers/net/wireless/rt2x00/rt2800lib.c        |    2=20
 drivers/net/wireless/rtlwifi/ps.c              |   17 +-
 drivers/oprofile/oprof.c                       |   29 +++-
 drivers/oprofile/timer_int.c                   |    1=20
 drivers/pci/hotplug/shpchp_core.c              |    4=20
 drivers/pci/hotplug/shpchp_hpc.c               |    4=20
 drivers/regulator/aat2870-regulator.c          |    2=20
 drivers/regulator/twl-regulator.c              |   46 +++++++
 drivers/rtc/class.c                            |   10 -
 drivers/rtc/interface.c                        |   44 +++++--
 drivers/s390/net/qeth_l3_main.c                |    7 +
 drivers/scsi/scsi_lib.c                        |    3=20
 drivers/staging/comedi/comedi_fops.c           |   94 +++++++++++----
 drivers/staging/rts_pstor/rtsx.c               |    1=20
 drivers/staging/usbip/vhci_rx.c                |   10 -
 drivers/usb/host/ehci-sched.c                  |   22 ++-
 drivers/usb/host/whci/qset.c                   |    2=20
 drivers/usb/host/xhci.c                        |    5=20
 drivers/usb/musb/musb_core.c                   |    6=20
 drivers/usb/serial/ftdi_sio.c                  |    1=20
 drivers/usb/serial/ftdi_sio_ids.h              |    1=20
 drivers/usb/serial/option.c                    |    4=20
 drivers/usb/storage/unusual_devs.h             |    7 +
 drivers/video/via/share.h                      |    4=20
 fs/ecryptfs/crypto.c                           |   26 ++--
 fs/ecryptfs/ecryptfs_kernel.h                  |    5=20
 fs/ecryptfs/file.c                             |   23 +++
 fs/ecryptfs/inode.c                            |   52 +++++---
 fs/ext4/inode.c                                |    2=20
 fs/xfs/xfs_buf.h                               |    1=20
 fs/xfs/xfs_file.c                              |   34 ++++-
 fs/xfs/xfs_iops.c                              |    2=20
 fs/xfs/xfs_mount.c                             |   29 +---
 fs/xfs/xfs_qm.c                                |    3=20
 fs/xfs/xfs_vnodeops.c                          |   14 +-
 include/drm/drm_mode.h                         |    2=20
 include/drm/drm_pciids.h                       |    8 +
 include/linux/clocksource.h                    |    3=20
 include/linux/sigma.h                          |   13 --
 include/net/inetpeer.h                         |    1=20
 include/net/red.h                              |   15 --
 kernel/cgroup_freezer.c                        |   11 +
 kernel/hrtimer.c                               |    6=20
 kernel/irq/manage.c                            |    5=20
 kernel/irq/spurious.c                          |    4=20
 kernel/jump_label.c                            |    3=20
 kernel/time/clockevents.c                      |    1=20
 kernel/time/clocksource.c                      |   62 ++++++++--
 kernel/time/tick-broadcast.c                   |    2=20
 kernel/time/timekeeping.c                      |   11 +
 kernel/trace/ftrace.c                          |    1=20
 kernel/trace/trace_events.c                    |    1=20
 kernel/trace/trace_events_filter.c             |    6=20
 mm/hugetlb.c                                   |    2=20
 mm/slab.c                                      |    5=20
 net/bridge/br_multicast.c                      |    2=20
 net/ipv4/ah4.c                                 |    6=20
 net/ipv4/ip_options.c                          |    1=20
 net/ipv4/route.c                               |  152 ++++++++++++++++----=
-----
 net/ipv6/ah6.c                                 |    6=20
 net/mac80211/agg-tx.c                          |   41 ++++++
 net/mac80211/main.c                            |    6=20
 net/sched/sch_red.c                            |    4=20
 net/sched/sch_teql.c                           |   31 +++--
 net/sunrpc/xprtsock.c                          |    3=20
 net/wireless/nl80211.c                         |    4=20
 net/wireless/reg.c                             |   49 +++++---
 sound/pci/hda/patch_realtek.c                  |   14 ++
 sound/pci/hda/patch_sigmatel.c                 |   18 --
 sound/pci/hda/patch_via.c                      |   76 +++++++-----
 sound/pci/lx6464es/lx_core.c                   |   16 +-
 sound/soc/codecs/ad1836.h                      |    2=20
 sound/soc/codecs/sta32x.c                      |   63 ++++++++++
 sound/soc/codecs/sta32x.h                      |    1=20
 sound/soc/codecs/wm8731.c                      |    1=20
 sound/soc/codecs/wm8753.c                      |    3=20
 sound/soc/fsl/fsl_ssi.c                        |    1=20
 tools/perf/util/trace-event-parse.c            |    2=20
 135 files changed, 1170 insertions(+), 471 deletions(-)

Alex Deucher (4):
      drm/radeon/kms: fix up gpio i2c mask bits for r4xx for real
      drm/radeon/kms: fix up gpio i2c mask bits for r4xx
      drm/radeon/kms: add some new pci ids
      drm/radeon/kms: add some loop timeouts in pageflip code

Andiry Xu (1):
      xHCI: fix bug in xhci_clear_command_ring()

Arve Hj=C3=B8nnev=C3=A5g (1):
      rtc: Fix some bugs that allowed accumulating time drift in suspend/re=
sume

Axel Lin (2):
      regulator: aat2870: Fix the logic of checking if no id is matched in =
aat2870_get_regulator
      ASoC: Fix wrong define for AD1836_ADC_WORD_OFFSET

Bart Westgeest (1):
      staging: usbip: bugfix for deadlock

Benjamin Tissoires (1):
      HID: Correct General touch PID

Bernd Porr (1):
      staging: comedi: fix oops for USB DAQ devices.

Bjorn Helgaas (2):
      PCI hotplug: shpchp: don't blindly claim non-AMD 0x7450 device IDs
      x86/mpparse: Account for bus types other than ISA and PCI

Carlos Maiolino (1):
      xfs: Fix possible memory corruption in xfs_readlink

Charles Chin (1):
      ALSA: hda - Fix S3/S4 problem on machines with VREF-pin mute-LED

Christoph Hellwig (2):
      xfs: avoid direct I/O write vs buffered I/O race
      xfs: fix buffer flushing during unmount

Dan Carpenter (1):
      USB: whci-hcd: fix endian conversion in qset_clear()

Daniel Drake (1):
      viafb: correct sync polarity for OLPC DCON

Daniel Vetter (1):
      drm/i915: Ivybridge still has fences!

Dave Chinner (1):
      xfs: don't serialise direct IO reads on page cache checks

David S. Miller (1):
      ipv4: Perform peer validation on cached route lookup.

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

Eric Dumazet (7):
      IB: Fix RCU lockdep splats
      ipv4: fix lockdep splat in rt_cache_seq_show
      sch_teql: fix lockdep splat
      ipv4: fix redirect handling
      inet: add a redirect generation id in inetpeer
      sch_red: fix red_calc_qavg_from_idle_time
      sch_red: fix red_change

Federico Vaga (2):
      Staging: comedi: fix mmap_count
      Staging: comedi: fix signal handling in read and write

Felipe Balbi (1):
      ARM: OMAP: smartreflex: fix IRQ handling bug

Flavio Leitner (1):
      route: fix ICMP redirect validation

Frank Blaschka (1):
      qeth: l3 fix rcu splat in xmit

Gao feng (1):
      ipv4: avoid useless call of the function check_peer_pmtu

Gertjan van Wingerde (1):
      rt2x00: Fix efuse EEPROM reading on PPC32.

Gleb Natapov (1):
      jump_label: jump_label_inc may return before the code is patched

Greg Kroah-Hartman (1):
      Linux 3.1.5

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

Jeff Ohlstein (1):
      hrtimer: Fix extra wakeups from __remove_hrtimer()

Jeffrey (Sheng-Hui) Chu (1):
      i2c-algo-bit: Generate correct i2c address sequence for 10-bit target

Johannes Berg (3):
      cfg80211: fix regulatory NULL dereference
      mac80211: don't stop a single aggregation session twice
      iwlagn: fix HW crypto for TX-only keys

Johannes Stezenbach (1):
      ASoC: sta32x: preserve coefficient RAM

John Stultz (1):
      clocksource: Avoid selecting mult values that might overflow when adj=
usted

Julian Anastasov (1):
      ipv4: make sure RTO_ONLINK is saved in routing cache

Kevin Hilman (2):
      ARM: OMAP: PM: only register TWL with voltage layer when device is pr=
esent
      usb: musb: PM: fix context save/restore in suspend/resume path

Konrad Rzeszutek Wilk (1):
      x86/paravirt: PTE updates in k(un)map_atomic need to be synchronous, =
regardless of lazy_mmu mode

Lars-Peter Clausen (3):
      firmware: Sigma: Prevent out of bounds memory access
      firmware: Sigma: Skip header during CRC generation
      firmware: Sigma: Fix endianess issues

Li Wei (1):
      ipv4: fix for ip_options_rcv_srr() daddr update.

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

Michael Buesch (2):
      p54spi: Add missing spin_lock_init
      p54spi: Fix workqueue deadlock

Michal Hocko (1):
      cgroup_freezer: fix freezing groups with stopped tasks

Ming Lei (1):
      ARM: OMAP2: select ARM_AMBA if OMAP3_EMU is defined

Mitsuo Hayasaka (2):
      xfs: Return -EIO when xfs_vn_getattr() failed
      xfs: use doalloc flag in xfs_qm_dqattach_one()

Nick Bowler (2):
      ah: Correctly pass error codes in ahash output callback.
      ah: Read nexthdr value before overwriting it in ahash input callback.

Nikolay Martynov (1):
      mac80211: fix race condition caused by late addBA response

Peter Chubb (1):
      x86: Fix "Acer Aspire 1" reboot hang

Peter Zijlstra (2):
      perf/x86: Fix PEBS instruction unwind
      slab, lockdep: Fix silly bug

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

Simon Wunderlich (1):
      mac80211: fill rate filter for internal scan requests

Stanislaw Gruszka (1):
      rtlwifi: fix lps_lock deadlock

Steven Rostedt (2):
      ftrace: Remove force undef config value left for testing
      perf: Fix parsing of __print_flags() in TP_printk()

Takashi Iwai (3):
      drm/i915: Fix inconsistent backlight level during disabled
      ALSA: hda - Fix jack-detection control of VT1708
      ALSA: hda/realtek - Fix missing inits of item indices for auto-mic

Tejun Heo (2):
      ext4: fix racy use-after-free in ext4_end_io_dio()
      trace_events_filter: Use rcu_assign_pointer() when setting ftrace_eve=
nt_call->filter

Tero Kristo (1):
      regulator: twl: fix twl4030 support for smps regulators

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

Trond Myklebust (1):
      SUNRPC: Ensure we return EAGAIN in xs_nospace if congestion is cleared

Tyler Hicks (3):
      eCryptfs: Prevent file create race condition
      eCryptfs: Flush file in vma close
      eCryptfs: Extend array bounds for all filename chars

Veli-Pekka Peltola (1):
      usb: option: add SIMCom SIM5218

Wey-Yi Guy (2):
      iwlwifi: allow pci_enable_msi fail
      iwlwifi: do not re-configure HT40 after associated

Will Deacon (1):
      ARM: 7161/1: errata: no automatic store buffer drain

Wolfram Sang (1):
      arm: mx28: fix bit operation in clock setting

Xi Wang (1):
      drm: integer overflow in drm_mode_dirtyfb_ioctl()

Yang Honggang (Joseph) (1):
      clocksource: Fix bug with max_deferment margin calculation

sricharan (1):
      ARM: OMAP: hwmod: Fix the addr space, irq, dma count APIs

stephen hemminger (1):
      bridge: correct IPv6 checksum after pull

wwang (1):
      staging:rts_pstor:Complete scanning_done variable


--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJO4kQEAAoJEDjbvchgkmk++xIQAM6hQZo1/TnxKPo+eIeP3Mnh
mHbiLR2akpnp5gTW9Da0BZU7TMSN2dsByZ9e0pa29ddfXI8u8q5Cw6nl+ZGx6XoH
Pp+fDKvvR1XOuZejCTfqQjWvsM/OodfEKHvTLe00W8Iz4rtkHQJ/pB5Q8vKLkQlX
NjRv6kDIFvdwfsPiS/q+C90RPLqxJHaBJ/J8CFTx3th+zmCXzF9BB5FmLxW9H27A
AKIO0jOOm40cGcoGEVWSW9Xi9yMjrINPcJ5tI+5qk90k5gxQEx1vW9yNJdhuWoZX
WWo4HhrVj+x+5KquL3lfI5V1QzuqUUeALcwt4XLJApKu8xub//q9I98B5dxBPhuS
QYGUex2W45jsjCUtUui8/rEptOGQgHsCjBMCnxM/MJng3bDutIYzQZ93QVcDakoW
cG5lft5nnxelmqURHNt2AJPUDuhnjU/reldLbC3h2cvIYjyhZRybYWCZ489G9vk4
h8KglMQo8D6sA/rFx6nj1VPNLYmwxzZLii5/5l1EoRWGpiJprRZZrcpgp5mN7dGH
3xr9tV9e/+O66LGfuVgLzTULx6rsBsXbEllJgQHSnYS0ARD4OA2qWBMNJNxg4cpT
URrFFXLehy0Xo5vUwoPQDMORQ2OItSUj+ueAQQDNecVIZDNkVf3QirrpqY959H+y
dmFCePPuXx+v4HrG6TFg
=WFwG
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
