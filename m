Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210Ab1KKUzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 15:55:46 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60007 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758195Ab1KKUzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 15:55:42 -0500
X-Sasl-enc: Jfywoh7KmmWsgz6suEpFHtwgRVAdyeoMG/lmjEjrkpZx 1321044941
Date: Fri, 11 Nov 2011 12:51:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.9
Message-ID: <20111111205132.GA11508@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.9 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at (NOTE THE ADDRESS CHANGE):
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Documentation/hwspinlock.txt                     |   18 --
 Documentation/power/runtime_pm.txt               |   10 +
 Documentation/stable_kernel_rules.txt            |   14 -
 MAINTAINERS                                      |   14 -
 Makefile                                         |    2=20
 arch/arm/mach-ux500/cpu.c                        |   25 +++
 arch/arm/plat-mxc/include/mach/iomux-v3.h        |   10 -
 arch/powerpc/include/asm/sparsemem.h             |    2=20
 arch/powerpc/mm/gup.c                            |   12 -
 arch/powerpc/mm/hash_utils_64.c                  |    6=20
 arch/powerpc/mm/hugetlbpage.c                    |   21 ++
 arch/powerpc/mm/mem.c                            |    3=20
 arch/powerpc/mm/mmu_context_hash64.c             |   12 -
 arch/powerpc/mm/numa.c                           |    3=20
 arch/powerpc/platforms/pseries/dlpar.c           |    4=20
 arch/powerpc/platforms/pseries/eeh.c             |    2=20
 arch/s390/kernel/ptrace.c                        |   28 ++-
 arch/s390/kvm/kvm-s390.c                         |   14 +
 arch/s390/mm/gup.c                               |   14 +
 arch/s390/mm/pgtable.c                           |    5=20
 arch/um/drivers/ubd_kern.c                       |   31 ++++
 arch/x86/include/asm/apic.h                      |    2=20
 arch/x86/include/asm/uv/uv_bau.h                 |    1=20
 arch/x86/include/asm/uv/uv_hub.h                 |   37 ++++-
 arch/x86/kernel/amd_iommu.c                      |    2=20
 arch/x86/kernel/apic/bigsmp_32.c                 |   20 ++
 arch/x86/kernel/apic/probe_32.c                  |   10 -
 arch/x86/kernel/apic/x2apic_uv_x.c               |    7=20
 arch/x86/kernel/kprobes.c                        |    4=20
 arch/x86/mm/gup.c                                |   10 -
 arch/x86/platform/uv/tlb_uv.c                    |   17 --
 block/genhd.c                                    |    8 +
 crypto/cryptd.c                                  |    2=20
 drivers/acpi/atomicio.c                          |    2=20
 drivers/ata/ata_piix.c                           |   37 ++++-
 drivers/base/power/runtime.c                     |   18 ++
 drivers/block/cciss.c                            |    7=20
 drivers/block/xen-blkback/blkback.c              |    2=20
 drivers/bluetooth/ath3k.c                        |    6=20
 drivers/bluetooth/btusb.c                        |   22 ++
 drivers/gpu/drm/i915/intel_dp.c                  |   31 +++-
 drivers/gpu/drm/i915/intel_panel.c               |   21 +-
 drivers/gpu/drm/radeon/atombios_dp.c             |   11 +
 drivers/gpu/drm/radeon/evergreen.c               |    1=20
 drivers/gpu/drm/radeon/r100.c                    |    1=20
 drivers/gpu/drm/radeon/r600.c                    |   19 +-
 drivers/gpu/drm/radeon/radeon.h                  |    1=20
 drivers/gpu/drm/radeon/radeon_combios.c          |    4=20
 drivers/gpu/drm/radeon/radeon_connectors.c       |   29 +++
 drivers/gpu/drm/radeon/radeon_drv.c              |    4=20
 drivers/gpu/drm/radeon/radeon_irq_kms.c          |   48 +++++-
 drivers/gpu/drm/radeon/radeon_mode.h             |    1=20
 drivers/gpu/drm/radeon/rs600.c                   |    1=20
 drivers/hid/Kconfig                              |    3=20
 drivers/hid/hid-apple.c                          |   27 +++
 drivers/hid/hid-core.c                           |   17 ++
 drivers/hid/hid-ids.h                            |   17 ++
 drivers/hid/hid-multitouch.c                     |    5=20
 drivers/hid/usbhid/hid-quirks.c                  |    1=20
 drivers/hwmon/coretemp.c                         |    3=20
 drivers/hwmon/w83627ehf.c                        |   12 +
 drivers/hwspinlock/hwspinlock_core.c             |   45 ++----
 drivers/leds/led-class.c                         |    7=20
 drivers/md/raid5.c                               |    2=20
 drivers/media/dvb/dvb-usb/dib0700_core.c         |   81 +++++++++-
 drivers/media/dvb/frontends/dib0070.c            |   37 ++++-
 drivers/media/dvb/frontends/dib0090.c            |   70 +++++++--
 drivers/media/dvb/frontends/dib7000m.c           |   27 +++
 drivers/media/dvb/frontends/dib7000p.c           |   32 +++-
 drivers/media/dvb/frontends/dib8000.c            |   72 ++++++++-
 drivers/media/dvb/frontends/dib9000.c            |  164 ++++++++++++++++++=
