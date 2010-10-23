Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab0JWVjO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 17:39:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:56516 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab0JWVjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 17:39:09 -0400
Date: Sat, 23 Oct 2010 23:39:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial
Message-ID: <alpine.LNX.2.00.1010232317360.6879@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from 'for-next' branch at

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-next

to receive patches queued in trivial tree. Mostly spelling fixes, removals 
of unnecessary casts and update of broken URLs all over the tree.

Anton Blanchard (1):
      Fix spelling mistake in jhash

H Hartley Sweeten (2):
      arm: scoop.c: remove C99 comments
      arm: uengine.c: remove C99 comments

Jiri Kosina (4):
      paravirt: noreplace-paravirt is implemented for x86 and ia-64
      Revert "drivers/usb: Remove unnecessary return's from void functions" partially
      Revert "Fix typo: configuation => configuration" partially
      Revert "drivers/usb: Remove unnecessary return's from void functions" for musb gadget

Joe Perches (9):
      drivers/usb: Remove unnecessary return's from void functions
      fs/seq_file.c: Remove unnecessary casts of private_data
      fs/ecryptfs: Remove unnecessary casts of private_data
      kernel/pm_qos_params.c: Remove unnecessary casts of private_data
      drivers/gpu/drm: Remove unnecessary casts of private_data
      drivers/infiniband: Remove unnecessary casts of private_data
      net/sunrpc/rpc_pipe.c: Remove unnecessary casts of private_data
      drivers/s390: Remove unnecessary casts of private_data
      drivers/scsi: Remove unnecessary casts of private_data

Justin P. Mattock (5):
      vesafb: fix comment a typo
      include/video/vga.h: update web address.
      MAINTAINERS: update broken web address
      Update broken web addresses in the kernel.
      Update broken web addresses in arch directory.

Namhyung Kim (3):
      fix a typo on comments in mm/percpu.c
      ext2: fix a typo on comment in ext2/inode.c
      ida: document IDA_BITMAP_LONGS calculation

Naohiro Aota (2):
      idr: fix kernel-doc warnings.
      idr: describe how nextidp works in idr_get_next().

Niels de Vos (1):
      parport_pc: show the detection of a 2 serial port ITE8874 chip

Nikanth Karthikesan (3):
      Fix typo s/contenious/continuous in comment
      Doc: Fix typo s/packages/packaged
      Fix various typos of valid in comments

Paul Bolle (1):
      fix printk typo 'faild'

Stefan Weil (2):
      Fix spelling fuction -> function in comments
      Doc: Fix spelling

Stephan Sperber (1):
      Kconfig: delete duplicate word

Tao Ma (1):
      Use kzalloc in idedisk_prep_fn.

