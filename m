Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab2GPS3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 14:29:16 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46910 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2GPS3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 14:29:12 -0400
Date: Mon, 16 Jul 2012 11:29:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.4.5
Message-ID: <20120716182906.GA28034@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.5 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Documentation/device-mapper/verity.txt              |  131 +++++++--------=
-----
 Documentation/stable_kernel_rules.txt               |    6=20
 Makefile                                            |    2=20
 arch/arm/mach-dove/include/mach/bridge-regs.h       |    1=20
 arch/arm/mach-dove/include/mach/dove.h              |    1=20
 arch/arm/mach-kirkwood/include/mach/bridge-regs.h   |    1=20
 arch/arm/mach-kirkwood/include/mach/kirkwood.h      |    1=20
 arch/arm/mach-mv78xx0/include/mach/bridge-regs.h    |    1=20
 arch/arm/mach-mv78xx0/include/mach/mv78xx0.h        |    2=20
 arch/arm/mach-orion5x/include/mach/bridge-regs.h    |    2=20
 arch/arm/mach-orion5x/include/mach/orion5x.h        |    1=20
 arch/arm/mach-tegra/reset.c                         |    2=20
 arch/arm/mm/mmu.c                                   |   74 +++++++++++
 arch/arm/plat-orion/common.c                        |    2=20
 arch/arm/plat-samsung/include/plat/map-s3c.h        |    2=20
 arch/arm/plat-samsung/include/plat/watchdog-reset.h |    2=20
 arch/powerpc/include/asm/hw_irq.h                   |   11 +
 arch/powerpc/kernel/irq.c                           |   50 +++++++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S             |    2=20
 arch/powerpc/mm/numa.c                              |    2=20
 arch/powerpc/platforms/cell/pervasive.c             |   11 -
 arch/powerpc/platforms/pseries/iommu.c              |    4=20
 arch/powerpc/platforms/pseries/processor_idle.c     |   17 +-
 arch/powerpc/xmon/xmon.c                            |    2=20
 arch/x86/ia32/ia32_signal.c                         |    2=20
 arch/x86/include/asm/cpufeature.h                   |    2=20
 arch/x86/include/asm/pgtable-3level.h               |   54 ++++++++
 arch/x86/kernel/acpi/boot.c                         |   27 ++--
 arch/x86/kernel/cpu/scattered.c                     |    2=20
 arch/x86/kernel/reboot.c                            |    8 +
 drivers/acpi/acpi_pad.c                             |    7 -
 drivers/acpi/acpica/hwsleep.c                       |   22 ---
 drivers/acpi/apei/apei-base.c                       |   17 ++
 drivers/acpi/apei/apei-internal.h                   |    9 +
 drivers/acpi/apei/ghes.c                            |    6=20
 drivers/acpi/sleep.c                                |    4=20
 drivers/acpi/sysfs.c                                |    4=20
 drivers/acpi/video.c                                |    2=20
 drivers/base/power/main.c                           |    6=20
 drivers/block/umem.c                                |   40 ++++++
 drivers/block/xen-blkback/common.h                  |    2=20
 drivers/clk/clk.c                                   |   27 ++--
 drivers/dma/pl330.c                                 |    2=20
 drivers/gpio/gpio-wm8994.c                          |    5=20
 drivers/gpu/drm/drm_edid.c                          |    2=20
 drivers/gpu/drm/i915/i915_irq.c                     |   57 ++++----
 drivers/gpu/drm/i915/i915_suspend.c                 |    5=20
 drivers/gpu/drm/nouveau/nouveau_fbcon.c             |    2=20
 drivers/gpu/drm/radeon/radeon_gart.c                |   13 +
 drivers/gpu/drm/radeon/si.c                         |    4=20
 drivers/hid/hid-multitouch.c                        |   58 +++++++-
 drivers/hwmon/applesmc.c                            |    4=20
 drivers/hwmon/coretemp.c                            |    4=20
 drivers/hwspinlock/hwspinlock_core.c                |    4=20
 drivers/iommu/amd_iommu.c                           |    9 +
 drivers/iommu/amd_iommu_init.c                      |    4=20
 drivers/iommu/tegra-smmu.c                          |    4=20
 drivers/md/persistent-data/dm-space-map-checker.c   |   54 ++++----
 drivers/md/persistent-data/dm-space-map-disk.c      |   11 +
 drivers/md/persistent-data/dm-transaction-manager.c |   11 +
 drivers/md/raid10.c                                 |   12 +
 drivers/md/raid5.c                                  |   14 +-
 drivers/media/dvb/siano/smsusb.c                    |    2=20
 drivers/media/video/gspca/gspca.c                   |    4=20
 drivers/mtd/nand/cafe_nand.c                        |    2=20
 drivers/net/bonding/bond_main.c                     |    9 -
 drivers/net/can/c_can/c_can.c                       |    4=20
 drivers/net/can/flexcan.c                           |    4=20
 drivers/net/dummy.c                                 |    4=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h         |   15 --
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c     |   35 +++--
 drivers/net/ethernet/broadcom/tg3.c                 |    3=20
 drivers/net/ethernet/emulex/benet/be_main.c         |    5=20
 drivers/net/ethernet/intel/e1000e/defines.h         |    1=20
 drivers/net/ethernet/intel/e1000e/ethtool.c         |    6=20
 drivers/net/ethernet/intel/e1000e/mac.c             |    2=20
 drivers/net/ethernet/intel/e1000e/netdev.c          |   79 ++----------
 drivers/net/ethernet/intel/e1000e/phy.c             |    8 -
 drivers/net/ethernet/intel/igbvf/ethtool.c          |   29 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe.h            |    4=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c        |    2=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c       |   14 +-
 drivers/net/ethernet/marvell/sky2.c                 |   10 -
 drivers/net/ethernet/nxp/lpc_eth.c                  |   11 -
 drivers/net/ethernet/realtek/r8169.c                |    3=20
 drivers/net/ethernet/sun/niu.c                      |   12 -
 drivers/net/macvtap.c                               |   25 +++
 drivers/net/usb/ipheth.c                            |    5=20
 drivers/net/usb/qmi_wwan.c                          |  109 +++++++++-------
 drivers/net/wireless/ath/ath.h                      |    1=20
 drivers/net/wireless/ath/ath9k/ath9k.h              |    1=20
 drivers/net/wireless/ath/ath9k/htc_drv_main.c       |    5=20
 drivers/net/wireless/ath/ath9k/hw.c                 |   16 ++
 drivers/net/wireless/ath/ath9k/main.c               |   18 +-
 drivers/net/wireless/ath/ath9k/recv.c               |    7 -
 drivers/net/wireless/ath/ath9k/xmit.c               |   31 ++--
 drivers/net/wireless/ath/key.c                      |    4=20
 drivers/net/wireless/ipw2x00/ipw.h                  |   23 +++
 drivers/net/wireless/ipw2x00/ipw2100.c              |    4=20
 drivers/net/wireless/ipw2x00/ipw2200.c              |    4=20
 drivers/net/wireless/iwlwifi/iwl-mac80211.c         |   12 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c       |    6=20
 drivers/net/wireless/mwifiex/11n_rxreorder.c        |    5=20
 drivers/net/wireless/mwifiex/11n_rxreorder.h        |    7 +
 drivers/net/wireless/mwifiex/cfg80211.c             |   21 +--
 drivers/net/wireless/mwifiex/wmm.c                  |    3=20
 drivers/net/wireless/rtl818x/rtl8187/leds.c         |    2=20
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c         |    3=20
 drivers/net/xen-netfront.c                          |    8 -
 drivers/oprofile/oprofile_perf.c                    |    2=20
 drivers/pci/pci-driver.c                            |   12 +
 drivers/pci/pci.c                                   |    5=20
 drivers/pci/quirks.c                                |   26 ---
 drivers/remoteproc/Kconfig                          |    2=20
 drivers/rpmsg/virtio_rpmsg_bus.c                    |   55 +++++++-
 drivers/rtc/rtc-ab8500.c                            |    2=20
 drivers/rtc/rtc-mxc.c                               |    5=20
 drivers/rtc/rtc-spear.c                             |    2=20
 drivers/scsi/aic94xx/aic94xx_task.c                 |    2=20
 drivers/scsi/libsas/sas_ata.c                       |   12 -
 drivers/scsi/sd.c                                   |    2=20
 drivers/staging/iio/adc/ad7606_core.c               |    1=20
 drivers/staging/rtl8712/usb_intf.c                  |    2=20
 drivers/target/tcm_fc/tfc_sess.c                    |    3=20
 drivers/usb/class/cdc-wdm.c                         |    2=20
 drivers/usb/core/hub.c                              |   18 +-
 drivers/usb/host/xhci-hub.c                         |   44 +++++-
 drivers/usb/host/xhci-ring.c                        |   11 +
 drivers/usb/host/xhci.h                             |    6=20
 drivers/usb/serial/cp210x.c                         |   11 +
 drivers/usb/serial/metro-usb.c                      |    8 -
 drivers/usb/serial/option.c                         |   34 +++++
 drivers/usb/storage/scsiglue.c                      |    6=20
 drivers/usb/storage/unusual_devs.h                  |    7 -
 drivers/video/omap2/dss/apply.c                     |    2=20
 drivers/video/omap2/dss/dispc.c                     |    5=20
 drivers/video/omap2/dss/dss.h                       |    3=20
 fs/btrfs/tree-log.c                                 |    6=20
 fs/cifs/connect.c                                   |   41 +++---
 fs/ecryptfs/kthread.c                               |    2=20
 fs/ecryptfs/miscdev.c                               |   48 ++++---
 fs/exec.c                                           |    2=20
 fs/lockd/clntlock.c                                 |   13 +
 fs/lockd/svc.c                                      |   38 +++--
 fs/nfs/callback.c                                   |   16 +-
 fs/nfs/idmap.c                                      |   13 +
 fs/nfsd/nfsctl.c                                    |   12 +
 fs/nfsd/nfssvc.c                                    |   29 +++-
 fs/nilfs2/gcinode.c                                 |    2=20
 fs/nilfs2/segment.c                                 |    2=20
 fs/ocfs2/file.c                                     |    6=20
 fs/open.c                                           |    6=20
 fs/ramfs/file-nommu.c                               |    1=20
 fs/splice.c                                         |   35 +++--
 fs/udf/super.c                                      |  102 +++++++++------
 include/asm-generic/pgtable.h                       |   32 ++++
 include/linux/aio.h                                 |    1=20
 include/linux/lockd/bind.h                          |    4=20
 include/linux/memblock.h                            |    4=20
 include/linux/mm_types.h                            |   10 +
 include/linux/mmzone.h                              |    2=20
 include/linux/pci.h                                 |    2=20
 include/linux/rpmsg.h                               |    6=20
 include/linux/skbuff.h                              |    7 -
 include/linux/splice.h                              |    8 -
 include/linux/sunrpc/svc.h                          |    1=20
 include/net/cipso_ipv4.h                            |   29 ++++
 include/net/inetpeer.h                              |    5=20
 include/net/sch_generic.h                           |    7 -
 include/scsi/libsas.h                               |    6=20
 include/scsi/scsi_cmnd.h                            |    8 +
 include/scsi/scsi_device.h                          |    1=20
 kernel/exit.c                                       |    1=20
 kernel/relay.c                                      |    5=20
 kernel/trace/trace.c                                |    8 -
 lib/dynamic_queue_limits.c                          |   18 +-
 mm/compaction.c                                     |    5=20
 mm/madvise.c                                        |   16 +-
 mm/memblock.c                                       |  123 ++++++++++++---=
