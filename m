Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab1FCBj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 21:39:28 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:44355 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755428Ab1FCBj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 21:39:27 -0400
X-Sasl-enc: Ry2aISbWhpRkE0x8mQ4W2Sg4HIpaNHCPcF/5xIC4Zs1Z 1307065165
Date: Fri, 3 Jun 2011 10:40:31 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.38.8
Message-ID: <20110603014031.GA25076@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.38.8 kernel.

All users of the 2.6.38 kernel series must upgrade.

This is the LAST .38 stable kernel release, please move to the
.39-stable tree at this point in time.

The updated 2.6.38.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.38.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.38.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/i2c/writing-clients              |    2 
 Documentation/usb/linux-cdc-acm.inf            |    4 -
 Documentation/usb/linux.inf                    |    6 -
 Makefile                                       |    4 -
 arch/arm/mm/cache-v6.S                         |    1 
 arch/arm/mm/cache-v7.S                         |    2 
 arch/parisc/include/asm/unistd.h               |    5 +
 arch/parisc/kernel/sys_parisc32.c              |    8 ++
 arch/parisc/kernel/syscall_table.S             |    3 
 arch/powerpc/kernel/crash.c                    |    2 
 arch/powerpc/kernel/misc_64.S                  |   13 ++-
 arch/powerpc/kernel/paca.c                     |    2 
 arch/powerpc/kernel/setup-common.c             |    3 
 arch/powerpc/oprofile/op_model_power4.c        |   24 ++++++
 arch/sh/kernel/cpu/Makefile                    |    4 -
 arch/x86/include/asm/cpufeature.h              |    2 
 arch/x86/include/asm/uaccess.h                 |    2 
 arch/x86/kernel/apic/io_apic.c                 |    4 -
 arch/x86/kernel/cpu/amd.c                      |   16 ++--
 arch/x86/kernel/cpu/common.c                   |    3 
 arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c      |    4 -
 arch/x86/lib/copy_user_64.S                    |    4 -
 arch/x86/oprofile/op_model_amd.c               |   95 ++++++++++++++-----------
 arch/x86/xen/mmu.c                             |    2 
 block/blk-settings.c                           |    3 
 block/blk-sysfs.c                              |    3 
 block/blk.h                                    |    3 
 block/genhd.c                                  |    2 
 drivers/ata/pata_cmd64x.c                      |   42 ++++++++++-
 drivers/block/brd.c                            |   11 +-
 drivers/block/loop.c                           |   11 +-
 drivers/block/paride/pcd.c                     |   19 +++--
 drivers/block/paride/pd.c                      |    7 +
 drivers/block/paride/pf.c                      |   10 +-
 drivers/cdrom/gdrom.c                          |   16 ++--
 drivers/cdrom/viocd.c                          |   20 +++--
 drivers/char/i8k.c                             |    4 -
 drivers/cpufreq/cpufreq.c                      |   20 ++++-
 drivers/cpufreq/cpufreq_stats.c                |   21 ++++-
 drivers/cpuidle/governors/menu.c               |    4 -
 drivers/gpu/drm/drm_irq.c                      |   23 ++++++
 drivers/gpu/drm/i915/intel_ringbuffer.c        |   29 +++++++
 drivers/gpu/drm/radeon/evergreen.c             |    6 +
 drivers/gpu/drm/radeon/evergreend.h            |    2 
 drivers/gpu/drm/radeon/radeon_asic.c           |    4 +
 drivers/hid/hid-magicmouse.c                   |   10 ++
 drivers/ide/ide-cd.c                           |   12 +--
 drivers/ide/ide-cd.h                           |    3 
 drivers/ide/ide-cd_ioctl.c                     |    8 +-
 drivers/ide/ide-gd.c                           |   14 ++-
 drivers/md/bitmap.c                            |   10 +-
 drivers/md/dm-table.c                          |   17 ++++
 drivers/md/md.c                                |   11 ++
 drivers/media/video/cx88/cx88-blackbird.c      |    5 -
 drivers/media/video/cx88/cx88-dvb.c            |    2 
 drivers/media/video/cx88/cx88-mpeg.c           |   20 ++---
 drivers/media/video/cx88/cx88.h                |    7 +
 drivers/mtd/mtdconcat.c                        |    4 -
 drivers/mtd/nand/nand_base.c                   |    2 
 drivers/net/bonding/bond_3ad.c                 |    7 +
 drivers/net/bonding/bond_alb.c                 |    4 -
 drivers/net/bonding/bond_main.c                |   16 ++--
 drivers/net/bonding/bond_sysfs.c               |    6 -
 drivers/net/macvlan.c                          |    4 -
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   14 +++
 drivers/net/wireless/ath/ath9k/calib.c         |   13 +++
 drivers/net/wireless/iwlwifi/iwl-core.c        |   10 ++
 drivers/net/wireless/iwlwifi/iwl-dev.h         |   19 ++---
 drivers/net/wireless/p54/p54usb.c              |    1 
 drivers/pci/quirks.c                           |   10 ++
 drivers/platform/x86/intel_ips.c               |    2 
 drivers/scsi/bnx2i/bnx2i_hwi.c                 |    1 
 drivers/scsi/bnx2i/bnx2i_init.c                |    2 
 drivers/scsi/bnx2i/bnx2i_iscsi.c               |    5 +
 drivers/scsi/mpt2sas/mpt2sas_scsih.c           |   94 +++++++++++++++++-------
 drivers/scsi/qla2xxx/qla_attr.c                |    5 -
 drivers/scsi/qla2xxx/qla_os.c                  |   32 +++++---
 drivers/scsi/sr.c                              |    2 
 drivers/scsi/ultrastor.c                       |    2 
 drivers/sh/clk/cpg.c                           |    2 
 drivers/staging/rtl8712/rtl871x_ioctl_set.c    |    5 +
 drivers/staging/usbip/usbip_common.c           |    2 
 drivers/target/target_core_device.c            |    4 -
 drivers/target/target_core_tmr.c               |    7 +
 drivers/target/target_core_transport.c         |   46 ++++++++----
 drivers/usb/class/cdc-acm.c                    |   13 ++-
 drivers/usb/class/cdc-acm.h                    |    1 
 drivers/usb/core/hcd.c                         |    5 -
 drivers/usb/gadget/at91_udc.c                  |    2 
 drivers/usb/gadget/f_rndis.c                   |    3 
 drivers/usb/host/ehci-hcd.c                    |    4 -
 drivers/usb/host/ehci-sched.c                  |    8 +-
 drivers/usb/host/isp116x-hcd.c                 |    1 
 drivers/usb/host/ohci-hcd.c                    |    4 -
 drivers/usb/host/ohci-pci.c                    |   12 ++-
 drivers/usb/host/oxu210hp-hcd.c                |    6 +
 drivers/usb/host/xhci-mem.c                    |   11 +-
 drivers/usb/host/xhci-ring.c                   |   18 ++--
 drivers/usb/host/xhci.c                        |   11 ++
 drivers/usb/serial/cp210x.c                    |    4 +
 drivers/usb/serial/ftdi_sio.c                  |    1 
 drivers/usb/serial/ftdi_sio_ids.h              |    5 +
 drivers/usb/serial/garmin_gps.c                |   20 +++--
 drivers/usb/serial/moto_modem.c                |    1 
 drivers/usb/serial/option.c                    |   10 ++
 fs/block_dev.c                                 |   45 +++++++----
 fs/cifs/connect.c                              |   31 +++++---
 fs/ecryptfs/keystore.c                         |   46 +++++-------
 fs/ext3/namei.c                                |   13 ++-
 fs/ext4/ext4.h                                 |    4 -
 fs/ext4/mballoc.c                              |    2 
 fs/ext4/super.c                                |   41 +++-------
 fs/jbd/commit.c                                |    9 +-
 fs/jbd/journal.c                               |   16 +++-
 fs/nfs/nfs4proc.c                              |    9 +-
 fs/nfs/nfs4state.c                             |    6 +
 fs/partitions/ldm.c                            |    5 +
 fs/ubifs/sb.c                                  |    3 
 fs/ubifs/super.c                               |    1 
 include/linux/blkdev.h                         |    7 +
 include/linux/genhd.h                          |    1 
 include/linux/pci_ids.h                        |    2 
 include/linux/pm_qos_params.h                  |    4 +
 include/linux/seqlock.h                        |    4 -
 include/target/target_core_base.h              |    1 
 include/target/target_core_transport.h         |    1 
 init/main.c                                    |    2 
 kernel/pm_qos_params.c                         |   37 ++++++---
 kernel/trace/ftrace.c                          |   12 +--
 lib/locking-selftest.c                         |    2 
 mm/kmemleak.c                                  |    7 +
 mm/page_alloc.c                                |    2 
 mm/shmem.c                                     |    2 
 mm/vmscan.c                                    |   11 ++
 net/8021q/vlan.c                               |    3 
 net/8021q/vlan_dev.c                           |    3 
 net/atm/atm_sysfs.c                            |   10 ++
 net/bridge/br_input.c                          |    2 
 net/bridge/br_netfilter.c                      |    2 
 net/core/dev.c                                 |    2 
 net/core/skbuff.c                              |    3 
 net/ieee802154/Makefile                        |    2 
 net/ipv4/igmp.c                                |   10 +-
 net/ipv4/inet_connection_sock.c                |    5 -
 net/ipv4/inetpeer.c                            |   13 +--
 net/ipv4/sysctl_net_ipv4.c                     |    3 
 net/ipv4/tcp_output.c                          |    3 
 net/ipv6/inet6_connection_sock.c               |    2 
 net/ipv6/route.c                               |    1 
 net/ipv6/udp.c                                 |    2 
 net/irda/af_irda.c                             |    3 
 net/mac80211/cfg.c                             |   12 +--
 net/sched/sch_sfq.c                            |   22 +----
 net/sctp/associola.c                           |   16 ++++
 net/sctp/bind_addr.c                           |   10 +-
 net/socket.c                                   |    6 +
 net/sunrpc/xprtsock.c                          |   16 +++-
 net/wireless/nl80211.c                         |    8 --
 security/apparmor/lsm.c                        |    3 
 sound/pci/hda/hda_intel.c                      |    9 ++
 sound/pci/hda/patch_analog.c                   |    3 
 sound/pci/hda/patch_conexant.c                 |    1 
 sound/pci/hda/patch_sigmatel.c                 |    2 
 sound/soc/codecs/wm_hubs.c                     |   24 +++---
 164 files changed, 1065 insertions(+), 517 deletions(-)


