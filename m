Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab2CMARX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:17:23 -0400
Received: from mail.windriver.com ([147.11.1.11]:46457 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab2CMARU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:17:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 000/196] v2.6.34.11 longterm review
Date: Mon, 12 Mar 2012 20:12:08 -0400
Message-Id: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the v2.6.34.11 release.
There are 196 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Reponses should be made within 72 hours.

Abhijith Das (2):
  GFS2: Fix writing to non-page aligned gfs2_quota structures
  GFS2: BUG in gfs2_adjust_quota

Alan Stern (2):
  USB: EHCI: unlink unused QHs when the controller is stopped
  USB: teach "devices" file about Wireless and SuperSpeed USB

Alex Deucher (1):
  drm/radeon/kms: fix bad shift in atom iio table parser

Alex Williamson (2):
  intel-iommu: Unlink domain from iommu
  intel-iommu: Fix get_domain_for_dev() error path

Andy Chittenden (1):
  SUNRPC: fix NFS client over TCP hangs due to packet loss (Bug 16494)

Andy Gospodarek (1):
  gro: reset skb_iif on reuse

Arjan Mels (3):
  staging: usbip: bugfixes related to kthread conversion
  staging: usbip: bugfix add number of packets for isochronous frames
  staging: usbip: bugfix for isochronous packets and optimization

Artem Bityutskiy (5):
  UBIFS: do not read flash unnecessarily
  UBIFS: fix oops on error path in read_pnode
  UBIFS: fix debugging failure in dbg_check_space_info
  UBIFS: fix oops when R/O file-system is fsync'ed
  UBIFS: fix master node recovery

Ben Dooks (1):
  mmc: sdhci: Check mrq->cmd in sdhci_tasklet_finish

Ben Hutchings (7):
  kconfig: Avoid buffer underrun in choice input
  Staging: rtl8192su: Clean up in case of an error in module
    initialisation
  Staging: rtl8192su: Fix procfs code for interfaces not named wlan0
  ALSA: emux: Add trivial compat ioctl handler
  btrfs: Require CAP_SYS_ADMIN for filesystem rebalance
  powerpc/boot/dts: Install dts from the right directory
  tehuti: Firmware filename is tehuti/bdx.bin

Bernhard Froemel (1):
  hwmon: (applesmc) Add generic support for MacBook Pro 6

Bjørn Mork (1):
  megaraid_sas: Sanity check user supplied length before passing it to
    dma_alloc_coherent()

Bob Liu (1):
  ramfs: fix memleak on no-mmu arch

Boris Ostrovsky (1):
  x86, AMD: Set ARAT feature on AMD processors

Borislav Petkov (2):
  x86, microcode, AMD: Extend ucode size verification
  x86, AMD: Fix ARAT feature setting again

Bruce Allan (1):
  e1000e: Reset 82577/82578 PHY before first PHY register read

Bruce Rogers (1):
  virtio_net: Add schedule check to napi_enable call

Bud Brown (1):
  cciss: fix lost command issue

Chris Ball (2):
  mmc: sdhci-pci: Fix error case in sdhci_pci_probe_slot()
  mmc: sdhci: Check mrq != NULL in sdhci_tasklet_finish

Christian Lamparter (2):
  p54usb: IDs for two new devices
  ath: add missing regdomain pair 0x5c mapping

Christian Simon (1):
  USB: ftdi_sio: Added IDs for CTI USB Serial Devices

Clemens Ladisch (1):
  ALSA: ens1371: fix Creative Ectiva support

Dan Rosenberg (9):
  sound/oss/opl3: validate voice and channel indexes
  irda: validate peer name and attribute lengths
  irda: prevent heap corruption on invalid nickname
  ROSE: prevent heap corruption with bad facilities
  sound/oss: remove offset from load_patch callbacks
  pmcraid: reject negative request size
  ARM: 6891/1: prevent heap corruption in OABI semtimedop
  dccp: handle invalid feature options length
  Bluetooth: Prevent buffer overflow in l2cap config request