---
 mm/nobootmem.c                                      |   38 +++--
 mm/shmem.c                                          |    3=20
 mm/vmscan.c                                         |    7 -
 net/batman-adv/routing.c                            |    2=20
 net/batman-adv/translation-table.c                  |    8 -
 net/bridge/br_if.c                                  |    1=20
 net/bridge/br_netlink.c                             |    2=20
 net/bridge/br_private.h                             |    1=20
 net/can/raw.c                                       |    3=20
 net/core/dev.c                                      |   23 ---
 net/core/drop_monitor.c                             |  102 +++++----------
 net/core/neighbour.c                                |   14 --
 net/core/netpoll.c                                  |   11 -
 net/core/skbuff.c                                   |    3=20
 net/core/sock.c                                     |    7 -
 net/ipv4/inetpeer.c                                 |   16 +-
 net/ipv6/ip6_fib.c                                  |    2=20
 net/ipv6/route.c                                    |   41 ++++--
 net/iucv/af_iucv.c                                  |    1=20
 net/l2tp/l2tp_eth.c                                 |    2=20
 net/l2tp/l2tp_ip.c                                  |    9 -
 net/mac80211/mlme.c                                 |   24 +--
 net/mac80211/rx.c                                   |    5=20
 net/nfc/nci/ntf.c                                   |   10 -
 net/nfc/rawsock.c                                   |    5=20
 net/sunrpc/rpcb_clnt.c                              |   12 +
 net/sunrpc/svc.c                                    |   23 +--
 net/wireless/reg.c                                  |    2=20
 sound/pci/hda/hda_codec.c                           |    2=20
 sound/pci/hda/patch_realtek.c                       |    1=20
 sound/pci/hda/patch_sigmatel.c                      |    4=20
 sound/soc/codecs/tlv320aic3x.c                      |    4=20
 sound/soc/codecs/tlv320aic3x.h                      |    1=20
 sound/soc/codecs/wm2200.c                           |    1=20
 tools/hv/hv_kvp_daemon.c                            |   10 +
 214 files changed, 1801 insertions(+), 1010 deletions(-)