Thomas Weber (4):
      Fix typo in Kconfig help text
      Fix typo interrest[ing|ed] => interest[ing|ed]
      Fix typo: configuation => configuration
      Fix typo configue => configure in comments

 Documentation/arm/SA1100/FreeBird               |    4 ++--
 Documentation/kernel-parameters.txt             |    2 +-
 Documentation/vm/numa_memory_policy.txt         |    2 +-
 MAINTAINERS                                     |    2 +-
 arch/arm/Kconfig                                |    2 +-
 arch/arm/common/icst.c                          |    2 +-
 arch/arm/common/scoop.c                         |   12 ++++++------
 arch/arm/common/uengine.c                       |   18 +++++++++---------
 arch/arm/include/asm/hardware/icst.h            |    2 +-
 arch/arm/mach-at91/Kconfig                      |    6 +++---
 arch/arm/mach-omap1/Kconfig                     |    2 +-
 arch/arm/mach-omap2/hsmmc.h                     |    2 +-
 arch/arm/mach-s3c2440/mach-at2440evb.c          |    2 +-
 arch/arm/mach-sa1100/Kconfig                    |    6 +++---
 arch/arm/mach-sa1100/cpu-sa1100.c               |    2 +-
 arch/arm/nwfpe/milieu.h                         |    4 ++--
 arch/arm/nwfpe/softfloat-macros                 |    4 ++--
 arch/arm/nwfpe/softfloat-specialize             |    4 ++--
 arch/arm/nwfpe/softfloat.c                      |    4 ++--
 arch/arm/nwfpe/softfloat.h                      |    4 ++--
 arch/arm/plat-samsung/include/plat/adc.h        |    2 +-
 arch/avr32/Kconfig                              |    2 +-
 arch/blackfin/mach-bf527/boards/ezkit.c         |    2 +-
 arch/blackfin/mach-bf537/boards/stamp.c         |    2 +-
 arch/h8300/Kconfig.cpu                          |    8 ++++----
 arch/h8300/README                               |    1 +
 arch/m32r/Kconfig                               |    2 +-
 arch/m68k/mac/macboing.c                        |    3 ++-
 arch/m68k/q40/README                            |    2 +-
 arch/mips/Kconfig                               |   12 ++++++++----
 arch/mips/math-emu/cp1emu.c                     |    1 -
 arch/mips/math-emu/dp_add.c                     |    1 -
 arch/mips/math-emu/dp_cmp.c                     |    1 -
 arch/mips/math-emu/dp_div.c                     |    1 -
 arch/mips/math-emu/dp_fint.c                    |    1 -
 arch/mips/math-emu/dp_flong.c                   |    1 -
 arch/mips/math-emu/dp_frexp.c                   |    1 -
 arch/mips/math-emu/dp_fsp.c                     |    1 -
 arch/mips/math-emu/dp_logb.c                    |    1 -
 arch/mips/math-emu/dp_modf.c                    |    1 -
 arch/mips/math-emu/dp_mul.c                     |    1 -
 arch/mips/math-emu/dp_scalb.c                   |    1 -
 arch/mips/math-emu/dp_simple.c                  |    1 -
 arch/mips/math-emu/dp_sqrt.c                    |    1 -
 arch/mips/math-emu/dp_sub.c                     |    1 -
 arch/mips/math-emu/dp_tint.c                    |    1 -
 arch/mips/math-emu/dp_tlong.c                   |    1 -
 arch/mips/math-emu/ieee754.c                    |    1 -
 arch/mips/math-emu/ieee754.h                    |    1 -
 arch/mips/math-emu/ieee754d.c                   |    1 -
 arch/mips/math-emu/ieee754dp.c                  |    1 -
 arch/mips/math-emu/ieee754dp.h                  |    1 -
 arch/mips/math-emu/ieee754int.h                 |    1 -
 arch/mips/math-emu/ieee754m.c                   |    1 -
 arch/mips/math-emu/ieee754sp.c                  |    1 -
 arch/mips/math-emu/ieee754sp.h                  |    1 -
 arch/mips/math-emu/ieee754xcpt.c                |    1 -
 arch/mips/math-emu/sp_add.c                     |    1 -
 arch/mips/math-emu/sp_cmp.c                     |    1 -
 arch/mips/math-emu/sp_div.c                     |    1 -
 arch/mips/math-emu/sp_fdp.c                     |    1 -
 arch/mips/math-emu/sp_fint.c                    |    1 -
 arch/mips/math-emu/sp_flong.c                   |    1 -
 arch/mips/math-emu/sp_frexp.c                   |    1 -
 arch/mips/math-emu/sp_logb.c                    |    1 -
 arch/mips/math-emu/sp_modf.c                    |    1 -
 arch/mips/math-emu/sp_mul.c                     |    1 -
 arch/mips/math-emu/sp_scalb.c                   |    1 -
 arch/mips/math-emu/sp_simple.c                  |    1 -
 arch/mips/math-emu/sp_sqrt.c                    |    1 -
 arch/mips/math-emu/sp_sub.c                     |    1 -
 arch/mips/math-emu/sp_tint.c                    |    1 -
 arch/mips/math-emu/sp_tlong.c                   |    1 -
 arch/mips/pci/fixup-fuloong2e.c                 |    2 +-
 arch/mips/sibyte/common/sb_tbprof.c             |    2 +-
 arch/powerpc/include/asm/hydra.h                |    2 +-
 arch/x86/kernel/apm_32.c                        |    4 ++--
 arch/x86/kernel/microcode_core.c                |    2 +-
 arch/x86/kernel/microcode_intel.c               |    2 +-
 arch/xtensa/include/asm/uaccess.h               |    2 +-
 block/blk-core.c                                |    2 +-
 drivers/ata/pata_bf54x.c                        |    2 +-
 drivers/ata/pata_it821x.c                       |    4 ++--
 drivers/atm/Kconfig                             |    2 +-
 drivers/base/core.c                             |    2 +-
 drivers/char/agp/Kconfig                        |    2 +-
 drivers/char/agp/i460-agp.c                     |    2 +-
 drivers/char/apm-emulation.c                    |    4 ++--
 drivers/char/ipmi/ipmi_bt_sm.c                  |    2 +-
 drivers/char/ipmi/ipmi_si_intf.c                |    3 +--
 drivers/char/n_r3964.c                          |    1 -
 drivers/char/pcmcia/Kconfig                     |    4 ++--
 drivers/char/pcmcia/cm4000_cs.c                 |    2 +-
 drivers/char/stallion.c                         |    4 ++--
 drivers/char/tpm/Kconfig                        |    2 +-
 drivers/char/tpm/tpm_infineon.c                 |    2 +-
 drivers/edac/edac_device_sysfs.c                |    2 +-
 drivers/edac/i82443bxgx_edac.c                  |    2 +-
 drivers/firmware/Kconfig                        |    3 ++-
 drivers/firmware/edd.c                          |    2 +-
 drivers/firmware/pcdp.h                         |    4 ++--
 drivers/gpu/drm/drm_modes.c                     |    2 +-
 drivers/gpu/drm/radeon/radeon_cs.c              |    2 +-
 drivers/gpu/drm/radeon/radeon_ttm.c             |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c            |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c        |    2 +-
 drivers/hwmon/adm1025.c                         |    2 +-
 drivers/hwmon/adm1026.c                         |    2 +-
 drivers/hwmon/f75375s.c                         |    4 ++--
 drivers/hwmon/g760a.c                           |    2 +-
 drivers/hwmon/hwmon-vid.c                       |    2 +-
 drivers/ide/hpt366.c                            |    2 +-
 drivers/ide/ht6560b.c                           |    1 -
 drivers/ide/ide-disk.c                          |    3 +--
 drivers/infiniband/Kconfig                      |    4 ++--
 drivers/infiniband/hw/cxgb3/Kconfig             |    2 +-
 drivers/infiniband/hw/cxgb4/Kconfig             |    2 +-
 drivers/infiniband/hw/qib/qib_file_ops.c        |    4 ++--
 drivers/infiniband/ulp/iser/Kconfig             |    2 +-
 drivers/input/joystick/gamecon.c                |    3 +--
 drivers/input/misc/cm109.c                      |    2 +-
 drivers/input/mouse/Kconfig                     |    1 +
 drivers/input/mouse/touchkit_ps2.c              |    4 ++--
 drivers/input/touchscreen/mk712.c               |    2 +-
 drivers/isdn/i4l/isdn_audio.c                   |    2 +-
 drivers/macintosh/therm_adt746x.c               |    6 +++---
 drivers/media/IR/keymaps/rc-manli.c             |    1 -
 drivers/media/dvb/ttpci/av7110.c                |    9 ++-------
 drivers/media/dvb/ttpci/av7110_av.c             |    2 +-
 drivers/media/dvb/ttpci/av7110_ca.c             |    2 +-
 drivers/media/dvb/ttpci/av7110_hw.c             |    2 +-
 drivers/media/dvb/ttpci/av7110_v4l.c            |    2 +-
 drivers/media/dvb/ttpci/budget-av.c             |    2 +-
 drivers/media/dvb/ttpci/budget-ci.c             |    2 +-
 drivers/media/dvb/ttpci/budget-core.c           |    2 +-
 drivers/media/dvb/ttpci/budget-patch.c          |    2 +-
 drivers/media/dvb/ttpci/budget.c                |    2 +-
 drivers/media/radio/radio-maxiradio.c           |    2 +-
 drivers/media/radio/radio-typhoon.c             |    3 ---
 drivers/media/video/Kconfig                     |    2 +-
 drivers/media/video/cafe_ccic.c                 |    2 +-
 drivers/media/video/cx18/cx18-cards.c           |    2 +-
 drivers/media/video/cx23885/cx23885-417.c       |    2 +-
 drivers/media/video/cx88/cx88-blackbird.c       |    2 +-
 drivers/media/video/ivtv/ivtv-cards.c           |    2 +-
 drivers/media/video/mxb.c                       |    2 +-
 drivers/media/video/sn9c102/sn9c102_pas202bcb.c |    1 -
 drivers/media/video/zoran/videocodec.h          |    2 +-
 drivers/media/video/zoran/zoran_driver.c        |    2 +-
 drivers/misc/Kconfig                            |    6 +++---
 drivers/mtd/chips/cfi_cmdset_0002.c             |    4 ++--
 drivers/mtd/devices/lart.c                      |    2 +-
 drivers/mtd/ftl.c                               |    2 +-
 drivers/mtd/maps/Kconfig                        |    4 ++--
 drivers/mtd/nand/cafe_nand.c                    |    2 +-
 drivers/net/Kconfig                             |   21 ++++++++++-----------
 drivers/net/appletalk/Kconfig                   |    2 +-
 drivers/net/atp.c                               |    2 +-
 drivers/net/depca.c                             |    2 +-
 drivers/net/epic100.c                           |    4 ++--
 drivers/net/hamradio/Kconfig                    |    2 +-
 drivers/net/ibmlana.c                           |    2 +-
 drivers/net/igb/igb_main.c                      |    2 +-
 drivers/net/irda/ali-ircc.c                     |    2 +-
 drivers/net/irda/donauboe.h                     |    2 +-
 drivers/net/pci-skeleton.c                      |    2 +-
 drivers/net/pcmcia/3c574_cs.c                   |    2 +-
 drivers/net/ps3_gelic_net.c                     |    4 ++--
 drivers/net/sb1250-mac.c                        |    6 +++---
 drivers/net/sc92031.c                           |    2 +-
 drivers/net/skfp/hwt.c                          |    2 +-
 drivers/net/skfp/skfddi.c                       |    2 +-
 drivers/net/tlan.c                              |    2 +-
 drivers/net/tokenring/tms380tr.c                |    2 +-
 drivers/net/tulip/Kconfig                       |    2 +-
 drivers/net/tulip/pnic2.c                       |    2 +-
 drivers/net/usb/plusb.c                         |    2 +-
 drivers/net/wan/Kconfig                         |    2 +-
 drivers/net/wan/hdlc.c                          |    2 +-
 drivers/net/wireless/ath/ath5k/ath5k.h          |    2 +-
 drivers/net/wireless/ath/ath5k/reg.h            |    1 -
 drivers/net/wireless/hostap/hostap_hw.c         |    2 +-
 drivers/net/wireless/p54/Kconfig                |    6 +++---
 drivers/net/wireless/prism54/islpci_hotplug.c   |    2 +-
 drivers/parisc/README.dino                      |    3 +--
 drivers/parport/parport_pc.c                    |    2 +-
 drivers/pci/quirks.c                            |    3 ++-
 drivers/pcmcia/yenta_socket.c                   |    2 +-
 drivers/pnp/pnpbios/proc.c                      |    1 -
 drivers/rtc/rtc-nuc900.c                        |    2 +-
 drivers/s390/block/dasd_3990_erp.c              |    2 +-
 drivers/s390/block/dasd_eckd.c                  |    4 ++--
 drivers/s390/char/tape_3590.c                   |    6 +++---
 drivers/s390/char/vmcp.c                        |    6 +++---
 drivers/scsi/Kconfig                            |    9 +++++----
 drivers/scsi/aacraid/linit.c                    |    2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                |    2 +-
 drivers/scsi/sg.c                               |    2 +-
 drivers/serial/8250.c                           |    2 +-
 drivers/serial/bfin_sport_uart.c                |    2 +-
 drivers/serial/bfin_sport_uart.h                |    2 +-
 drivers/serial/uartlite.c                       |    2 +-
 drivers/staging/asus_oled/README                |    2 +-
 drivers/staging/asus_oled/asus_oled.c           |    2 +-
 drivers/staging/comedi/drivers/cb_pcimdas.c     |    2 +-
 drivers/staging/comedi/drivers/daqboard2000.c   |    4 ++--
 drivers/staging/comedi/drivers/ni_labpc.c       |    2 +-
 drivers/staging/comedi/drivers/ni_mio_common.c  |    2 +-
 drivers/staging/comedi/drivers/plx9080.h        |    2 +-
 drivers/staging/comedi/drivers/rtd520.c         |    2 +-
 drivers/staging/quickstart/quickstart.c         |    3 +--
 drivers/uio/Kconfig                             |    6 +++---
 drivers/usb/gadget/at91_udc.c                   |    1 -
 drivers/usb/gadget/f_audio.c                    |    2 --
 drivers/usb/gadget/f_hid.c                      |    4 ----
 drivers/usb/gadget/fsl_udc_core.c               |    6 ------
 drivers/usb/gadget/pxa27x_udc.c                 |    2 --
 drivers/usb/gadget/rndis.c                      |    2 --
 drivers/usb/host/ehci-hcd.c                     |    1 -
 drivers/usb/host/imx21-hcd.c                    |    4 ++--
 drivers/usb/host/ohci-hcd.c                     |    1 -
 drivers/usb/host/oxu210hp-hcd.c                 |    9 ---------
 drivers/usb/host/pci-quirks.c                   |    2 --
 drivers/usb/host/u132-hcd.c                     |    8 ++------
 drivers/usb/image/microtek.c                    |    9 ---------
 drivers/usb/misc/ftdi-elan.c                    |    2 --
 drivers/usb/mon/mon_main.c                      |    2 --
 drivers/usb/serial/Kconfig                      |    4 ++--
 drivers/usb/serial/cypress_m8.c                 |    2 --
 drivers/usb/serial/ftdi_sio.c                   |    1 -
 drivers/usb/serial/ftdi_sio_ids.h               |   12 ++++++------
 drivers/usb/serial/garmin_gps.c                 |    1 -
 drivers/usb/serial/io_edgeport.c                |   11 -----------
 drivers/usb/serial/io_ti.c                      |    4 ----
 drivers/usb/serial/iuu_phoenix.c                |    1 -
 drivers/usb/serial/keyspan.c                    |    2 +-
 drivers/usb/serial/keyspan.h                    |    2 +-
 drivers/usb/serial/keyspan_pda.c                |    1 -
 drivers/usb/serial/mct_u232.h                   |    9 ++++-----
 drivers/usb/serial/mos7720.c                    |    6 ------
 drivers/usb/serial/mos7840.c                    |    7 -------
 drivers/usb/serial/omninet.c                    |    2 --
 drivers/usb/serial/sierra.c                     |    2 --
 drivers/usb/serial/spcp8x5.c                    |    1 -
 drivers/usb/serial/usb_wwan.c                   |    1 -
 drivers/usb/serial/whiteheat.c                  |    6 ------
 drivers/usb/storage/Kconfig                     |    2 +-
 drivers/video/Kconfig                           |   10 +++++-----
 drivers/video/arcfb.c                           |    1 -
 drivers/video/bf54x-lq043fb.c                   |    6 +++---
 drivers/video/bfin-t350mcqb-fb.c                |    2 +-
 drivers/video/epson1355fb.c                     |    2 +-
 drivers/video/fbcvt.c                           |    2 +-
 drivers/video/metronomefb.c                     |    2 +-
 drivers/video/vesafb.c                          |    2 +-
 firmware/keyspan_pda/keyspan_pda.S              |    2 +-
 firmware/keyspan_pda/xircom_pgs.S               |    2 +-
 fs/ecryptfs/ecryptfs_kernel.h                   |    2 +-
 fs/exofs/inode.c                                |   14 +++++++-------
 fs/exofs/ios.c                                  |   10 +++++-----
 fs/ext2/inode.c                                 |    4 ++--
 fs/hostfs/hostfs.h                              |    7 +------
 fs/jfs/jfs_logmgr.c                             |    6 ++----
 fs/jfs/jfs_mount.c                              |    4 ++--
 fs/ocfs2/cluster/tcp_internal.h                 |    2 +-
 fs/partitions/ldm.c                             |    2 +-
 fs/partitions/ldm.h                             |    2 +-
 fs/reiserfs/Kconfig                             |    6 ++++--
 fs/reiserfs/README                              |    2 +-
 fs/seq_file.c                                   |    6 +++---
 include/crypto/gf128mul.h                       |    4 ++--
 include/linux/fdreg.h                           |    2 +-
 include/linux/idr.h                             |    7 +++++--
 include/linux/if_infiniband.h                   |    2 +-
 include/linux/jhash.h                           |    2 +-
 include/linux/n_r3964.h                         |    1 -
 include/video/vga.h                             |    2 +-
 init/Kconfig                                    |    2 +-
 kernel/pm_qos_params.c                          |    2 +-
 kernel/trace/trace_kprobe.c                     |    2 +-
 lib/idr.c                                       |   13 +++++++------
 mm/percpu.c                                     |    2 +-
 mm/vmscan.c                                     |    4 ++--
 net/ax25/Kconfig                                |    8 ++++----
 net/ipv4/Kconfig                                |    4 ++--
 net/ipv4/cipso_ipv4.c                           |    2 +-
 net/ipv4/fib_trie.c                             |    2 +-
 net/ipv4/netfilter/Kconfig                      |    2 +-
 net/ipv4/tcp_illinois.c                         |    2 +-
 net/ipv4/tcp_input.c                            |    4 ++--
 net/ipv4/tcp_veno.c                             |    2 +-
 net/irda/irnet/irnet_ppp.c                      |    2 +-
 net/mac80211/mesh.h                             |    2 +-
 net/netfilter/nf_conntrack_proto_tcp.c          |    4 ++--
 net/sunrpc/rpc_pipe.c                           |    4 ++--
 net/wanrouter/wanmain.c                         |    4 ++--
 sound/oss/ac97_codec.c                          |    7 ++-----
 sound/pci/ens1370.c                             |    2 +-
 sound/pci/intel8x0.c                            |    2 +-
 sound/soc/s3c24xx/neo1973_gta02_wm8753.c        |    2 +-
 sound/soc/s3c24xx/neo1973_wm8753.c              |    2 +-
 usr/Kconfig                                     |    2 +-
 302 files changed, 359 insertions(+), 512 deletions(-)