Dave Jones (1):
  can: Add missing socket check in can/bcm release.

David Rientjes (1):
  set memory ranges in N_NORMAL_MEMORY when onlined

David Woodhouse (1):
  intel-iommu: Force-disable IOMMU for iGFX on broken Cantiga
    revisions.

Dmitry Torokhov (4):
  USB: fix formatting of SuperSpeed endpoints in /proc/bus/usb/devices
  USB: xhci - fix unsafe macro definitions
  USB: xhci - fix math in xhci_get_endpoint_interval()
  Input: elantech - relax signature checks

Edgar (gimli) Hucek (4):
  ALSA: hda - MacBookAir3,1(3,2) alsa support
  Bluetooth: Add MacBookAir3,1(2) support
  backlight: MacBookAir3,1(3,2) mbp-nvidia-bl support
  HID: add MacBookAir 3,1 and 3,2 support

Edgar Hucek (1):
  hwmon: (applesmc) Add MacBookAir3,1(3,2) support

Enrico Mioso (1):
  USB: option: Add new ONDA vendor id and product id for ONDA MT825UP

Eric Dumazet (2):
  inet_diag: fix inet_diag_bc_audit()
  net: sk_add_backlog() take rmem_alloc into account

Eric W. Biederman (2):
  af_unix: Only allow recv on connected seqpacket sockets.
  rtnetlink: Add missing manual netlink notification in
    dev_change_net_namespaces

FUJITA Tomonori (1):
  mpt2sas: fix the incorrect scsi_dma_map error checking

Felix Fietkau (2):
  mac80211: initialize sta->last_rx in sta_info_alloc
  ath9k: fix a chip wakeup related crash in ath9k_start

Florian Schilhabel (3):
  Staging: rtl8192su: check for skb == NULL
  Staging: rtl8192su: remove device ids
  Staging: rtl8192su: add device ids

Frederic Weisbecker (1):
  perf: Better fit max unprivileged mlock pages for tools needs

Fry, Donald H (1):
  iwlagn: Support new 5000 microcode.

Geert Uytterhoeven (3):
  ne-h8300: Fix regression caused during net_device_ops conversion
  hydra: Fix regression caused during net_device_ops conversion
  zorro8390: Fix regression caused during net_device_ops conversion

Goldwyn Rodrigues (1):
  Treat writes as new when holes span across page boundaries

Greg Rose (1):
  Remove extra struct page member from the buffer info structure

Guennadi Liakhovetski (1):
  wireless: b43: fix error path in SDIO

Haiyang Zhang (1):
  staging: hv: Fix GARP not sent after Quick Migration

Hans Rosenfeld (3):
  x86, cpu: AMD errata checking framework
  x86, cpu: Clean up AMD erratum 400 workaround
  x86, cpu: Fix regression in AMD errata checking code

Henrik Rydberg (2):
  hwmon: (applesmc) Add support for MacBook Pro 5,3 and 5,4
  hwmon: (applesmc) Add generic support for MacBook Pro 7

Herbert Xu (2):
  gro: Reset dev pointer on reuse
  gro: Only reset frag0 when skb can be pulled

Hugh Dickins (1):
  shmem: let shared anonymous be nonlinear again

J. Bruce Fields (1):
  nfsd: fix auth_domain reference leak on nlm operations

James Bottomley (3):
  slub: fix panic with DISCONTIGMEM
  put stricter guards on queue dead checks
  fix oops in scsi_run_queue()

Jan Beulich (1):
  x86: Fix a bogus unwind annotation in lib/semaphore_32.S

Jan Kara (1):
  quota: Don't write quota info in dquot_commit()

Jason Conti (1):
  p54: Initialize extra_len in p54_tx_80211

Jason Wessel (1):
  repair gdbstub to match the gdbserial protocol specification

Jeff Layton (4):
  cifs: always do is_path_accessible check in cifs_mount
  nfs: don't lose MS_SYNCHRONOUS on remount of noac mount
  cifs: check for bytes_remaining going to zero in CIFS_SessSetup
  cifs: add fallback in is_path_accessible for old servers