Alan Stern (3):
      SCSI & usb-storage: add try_rc_10_first flag
      usb-storage: revert commit afff07e61a52 (Add 090c:1000 to unusal-devs)
      PCI: EHCI: fix crash during suspend on ASUS computers

Alex Deucher (1):
      drm/radeon: fix VM page table setup on SI

Alexander Duyck (1):
      ixgbe: Do not pad FCoE frames as this can cause issues with FCoE DDP

Andrea Arcangeli (2):
      mm: pmd_read_atomic: fix 32bit PAE pmd walk vs pmd_populate SMP race =
condition
      thp: avoid atomic64_read in pmd_read_atomic for 32bit PAE

Andrew Bird (Sphere Systems) (2):
      USB: qmi_wwan: Make forced int 4 whitelist generic
      USB: qmi_wwan: Add ZTE (Vodafone) K3520-Z

Andrew Lunn (2):
      ARM: Orion: Fix Virtual/Physical mixup with watchdog
      ARM: Orion: Fix WDT compile for Dove and MV78xx0

Andy Lutomirski (1):
      mm: Hold a file reference in madvise_remove

Anton Blanchard (2):
      powerpc: check_and_cede_processor() never cedes
      powerpc/xmon: Use cpumask iterator to avoid warning

Antonio Quartulli (1):
      batman-adv: fix skb->data assignment