Adrian Wilkins (1):
      ALSA: hda - Fix input-src parse in patch_analog.c

Alan Stern (2):
      OHCI: fix regression caused by nVidia shutdown workaround
      USB: remove remaining usages of hcd->state from usbcore and fix regression

Alex Deucher (1):
      drm/radeon/evergreen/btc/fusion: setup hdp to invalidate and flush when asked

Andrew Barry (1):
      mm/page_alloc.c: prevent unending loop in __alloc_pages_slowpath()

Anton Blanchard (1):
      net: recvmmsg: Strip MSG_WAITFORONE when calling recvmsg

Artem Bityutskiy (2):
      mtd: return badblockbits back
      UBIFS: fix a rare memory leak in ro to rw remounting path

Arun Easi (2):
      qla2xxx: Fix hang during driver unload when vport is active.
      qla2xxx: Fix vport delete hang when logins are outstanding.

Benedek László (1):
      USB: serial: ftdi_sio: adding support for TavIR STK500

Boqun Feng (1):
      drm/i915: fix user irq miss in BSD ring on g4x

Boris Ostrovsky (1):
      x86, amd: Do not enable ARAT feature on AMD processors below family 0x12

Catalin Marinas (2):
      kmemleak: Do not return a pointer to an object that kmemleak did not get
      kmemleak: Initialise kmemleak after debug_objects_mem_init()