+---
 drivers/media/dvb/frontends/dibx000_common.c     |   76 ++++++++--
 drivers/media/dvb/frontends/dibx000_common.h     |    1=20
 drivers/media/video/cx23885/cx23885-dvb.c        |    2=20
 drivers/media/video/uvc/uvc_driver.c             |    2=20
 drivers/media/video/uvc/uvc_video.c              |   10 +
 drivers/media/video/uvc/uvcvideo.h               |    2=20
 drivers/mmc/core/core.c                          |   10 -
 drivers/mmc/core/core.h                          |    1=20
 drivers/mmc/core/mmc.c                           |    3=20
 drivers/mmc/core/sd.c                            |    1=20
 drivers/mmc/core/sdio.c                          |    1=20
 drivers/mtd/mtdchar.c                            |    1=20
 drivers/mtd/nand/nand_base.c                     |   27 ++-
 drivers/mtd/nand/pxa3xx_nand.c                   |   14 +
 drivers/mtd/redboot.c                            |    3=20
 drivers/net/bonding/bond_main.c                  |    7=20
 drivers/net/enic/enic_main.c                     |    8 -
 drivers/net/macvlan.c                            |    2=20
 drivers/net/netconsole.c                         |    5=20
 drivers/net/phy/dp83640.c                        |    9 +
 drivers/net/rionet.c                             |    4=20
 drivers/net/tg3.c                                |    2=20
 drivers/net/usb/asix.c                           |    7=20
 drivers/net/usb/cdc_ncm.c                        |   47 +++++-
 drivers/net/usb/ipheth.c                         |    5=20
 drivers/net/usb/rtl8150.c                        |    1=20
 drivers/net/wireless/ath/ath9k/ani.c             |    5=20
 drivers/net/wireless/ath/ath9k/ar9003_calib.c    |    3=20
 drivers/net/wireless/ath/ath9k/ar9003_mac.c      |    4=20
 drivers/net/wireless/ath/ath9k/ar9003_phy.h      |   12 -
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h |   10 -
 drivers/net/wireless/ath/ath9k/hif_usb.c         |    1=20
 drivers/net/wireless/ath/ath9k/hw.c              |    4=20
 drivers/net/wireless/ath/ath9k/recv.c            |    5=20
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c     |    9 -
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    2=20
 drivers/net/wireless/iwlwifi/iwl-core.c          |    4=20
 drivers/net/wireless/iwlwifi/iwl-hcmd.c          |    2=20
 drivers/net/wireless/iwlwifi/iwl-rx.c            |    2=20
 drivers/net/wireless/iwlwifi/iwl-tx.c            |    2=20
 drivers/net/wireless/wl12xx/scan.c               |   19 +-
 drivers/net/xen-netback/interface.c              |    4=20
 drivers/pci/quirks.c                             |   28 +--
 drivers/pci/xen-pcifront.c                       |    5=20
 drivers/platform/x86/samsung-laptop.c            |   39 ++++-
 drivers/platform/x86/wmi.c                       |    6=20
 drivers/power/ds2780_battery.c                   |   86 ++++++-----
 drivers/s390/cio/ccwgroup.c                      |   42 ++---
 drivers/scsi/device_handler/scsi_dh.c            |   10 +
 drivers/scsi/hosts.c                             |    9 -
 drivers/scsi/hpsa.c                              |    7=20
 drivers/scsi/ipr.c                               |    2=20
 drivers/scsi/isci/isci.h                         |    2=20
 drivers/scsi/isci/port_config.c                  |    2=20
 drivers/scsi/isci/request.c                      |   49 ++----
 drivers/scsi/isci/request.h                      |    3=20
 drivers/scsi/isci/sas.h                          |    2=20
 drivers/scsi/libsas/sas_expander.c               |    2=20
 drivers/scsi/megaraid/megaraid_sas_base.c        |    3=20
 drivers/scsi/mpt2sas/mpt2sas_scsih.c             |   15 +-
 drivers/scsi/scsi_lib.c                          |    9 +
 drivers/scsi/scsi_scan.c                         |    1=20
 drivers/scsi/st.c                                |    4=20
 drivers/staging/hv/hyperv_storage.h              |    1=20
 drivers/staging/hv/storvsc_drv.c                 |    2=20
 drivers/staging/quatech_usb2/quatech_usb2.c      |    9 -
 drivers/staging/serqt_usb2/serqt_usb2.c          |    3=20
 drivers/target/loopback/tcm_loop.c               |   18 ++
 drivers/target/target_core_alua.c                |   20 ++
 drivers/tty/pty.c                                |   26 ++-
 drivers/tty/serial/crisv10.c                     |    4=20
 drivers/tty/serial/jsm/jsm.h                     |    7=20
 drivers/tty/serial/jsm/jsm_driver.c              |    1=20
 drivers/tty/serial/jsm/jsm_neo.c                 |   29 ++-
 drivers/tty/serial/jsm/jsm_tty.c                 |   94 +-----------
 drivers/tty/serial/pxa.c                         |   20 ++
 drivers/tty/serial/serial_core.c                 |    2=20
 drivers/tty/tty_io.c                             |   48 ++++--
 drivers/usb/class/cdc-acm.c                      |    3=20
 drivers/usb/core/devio.c                         |   27 ++-
 drivers/usb/core/driver.c                        |    7=20
 drivers/usb/core/hcd.c                           |    2=20
 drivers/usb/core/quirks.c                        |   24 +++
 drivers/usb/gadget/printer.c                     |    2=20
 drivers/usb/host/ehci-dbg.c                      |    2=20
 drivers/usb/host/ehci-hcd.c                      |   32 ++++
 drivers/usb/host/ehci-hub.c                      |   12 +
 drivers/usb/host/ehci-pci.c                      |    5=20
 drivers/usb/host/ehci-sched.c                    |   30 +++-
 drivers/usb/host/ehci.h                          |   17 ++
 drivers/usb/host/fhci-sched.c                    |   19 ++
 drivers/usb/host/isp1760-hcd.c                   |    3=20
 drivers/usb/host/ohci-hub.c                      |    5=20
 drivers/usb/host/xhci-hub.c                      |   22 ++
 drivers/usb/host/xhci-mem.c                      |   54 ++++---
 drivers/usb/host/xhci-pci.c                      |    3=20
 drivers/usb/host/xhci-ring.c                     |   82 +++++++----
 drivers/usb/host/xhci.c                          |    6=20
 drivers/usb/host/xhci.h                          |    3=20
 drivers/usb/mon/mon_bin.c                        |    2=20
 drivers/usb/serial/ftdi_sio.c                    |    5=20
 drivers/usb/serial/ftdi_sio_ids.h                |   13 +
 drivers/usb/serial/option.c                      |  170 ++++++++++++++----=