Ben Skeggs (1):
      drm/nouveau/fbcon: using nv_two_heads is not a good idea

Benjamin Herrenschmidt (2):
      powerpc: More fixes for lazy IRQ vs. idle
      powerpc: Fix build of some debug irq code

Benjamin Tissoires (1):
      HID: hid-multitouch: fix wrong protocol detection

Beno=EEt Th=E9baudeau (1):
      drivers/rtc/rtc-mxc.c: fix irq enabled interrupts warning

Bing Zhao (1):
      mwifiex: fix wrong return values in add_virtual_intf() error cases

Bj=F8rn Mork (4):
      net: qmi_wwan: fix Gobi device probing
      net: qmi_wwan: fix Oops while disconnecting
      USB: cdc-wdm: fix lockup on error in wdm_read
      USB: option: add ZTE MF60

Bob Liu (1):
      fs: ramfs: file-nommu: add SetPageUptodate()

Bruce Allan (2):
      e1000e: remove use of IP payload checksum
      e1000e: test for valid check_reset_block function pointer

Bryan Schumaker (1):
      NFS: Force the legacy idmapper to be single threaded

Chris Mason (1):
      Btrfs: run delayed directory updates during log replay

Chris Wilson (1):
      drm/i915: Refactor the deferred PM_IIR handling into a single function