Jeff Mahoney (2):
  tioca: Fix assignment from incompatible pointer warnings
  mca.c: Fix cast from integer to pointer warning

Jesse Brandeburg (1):
  e1000: fix Tx hangs by disabling 64-bit DMA

Jim Bos (2):
  i8k: Tell gcc that *regs gets clobbered
  Fix gcc 4.5.1 miscompiling drivers/char/i8k.c (again)

Jiri Slaby (1):
  NET: cdc-phonet, handle empty phonet header

Joerg Roedel (1):
  x86, amd: Disable GartTlbWlkErr when BIOS forgets it

Johan Hovold (1):
  USB: ftdi_sio: add PID for OCT DK201 docking station

John Hughes (1):
  ses: show devices for enclosures with no page 7

John Stultz (1):
  clocksource: Install completely before selecting

John W. Linville (1):
  b43: allocate receive buffers big enough for max frame len + offset

Jovi Zhang (1):
  nfs: fix compilation warning

Julia Lawall (1):
  x86, mce, AMD: Fix leaving freed data in a list

Kees Cook (1):
  net: ax25: fix information leak to userland harder

Kleber Sacilotto de Souza (1):
  ehea: fix wrongly reported speed and port

Krishnasamy, Somasundaram (1):
  ses: Avoid kernel panic when lun 0 is not mapped

Kulikov Vasiliy (1):
  sound: oss: midi_synth: check get_user() return value

Kyle McMartin (1):
  perf symbols: allow forcing use of cplus_demangle

Larry Finger (1):
  b43: Fix warning at drivers/mmc/core/core.c:237 in mmc_wait_for_cmd

Li Zefan (1):
  Btrfs: Fix uninitialized root flags for subvolumes

Linus Torvalds (4):
  mm: avoid wrapping vm_pgoff in mremap()
  next_pidmap: fix overflow condition
  proc: do proper range check on readdir offset
  Increase OSF partition limit from 8 to 18

Liu Yuan (1):
  block, blk-sysfs: Fix an err return path in blk_register_queue()

Marc-Antoine Perennou (1):
  Bluetooth: add support for Apple MacBook Pro 8,2

Marius B. Kotsbak (1):
  USB: option: Added support for Samsung GT-B3730/GT-B3710 LTE USB
    modem.

Mark Brown (2):
  ASoC: Explicitly say registerless widgets have no register
  ASoC: Fix output PGA enabling in wm_hubs CODECs

Matvejchikov Ilya (1):
  NET: slip, fix ldisc->open retval

Maxim Levitsky (1):
  mmc: fix all hangs related to mmc/sd card insert/removal during
    suspend/resume

Michael Schmitz (1):
  m68k/mm: Set all online nodes in N_NORMAL_MEMORY

Mike Christie (1):
  scsi_dh_emc: request flag cleanup

Neil Horman (2):
  nfs4: Ensure that ACL pages sent over NFS were not allocated from the
    slab (v3)
  bonding: Ensure that we unshare skbs prior to calling pskb_may_pull

Nobuhiro Iwamatsu (2):
  Bluetooth: Add support Bluetooth controller of MacbookPro 6,2
  Bluetooth: Add support Bluetooth controller of MacbookPro 7,1

Olaf Hering (1):
  staging: hv: use sync_bitops when interacting with the hypervisor

Oleg Nesterov (1):
  exec: copy-and-paste the fixes into compat_do_execve() paths

Oliver Hartkopp (1):
  can: add missing socket check in can/raw release

Ondrej Zary (1):
  rt2500usb: fallback to SW encryption for TKIP+AES

Oskar Schirmer (1):
  cifs: fix another memleak, in cifs_root_iget

Patrick Boettcher (1):
  FLEXCOP-PCI: fix __xlate_proc_name-warning for flexcop-pci

Paul Fox (1):
  libertas: fix cmdpendingq locking

Paul Friedrich (1):
  USB: ftdi_sio: add ids for Hameg HO720 and HO730