-----
 drivers/usb/serial/pl2303.c                      |    1=20
 drivers/usb/serial/pl2303.h                      |    5=20
 drivers/usb/serial/qcserial.c                    |    3=20
 drivers/usb/storage/transport.c                  |   34 ++--
 drivers/usb/storage/usb.c                        |   16 +-
 drivers/video/carminefb.c                        |    6=20
 drivers/video/fbmem.c                            |    3=20
 drivers/video/fbsysfs.c                          |    3=20
 drivers/video/sh_mobile_hdmi.c                   |   47 +++---
 drivers/video/via/via_modesetting.h              |    5=20
 drivers/video/via/viafbdev.c                     |   16 +-
 drivers/w1/slaves/w1_ds2780.c                    |   48 ++++--
 drivers/w1/slaves/w1_ds2780.h                    |    2=20
 drivers/xen/events.c                             |    2=20
 drivers/xen/swiotlb-xen.c                        |    7=20
 fs/binfmt_elf.c                                  |   11 +
 fs/block_dev.c                                   |   13 +
 fs/cifs/connect.c                                |    4=20
 fs/cifs/inode.c                                  |   19 +-
 fs/eventpoll.c                                   |   25 ++-
 fs/ext4/ext4.h                                   |    4=20
 fs/ext4/inode.c                                  |    3=20
 fs/ext4/namei.c                                  |    8 -
 fs/ext4/page-io.c                                |   18 ++
 fs/ext4/xattr.c                                  |    6=20
 fs/hppfs/hppfs.c                                 |    1=20
 fs/namei.c                                       |   55 +++++--
 fs/namespace.c                                   |    3=20
 fs/nfs/super.c                                   |    2=20
 fs/nfs/write.c                                   |   43 ++---
 fs/nfsd/nfs4proc.c                               |    6=20
 fs/nfsd/nfs4recover.c                            |    2=20
 fs/nfsd/nfs4state.c                              |   30 ++--
 fs/nfsd/nfs4xdr.c                                |   12 +
 fs/nfsd/state.h                                  |    6=20
 fs/nfsd/vfs.c                                    |    3=20
 fs/nfsd/vfs.h                                    |    1=20
 fs/proc/base.c                                   |   10 +
 fs/proc/task_mmu.c                               |    3=20
 fs/quota/quota.c                                 |    2=20
 fs/stat.c                                        |    5=20
 fs/statfs.c                                      |    2=20
 include/drm/drm_dp_helper.h                      |    3=20
 include/linux/ext2_fs.h                          |    4=20
 include/linux/ext3_fs.h                          |    4=20
 include/linux/interrupt.h                        |    3=20
 include/linux/io-mapping.h                       |    4=20
 include/linux/jiffies.h                          |    2=20
 include/linux/mm.h                               |   67 ++++-----
 include/linux/mm_types.h                         |   22 ++
 include/linux/namei.h                            |    2=20
 include/linux/phy.h                              |    2=20
 include/linux/skbuff.h                           |    7=20
 include/linux/tty.h                              |    4=20
 include/linux/usb/hcd.h                          |    2=20
 include/linux/vmalloc.h                          |    1=20
 include/net/flow.h                               |   25 ++-
 kernel/irq/pm.c                                  |   48 +++++-
 kernel/kmod.c                                    |    4=20
 kernel/power/suspend.c                           |    2=20
 kernel/signal.c                                  |    4=20
 kernel/time.c                                    |    2=20
 kernel/trace/trace.c                             |    4=20
 lib/kobject_uevent.c                             |    2=20
 lib/nlattr.c                                     |    1=20
 mm/huge_memory.c                                 |   37 +++--
 mm/internal.h                                    |   46 ++++++
 mm/memory.c                                      |    2=20
 mm/swap.c                                        |   83 +++++++----
 mm/vmalloc.c                                     |   65 ++++++--
 net/bridge/br_device.c                           |    3=20
 net/bridge/br_if.c                               |    9 -
 net/bridge/br_netlink.c                          |    1=20
 net/bridge/br_private.h                          |    1=20
 net/caif/caif_dev.c                              |    5=20
 net/can/bcm.c                                    |   53 +++----
 net/core/dev.c                                   |    1=20
 net/core/flow.c                                  |   31 ++--
 net/core/sock.c                                  |    1=20
 net/core/timestamping.c                          |   12 +
 net/ipv4/tcp_input.c                             |    4=20
 net/ipv4/tcp_ipv4.c                              |   11 -
 net/ipv4/xfrm4_policy.c                          |   14 -
 net/ipv6/tcp_ipv6.c                              |   11 +
 net/l2tp/l2tp_core.c                             |    4=20
 net/mac80211/cfg.c                               |    2=20
 net/mac80211/ieee80211_i.h                       |    2=20
 net/mac80211/mlme.c                              |   18 ++
 net/mac80211/status.c                            |    2=20
 net/mac80211/work.c                              |    9 -
 net/packet/af_packet.c                           |    5=20
 net/sunrpc/auth_unix.c                           |    3=20
 scripts/kconfig/menu.c                           |    7=20
 sound/pci/hda/patch_conexant.c                   |   30 +++-
 sound/pci/hda/patch_realtek.c                    |   14 +
 sound/pci/hda/patch_sigmatel.c                   |   56 ++-----
 sound/soc/codecs/ak4535.c                        |   10 -
 sound/soc/codecs/ak4642.c                        |   22 +-
 sound/soc/codecs/wm8711.c                        |    4=20
 sound/soc/codecs/wm8741.c                        |    4=20
 sound/soc/codecs/wm8904.c                        |    2=20
 sound/soc/codecs/wm8940.c                        |    2=20
 sound/soc/codecs/wm8962.c                        |   38 +++--
 sound/soc/codecs/wm8994.c                        |    2=20
 sound/usb/misc/ua101.c                           |   28 ++-
 tools/perf/util/probe-event.c                    |    4=20
 280 files changed, 2891 insertions(+), 1238 deletions(-)