Craig Shelley (1):
      USB: CP210x Add 10 Device IDs

Dan Carpenter (2):
      can: c_can: precedence error in c_can_chip_config()
      mtd: cafe_nand: fix an & vs | mistake

Dan Rosenberg (1):
      NFC: Prevent multiple buffer overflows in NCI

Dan Williams (1):
      SCSI: libsas: fix taskfile corruption in sas_ata_qc_fill_rtf

Daniel Vetter (2):
      drm/edid: don't return stack garbage from supports_rb
      drm/i915: rip out the PM_IIR WARN

David Henningsson (1):
      ALSA: hda - Add Realtek ALC280 codec support

David Rientjes (1):
      mm, thp: abort compaction if migration page cannot be charged to memcg

David S. Miller (1):
      Revert "niu: Add support for byte queue limits."

Davide Gerhard (1):
      ipheth: add support for iPad

Devendra Naga (2):
      r8169: call netif_napi_del at errpaths and at driver unload
      drivers/rtc/rtc-spear.c: fix use-after-free in spear_rtc_remove()

Dmitry Shmygov (1):
      USB: option: add id for Cellient MEN-200

Eliad Peller (2):
      cfg80211: fix potential deadlock in regulatory
      mac80211: clear ifmgd->bssid only after building DELBA

Eric Dumazet (16):
      drop_monitor: dont sleep in atomic context
      inetpeer: fix a race in inetpeer_gc_worker()
      net: l2tp_eth: fix kernel panic on rmmod l2tp_eth
      l2tp: fix a race in l2tp_ip_sendmsg()
      lpc_eth: add missing ndo_change_mtu()
      lpc_eth: fix tx completion
      net: neighbour: fix neigh_dump_info()
      be2net: fix a race in be_xmit()
      dummy: fix rcu_sched self-detected stalls
      bonding: Fix corrupted queue_mapping
      netpoll: fix netpoll_send_udp() bugs
      bnx2x: fix checksum validation
      bnx2x: fix panic when TX ring is full
      net: remove skb_orphan_try()
      NFC: Return from rawsock_release when sk is NULL
      splice: fix racy pipe->buffers uses

Felix Fietkau (3):
      ath9k: fix a tx rate duration calculation bug
      ath9k: fix invalid pointer access in the tx path
      ath9k: fix dynamic WEP related regression

Feng Tang (3):
      ACPI: Make acpi_skip_timer_override cover all source_irq=3D=3D0 cases
      ACPI: Remove one board specific WARN when ignoring timer overriding
      ACPI: Add a quirk for "AMILO PRO V2030" to ignore the timer overriding

Forest Bond (1):
      USB: option: Add USB ID for Novatel Ovation MC551

Gaosen Zhang (1):
      USB: option: Add MEDIATEK product ids

Gavin Shan (2):
      mm/memblock: cleanup on duplicate VA/PA conversion
      mm/memblock: fix memory leak on extending regions

Greg Kroah-Hartman (1):
      Linux 3.4.5