Christian Lamparter (1):
      p54usb: add zoom 4410 usbid

Christopher James Halse Rogers (1):
      drm: Send pending vblank events before disabling vblank.

Craig Shelley (1):
      USB: CP210x Add 4 Device IDs for AC-Services Devices

Dan Williams (1):
      atm: expose ATM device index in sysfs

Daniel J Blueman (1):
      x86, ioapic: Fix potential resume deadlock

Dave Airlie (1):
      drm/radeon/kms: add wait idle ioctl for eg->cayman

Dave Jones (1):
      irda: fix locking unbalance in irda_sendmsg

David Chang (1):
      staging: usbip: fix wrong endian conversion

David Henningsson (2):
      ALSA: HDA: Use one dmic only for Dell Studio 1558
      ALSA: HDA: Add quirk for Lenovo U350

David S. Miller (3):
      ieee802154: Remove hacked CFLAGS in net/ieee802154/Makefile
      Revert "bridge: Forward reserved group addresses if !STP"
      Revert "tcp: disallow bind() to reuse addr/port"

Eddie Wai (2):
      bnx2i: Fixed packet error created when the sq_size is set to 16
      bnx2i: Updated the connection shutdown/cleanup timeout

Elizabeth Jennifer Myers (1):
      USB: moto_modem: Add USB identifier for the Motorola VE240.

Eric B Munson (1):
      powerpc/oprofile: Handle events that raise an exception without overflowing