Pavel Shilovsky (1):
  CIFS: Fix memory over bound bug in cifs_parse_mount_options

Peter Huewe (1):
  char/tpm: Fix unitialized usage of data buffer

Peter Zijlstra (1):
  init, sched: Fix race between init and kthreadd

Philip A. Prindeville (1):
  atm/solos-pci: Don't include frame pseudo-header on transmit hex-dump

Phillip Lougher (1):
  Squashfs: handle corruption of directory structure

Randy Dunlap (1):
  MAINTAINERS: update STABLE BRANCH info

Rezwanul Kabir (1):
  dell-laptop: Add another Dell laptop family to the DMI whitelist

Risto Suominen (2):
  ALSA: powermac - Reverse HP detection on G4 DA
  ALSA: powermac - Lineout detection on G4 DA

Roberto Sassu (1):
  eCryptfs: ecryptfs_keyring_auth_tok_for_sig() bug fix

Roland Dreier (1):
  aio: wake all waiters when destroying ctx

Romain Francoise (1):
  ipv6: Silence privacy extensions initialization

Ryusuke Konishi (1):
  nilfs2: fix data loss in mmap page write for hole blocks

Sachin Prabhu (1):
  Open with O_CREAT flag set fails to open existing files on non
    writable directories

Shan Wei (1):
  ipv6: udp: fix the wrong headroom check

Stanislaw Gruszka (2):
  myri10ge: fix rmmod crash
  iwlwifi: fix skb usage after free

Stefan Haberland (1):
  dasd: correct device table

Stefano Stabellini (2):
  xen: set max_pfn_mapped to the last pfn mapped
  PCI hotplug: acpiphp: set current_state to D0 in register_slot

Suresh Siddha (1):
  x86, mtrr, pat: Fix one cpu getting out of sync during resume

Takashi Iwai (4):
  ALSA: hda - Fix SPDIF out regression on ALC889
  ALSA: Fix yet another race in disconnection
  ALSA: powermac - Fix obsoleted machine_is_compatible()
  ALSA: hda - Add model=mbp55 entry for MacBookPro 7,1

Tejun Heo (1):
  libata: set queue DMA alignment to sector size for ATAPI too

Thomas Gleixner (1):
  tick: Clear broadcast active bit when switching to oneshot

Thomas Jarosch (1):
  vmxnet3: Fix inconsistent LRO state after initialization

Timo Warns (4):
  Fix corrupted OSF partition table parsing
  Validate size of EFI GUID partition entries.
  fs/partitions/efi.c: corrupted GUID partition tables can cause kernel
    oops
  befs: Validate length of long symbolic links.

Trond Myklebust (2):
  NFS: nfs_wcc_update_inode() should set nfsi->attr_gencount
  NFSv4.1: Ensure state manager thread dies on last umount

Tyler Hicks (1):
  eCryptfs: Unlock page in write_begin error path

Uwe Kleine-König (2):
  serial/imx: read cts state only after acking cts change irq
  mmc: build fix: mmc_pm_notify is only available with CONFIG_PM=y

Vasiliy Kulikov (7):
  netfilter: ipt_CLUSTERIP: fix buffer overflow
  mfd: ab3100: world-writable debugfs *_priv files
  drivers/rtc/rtc-ds1511.c: world-writable sysfs nvram file
  drivers/misc/ep93xx_pwm.c: world-writable sysfs files
  video: sn9c102: world-wirtable sysfs files
  UBIFS: restrict world-writable debugfs files
  taskstats: don't allow duplicate entries in listener mode

Vince Weaver (1):
  ALSA: hda - MacBookPro 5,3 line-in support

Yongqiang Yang (1):
  ext4: fix credits computing for indirect mapped files

Youquan Song (1):
  x86, apic: Fix spurious error interrupts triggering on all non-boot
    APs

Zachary Amsden (1):
  x86: pvclock: Move scale_delta into common header

michael@alice-dsl.net (1):
  V4L/DVB: Add Elgato EyeTV Diversity to dibcom driver