Adam Radford (1):
      megaraid_sas: Fix instance access in megasas_reset_timer

Al Viro (2):
      hppfs: missing include
      VFS: we need to set LOOKUP_JUMPED on mountpoint crossing

Alan Stern (3):
      EHCI: workaround for MosChip controller bug
      PM / Runtime: Automatically retry failed autosuspends
      USB: Update last_busy time after autosuspend fails

Alex Deucher (8):
      drm/radeon/kms: bail early in dvi_detect for digital only connectors
      drm/radeon/kms: handle !force case in connector detect more gracefully
      drm/radeon/kms: split MSI check into a separate function
      drm/radeon/kms: Add MSI quirk for HP RS690
      drm/radeon/kms: properly set panel mode for eDP
      drm/radeon/kms: Add MSI quirk for Dell RS690
      drm/radeon/kms: add MSI module parameter
      drm/radeon/kms: set HPD polarity in hpd_init()

Alexandre Bounine (1):
      drivers/net/rionet.c: fix ethernet address macros for LE platforms

Andiry Xu (4):
      xHCI: AMD isoc link TRB chain bit quirk
      USB: xHCI: prevent infinite loop when processing MSE event
      xHCI: test and clear RWC bit
      xHCI: Clear PLC for USB2 root hub ports

Andrea Arcangeli (9):
      mm: thp: tail page refcounting fix
      powerpc: remove superfluous PageTail checks on the pte gup_fast
      powerpc: get_hugepte() don't put_page() the wrong page
      powerpc: gup_hugepte() avoid freeing the head page too many times
      powerpc: gup_hugepte() support THP based tail recounting
      powerpc: gup_huge_pmd() return 0 if pte changes
      s390: gup_huge_pmd() support THP tail recounting
      s390: gup_huge_pmd() return 0 if pte changes
      thp: share get_huge_page_tail()

Andreas Krist (1):
      HID: hid-apple: add device ID of another wireless aluminium

Andrei Warkentin (1):
      mmc: core: ext_csd.raw_* used in comparison but never set

Andres Salomon (1):
      mtd: provide an alias for the redboot module name

Andrew Morton (1):
      /proc/self/numa_maps: restore "huge" tag for hugetlb vmas

Andy Whitcroft (1):
      readlinkat: ensure we return ENOENT for the empty pathname for normal=
 lookups

Anton Blanchard (6):
      ipr: Always initiate hard reset in kdump kernel
      Fix block queue and elevator memory leak in scsi_alloc_sdev
      powerpc/numa: Remove double of_node_put in hot_add_node_scn_to_nid
      powerpc: Fix oops when echoing bad values to /sys/devices/system/memo=
ry/probe
      powerpc/pseries: Avoid spurious error during hotplug CPU add
      powerpc: Fix deadlock in icswx code