Eric Dumazet (7):
      inetpeer: reduce stack usage
      macvlan: fix panic if lowerdev in a bond
      net: use hlist_del_rcu() in dev_change_name()
      vlan: fix GVRP at dismantle time MIME-Version: 1.0
      net: add skb_dst_force() in sock_queue_err_skb()
      sch_sfq: avoid giving spurious NET_XMIT_CN signals
      sch_sfq: fix peek() implementation

Erik Slagter (1):
      USB: cdc_acm: Fix oops when Droids MuIn LCD is connected

Felipe Balbi (1):
      usb: gadget: rndis: don't test against req->length

Felix Radensky (1):
      mtd: mtdconcat: fix NAND OOB write

Fenghua Yu (1):
      x86, cpufeature: Fix cpuid leaf 7 feature detection

Frederic Weisbecker (1):
      rcu: Fix unpaired rcu_irq_enter() from locking selftests

Greg Kroah-Hartman (1):
      Linux 2.6.38.8

Hemant Pedanekar (1):
      PCI: Add quirk for setting valid class for TI816X Endpoint

Hermann Kneissel (1):
      USB: gamin_gps: Fix for data transfer problems in native mode

Hugh Dickins (1):
      tmpfs: fix race between truncate and writepage

Ilpo Järvinen (1):
      tcp: len check is unnecessarily devastating, change to WARN_ON

Jacek Luczak (1):
      SCTP: fix race between sctp_bind_addr_free() and sctp_bind_addr_conflict()

Jacob Shin (1):
      CPU hotplug, re-create sysfs directory and symlinks

James Bottomley (4):
      block: add proper state guards to __elv_next_request
      wire up fanotify syscalls
      wire up clock_adjtime syscall
      pata_cm64x: fix boot crash on parisc

Jan Kara (2):
      ext3: Fix fs corruption when make_indexed_dir() fails
      jbd: Fix forever sleeping process in do_get_write_access()

Jean-Christophe PLAGNIOL-VILLARD (1):
      usb/gadget: at91sam9g20 fix end point max packet size

Jeff Chua (1):
      staging: r8712u: Fix driver to support ad-hoc mode

Jesse Barnes (1):
      ips: use interruptible waits in ips-monitor

Jiri Bohac (1):
      bonding: 802.3ad - fix agg_device_up

Jiri Kosina (1):
      HID: magicmouse: ignore 'ivalid report id' while switching modes

Jiri Olsa (1):
      x86, 64-bit: Fix copy_[to/from]_user() checks for the userspace address limit

Joakim Tjernlund (1):
      net: Do not wrap sysctl igmp_max_memberships in IP_MULTICAST

Johannes Berg (3):
      iwlagn: fix iwl_is_any_associated
      iwlwifi: fix bugs in change_interface
      mac80211: fix a few RCU issues

Johannes Weiner (1):
      mm: vmscan: correct use of pgdat_balanced in sleeping_prematurely

Jonathan Nieder (3):
      cx88: protect per-device driver list with device lock
      cx88: fix locking of sub-driver operations
      cx88: hold device lock during sub-driver initialization

Jouni Malinen (1):
      nl80211: Fix set_key regression with some drivers

Kashyap, Desai (1):
      mpt2sas: move even handling of MPT2SAS_TURN_ON_FAULT_LED into process context

Kees Cook (2):
      x86, cpufeature: Update CPU feature RDRND to RDRAND
      AppArmor: fix oops in apparmor_setprocattr

Kevin Cernekee (1):
      kbuild: Fix GNU make v3.80 compatibility

Kuninori Morimoto (2):
      sh: clkfwk: fixup clk_rate_table_build parameter in div6 clock
      sh: fixup fpu.o compile order

Luca Tettamanti (1):
      i8k: Avoid lahf in 64-bit code

Luis R. Rodriguez (2):
      ath9k_hw: fix power for the HT40 duplicate frames
      ath9k_hw: fix dual band assumption for XB113

Lukas Czerner (2):
      ext4: fix possible use-after-free in ext4_remove_li_request()
      ext4: Use schedule_timeout_interruptible() for waiting in lazyinit thread

Marcin Gałczyński (1):
      USB: option: add support for Huawei E353 device

Marius B. Kotsbak (1):
      Bind only modem AT command endpoint to option module.

Mark Brown (2):
      ASoC: Ensure output PGA is enabled for line outputs in wm_hubs
      ASoC: Add some missing volume update bit sets for wm_hubs devices

Martin K. Petersen (1):
      block: Fix discard topology stacking and reporting

Michal Nazarewicz (1):
      USB: gadget: g_multi: fixed vendor and product ID in inf files