Éric Piel (1):
  Input: elantech - discard the first 2 positions on some firmwares

 Documentation/usb/proc_usb_info.txt         |   34 ++++--
 MAINTAINERS                                 |    1 -
 arch/arm/kernel/sys_oabi-compat.c           |    2 +-
 arch/ia64/kernel/mca.c                      |    3 +-
 arch/ia64/sn/pci/tioca_provider.c           |    2 +-
 arch/m68k/mm/motorola.c                     |    2 +
 arch/parisc/mm/init.c                       |    4 +-
 arch/powerpc/boot/Makefile                  |    2 +-
 arch/x86/include/asm/apicdef.h              |    1 +
 arch/x86/include/asm/msr-index.h            |    4 +
 arch/x86/include/asm/processor.h            |   19 ++++
 arch/x86/include/asm/pvclock.h              |   38 +++++++
 arch/x86/kernel/cpu/amd.c                   |   88 +++++++++++++++
 arch/x86/kernel/cpu/mcheck/mce_amd.c        |    1 +
 arch/x86/kernel/cpu/mcheck/therm_throt.c    |   12 +-
 arch/x86/kernel/cpu/mtrr/main.c             |   20 +++-
 arch/x86/kernel/microcode_amd.c             |   74 +++++++-----
 arch/x86/kernel/process.c                   |   39 +------
 arch/x86/kernel/pvclock.c                   |    3 +-
 arch/x86/lib/semaphore_32.S                 |    2 +-
 arch/x86/xen/mmu.c                          |   13 ++-
 block/blk-sysfs.c                           |    4 +-
 drivers/ata/libata-scsi.c                   |   24 +++-
 drivers/atm/solos-pci.c                     |    9 +-
 drivers/block/cciss.h                       |    1 +
 drivers/bluetooth/btusb.c                   |   12 ++
 drivers/char/i8k.c                          |    7 +-
 drivers/char/tpm/tpm.c                      |    2 +-
 drivers/gpu/drm/radeon/atom.c               |    6 +-
 drivers/hid/hid-apple.c                     |   46 +++++++-
 drivers/hid/hid-core.c                      |   12 ++
 drivers/hid/hid-ids.h                       |    6 +
 drivers/hwmon/applesmc.c                    |   48 ++++++++
 drivers/input/mouse/elantech.c              |   41 +++++--
 drivers/input/mouse/elantech.h              |    7 +-
 drivers/media/dvb/b2c2/flexcop-pci.c        |    2 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c |   46 +++++++-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h     |    1 +
 drivers/media/video/sn9c102/sn9c102_core.c  |    6 +-
 drivers/mfd/ab3100-core.c                   |    4 +-
 drivers/misc/ep93xx_pwm.c                   |    6 +-
 drivers/mmc/core/core.c                     |   83 +++++++++-----
 drivers/mmc/core/host.c                     |    6 +
 drivers/mmc/host/sdhci-pci.c                |    1 +
 drivers/mmc/host/sdhci.c                    |    9 +-
 drivers/net/Makefile                        |    6 +-
 drivers/net/bonding/bond_3ad.c              |    4 +
 drivers/net/bonding/bond_alb.c              |    4 +
 drivers/net/bonding/bond_main.c             |    4 +
 drivers/net/e1000/e1000_main.c              |  162 +++++++++++++++------------
 drivers/net/e1000e/ich8lan.c                |   10 ++
 drivers/net/ehea/ehea_ethtool.c             |   21 ++--
 drivers/net/hydra.c                         |   14 +--
 drivers/net/igbvf/igbvf.h                   |    1 -
 drivers/net/myri10ge/myri10ge.c             |    1 +
 drivers/net/ne-h8300.c                      |   16 +--
 drivers/net/slip.c                          |    4 +-
 drivers/net/tehuti.c                        |    4 +-
 drivers/net/usb/cdc-phonet.c                |    9 +-
 drivers/net/virtio_net.c                    |   27 +++--
 drivers/net/vmxnet3/vmxnet3_ethtool.c       |    3 +
 drivers/net/wireless/ath/ath9k/main.c       |    4 +
 drivers/net/wireless/ath/regd_common.h      |    1 +
 drivers/net/wireless/b43/dma.c              |    2 +-
 drivers/net/wireless/b43/dma.h              |    2 +-
 drivers/net/wireless/b43/sdio.c             |    3 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    8 +-
 drivers/net/wireless/libertas/cmd.c         |    6 +-
 drivers/net/wireless/p54/p54usb.c           |    2 +
 drivers/net/wireless/p54/txrx.c             |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.c     |   10 ++
 drivers/net/zorro8390.c                     |   12 +-
 drivers/pci/hotplug/acpiphp_glue.c          |    1 +
 drivers/pci/intel-iommu.c                   |   23 +++-
 drivers/platform/x86/dell-laptop.c          |    7 ++
 drivers/rtc/rtc-ds1511.c                    |    2 +-
 drivers/s390/block/dasd_eckd.c              |    2 +-
 drivers/scsi/device_handler/scsi_dh_emc.c   |    2 -
 drivers/scsi/megaraid/megaraid_sas.c        |    3 +
 drivers/scsi/mpt2sas/mpt2sas_scsih.c        |    4 +-
 drivers/scsi/pmcraid.c                      |    3 +
 drivers/scsi/scsi_lib.c                     |    7 +-
 drivers/scsi/scsi_sysfs.c                   |   16 +--
 drivers/scsi/ses.c                          |    4 +-
 drivers/serial/imx.c                        |    3 +-
 drivers/staging/hv/Channel.c                |    8 +-
 drivers/staging/hv/Connection.c             |    4 +-
 drivers/staging/hv/Vmbus.c                  |    2 +-
 drivers/staging/hv/VmbusPrivate.h           |    1 +
 drivers/staging/hv/netvsc_drv.c             |   24 ++++
 drivers/staging/rtl8192su/r8192S_firmware.c |  135 ++++++++++------------
 drivers/staging/rtl8192su/r8192U_core.c     |  122 ++++++++++++++------
 drivers/staging/rtl8192su/r819xU_cmdpkt.c   |    6 +
 drivers/staging/usbip/stub_rx.c             |   40 +++----
 drivers/staging/usbip/stub_tx.c             |   74 +++++++++---
 drivers/staging/usbip/usbip_common.c        |   64 ++++++++++-
 drivers/staging/usbip/usbip_common.h        |    2 +
 drivers/staging/usbip/vhci_rx.c             |    3 +
 drivers/usb/core/devices.c                  |   21 ++--
 drivers/usb/host/ehci-q.c                   |   15 ++-
 drivers/usb/host/xhci-mem.c                 |   90 ++++++++++-----
 drivers/usb/host/xhci.h                     |    6 +-
 drivers/usb/serial/ftdi_sio.c               |    5 +
 drivers/usb/serial/ftdi_sio_ids.h           |   11 ++
 drivers/usb/serial/option.c                 |   12 ++
 drivers/video/backlight/mbp_nvidia_bl.c     |   18 +++
 fs/aio.c                                    |    4 +-
 fs/befs/linuxvfs.c                          |   23 ++--
 fs/btrfs/ctree.h                            |    4 +
 fs/btrfs/disk-io.c                          |    4 +-
 fs/btrfs/ioctl.c                            |    4 +
 fs/btrfs/root-tree.c                        |   18 +++
 fs/btrfs/transaction.c                      |    1 +
 fs/btrfs/volumes.c                          |    4 +
 fs/cifs/connect.c                           |   12 +-
 fs/cifs/inode.c                             |   12 +-
 fs/cifs/sess.c                              |    4 +-
 fs/compat.c                                 |   28 ++---
 fs/ecryptfs/keystore.c                      |    1 +
 fs/ecryptfs/mmap.c                          |    5 +
 fs/exec.c                                   |    8 +-
 fs/ext4/inode.c                             |   11 +-
 fs/gfs2/quota.c                             |   84 +++++++++-----
 fs/nfs/inode.c                              |   26 +++--
 fs/nfs/nfs4proc.c                           |   44 +++++++-
 fs/nfs/nfs4state.c                          |    4 +-
 fs/nfs/super.c                              |    9 ++
 fs/nfsd/lockd.c                             |    1 -
 fs/nfsd/vfs.c                               |    9 +-
 fs/nilfs2/file.c                            |   12 +-
 fs/ocfs2/aops.c                             |    6 +
 fs/partitions/efi.c                         |   15 +++
 fs/partitions/osf.c                         |   12 +-
 fs/proc/base.c                              |    9 +-
 fs/quota/dquot.c                            |   13 +--
 fs/ramfs/file-nommu.c                       |    1 +
 fs/squashfs/dir.c                           |    9 ++
 fs/squashfs/namei.c                         |   12 ++
 fs/ubifs/commit.c                           |    2 +-
 fs/ubifs/debug.c                            |   47 ++++++--
 fs/ubifs/file.c                             |    3 +
 fs/ubifs/lpt.c                              |    7 +-
 fs/ubifs/recovery.c                         |   26 +++++
 include/linux/binfmts.h                     |    4 +
 include/linux/mmc/host.h                    |    3 +
 include/linux/netdevice.h                   |    5 +-
 include/linux/pid.h                         |    2 +-
 include/net/sock.h                          |   13 ++-
 include/scsi/scsi_device.h                  |    2 +-
 include/sound/soc-dapm.h                    |   16 +--
 init/Kconfig                                |    1 +
 init/main.c                                 |   12 ++
 kernel/kgdb.c                               |    9 +-
 kernel/perf_event.c                         |    3 +-
 kernel/pid.c                                |    5 +-
 kernel/taskstats.c                          |   15 ++-
 kernel/time/clocksource.c                   |    2 +-
 kernel/time/tick-broadcast.c                |   12 +-
 mm/mremap.c                                 |   11 +-
 mm/shmem.c                                  |    1 +
 net/ax25/af_ax25.c                          |    2 +-
 net/bluetooth/l2cap.c                       |    3 +-
 net/can/bcm.c                               |    7 +-
 net/can/raw.c                               |    7 +-
 net/core/dev.c                              |    3 +
 net/core/sock.c                             |    5 +-
 net/dccp/options.c                          |    2 +
 net/ipv4/inet_diag.c                        |   14 +--
 net/ipv4/netfilter/ipt_CLUSTERIP.c          |    5 +-
 net/ipv4/udp.c                              |    4 +
 net/ipv6/addrconf.c                         |    3 -
 net/ipv6/udp.c                              |   10 +-
 net/irda/iriap.c                            |    6 +
 net/irda/irnet/irnet_ppp.c                  |    3 +
 net/mac80211/sta_info.c                     |    1 +
 net/rose/rose_subr.c                        |   18 ++-
 net/sctp/socket.c                           |    3 -
 net/sunrpc/xprtsock.c                       |   28 ++++-
 net/unix/af_unix.c                          |   16 ++-
 scripts/kconfig/conf.c                      |    2 +-
 sound/core/init.c                           |    4 +
 sound/oss/dev_table.h                       |    2 +-
 sound/oss/midi_synth.c                      |   34 +++---
 sound/oss/midi_synth.h                      |    2 +-
 sound/oss/opl3.c                            |   23 ++--
 sound/oss/sequencer.c                       |    2 +-
 sound/pci/ens1370.c                         |   23 +++-
 sound/pci/hda/patch_cirrus.c                |   24 +++-
 sound/pci/hda/patch_realtek.c               |    2 +-
 sound/ppc/tumbler.c                         |    9 +-
 sound/soc/codecs/wm_hubs.c                  |    8 +-
 sound/synth/emux/emux_hwdep.c               |    3 +
 tools/perf/Makefile                         |    3 +
 194 files changed, 1992 insertions(+), 736 deletions(-)

-- 
1.7.9.3