Antonio Ospite (2):
      leds: save the delay values after a successful call to blink_set()
      leds: turn the blink_timer off before starting to blink

Artur Zimmer (1):
      USB: Serial: Add PID(0xF7C0) to FTDI SIO driver for a zeitcontrol-dev=
ice

Arvid Brodin (1):
      usb/isp1760: Added missing call to usb_hcd_check_unlink_urb() during =
unlink

Axel Lin (6):
      ASoC: wm8940: Properly set codec->dapm.bias_level
      ASoC: wm8741: Fix setting interface format for DSP modes
      ASoC: ak4535: fixup cache register table
      ASoC: wm8994: Use SND_SOC_DAPM_AIF_OUT for AIF3 Capture
      ASoC: wm8711: Fix wrong mask for setting input audio data bit length =
select
      ASoC: Leave input audio data bit length settings untouched in wm8711_=
set_dai_fmt

Bart Van Assche (1):
      Make scsi_free_queue() kill pending SCSI commands

Bernd Schubert (1):
      nfsd4: Remove check for a 32-bit cookie in nfsd4_readdir()

Bill Pemberton (1):
      staging: serqt_usb2: remove ssu100 from supported devices

Boris Todorov (1):
      USB: EHCI: Fix test mode sequence

Bruno Pr=E9mont (1):
      fb: sh-mobile: Fix deadlock risk between lock_fb_info() and console_l=
ock()

Bryan Schumaker (1):
      vfs: add "device" tag to /proc/self/mountstats

Carsten Otte (1):
      KVM: s390: check cpu_id prior to using it

Charles Chin (3):
      ALSA: hda - Remove bad code for IDT 92HD83 family patch
      ALSA: hda - Disable power-widget control for IDT 92HD83/93 as default
      ALSA: hda - Add support for 92HD65 / 92HD66 family of codecs

Clemens Ladisch (1):
      ALSA: ua101: fix crash when unplugging

Clemens Werther (1):
      HID: add support for HuiJia USB Gamepad connector

Clifton Barnes (3):
      drivers/power/ds2780_battery.c: create central point for calling w1 i=
nterface
      drivers/power/ds2780_battery.c: add a nolock function to w1 interface
      drivers/power/ds2780_battery.c: fix deadlock upon insertion and remov=
al

Dan Bastone (1):
      HID: add support for new revision of Apple aluminum keyboard

Dan Carpenter (1):
      PM / Suspend: Off by one in pm_suspend()

Dan McGee (1):
      VFS: fix statfs() automounter semantics regression

Dan Williams (5):
      isci: fix support for large smp requests
      USB: option: convert interface blacklisting to bitfields
      USB: option: convert Huawei K3765, K4505, K4605 reservered interface =
to blacklist
      USB: option: add ZTE product 0x0037 to sendsetup blacklist
      USB: option: add various ZTE device network interfaces to the blackli=
st

Daniel Mack (1):
      mtd: pxa3xx_nand: Fix blank page ECC mismatch

Daniel Vetter (1):
      io-mapping: ensure io_mapping_map_atomic _is_ atomic

Darrick J. Wong (2):
      ext4: ext4_rename should dirty dir_bh with the correct directory
      ext4: ext4_mkdir should dirty dir_block with newly created directory =
inode

David Henningsson (1):
      ALSA: HDA: Add new revision for ALC662

David Herrmann (1):
      Platform: Fix error path in samsung-laptop init

David Howells (1):
      VFS: Fix automount for negative autofs dentries

David Vrabel (1):
      net: xen-netback: correctly restart Tx after a VM restore/migrate

David Ward (2):
      macvlan/macvtap: Fix unicast between macvtap interfaces in bridge mode
      net: Align AF-specific flowi structs to long

David Woodhouse (1):
      caif: Fix BUG() with network namespaces

Denis Pershin (1):
      usb: cdc-acm: Owen SI-30 support

Dmitry Torokhov (1):
      WMI: properly cleanup devices to avoid crashes

Eliad Peller (2):
      mac80211: fix remain_off_channel regression
      mac80211: config hw when going back on-channel

Eric Benoit (1):
      USB: pl2303: add id for SMART device

Eric Dumazet (1):
      l2tp: fix a potential skb leak in l2tp_xmit_skb()

Eric Sandeen (1):
      ext4: fix race in xattr block allocation path

Eric W. Biederman (1):
      rtnetlink: Add missing manual netlink notification in dev_change_net_=
namespaces

Fabian Godehardt (1):
      USB: g_printer: fix bug in unregistration

Felix Fietkau (1):
      ath9k: disable unnecessary PHY error reporting

Florian Echtler (1):
      USB: Serial: Add device ID for Sierra Wireless MC8305

Florian Tobias Schandinat (2):
      viafb: use display information in info not in var for panning
      viafb: improve pitch handling

Gao feng (1):
      netconsole: enable netconsole can make net_device refcnt incorrent

Greg Kroah-Hartman (1):
      Linux 3.0.9

Guenter Roeck (1):
      hwmon: (w83627ehf) Fix broken driver init

G=F6k=E7en Eraslan (1):
      HID: Add device IDs for Macbook Pro 8 keyboards

Hakan Kvist (1):
      USB: ftdi_sio: add PID for Sony Ericsson Urban