Greg Pearson (1):
      mm/memblock: fix overlapping allocation when doubling reserved array

H. Peter Anvin (1):
      x86, cpufeature: Rename X86_FEATURE_DTS to X86_FEATURE_DTHERM

Hans de Goede (1):
      gspca-core: Fix buffers staying in queued state after a stream_off

Hebbar, Gururaja (1):
      ASoC: tlv320aic3x: Fix codec pll configure bug

Henrik Rydberg (1):
      hwmon: (applesmc) Limit key length in warning messages

Hiroaki SHIMODA (3):
      bql: Fix POSDIFF() to integer overflow aware.
      bql: Avoid unneeded limit decrement.
      bql: Avoid possible inconsistent calculation.

Hiroshi DOYU (1):
      iommu/tegra: smmu: Fix unsleepable memory allocation

Huang Ying (1):
      ACPI, APEI, Avoid too much error reporting in runtime

Hui Wang (1):
      can: flexcan: use be32_to_cpup to handle the value of dt entry

Ian Campbell (1):
      xen/netfront: teardown the device before unregistering it.

Jan Kara (3):
      udf: Use 'ret' instead of abusing 'i' in udf_load_logicalvol()
      udf: Avoid run away loop when partition table length is corrupted
      udf: Fortify loading of sparing table

Jason Wang (2):
      net: sock: validate data_len before allocating skb in sock_alloc_send=
_pskb()
      macvtap: zerocopy: validate vectors before building skb

Jeff Layton (1):
      cifs: when server doesn't set CAP_LARGE_READ_X, cap default rsize at =
MaxBufferSize

Jiang Liu (1):
      memory hotplug: fix invalid memory access caused by stale kswapd poin=
ter

Joerg Roedel (1):
      iommu/amd: Initialize dma_ops for hotplug and sriov devices

Johan Hovold (1):
      USB: metro-usb: fix tty_flip_buffer_push use

Johannes Berg (4):
      mac80211: correct behaviour on unrecognised action frames
      iwlwifi: fix activating inactive stations
      mac80211: fix queues stuck issue with HT bandwidth change
      iwlwifi: remove log_event debugfs file debugging is disabled

Jonathan Nieder (1):
      ACPI / PM: Leave Bus Master Arbitration enabled for suspend/resume

Jonghwan Choi (1):
      ARM: SAMSUNG: Should check for IS_ERR(clk) instead of NULL

Jose Miguel Goncalves (1):
      ARM: SAMSUNG: Fix for S3C2412 EBI memory mapping

Junxiao Bi (2):
      aio: make kiocb->private NUll in init_sync_kiocb()
      ocfs2: clear unaligned io flag when dio fails

Konrad Rzeszutek Wilk (1):
      xen/blkback: Copy id field when doing BLKIF_DISCARD.

Konstantin Khlebnikov (1):
      mm: correctly synchronize rss-counters at exit/exec

Larry Finger (1):
      rtlwifi: rtl8192cu: New USB IDs

Lars-Peter Clausen (1):
      staging:iio:ad7606: Re-add missing scale attribute

Lee Jones (1):
      drivers/rtc/rtc-ab8500.c: use IRQF_ONESHOT when requesting a threaded=
 IRQ

Linus Torvalds (1):
      vfs: make O_PATH file descriptors usable for 'fchdir()'

Lubomir Schmidt (1):
      staging: r8712u: Add new USB IDs

Luis Henriques (1):
      ocfs2: fix NULL pointer dereference in __ocfs2_change_file_space()

Mandeep Singh Baines (1):
      PM / Sleep: Prevent waiting forever on asynchronous suspend after abo=
rt

Marek Lindner (1):
      batman-adv: only drop packets of known wifi clients

Mark Brown (2):
      ASoC: wm2200: Add missing BCLK rate
      gpiolib: wm8994: Pay attention to the value set when enabling as outp=
ut

