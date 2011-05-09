Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab1EIXO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 19:14:28 -0400
Received: from kroah.org ([198.145.64.141]:43788 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab1EIXO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 19:14:26 -0400
Date: Mon, 9 May 2011 16:12:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.40
Message-ID: <20110509231229.GA2908@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.40 kernel.

All users of the 2.6.32 series must upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/sound/alsa/HD-Audio-Models.txt |    1 
 Documentation/usb/proc_usb_info.txt          |   34 +++--
 Makefile                                     |    2 
 arch/arm/kernel/sys_oabi-compat.c            |    2 
 arch/m68k/mm/motorola.c                      |    2 
 arch/mips/mm/dma-default.c                   |   28 +++-
 arch/parisc/mm/init.c                        |    4 
 arch/powerpc/boot/Makefile                   |    2 
 arch/x86/include/asm/kvm_host.h              |    3 
 arch/x86/include/asm/pvclock.h               |   38 ++++++
 arch/x86/kernel/cpu/amd.c                    |    2 
 arch/x86/kernel/pvclock.c                    |    3 
 arch/x86/kvm/x86.c                           |   48 +++++++-
 block/blk-sysfs.c                            |    4 
 drivers/ata/libata-scsi.c                    |   24 +++-
 drivers/ata/sata_via.c                       |   15 ++
 drivers/bluetooth/btusb.c                    |    9 +
 drivers/char/agp/generic.c                   |   19 ++-
 drivers/char/i8k.c                           |    7 -
 drivers/gpu/drm/radeon/atom.c                |    6 -
 drivers/hid/hid-apple.c                      |   46 +++++++
 drivers/hid/hid-core.c                       |   12 ++
 drivers/hid/hid-ids.h                        |    6 +
 drivers/hwmon/applesmc.c                     |   66 +++++++++++
 drivers/input/mouse/elantech.c               |  142 +++++++++++++++--------
 drivers/input/mouse/elantech.h               |    8 -
 drivers/input/mouse/synaptics.c              |   35 +++++
 drivers/input/mouse/synaptics.h              |    4 
 drivers/input/xen-kbdfront.c                 |   12 +-
 drivers/media/dvb/b2c2/flexcop-pci.c         |    2 
 drivers/media/dvb/dvb-usb/dib0700_devices.c  |   46 +++++++
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h      |    1 
 drivers/mmc/core/core.c                      |   81 +++++++++----
 drivers/mmc/core/host.c                      |    6 +
 drivers/mmc/host/sdhci-pci.c                 |    1 
 drivers/mmc/host/sdhci.c                     |    9 +
 drivers/net/atl1c/atl1c_main.c               |    2 
 drivers/net/bnx2x_main.c                     |   27 ++--
 drivers/net/bonding/bond_3ad.c               |    4 
 drivers/net/bonding/bond_alb.c               |    4 
 drivers/net/bonding/bond_main.c              |    4 
 drivers/net/cxgb3/common.h                   |    8 -
 drivers/net/cxgb3/cxgb3_main.c               |   25 ++--
 drivers/net/e1000/e1000_main.c               |  162 +++++++++++++++------------
 drivers/net/e1000e/ich8lan.c                 |   11 +
 drivers/net/igbvf/igbvf.h                    |    1 
 drivers/net/ipg.c                            |    4 
 drivers/net/myri10ge/myri10ge.c              |    4 
 drivers/net/netx-eth.c                       |    3 
 drivers/net/netxen/netxen_nic.h              |    6 +
 drivers/net/netxen/netxen_nic_init.c         |    6 -
 drivers/net/netxen/netxen_nic_main.c         |    4 
 drivers/net/niu.c                            |   17 +-
 drivers/net/pcmcia/pcnet_cs.c                |    7 +
 drivers/net/pppol2tp.c                       |    3 
 drivers/net/spider_net.c                     |    1 
 drivers/net/tehuti.c                         |    4 
 drivers/net/tokenring/tms380tr.c             |    2 
 drivers/net/tulip/tulip_core.c               |    1 
 drivers/net/virtio_net.c                     |   48 ++++----
 drivers/net/wireless/ath/regd_common.h       |    1 
 drivers/net/wireless/b43/sdio.c              |    3 
 drivers/net/wireless/iwlwifi/iwl-5000.c      |    2 
 drivers/net/wireless/iwlwifi/iwl-tx.c        |    8 +
 drivers/net/wireless/p54/txrx.c              |    2 
 drivers/net/wireless/rt2x00/rt2400pci.c      |    2 
 drivers/net/wireless/rt2x00/rt2500pci.c      |    3 
 drivers/net/wireless/rt2x00/rt2500usb.c      |   13 +-
 drivers/net/wireless/rt2x00/rt2800usb.c      |    2 
 drivers/net/wireless/rt2x00/rt2x00.h         |    7 +
 drivers/net/wireless/rt2x00/rt2x00dev.c      |   15 ++
 drivers/net/wireless/rt2x00/rt2x00queue.c    |    6 -
 drivers/net/wireless/rt2x00/rt61pci.c        |    2 
 drivers/net/wireless/rt2x00/rt73usb.c        |    2 
 drivers/pci/intel-iommu.c                    |   23 +++
 drivers/platform/x86/dell-laptop.c           |   15 ++
 drivers/s390/block/dasd_eckd.c               |    2 
 drivers/scsi/device_handler/scsi_dh_emc.c    |    8 -
 drivers/scsi/mpt2sas/mpt2sas_ctl.c           |   23 +++
 drivers/scsi/mpt2sas/mpt2sas_scsih.c         |    4 
 drivers/scsi/pmcraid.c                       |    3 
 drivers/scsi/scsi_lib.c                      |    7 +
 drivers/scsi/scsi_sysfs.c                    |   16 +-
 drivers/serial/imx.c                         |    3 
 drivers/staging/rtl8192su/r8192S_firmware.c  |    5 
 drivers/staging/rtl8192su/r8192U_core.c      |  120 +++++++++++++++-----
 drivers/staging/rtl8192su/r819xU_cmdpkt.c    |    6 +
 drivers/staging/usbip/vhci_hcd.c             |    2 
 drivers/usb/core/devices.c                   |   10 +
 drivers/usb/core/hub.c                       |   15 +-
 drivers/usb/musb/musb_core.c                 |    1 
 drivers/video/backlight/mbp_nvidia_bl.c      |   18 +++
 fs/btrfs/volumes.c                           |    4 
 fs/cifs/inode.c                              |   12 +-
 fs/gfs2/quota.c                              |  132 +++++++++++-----------
 fs/nfs/inode.c                               |   26 ++--
 fs/nfs/nfs4proc.c                            |   43 ++++++-
 fs/nfs/nfs4state.c                           |    4 
 fs/nfs/super.c                               |    9 +
 fs/nfsd/vfs.c                                |    9 +
 fs/partitions/ldm.c                          |   16 ++
 fs/partitions/osf.c                          |   12 +-
 fs/ubifs/recovery.c                          |   26 ++++
 include/linux/mmc/host.h                     |    3 
 include/net/af_unix.h                        |    2 
 include/net/mac80211.h                       |    6 +
 init/Kconfig                                 |    1 
 init/main.c                                  |   12 ++
 net/can/bcm.c                                |    7 +
 net/can/raw.c                                |    7 +
 net/econet/af_econet.c                       |   62 +++++-----
 net/ipv4/ip_output.c                         |    9 +
 net/ipv6/addrconf.c                          |    3 
 net/mac80211/main.c                          |    2 
 net/phonet/pn_dev.c                          |    3 
 net/sunrpc/xprtsock.c                        |   28 +++-
 net/unix/af_unix.c                           |   53 +++++++-
 net/unix/garbage.c                           |    9 +
 scripts/kconfig/conf.c                       |    2 
 sound/pci/hda/patch_cirrus.c                 |   44 +++++++
 sound/ppc/tumbler.c                          |    9 +
 sound/soc/codecs/wm_hubs.c                   |    8 -
 sound/synth/emux/emux_hwdep.c                |    3 
 tools/perf/Makefile                          |   75 ++++++++----
 124 files changed, 1554 insertions(+), 524 deletions(-)

Abhijith Das (2):
      GFS2: Fix writing to non-page aligned gfs2_quota structures
      GFS2: BUG in gfs2_adjust_quota

Alan Stern (3):
      USB: fix regression in usbip by setting has_tt flag
      USB: don't enable remote wakeup by default
      USB: teach "devices" file about Wireless and SuperSpeed USB

Alex Deucher (1):
      drm/radeon/kms: fix bad shift in atom iio table parser

Alex Williamson (2):
      intel-iommu: Unlink domain from iommu
      intel-iommu: Fix get_domain_for_dev() error path

Andy Chittenden (1):
      SUNRPC: fix NFS client over TCP hangs due to packet loss (Bug 16494)

Arnaldo Carvalho de Melo (2):
      perf tools: Move QUIET_STDERR def to before first use
      perf tools: Check if /dev/null can be used as the -o gcc argument

Artem Bityutskiy (1):
      UBIFS: fix master node recovery

Bart Hartgers (1):
      sata_via: Delay on vt6420 when starting ATAPI DMA write

Ben Dooks (1):
      mmc: sdhci: Check mrq->cmd in sdhci_tasklet_finish

Ben Hutchings (15):
      kconfig: Avoid buffer underrun in choice input
      bnx2x: declare MODULE_FIRMWARE
      cxgb3: declare MODULE_FIRMWARE
      myri10ge: declare MODULE_FIRMWARE
      netx: declare MODULE_FIRMWARE
      pcnet-cs: declare MODULE_FIRMWARE
      spider-net: declare MODULE_FIRMWARE
      tms380tr: declare MODULE_FIRMWARE
      Staging: rtl8192su: Clean up in case of an error in module initialisation
      Staging: rtl8192su: Fix procfs code for interfaces not named wlan0
      ALSA: emux: Add trivial compat ioctl handler
      btrfs: Require CAP_SYS_ADMIN for filesystem rebalance
      niu: Fix kernel buffer overflow for ETHTOOL_GRXCLSRLALL
      powerpc/boot/dts: Install dts from the right directory
      tehuti: Firmware filename is tehuti/bdx.bin

Bernhard Froemel (1):
      hwmon: (applesmc) Add generic support for MacBook Pro 6

Boris Ostrovsky (1):
      x86, AMD: Fix APIC timer erratum 400 affecting K8 Rev.A-E processors

Bruce Allan (1):
      e1000e: Reset 82577/82578 PHY before first PHY register read

Bruce Rogers (1):
      virtio_net: Add schedule check to napi_enable call

Chris Ball (2):
      mmc: sdhci-pci: Fix error case in sdhci_pci_probe_slot()
      mmc: sdhci: Check mrq != NULL in sdhci_tasklet_finish

Christian Lamparter (1):
      ath: add missing regdomain pair 0x5c mapping

Dan Rosenberg (3):
      pmcraid: reject negative request size
      mpt2sas: prevent heap overflows and unchecked reads
      ARM: 6891/1: prevent heap corruption in OABI semtimedop

Dan Streetman (1):
      USB: retain USB device power/wakeup setting across reconfiguration

Dave Jones (1):
      can: Add missing socket check in can/bcm release.

David Rientjes (1):
      set memory ranges in N_NORMAL_MEMORY when onlined

David Woodhouse (1):
      intel-iommu: Force-disable IOMMU for iGFX on broken Cantiga revisions.

Dhananjay Phadke (1):
      netxen: module firmware hints

Dmitry Torokhov (3):
      Input: elantech - do not advertise relative events
      Input: elantech - use all 3 bytes when checking version
      Input: elantech - relax signature checks

Edgar (gimli) Hucek (4):
      ALSA: hda - MacBookAir3,1(3,2) alsa support
      Bluetooth: Add MacBookAir3,1(2) support
      backlight: MacBookAir3,1(3,2) mbp-nvidia-bl support
      HID: add MacBookAir 3,1 and 3,2 support

Edgar Hucek (1):
      hwmon: (applesmc) Add MacBookAir3,1(3,2) support

Eric Dumazet (2):
      af_unix: limit recursion level
      af_unix: limit unix_tot_inflight

Eric W. Biederman (1):
      af_unix: Only allow recv on connected seqpacket sockets.

Erik Andren (1):
      dell-laptop: Add another Dell laptop to the DMI whitelist

FUJITA Tomonori (1):
      mpt2sas: fix the incorrect scsi_dma_map error checking

Felipe Balbi (1):
      usb: musb: core: set has_tt flag

Florian Ragwitz (3):
      Input: elantech - fix firmware version check
      Input: elantech - allow forcing Elantech protocol
      Input: elantech - ignore high bits in the position coordinates

Florian Schilhabel (3):
      Staging: rtl8192su: check for skb == NULL
      Staging: rtl8192su: remove device ids
      Staging: rtl8192su: add device ids

Fry, Donald H (1):
      iwlagn: Support new 5000 microcode.

Gertjan van Wingerde (3):
      mac80211: Add define for TX headroom reserved by mac80211 itself.
      rt2x00: Centralize setting of extra TX headroom requested by rt2x00.
      rt2x00: Properly request tx headroom for alignment operations.

Greg Kroah-Hartman (1):
      Linux 2.6.32.40

Greg Rose (1):
      Remove extra struct page member from the buffer info structure

Guennadi Liakhovetski (1):
      wireless: b43: fix error path in SDIO

Hagen Paul Pfeifer (1):
      econet: Fix redeclaration of symbol len

Hannes Reinecke (1):
      scsi_dh_emc: fix mode select request setup

Henrik Rydberg (2):
      hwmon: (applesmc) Add support for MacBook Pro 5,3 and 5,4
      hwmon: (applesmc) Add generic support for MacBook Pro 7

Herbert Xu (1):
      udp: Fix bogus UFO packet generation

Igor Mammedov (1):
      Input: xen-kbdfront - fix mouse getting stuck after save/restore

James Bottomley (3):
      slub: fix panic with DISCONTIGMEM
      put stricter guards on queue dead checks
      fix oops in scsi_run_queue()

James Chapman (1):
      l2tp: Fix UDP socket reference count bugs in the pppol2tp driver

Jason Conti (1):
      p54: Initialize extra_len in p54_tx_80211

Jeff Layton (1):
      nfs: don't lose MS_SYNCHRONOUS on remount of noac mount

Jeff Mahoney (1):
      ipg: Remove device claimed by dl2k from pci id table

Jesse Brandeburg (1):
      e1000: fix Tx hangs by disabling 64-bit DMA

Jie Yang (1):
      atl1c: duplicate atl1c_get_tpd

Jim Bos (2):
      i8k: Tell gcc that *regs gets clobbered
      Fix gcc 4.5.1 miscompiling drivers/char/i8k.c (again)

Jovi Zhang (1):
      nfs: fix compilation warning

Justin P. Mattock (1):
      hwmon: (applesmc) Add iMac9,1 and MacBookPro2,2 support

Kyle McMartin (1):
      perf symbols: allow forcing use of cplus_demangle

Larry Finger (1):
      b43: Fix warning at drivers/mmc/core/core.c:237 in mmc_wait_for_cmd

Linus Torvalds (1):
      Increase OSF partition limit from 8 to 18

Liu Yuan (1):
      block, blk-sysfs: Fix an err return path in blk_register_queue()

Mark Brown (1):
      ASoC: Fix output PGA enabling in wm_hubs CODECs

Maxim Levitsky (1):
      mmc: fix all hangs related to mmc/sd card insert/removal during suspend/resume

Michael Cree (1):
      perf tools: Test -fstack-protector-all compiler option for inclusion in CFLAGS

Michael Müller (1):
      V4L/DVB: Add Elgato EyeTV Diversity to dibcom driver

Michael S. Tsirkin (4):
      perf tools: Support static build
      perf tools: Add V=2 option to help debug config issues
      perf tools: Suggest static libraries as well
      perf: Use default compiler mode by default

Michael Schmitz (1):
      m68k/mm: Set all online nodes in N_NORMAL_MEMORY

Mike Christie (1):
      scsi_dh_emc: request flag cleanup

Neil Horman (2):
      nfs4: Ensure that ACL pages sent over NFS were not allocated from the slab (v3)
      bonding: Ensure that we unshare skbs prior to calling pskb_may_pull

Nobuhiro Iwamatsu (2):
      Bluetooth: Add support Bluetooth controller of MacbookPro 6,2
      Bluetooth: Add support Bluetooth controller of MacbookPro 7,1

Oliver Hartkopp (1):
      can: add missing socket check in can/raw release

Ondrej Zary (1):
      rt2500usb: fallback to SW encryption for TKIP+AES

Oskar Schirmer (1):
      cifs: fix another memleak, in cifs_root_iget

Patrick Boettcher (1):
      FLEXCOP-PCI: fix __xlate_proc_name-warning for flexcop-pci

Pavel Roskin (1):
      rt2x00: use correct headroom for transmission

Peter Zijlstra (1):
      init, sched: Fix race between init and kthreadd

Phil Blundell (1):
      econet: fix CVE-2010-3848

Rafael Avila de Espindola (1):
      ALSA: hda - Add support for the new 27 inch IMacs

Ralf Baechle (1):
      MIPS: DMA: Fix computation of DMA flags from device's coherent_dma_mask.

Randy Dunlap (1):
      perf tools: Display better error messages on missing packages

Rezwanul Kabir (1):
      dell-laptop: Add another Dell laptop family to the DMI whitelist

Risto Suominen (2):
      ALSA: powermac - Reverse HP detection on G4 DA
      ALSA: powermac - Lineout detection on G4 DA

Romain Francoise (1):
      ipv6: Silence privacy extensions initialization

Ron Murray (1):
      Please add support for Microsoft MN-120 PCMCIA network card

Rusty Russell (1):
      virtio_net: fix oom handling on tx

Rémi Denis-Courmont (1):
      Phonet: device notifier only runs on initial namespace

Sachin Prabhu (1):
      Open with O_CREAT flag set fails to open existing files on non writable directories

Stanislaw Gruszka (1):
      iwlwifi: fix skb usage after free

Stefan Haberland (1):
      dasd: correct device table

Steven Rostedt (1):
      perf tools: Add 'make DEBUG=1' to remove the -O6 cflag

Steven Whitehouse (1):
      GFS2: Clean up gfs2_adjust_quota() and do_glock()

Takashi Iwai (2):
      Input: Add support of Synaptics Clickpad device
      ALSA: hda - Add model=mbp55 entry for MacBookPro 7,1

Tejun Heo (1):
      libata: set queue DMA alignment to sector size for ATAPI too

Timo Warns (2):
      fs/partitions/ldm.c: fix oops caused by corrupted partition table
      Fix corrupted OSF partition table parsing

Trond Myklebust (2):
      NFS: nfs_wcc_update_inode() should set nfsi->attr_gencount
      NFSv4.1: Ensure state manager thread dies on last umount

Uwe Kleine-König (2):
      serial/imx: read cts state only after acking cts change irq
      mmc: build fix: mmc_pm_notify is only available with CONFIG_PM=y

Vasiliy Kulikov (2):
      agp: fix arbitrary kernel memory writes
      agp: fix OOM and buffer overflow

Vince Weaver (1):
      ALSA: hda - MacBookPro 5,3 line-in support

Zachary Amsden (3):
      x86: pvclock: Move scale_delta into common header
      KVM: x86: Fix a possible backwards warp of kvmclock
      KVM: x86: Fix kvmclock bug

Éric Piel (1):
      Input: elantech - discard the first 2 positions on some firmwares