Milan Broz (1):
      dm table: reject devices without request fns

Milton Miller (3):
      powerpc/kdump64: Don't reference freed memory as pacas
      powerpc/kexec: Fix memory corruption from unallocated slaves
      seqlock: Don't smp_rmb in seqlock reader spin loop

Minchan Kim (1):
      mm: vmscan: correctly check if reclaimer should schedule during shrink_slab

Naga Chumbalkar (1):
      Fix _OSC UUID in pcc-cpufreq

Namhyung Kim (4):
      loop: limit 'max_part' module param to DISK_MAX_PARTS
      loop: handle on-demand devices correctly
      brd: limit 'max_part' module param to DISK_MAX_PARTS
      brd: handle on-demand devices correctly

Neil Horman (1):
      bonding: prevent deadlock on slave store with alb mode (v3)

NeilBrown (2):
      md: Fix race when creating a new md device.
      md/bitmap: fix saving of events_cleared and other state.

Nicholas Bellinger (4):
      target: Fix multi task->task_sg[] chaining logic bug
      target: Fix interrupt context bug with stats_lock and core_tmr_alloc_req
      target: Fix bug with task_sg chained transport_free_dev_tasks release
      target: Fix task->task_execute_queue=1 clear bug + LUN_RESET OOPs

Rajkumar Manoharan (1):
      ath9k_hw: do noise floor calibration only on required chains

Robert Richter (1):
      oprofile, x86: Enable preemption during pci device setup in IBS init

Roedel, Joerg (1):
      x86, amd: Use _safe() msr access for GartTlbWlk disable code

Ryan Grimm (1):
      powerpc: Set nr_cpu_ids early and use it to free PACAs

Samuel Thibault (1):
      Fix Ultrastor asm snippet

Sarah Sharp (4):
      xhci: Fix bug in control transfer cancellation.
      xhci: Fix full speed bInterval encoding.
      xhci: Fix memory leak in ring cache deallocation.
      xhci: Fix memory leak bug when dropping endpoints

Saurav Kashyap (1):
      qla2xxx: Fix virtual port failing to login after chip reset.

Senthil Balasubramanian (1):
      ath9k_hw: Fix STA connection issues with AR9380 (XB113).

Shan Wei (1):
      ipv6: udp: fix the wrong headroom check

Stephen Hemminger (1):
      bridge: fix forwarding of IPv6

Steve French (1):
      When mandatory encryption on share, fail mount

Steven Rostedt (1):
      ftrace: Only update the function code on write to filter files

Takashi Iwai (1):
      ALSA: hda - Use LPIB for ATI/AMD chipsets as default

Ted Ts'o (1):
      jbd: fix fsync() tid wraparound bug

Tejun Heo (7):
      block: rescan partitions on invalidated devices on -ENOMEDIA too
      block: move bd_set_size() above rescan_partitions() in __blkdev_get()
      paride: Convert to bdops->check_events()
      gdrom,viocd: Convert to bdops->check_events()
      ide: Convert to bdops->check_events()
      block: don't block events on excl write for non-optical devices
      block: always allocate genhd->ev if check_events is implemented

Tero Kristo (1):
      cpuidle: menu: fixed wrapping timers at 4.294 seconds

Thomas Egerer (1):
      ipv6: Remove hoplimit initialization to -1

Tian, Kevin (1):
      xen mmu: fix a race window causing leave_mm BUG()

Tim Chen (1):
      idle governor: Avoid lock acquisition to read pm_qos before entering idle

Timo Warns (1):
      Fix for buffer overflow in ldm_frag_add not sufficient

Trond Myklebust (3):
      SUNRPC: Deal with the lack of a SYN_SENT sk->sk_state_change callback...
      NFSv4: Handle expired stateids when the lease is still valid
      NFSv4.1: Fix the handling of NFS4ERR_SEQ_MISORDERED errors

Tyler Hicks (1):
      eCryptfs: Allow 2 scatterlist entries for encrypted filenames

Veaceslav Falico (1):
      igmp: call ip_mc_clear_src() only when we have no users of ip_mc_list

Vikram Narayanan (1):
      i2c/writing-clients: Fix foo_driver.id_table

Wei Yongjun (1):
      sctp: fix memory leak of the ASCONF queue when free asoc

Will Deacon (1):
      ARM: 6941/1: cache: ensure MVA is cacheline aligned in flush_kern_dcache_area

Yang Ruirui (1):
      ext4: release page cache in ext4_mb_load_buddy error path

steven finney (1):
      Fix memory leak in cpufreq_stat