Mark Rustad (2):
      tcm_fc: Resolve suspicious RCU usage warnings
      SCSI: Fix NULL dereferences in scsi_cmd_to_driver

Matt Carlson (1):
      tg3: Apply short DMA frag workaround to 5906

Mel Gorman (1):
      stable: Allow merging of backports for serious user-visible performan=
ce issues

Michael Krufky (1):
      media: smsusb: add autodetection support for USB ID 2040:f5a0

Michael Neuling (3):
      powerpc: Fix uninitialised error in numa.c
      powerpc/pseries: Fix software invalidate TCE
      powerpc/kvm: sldi should be sld

Mike Snitzer (3):
      dm persistent data: fix shadow_info_leak on dm_tm_destroy
      dm persistent data: handle space map checker creation failure
      dm persistent data: fix allocation failure in space map checker init

Milan Broz (1):
      dm: verity fix documentation

Mitch A Williams (1):
      igbvf: fix divide by zero

Mohammed Shafi Shajakhan (3):
      ath9k: Fix a WARNING on suspend/resume with IBSS
      ath9k: Fix softlockup in AR9485
      ath9k_hw: avoid possible infinite loop in ar9003_get_pll_sqsum_dvc

NeilBrown (2):
      md/raid10: Don't try to recovery unmatched (and unused) chunks.
      md/raid10: fix failure when trying to repair a read error.

Nicolas Pitre (1):
      ARM: 7438/1: fill possible PMD empty section gaps

Ohad Ben-Cohen (4):
      rpmsg: avoid premature deallocation of endpoints
      rpmsg: make sure inflight messages don't invoke just-removed callbacks
      remoteproc/omap: fix randconfig unmet direct dependencies
      remoteproc: fix missing CONFIG_FW_LOADER configurations

Olaf Hering (1):
      Tools: hv: verify origin of netlink connector message

Panayiotis Karabassis (1):
      ath9k: enable serialize_regmode for non-PCIE AR9287

Paul Moore (1):
      cipso: handle CIPSO options correctly when NetLabel is disabled

Pavel Vasilyev (1):
      ACPI sysfs.c strlen fix

Pravin B Shelar (1):
      mm: fix slab->page _count corruption when using slub

Rafael J. Wysocki (1):
      ACPI / PM: Make acpi_pm_device_sleep_state() follow the specification

Rajendra Nayak (2):
      clk: Allow late cache allocation for clk->parents
      clk: fix parent validation in __clk_set_parent()

Rajkumar Manoharan (1):
      ath9k_htc: configure bssid on ASSOC/IBSS change

Ryusuke Konishi (1):
      nilfs2: ensure proper cache clearing for gc-inodes

Sarah Sharp (1):
      xhci: Fix hang on back-to-back Set TR Deq Ptr commands.

Shaohua Li (1):
      raid5: delayed stripe fix

Shinya Kuribayashi (1):
      hwspinlock/core: use global ID to register hwspinlocks on multiple de=
vices

Shuah Khan (1):
      iommu/amd: Fix missing iommu_shutdown initialization in passthrough m=
ode

Stanislav Kinsbursky (4):
      Lockd: pass network namespace to creation and destruction routines
      SUNRPC: new svc_bind() routine introduced
      SUNRPC: move per-net operations from svc_destroy()
      NFS: hard-code init_net for NFS callback transports

Stanislav Yakovlev (1):
      net/wireless: ipw2x00: add supported cipher suites to wiphy initializ=
ation

Stanislaw Gruszka (1):
      rtl8187: ->brightness_set can not sleep

Stanislaw Ledwon (1):
      usb: Add support for root hub port status CAS

Stephen Warren (1):
      ARM: tegra: make tegra_cpu_reset_handler_enable() __init

Steven Rostedt (1):
      powerpc/ftrace: Do not trace restore_interrupts()

Stone Piao (2):
      mwifiex: fix 11n rx packet drop issue
      mwifiex: fix WPS eapol handshake failure

