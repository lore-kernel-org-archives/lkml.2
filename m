Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253Ab0HDOeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:34:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:53075 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758216Ab0HDOeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:34:15 -0400
Date: Wed, 4 Aug 2010 16:34:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial
Message-ID: <alpine.LNX.2.00.1008041546220.29919@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch at

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-next

to receive updates which are sitting in the trivial queue. Mostly comment 
typo fixes, obvious dead code removals, and tree-wide update of broken 
URLs.

Thanks.

Christoph Egger (2):
      Remove dead CONFIG_SIBYTE_BCM1480_PROF
      Removing dead MACH_U300_BS26

Davidlohr Bueso (2):
      reiserfs: typo comment fix
      arm: plat-spear: fix typo in kerneldoc

Jim Cromie (1):
      variable name fix to Documentation/rt-mutex-design.txt

Jiri Kosina (3):
      trivial: don't touch drivers/staging
      Revert "Remove dead CONFIG_SIBYTE_BCM1480_PROF"
      trivial: no changes to ov511 driver

Joe Perches (3):
      arch/cris: Remove unnecessary kmalloc casts
      fs/ocfs2: Remove unnecessary casts of private_data
      drivers/infiniband: Remove unnecessary casts of private_data

Justin P. Mattock (5):
      fix comment typo in netdevice.h
      fix #warning about using kernel headers in userpsace
      Documentation update broken web addresses
      hostap:hostap_hw.c Fix typo in comment
      Documentation: update broken web addresses.

Kulikov Vasiliy (9):
      Documentation/sysctl/vm.txt typo
      lib/devres.c: fix comment typo
      Documentation: pci.txt: fix typo
      block: cciss: use ARRAY_SIZE
      synclink: use ARRAY_SIZE
      drm: drm_edid: use ARRAY_SIZE
      drm: i915: use ARRAY_SIZE
      scsi: bfa: use ARRAY_SIZE
      libfc: use ARRAY_SIZE

Matthew Whitworth (1):
      Fix comment spelling errors in ncpfs/inode.c

Michael Witten (1):
      Kconfig: fixo typo in "Xilinx'"

Pavel Machek (1):
      update email address

Stefan Weil (1):
      Fix spelling contorller -> controller in comments

Stephen Boyd (1):
      fs/Kconfig: Fix typo Userpace -> Userspace

Suresh Jayaraman (2):
      fscache: fix a trivial typo in the comment
      fscache: fix missing kerneldoc annotation

Takuya Yoshikawa (1):
      Kconfig.debug: FAIL_IO_TIMEOUT: typo Faul -> Fault

Thomas Weber (1):
      comment typo fixes: charater => character