Harro Haan (1):
      USB: fix ehci alignment error

Herbert Xu (1):
      crypto: cryptd - Use subsys_initcall to prevent races with aesni

Herton Ronaldo Krzesinski (1):
      fb: avoid possible deadlock caused by fb_set_suspend

Hong Xu (1):
      ASoC: WM8904: Set `invert' bit for Capture Switch

Ian Campbell (1):
      genirq: Add IRQF_RESUME_EARLY and resume such IRQs earlier

J. Bruce Fields (5):
      nfsd4: stop using nfserr_resource for transitory errors
      nfsd4: fix seqid_mutating_error
      nfsd4: permit read opens of executable-only files
      nfsd4: fix open downgrade, again
      nfsd4: ignore WANT bits in open downgrade

Jack Steiner (1):
      x86: uv2: Workaround for UV2 Hub bug (system global address format)

Jack Wang (1):
      libsas: set sas_address and device type of rphy

Jan Beulich (1):
      apic, i386/bigsmp: Fix false warnings regarding logical APIC ID misma=
tches

Jason Stubbs (1):
      platform: samsung_laptop: fix samsung brightness min/max calculations

Jean Delvare (4):
      drm/radeon/kms: Fix I2C mask definitions
      carminefb: Fix module parameters permissions
      hwmon: (coretemp) Fix for non-SMP builds
      hwmon: (w83627ehf) Properly report PECI and AMD-SI sensor types

Jeff Brown (1):
      HID: hid-multitouch: Add LG Display Multitouch device.

Jeff Layton (2):
      nfs: don't redirty inode when ncommit =3D=3D 0 in nfs_commit_unstable=
_pages
      nfs: don't try to migrate pages with active requests

Jeff Skirvin (1):
      isci: fix missed unlock in apc_agent_timeout()

Jerome Glisse (2):
      drm/radeon: avoid bouncing connector status btw disconnected & unknown
      drm/radeon: set hpd polarity at init time so hotplug detect works

Jerry Huang (1):
      QE/FHCI: fixed the CONTROL bug

Jiaying Zhang (1):
      ext4: remove i_mutex lock in ext4_evict_inode to fix lockdep complain=
ing

Jim Wylder (1):
      USB: for usb_autopm_get_interface_async -EINPROGRESS is not an error

Jiri Kosina (4):
      kmod: prevent kmod_loop_msg overflow in __request_module()
      binfmt_elf: fix PIE execution with randomization disabled
      HID: add MacBookAir4,2 to hid_have_special_driver[]
      HID: consolidate MacbookAir 4,1 mappings

Jiri Pirko (1):
      tg3: negate USE_PHYLIB flag check

Jiri Slaby (3):
      TTY: drop driver reference in tty_open fail path
      TTY: make tty_add_file non-failing
      TTY: pty, release tty in all ptmx_open fail paths

Joerg Roedel (1):
      iommu/amd: Fix wrong shift direction

Johannes Berg (4):
      mac80211: fix offchannel TX cookie matching
      iwlagn: do not use interruptible waits
      netlink: validate NLA_MSECS length
      mac80211: disable powersave for broken APs

Johannes Stezenbach (1):
      usbmon vs. tcpdump: fix dropped packet count

Jon Levell (1):
      USB: add quirk for Logitech C300 web cam

Josh Boyer (3):
      PCI quirk: mmc: Always check for lower base frequency quirk for Ricoh=
 1180:e823
      Update email address for stable patch submission
      usbnet/cdc_ncm: Don't use stack variables for DMA

Josh Stone (1):
      x86: Fix compilation bug in kprobes' twobyte_is_boostable

Joshua V. Dillon (1):
      HID: add support for MacBookAir4,2 keyboard.

Juan Gutierrez (1):
      hwspinlock/core: use a mutex to protect the radix tree

Jurgen Kramer (1):
      Bluetooth: add support for 2011 mac mini

Kautuk Consul (2):
      staging: quatech_usb2: Potential lost wakeup scenario in TIOCMIWAIT
      xhci-mem.c: Check for ring->first_seg !=3D NULL

Kavan Smith (1):
      ipheth: iPhone 4 Verizon CDMA USB Product ID add

Keith Packard (1):
      drm/i915: Wrap DP EDID fetch functions to enable eDP panel power

Konrad Rzeszutek Wilk (3):
      xen-pcifront: Update warning comment to use 'e820_host' option.
      xen-swiotlb: Fix wrong panic.
      xen/blkback: Report VBD_WSECT (wr_sect) properly.

Kuninori Morimoto (1):
      ASoC: ak4642: fixup cache register table

Lei Wen (1):
      mtd: pxa3xx_nand: fix nand detection issue

Linus Torvalds (3):
      vfs pathname lookup: Add LOOKUP_AUTOMOUNT flag
      vfs: show O_CLOEXE bit properly in /proc/<pid>/fdinfo/<fd> files
      hid/apple: modern macbook airs use the standard apple function key tr=
anslations

Linus Walleij (1):
      ARM: mach-ux500: unlock I&D l2x0 caches before init

Luben Tuikov (1):
      USB: storage: Use normalized sense when emulating autosense

Luciano Coelho (1):
      wl12xx: fix forced passive scans

Luis R. Rodriguez (2):
      MAINTANERS: update Qualcomm Atheros addresses
      ath9k_htc: add AVM FRITZ!WLAN 11N v2 support

Marcus Folkesson (1):
      serial: pxa: work around for errata #20

Marek Vasut (2):
      ASIX: Simplify condition in rx_fixup()
      ASIX: Use only 11 bits of header for data size

Mark Brown (3):
      ASoC: Remove direct register cache accesses from WM8962 driver
      ASoC: Ensure WM8962 PLL registers are reset
      ASoC: Ensure the WM8962 oscillator and PLLs start up disabled

Martin Schwidefsky (2):
      user per registers vs. ptrace single stepping
      memory leak with RCU_TABLE_FREE

Masami Hiramatsu (1):
      perf probe: Fix to show correct error string

Matthew Garrett (1):
      USB: Fix runtime wakeup on OHCI

Matthias Dellweg (1):
      usb/core/devio.c: Check for printer class specific request

Matthieu CASTET (1):
      EHCI : introduce a common ehci_setup

Mauro Carvalho Chehab (1):
      tuner_xc2028: Allow selection of the frequency adjustment code for XC=
3028

Mike Miller (2):
      cciss: add small delay when using PCI Power Management to reset for k=
ump
      hpsa: add small delay when using PCI Power Management to reset for ku=
mp

Mike Sterling (1):
      Staging: hv: Add support for >2 TB LUN in storage driver.

Miklos Szeredi (1):
      vfs: automount should ignore LOOKUP_FOLLOW

Milan Broz (1):
      kobj_uevent: Ignore if some listeners cannot handle message

Ming Lei (2):
      ata_piix: make DVD Drive recognisable on systems with Intel Sandybrid=
ge chipsets(v2)
      uvcvideo: Set alternate setting 0 on resume if the bus has been reset

Mitsuo Hayasaka (2):
      mm: avoid null pointer access in vm_struct via /proc/vmallocinfo
      bonding: use local function pointer of bond->recv_probe in bond_handl=
e_frame

Moger, Babu (1):
      scsi_dh: check queuedata pointer before proceeding further

Mohammed Shafi Shajakhan (1):
      ath9k_hw: Fix number of GPIO pins for AR9287/9300

NeilBrown (2):
      md/raid5: fix bug that could result in reads from a failed device.
      NFS/sunrpc: don't use a credential with extra groups.

Nelson Elhage (1):
      epoll: fix spurious lockdep warnings

Nicholas Bellinger (2):
      target: Fix REPORT TARGET PORT GROUPS handling with small allocation =
length
      tcm_loop: Add explict read buffer memset for SCF_SCSI_CONTROL_SG_IO_C=
DB

Ning Jiang (1):
      serial-core: power up uart port early before we do set_termios when r=
esuming

Nobuhiro Iwamatsu (1):
      HID: Add support MacbookAir 4,1 keyboard

Oleg Nesterov (1):
      ptrace: don't clear GROUP_STOP_SIGMASK on double-stop

Oliver Hartkopp (2):
      can bcm: fix tx_setup off-by-one errors
      can bcm: fix incomplete tx_setup fix

Oliver Neukum (2):
      USB: add RESET_RESUME for webcams shown to be quirky
      btusb: add device entry for Broadcom SoftSailing

Olivier Grenie (1):
      dib0700: protect the dib0700 buffer access

Patrick Boettcher (1):
      DiBcom: protect the I2C bufer access

Paul Fertser (1):
      plat-mxc: iomux-v3.h: implicitly enable pull-up/down when that's desi=
red

Pavel Shilovsky (2):
      CIFS: Fix incorrect max RFC1002 write size value
      CIFS: Fix DFS handling in cifs_get_file_info

Peter Stuge (1):
      USB: ftdi_sio: Support TI/Luminary Micro Stellaris BD-ICDI Board

Peter Wippich (1):
      mtd: mtdchar: add missing initializer on raw write

Petr Uzel (1):
      st: fix race in st_scsi_execute_end

Pieter-Augustijn Van Malleghem (1):
      Bluetooth: Add MacBookAir4,1 support

Rajkumar Manoharan (4):
      ath9k_hw: Fix descriptor status of TxOpExceeded
      ath9k_hw: Fix magnitude/phase coeff correction
      ath9k_hw: Update AR9485 initvals to fix system hang issue
      ath9k_hw: Fix regression of register offset for AR9003 chips

Ricardo Mendoza (1):
      Bluetooth: Add Toshiba laptops AR30XX device ID

Richard Cochran (3):
      dp83640: free packet queues on remove
      net: hold sock reference while processing tx timestamps
      dp83640: use proper function to free transmit time stamping packets

Richard Hartmann (1):
      USB: qcserial: Add support for Sierra Wireless MC8355/Gobi 3000

Richard Weinberger (1):
      um: fix ubd cow size

Rigbert Hamisch (1):
      USB: qcserial: add device ID for "HP un2430 Mobile Broadband Module"

Sarah Sharp (2):
      USB: Avoid NULL pointer deref in usb_hcd_alloc_bandwidth.
      xhci: If no endpoints changed, don't issue BW command.

Sebastian Ott (1):
      ccwgroup: move attributes to attribute group

Serge Hallyn (1):
      USB: pid_ns: ensure pid is not freed during kill_pid_info_as_uid

Sergei Kolzun (1):
      HID: ACRUX - fix enabling force feedback support

Seth Forshee (1):
      usb_storage: Don't freeze in usb-stor-scan

Smelov Andrey (1):
      Platform: samsung_laptop: samsung backlight for R528/R728

Srinivas Kandagatla (1):
      kbuild: Fix help text not displayed in choice option.

Stefan Beller (1):
      platform: samsung_laptop: add dmi information for Samsung R700 laptops

Steven Rostedt (1):
      tracing: Fix returning of duplicate data after EOF in trace_pipe_raw

Steven.Li (1):
      Bluetooth: Add Atheros AR3012 one PID/VID supported

Susan Gao (1):
      ASoC: Fix a bug in WM8962 DSP_A and DSP_B settings

THOMSON, Adam (Adam) (1):
      mtd: nand_base: always initialise oob_poi before writing OOB data

Takashi Iwai (3):
      drm/i915/panel: Always record the backlight level again (but cleverly)
      ALSA: hda - Fix ADC input-amp handling for Cx20549 codec
      ALSA: hda/realtek - Skip invalid digital out pins

Tejun Heo (1):
      block: make gendisk hold a reference to its queue

Thadeu Lima de Souza Cascardo (2):
      jsm: remove buggy write queue
      powerpc/eeh: Fix /proc/ppc64/eeh creation

Theodore Ts'o (2):
      ext2,ext3,ext4: don't inherit APPEND_FL or IMMUTABLE_FL for new inodes
      ext4: call ext4_handle_dirty_metadata with correct inode in ext4_dx_a=
dd_entry

Thomas Gleixner (1):
      net: Unlock sock before calling sk_free()

Tommaso Massimi (1):
      Platform: samsung_laptop: add support for X520 machines.

Tony Luck (1):
      ACPI atomicio: Convert width in bits to bytes in __acpi_ioremap_fast()

Trond Myklebust (2):
      Revert "NFS: Ensure that writeback_single_inode() calls write_inode()=
 when syncing"
      VFS: Fix the remaining automounter semantics regressions

Ulf Hansson (1):
      mmc: core: Fix hangs related to insert/remove of cards

Vasanthy Kolluri (1):
      enic: Bug Fix: Fix hardware transmit queue indexing in enic_poll_cont=
roller

WANG Cong (1):
      cris: fix a build error in drivers/tty/serial/crisv10.c

Willem de Bruijn (1):
      make PACKET_STATISTICS getsockopt report consistently between ring an=
d non-ring

Yan, Zheng (4):
      ipv4: fix ipsec forward performance regression
      tcp: properly handle md5sig_pool references
      tcp: properly update lost_cnt_hint during shifting
      ipv6: nullify ipv6_ac_list and ipv6_fl_list when creating new socket

dpward (1):
      net: Handle different key sizes between address families in flow cache

hank (1):
      time: Change jiffies_to_clock_t() argument type to unsigned long

huajun li (1):
      rtl8150: rtl8150_disconnect(...) does not need tasklet_disable(...)

nagalakshmi.nandigama@lsi.com (1):
      mpt2sas: Fix for system hang when discovery in progress

stephen hemminger (2):
      bridge: fix hang on removal of bridge via netlink
      bridge: leave carrier on for empty bridge


--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJOvYrUAAoJEDjbvchgkmk+wgkP/3JUeVkaVsvccxQQ2QRrXSMz
1vW5QGnjYT/ppJp55bVPkeAWVqSYMgxMAcJzCN9z5yDP3QxIK3XaN34lfZgdtrzN
8AzDR35x7ed/5OR5PlHt6/VumwRBCz0W7n+WksvObXt4nE1aWB7Fx+Q+e1jclHSP
wK/gaKuQgWcq3z6deOvr1UgTk3iHOgixtoJ3LGUb5Zu7Frbrn+G7QB9gfqbA/hyU
GkD+/pbsGPclZhXxoAwKUzmfjsHTWCfyAR2bSfJbvXDcl0gfbDdEEkYkn/IHmg8Q
Wy4HxXMIYCPqkyVsEU6QiApvkNsoaiuXGjek1oV7BAZDi8UgAQK1Yr28zN38iMwZ
HuRHbzOY2MEM8+xAvgYCLRxyLNpDxuCyugaU2Kg9ScBBCe6MqJaJx2vcKhYSe+WI
z6UA4cAZF3254CVSA2BbjrWh+3uPNmh9Qsqfp6hojKnNEMvmdVKz5tzDLg3z46B6
Xd9TOUKKgut7K2UrCP0fcmDNyGxVrX40wCf6AKU6+gIUP8nCc2X6eFdWPOuPunei
cC2xK5M5PpimVjMS5d1mm4TfSBlwXTtP/tHzhfaTn7UlEGRQJd+lscJ09Gk3vS9K
Sc4fKs2MWTqmCYN/07Ye0lt0nT7GkCS+/SRQJ4sWVi5TKCNToSXfVMnRNmebn4so
cF9xAgXoGeR/34lAFpbD
=7ow8
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