Stuart Hayes (1):
      acpi_pad: fix power_saving thread deadlock

Suresh Jayaraman (1):
      cifs: fix parsing of password mount option

Suresh Siddha (1):
      x86, compat: Use test_thread_flag(TIF_IA32) in compat signal delivery

Takashi Iwai (3):
      ALSA: hda - Fix memory leaks at module unload
      ALSA: hda - Fix power-map regression for HP dv6 & co
      drm/i915: Fix eDP blank screen after S3 resume on HP desktops

Tao Guo (1):
      umem: fix up unplugging

Thomas Graf (2):
      ipv6: fib: Restore NTF_ROUTER exception in fib6_age()
      ipv6: Move ipv6 proc file registration to end of init order

Tom Hughes (1):
      ath9k: fix panic caused by returning a descriptor we have queued for =
reuse

Tomi Valkeinen (1):
      OMAPDSS: use DSI_FIFO_BUG workaround only for manual update displays

Tushar Behera (1):
      dmaengine: pl330: dont complete descriptor for cyclic dma

Tyler Hicks (3):
      eCryptfs: Gracefully refuse miscdev file ops on inherited/passed files
      eCryptfs: Fix lockdep warning in miscdev operations
      eCryptfs: Properly check for O_RDONLY flag before doing privileged op=
en

Vaibhav Nagarnaik (1):
      tracing: change CPU ring buffer state from tracing_cpumask

Will Deacon (1):
      oprofile: perf: use NR_CPUS instead or nr_cpumask_bits for static arr=
ay

Yinghai Lu (1):
      memblock: free allocated memblock_reserved_regions later

Zhang Rui (2):
      ACPI video: Still use ACPI backlight control if _DOS doesn't exist
      ACPI, x86: fix Dell M6600 ACPI reboot regression via DMI

majianpeng (2):
      md/raid5: In ops_run_io, inc nr_pending before calling md_wait_for_bl=
ocked_rdev
      md/raid5: Do not add data_offset before call to is_badblock

stephen hemminger (2):
      sky2: fix checksum bit management on some chips
      bridge: Assign rtnl_link_ops to bridge devices created via ioctl (v2)


--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJQBF1yAAoJEDjbvchgkmk+ocIQAKdHR3YbbRtviUhfvAHGBfrn
GnvumquPpUOqeKESPTT209mN586Z7mqzqfPdvImKVfTstPD22aRe5Rs+JVnMnuEM
dYR2UMvP6LipRuKApe7IOFydJpF4fnQoZ1f08WpWFLYPPjpXGnyzis5bikjwRuex
oWVT1J2mcqID37o/2ECNPG/R/vbrhN84LMhF5m0nWgnMSpsoN4a+bQkAXw6BtwTn
3yVnj7SgS1lpROA8/Vm3Ixm7Qxh3PDv1kfwL239U2/TzmZwukLO2QG8Wo9O0lo1Z
9xa7J5vuAEHOSrvo2x2+SHb+3YYSyc3jdelI2sGUeuEBy3Fm8RfA3LVgXvOiCnGh
W2S3oTccJNTyiU6eTSiDLX2jQ89D65b8HYoJqOjFjVLIOWITxl6WVCH5DdblDfko
jeB/1INDk3mkZj4nIHlssLMOVXk4nCnBYK/8+gME3slUyLUvjZ76JrHZc6CyZgHF
bLnL/JQhvgfguyfRYvyriSOdi1BwKIVCtI8lJ7bxmuY1K/7C3nrhJwvV7Iyhdz7W
b2QeV0AbZq/ReH5/x5fPF4+fpa2kkF/Wp41Bcuxu3pWDUEuESQk28u06PuhL1uho
JpnlF6scQ4M7/u60cD1xB95HiHLmUjK3mZihGzAnF6dfL5A6kfXC40c1/zDeQUAd
U2YqGdUBgMx0sN8nwcl5
=Pw0h
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