Uwe Kleine-König (14):
      fix typos concerning "hierarchy"
      fix typos concerning "acquire"
      fix typos concerning "first"
      fix typos concerning "management"
      fix typos concerning "initiali[zs]e"
      fix typos concerning "instead"
      fix typos concerning "associate"
      fix typos concerning "precedence"
      fix comment typos concerning "sequential"
      fix comment/printk typos concerning "already"
      remove a duplicated comment line
      fix comnment/printk typos concerning "empty"
      fix comment typos concerning "challenge"
      fix comment typo "choosed" -> "chosen"

 Documentation/ABI/testing/sysfs-devices-memory     |    6 +-
 Documentation/ABI/testing/sysfs-devices-system-cpu |    2 +-
 Documentation/Changes                              |   12 ++--
 Documentation/DocBook/scsi.tmpl                    |    2 +-
 Documentation/DocBook/v4l/compat.xml               |    5 +-
 Documentation/DocBook/v4l/fdl-appendix.xml         |    2 +-
 Documentation/HOWTO                                |    6 +-
 Documentation/PCI/pci.txt                          |    2 +-
 Documentation/RCU/RTFP.txt                         |    2 +-
 Documentation/SubmittingDrivers                    |    2 +-
 Documentation/aoe/aoe.txt                          |    2 +-
 Documentation/arm/IXP2000                          |    2 +-
 Documentation/arm/IXP4xx                           |   14 ++--
 Documentation/arm/README                           |    4 +-
 Documentation/arm/SA1100/Assabet                   |    5 +-
 Documentation/arm/SA1100/Brutus                    |    2 +-
 Documentation/arm/SA1100/FreeBird                  |    2 +-
 Documentation/arm/SA1100/GraphicsClient            |    2 +-
 Documentation/arm/SA1100/GraphicsMaster            |    2 +-
 Documentation/arm/SA1100/Itsy                      |    2 +-
 Documentation/arm/SA1100/PLEB                      |    2 +-
 Documentation/arm/SA1100/Victor                    |    2 +-
 Documentation/arm/SA1100/nanoEngine                |    2 +-
 Documentation/binfmt_misc.txt                      |    2 +-
 Documentation/blockdev/paride.txt                  |    2 +-
 Documentation/cdrom/packet-writing.txt             |    2 +-
 Documentation/cgroups/cpusets.txt                  |    2 +-
 Documentation/development-process/4.Coding         |    2 +-
 Documentation/device-mapper/dm-crypt.txt           |    2 +-
 Documentation/devices.txt                          |    9 ++-
 Documentation/dvb/faq.txt                          |    2 +-
 Documentation/fb/framebuffer.txt                   |    2 +-
 Documentation/feature-removal-schedule.txt         |    2 +-
 Documentation/filesystems/9p.txt                   |    2 +-
 Documentation/filesystems/affs.txt                 |    2 +-
 Documentation/filesystems/befs.txt                 |    4 +-
 Documentation/filesystems/isofs.txt                |    2 +-
 Documentation/filesystems/proc.txt                 |    4 +-
 Documentation/filesystems/vfat.txt                 |    3 +-
 Documentation/hwmon/adm1026                        |    2 +-
 Documentation/hwmon/g760a                          |    2 +-
 Documentation/hwmon/gl518sm                        |    3 +-
 Documentation/hwmon/hpfall.c                       |    2 +-
 Documentation/hwmon/k8temp                         |    2 +-
 Documentation/hwmon/lm85                           |    6 +-
 Documentation/hwmon/smsc47m1                       |   11 +--
 Documentation/hwmon/thmc50                         |    2 +-
 Documentation/hwmon/via686a                        |    2 +-
 Documentation/hwmon/w83627hf                       |    6 +--
 Documentation/hwmon/w83781d                        |    2 +-
 Documentation/hwmon/w83792d                        |    2 +-
 Documentation/i2c/busses/i2c-ali1535               |    2 +-
 Documentation/i2c/busses/i2c-ali1563               |    2 +-
 Documentation/i2c/busses/i2c-ali15x3               |    2 +-
 Documentation/i2c/busses/i2c-piix4                 |    2 +-
 Documentation/i2c/busses/i2c-sis630                |    2 +-
 Documentation/ia64/aliasing.txt                    |    2 -
 Documentation/ia64/serial.txt                      |    2 +-
 Documentation/infiniband/user_verbs.txt            |    2 +-
 Documentation/input/appletouch.txt                 |    2 +-
 Documentation/input/bcm5974.txt                    |    2 +-
 Documentation/input/iforce-protocol.txt            |    2 +-
 Documentation/input/sentelic.txt                   |    2 +-
 Documentation/input/xpad.txt                       |    2 +-
 Documentation/intel_txt.txt                        |   12 ++--
 Documentation/ioctl/ioctl-number.txt               |   10 ++--
 Documentation/isdn/README                          |    2 +-
 Documentation/isdn/README.HiSax                    |    2 +-
 Documentation/ja_JP/HOWTO                          |    2 +-
 Documentation/ja_JP/SubmittingPatches              |    6 +-
 Documentation/kernel-docs.txt                      |   39 +++++------
 Documentation/ko_KR/HOWTO                          |    8 +-
 Documentation/laptops/acer-wmi.txt                 |    2 +-
 Documentation/ldm.txt                              |    2 +-
 Documentation/md.txt                               |    2 +-
 Documentation/misc-devices/c2port.txt              |    4 +-
 Documentation/mtd/nand_ecc.txt                     |    2 +-
 Documentation/networking/3c509.txt                 |    2 +-
 Documentation/networking/README.ipw2100            |    3 +-
 Documentation/networking/README.ipw2200            |    2 +-
 Documentation/networking/README.sb1000             |    4 +-
 Documentation/networking/arcnet.txt                |    4 +-
 Documentation/networking/bonding.txt               |    2 +-
 Documentation/networking/decnet.txt                |    2 +-
 Documentation/networking/fore200e.txt              |    2 +-
 Documentation/networking/ipddp.txt                 |    5 --
 Documentation/networking/iphase.txt                |    2 +-
 Documentation/networking/packet_mmap.txt           |    4 +-
 Documentation/networking/ray_cs.txt                |    4 +-
 Documentation/networking/s2io.txt                  |    3 +-
 Documentation/networking/tlan.txt                  |    4 +-
 Documentation/networking/udplite.txt               |   13 ++--
 Documentation/networking/wavelan.txt               |    3 +-
 Documentation/power/apm-acpi.txt                   |    2 +-
 Documentation/power/basic-pm-debugging.txt         |    3 +-
 Documentation/power/tricks.txt                     |    2 +-
 Documentation/power/video.txt                      |   12 ++--
 Documentation/powerpc/booting-without-of.txt       |    2 +-
 Documentation/rt-mutex-design.txt                  |    2 +-
 Documentation/s390/Debugging390.txt                |    2 +-
 Documentation/scsi/BusLogic.txt                    |    2 +-
 Documentation/scsi/ChangeLog.lpfc                  |    2 +-
 Documentation/scsi/ChangeLog.megaraid              |    2 +-
 Documentation/scsi/FlashPoint.txt                  |    4 +-
 Documentation/scsi/Mylex.txt                       |    2 +-
 Documentation/scsi/NinjaSCSI.txt                   |    2 -
 Documentation/scsi/aic79xx.txt                     |    2 +-
 Documentation/scsi/aic7xxx.txt                     |    2 +-
 Documentation/scsi/ibmmca.txt                      |    2 +-
 Documentation/scsi/osst.txt                        |    2 +-
 Documentation/scsi/ppa.txt                         |    6 +-
 Documentation/scsi/scsi-generic.txt                |    8 +-
 Documentation/scsi/scsi.txt                        |    4 +-
 Documentation/scsi/scsi_mid_low_api.txt            |    2 +-
 Documentation/serial/moxa-smartio                  |    2 +-
 Documentation/sound/alsa/ALSA-Configuration.txt    |    2 +-
 Documentation/sound/alsa/HD-Audio.txt              |    2 +-
 Documentation/sound/alsa/soc/DAI.txt               |    2 +-
 Documentation/sound/alsa/soc/codec.txt             |    2 +-
 Documentation/sound/alsa/soc/platform.txt          |    2 +-
 Documentation/sound/oss/README.OSS                 |    5 +-
 Documentation/sparse.txt                           |    2 +-
 Documentation/sysctl/vm.txt                        |    2 +-
 Documentation/telephony/ixj.txt                    |    9 +--
 Documentation/uml/UserModeLinux-HOWTO.txt          |   73 ++-----------------
 Documentation/usb/linux.inf                        |    2 +-
 Documentation/usb/mtouchusb.txt                    |    6 +--
 Documentation/usb/usb-serial.txt                   |    4 +-
 Documentation/video4linux/API.html                 |    2 +-
 Documentation/video4linux/CQcam.txt                |    4 +-
 Documentation/video4linux/README.cpia              |    2 +-
 Documentation/video4linux/README.ivtv              |    2 +-
 Documentation/video4linux/Zoran                    |    6 +-
 Documentation/video4linux/bttv/Cards               |    6 +-
 Documentation/video4linux/bttv/MAKEDEV             |    2 +-
 Documentation/video4linux/bttv/Specs               |    4 +-
 .../video4linux/cx88/hauppauge-wintv-cx88-ir.txt   |    2 +-
 .../video4linux/hauppauge-wintv-cx88-ir.txt        |    2 +-
 Documentation/video4linux/ibmcam.txt               |    5 +-
 Documentation/video4linux/se401.txt                |    2 +-
 Documentation/video4linux/w9966.txt                |    2 +-
 Documentation/w1/masters/ds2482                    |    4 +-
 Documentation/w1/masters/mxc-w1                    |    3 +-
 Documentation/w1/masters/omap-hdq                  |    2 +-
 Documentation/zh_CN/HOWTO                          |    8 +-
 Documentation/zh_CN/SubmittingDrivers              |    2 +-
 Documentation/zh_CN/SubmittingPatches              |    6 +-
 Documentation/zh_CN/sparse.txt                     |    2 +-
 arch/arm/mach-imx/dma-v1.c                         |    3 +-
 arch/arm/mach-msm/acpuclock-arm11.c                |    4 +-
 arch/arm/mach-omap2/dpll3xxx.c                     |    2 +-
 arch/arm/mach-omap2/sleep34xx.S                    |    2 +-
 arch/arm/mach-sa1100/collie.c                      |    2 +-
 arch/arm/mach-u300/core.c                          |    7 --
 arch/arm/mach-u300/gpio.c                          |    2 +-
 arch/arm/plat-s3c24xx/clock.c                      |    2 +-
 arch/arm/plat-samsung/clock.c                      |    2 +-
 arch/arm/plat-spear/padmux.c                       |    2 +-
 arch/cris/arch-v32/mm/intmem.c                     |   13 ++--
 arch/h8300/kernel/timer/itu.c                      |    2 +-
 arch/h8300/kernel/timer/timer16.c                  |    2 +-
 arch/h8300/kernel/timer/timer8.c                   |    2 +-
 arch/ia64/kvm/kvm-ia64.c                           |    6 +-
 arch/ia64/sn/kernel/setup.c                        |    2 +-
 arch/microblaze/Makefile                           |    2 +-
 arch/powerpc/kernel/suspend.c                      |    2 +-
 arch/powerpc/platforms/ps3/htab.c                  |    2 +-
 arch/sh/kernel/clkdev.c                            |    2 +-
 arch/sparc/boot/btfixupprep.c                      |    4 +-
 arch/x86/kernel/acpi/sleep.c                       |    2 +-
 arch/x86/kernel/apic/apic.c                        |    2 +-
 arch/x86/kernel/apm_32.c                           |    2 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c          |    2 +-
 arch/x86/kernel/head32.c                           |    2 +-
 arch/x86/mm/init_64.c                              |    2 +-
 arch/x86/power/cpu.c                               |    2 +-
 arch/x86/power/hibernate_64.c                      |    2 +-
 drivers/block/cciss.c                              |    2 +-
 drivers/block/drbd/drbd_receiver.c                 |    2 +-
 drivers/block/nbd.c                                |    2 +-
 drivers/char/synclink_gt.c                         |    2 +-
 drivers/crypto/amcc/crypto4xx_reg_def.h            |    2 +-
 drivers/dma/at_hdmac.c                             |    2 +-
 drivers/dma/fsldma.c                               |    2 +-
 drivers/gpu/drm/drm_edid.c                         |    7 +--
 drivers/gpu/drm/i915/intel_sdvo.c                  |    4 +-
 drivers/gpu/drm/i915/intel_tv.c                    |    2 +-
 drivers/gpu/drm/savage/savage_bci.c                |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           |    2 +-
 drivers/ide/ide-gd.c                               |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_qp.c              |    4 +-
 drivers/infiniband/hw/cxgb4/qp.c                   |    4 +-
 drivers/infiniband/hw/ehca/hcp_if.h                |    2 +-
 drivers/infiniband/hw/ipath/ipath_file_ops.c       |    2 +-
 drivers/input/misc/ad714x.c                        |    2 +-
 drivers/isdn/hardware/mISDN/avmfritz.c             |    2 +-
 drivers/isdn/hardware/mISDN/hfcmulti.c             |    4 +-
 drivers/isdn/hardware/mISDN/hfcpci.c               |    2 +-
 drivers/isdn/hardware/mISDN/mISDNinfineon.c        |    2 +-
 drivers/isdn/hardware/mISDN/speedfax.c             |    2 +-
 drivers/isdn/hardware/mISDN/w6692.c                |    2 +-
 drivers/isdn/hisax/callc.c                         |    2 +-
 drivers/isdn/hisax/tei.c                           |    2 +-
 drivers/isdn/mISDN/tei.c                           |    2 +-
 drivers/media/dvb/siano/smscoreapi.c               |    2 +-
 drivers/media/video/gspca/sunplus.c                |    4 +-
 drivers/media/video/usbvideo/vicam.c               |    2 +-
 drivers/media/video/v4l2-compat-ioctl32.c          |    2 +-
 drivers/media/video/zoran/zoran.h                  |    2 +-
 drivers/media/video/zoran/zoran_device.c           |    2 +-
 drivers/media/video/zoran/zr36050.c                |    2 +-
 drivers/media/video/zoran/zr36060.c                |    2 +-
 drivers/message/fusion/mptbase.c                   |    4 +-
 drivers/mtd/nand/denali.c                          |    2 +-
 drivers/net/3c527.c                                |    4 +-
 drivers/net/appletalk/ipddp.c                      |    2 +-
 drivers/net/benet/be_hw.h                          |    2 +-
 drivers/net/gianfar.c                              |    2 +-
 drivers/net/hp100.c                                |    2 +-
 drivers/net/ibm_newemac/core.c                     |    2 +-
 drivers/net/ksz884x.c                              |    2 +-
 drivers/net/ll_temac_main.c                        |    2 +-
 drivers/net/sh_eth.c                               |    2 +-
 drivers/net/tulip/dmfe.c                           |   20 +++---
 drivers/net/wimax/i2400m/control.c                 |    2 +-
 drivers/net/wireless/hostap/hostap_ap.c            |    2 +-
 drivers/net/wireless/hostap/hostap_hw.c            |    2 +-
 drivers/parisc/ccio-dma.c                          |    4 +-
 drivers/pcmcia/sa11xx_base.c                       |    2 +-
 drivers/rapidio/rio.c                              |    2 +-
 drivers/rtc/rtc-fm3130.c                           |    2 +-
 drivers/rtc/rtc-rx8025.c                           |    2 +-
 drivers/scsi/advansys.c                            |    2 +-
 drivers/scsi/aic7xxx_old/aic7xxx.seq               |    2 +-
 drivers/scsi/aic94xx/aic94xx_seq.c                 |    4 +-
 drivers/scsi/bfa/bfa_core.c                        |    2 +-
 drivers/scsi/bfa/bfa_fcs.c                         |   10 +--
 drivers/scsi/bfa/bfa_ioim.c                        |    2 +-
 drivers/scsi/bfa/vport.c                           |    2 +-
 drivers/scsi/fcoe/fcoe.c                           |    4 +-
 drivers/scsi/libfc/fc_exch.c                       |    4 +-
 drivers/scsi/libfc/fc_lport.c                      |    6 +-
 drivers/scsi/libfc/fc_rport.c                      |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_base.h                |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c               |    4 +-
 drivers/scsi/pm8001/pm8001_hwi.c                   |    4 +-
 drivers/scsi/qla2xxx/qla_iocb.c                    |    2 +-
 drivers/scsi/qla2xxx/qla_nx.h                      |    2 +-
 drivers/scsi/qla4xxx/ql4_init.c                    |    2 +-
 drivers/scsi/scsi_transport_fc.c                   |    2 +-
 drivers/serial/68360serial.c                       |    6 +-
 drivers/serial/cpm_uart/cpm_uart_core.c            |    2 +-
 drivers/serial/nwpserial.c                         |    2 +-
 drivers/serial/sn_console.c                        |    6 +-
 drivers/staging/winbond/wbusb.c                    |    2 +-
 drivers/usb/class/cdc-acm.c                        |    2 +-
 drivers/usb/class/usblp.c                          |    2 +-
 drivers/usb/host/fhci-sched.c                      |    2 +-
 drivers/usb/serial/kl5kusb105.c                    |    2 +-
 drivers/usb/wusbcore/wusbhc.c                      |    2 +-
 drivers/uwb/wlp/wss-lc.c                           |    2 +-
 drivers/video/backlight/locomolcd.c                |    4 +-
 drivers/video/carminefb.c                          |    2 +-
 drivers/video/tgafb.c                              |    2 +-
 fs/Kconfig                                         |    2 +-
 fs/befs/linuxvfs.c                                 |    2 +-
 fs/compat.c                                        |    2 +-
 fs/compat_ioctl.c                                  |    2 +-
 fs/ecryptfs/crypto.c                               |    2 +-
 fs/ext4/extents.c                                  |    2 +-
 fs/ext4/mballoc.c                                  |    2 +-
 fs/ext4/super.c                                    |    2 +-
 fs/freevxfs/vxfs_super.c                           |    2 +-
 fs/ncpfs/inode.c                                   |    4 +-
 fs/ocfs2/dlm/dlmdebug.c                            |    6 +-
 fs/ocfs2/dlmfs/dlmfs.c                             |    3 +-
 fs/ocfs2/dlmglue.c                                 |    4 +-
 fs/ocfs2/super.c                                   |    2 +-
 fs/reiserfs/inode.c                                |    2 +-
 include/linux/fscache.h                            |    3 +-
 include/linux/ide.h                                |    2 +-
 include/linux/if_link.h                            |    2 +-
 include/linux/jffs2.h                              |    2 +-
 include/linux/kernel.h                             |    6 --
 include/linux/lru_cache.h                          |    2 +-
 include/linux/netdevice.h                          |    2 +-
 include/linux/reiserfs_fs.h                        |    2 +-
 include/linux/types.h                              |    5 +-
 kernel/cpuset.c                                    |    2 +-
 kernel/debug/debug_core.c                          |    2 +-
 kernel/debug/gdbstub.c                             |    2 +-
 kernel/power/hibernate.c                           |    2 +-
 kernel/power/snapshot.c                            |    2 +-
 kernel/power/swap.c                                |    2 +-
 kernel/time/tick-broadcast.c                       |    2 +-
 lib/Kconfig.debug                                  |    2 +-
 lib/devres.c                                       |    2 +-
 lib/random32.c                                     |    2 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |    2 +-
 net/netfilter/ipvs/ip_vs_lblc.c                    |    2 +-
 net/netfilter/ipvs/ip_vs_lblcr.c                   |    2 +-
 net/sctp/associola.c                               |    2 +-
 net/sctp/protocol.c                                |    2 +-
 security/smack/smack_lsm.c                         |    2 +-
 sound/drivers/Kconfig                              |    2 +-
 sound/pci/trident/trident_main.c                   |    2 +-
 sound/soc/fsl/mpc8610_hpcd.c                       |    2 +-
 sound/soc/imx/imx-ssi.c                            |    2 +-
 sound/soc/soc-core.c                               |    2 +-
 sound/usb/pcm.c                                    |    2 +-
 310 files changed, 461 insertions(+), 574 deletions(-)
