Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab1E2GGn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 02:06:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51900 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab1E2GGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 02:06:42 -0400
Date: Sun, 29 May 2011 03:07:03 -0300
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] Fix common misspellings
Message-ID: <20110529060702.GA7112@vigoh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the following fixes for common misspellings. This patch is shorter
than the other time, but larger than I expected, partially because there were
some new entries in the dictionary.


If this can be applied shortly after/before the rc1, I hope not to cause
troubles for others with conflicts.


Lucas De Marchi

The following changes since commit eee0f252c6537da2e883f75d22cff1427515eaf3:

  mm: fix page_lock_anon_vma leaving mutex locked (2011-05-28 16:55:32 -0700)

are available in the git repository at:
  git://git.profusion.mobi/users/lucas/linux-2.6.git for-linus

Lucas De Marchi (1):
      Fix common misspellings

 Documentation/hwmon/adm1275                        |    2 +-
 Documentation/hwmon/max16064                       |    4 +-
 Documentation/hwmon/max34440                       |    4 +-
 Documentation/hwmon/max8688                        |    4 +-
 Documentation/hwmon/sht15                          |    2 +-
 Documentation/hwmon/ucd9000                        |    6 +-
 Documentation/hwmon/ucd9200                        |   10 ++--
 Documentation/md.txt                               |    2 +-
 Documentation/video4linux/uvcvideo.txt             |    2 +-
 arch/alpha/lib/ev6-memcpy.S                        |    2 +-
 arch/arm/lib/uaccess.S                             |   50 ++++++++++----------
 arch/arm/mach-imx/cache-l2x0.c                     |    2 +-
 arch/arm/mach-pxa/include/mach/regs-u2d.h          |    6 +-
 arch/ia64/kvm/mmio.c                               |    2 +-
 arch/microblaze/lib/memmove.c                      |    2 +-
 arch/mips/pci/pci-lantiq.c                         |    2 +-
 arch/mn10300/unit-asb2305/include/unit/serial.h    |    2 +-
 arch/powerpc/include/asm/xics.h                    |    2 +-
 arch/powerpc/kernel/perf_event.c                   |    2 +-
 arch/s390/include/asm/pgtable.h                    |    2 +-
 arch/sparc/include/asm/hypervisor.h                |    2 +-
 arch/sparc/include/asm/pcr.h                       |    4 +-
 arch/sparc/kernel/irq_32.c                         |    2 +-
 arch/x86/kernel/cpu/mtrr/main.c                    |    2 +-
 arch/x86/xen/pci-swiotlb-xen.c                     |    2 +-
 drivers/block/drbd/drbd_int.h                      |    2 +-
 drivers/crypto/caam/desc.h                         |    2 +-
 drivers/gpio/pca953x.c                             |    2 +-
 drivers/gpu/drm/radeon/radeon_fence.c              |    2 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c        |    2 +-
 drivers/hwmon/pmbus_core.c                         |    2 +-
 drivers/input/keyboard/Kconfig                     |    2 +-
 drivers/isdn/hardware/mISDN/w6692.c                |    2 +-
 drivers/isdn/hisax/amd7930_fn.c                    |    2 +-
 drivers/isdn/hisax/avm_pci.c                       |    2 +-
 drivers/isdn/hisax/elsa_ser.c                      |    2 +-
 drivers/isdn/hisax/hisax_fcpcipnp.c                |    4 +-
 drivers/media/common/tuners/xc5000.c               |    2 +-
 drivers/media/rc/redrat3.c                         |    2 +-
 drivers/media/video/Kconfig                        |    2 +-
 drivers/mfd/ab8500-gpadc.c                         |    2 +-
 drivers/misc/carma/carma-fpga-program.c            |    2 +-
 drivers/misc/pti.c                                 |    6 +-
 drivers/mmc/host/vub300.c                          |    6 +-
 drivers/net/bnx2x/bnx2x_cmn.c                      |    2 +-
 drivers/net/ixgbe/ixgbe_main.c                     |    4 +-
 drivers/net/mlx4/en_ethtool.c                      |    2 +-
 drivers/net/ppp_async.c                            |    2 +-
 drivers/net/usb/lg-vl600.c                         |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-testmode.h        |    2 +-
 drivers/net/wireless/mwifiex/cfg80211.c            |    2 +-
 drivers/net/wireless/mwl8k.c                       |    2 +-
 drivers/net/wireless/rt2x00/rt2x00config.c         |    2 +-
 drivers/net/wireless/rtlwifi/core.c                |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c       |    2 +-
 drivers/scsi/fcoe/fcoe_ctlr.c                      |    2 +-
 drivers/scsi/lpfc/lpfc_bsg.c                       |    4 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c                |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c               |    6 +-
 drivers/spi/au1550_spi.c                           |    2 +-
 drivers/spi/spi_bfin_sport.c                       |    2 +-
 drivers/staging/bcm/PHSModule.c                    |   10 ++--
 drivers/staging/brcm80211/brcmsmac/aiutils.h       |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Tor.c        |    8 ++--
 drivers/staging/comedi/drivers/s626.c              |    4 +-
 drivers/staging/comedi/drivers/usbdux.c            |    8 ++--
 drivers/staging/comedi/drivers/usbduxfast.c        |    4 +-
 drivers/staging/generic_serial/rio/rioctrl.c       |    2 +-
 drivers/staging/hv/blkvsc_drv.c                    |    2 +-
 drivers/staging/hv/vmbus_drv.c                     |    2 +-
 drivers/staging/iio/Documentation/device.txt       |    2 +-
 drivers/staging/iio/accel/lis3l02dq_ring.c         |    2 +-
 drivers/staging/iio/gyro/adxrs450.h                |    2 +-
 drivers/staging/iio/iio.h                          |    4 +-
 drivers/staging/intel_sst/intelmid_msic_control.c  |    2 +-
 drivers/staging/mei/interface.c                    |    2 +-
 drivers/staging/mei/interrupt.c                    |    2 +-
 drivers/staging/mei/mei.txt                        |    2 +-
 drivers/staging/msm/mdp_ppp.c                      |    4 +-
 drivers/staging/tidspbridge/core/ue_deh.c          |    2 +-
 drivers/staging/usbip/stub_rx.c                    |    2 +-
 .../staging/usbip/userspace/libsrc/vhci_driver.c   |    2 +-
 drivers/staging/usbip/userspace/src/usbip.c        |    2 +-
 drivers/staging/usbip/userspace/src/usbipd.c       |    2 +-
 drivers/staging/vt6655/rxtx.c                      |    2 +-
 drivers/staging/vt6656/rxtx.c                      |    2 +-
 drivers/staging/wlan-ng/p80211req.c                |    2 +-
 drivers/tty/n_tracesink.c                          |    2 +-
 drivers/usb/gadget/fsl_udc_core.c                  |    4 +-
 drivers/usb/gadget/langwell_udc.c                  |    2 +-
 drivers/usb/gadget/mv_udc_core.c                   |    2 +-
 drivers/usb/gadget/s3c-hsudc.c                     |    4 +-
 drivers/usb/host/isp1760-hcd.c                     |    4 +-
 drivers/usb/otg/fsl_otg.c                          |    2 +-
 drivers/usb/otg/fsl_otg.h                          |    2 +-
 drivers/video/aty/radeon_base.c                    |    2 +-
 drivers/video/s3c-fb.c                             |    2 +-
 drivers/w1/masters/ds1wm.c                         |    2 +-
 drivers/xen/grant-table.c                          |    2 +-
 fs/btrfs/delayed-inode.c                           |    2 +-
 fs/btrfs/inode.c                                   |    2 +-
 fs/btrfs/ioctl.h                                   |    4 +-
 fs/ext4/extents.c                                  |    2 +-
 fs/ext4/inode.c                                    |    2 +-
 fs/ubifs/replay.c                                  |    2 +-
 include/linux/alarmtimer.h                         |    2 +-
 include/linux/mfd/db8500-prcmu.h                   |   32 ++++++------
 include/linux/mm.h                                 |    2 +-
 include/linux/mmc/card.h                           |    2 +-
 include/linux/nl80211.h                            |    4 +-
 include/linux/ptp_clock.h                          |    2 +-
 include/linux/ptp_clock_kernel.h                   |    6 +-
 include/net/cfg80211.h                             |    2 +-
 kernel/signal.c                                    |    2 +-
 kernel/trace/ftrace.c                              |    2 +-
 lib/xz/xz_dec_bcj.c                                |    2 +-
 net/atm/lec.h                                      |    4 +-
 net/caif/caif_socket.c                             |    2 +-
 net/caif/cfcnfg.c                                  |    2 +-
 sound/pci/au88x0/au88x0_core.c                     |    2 +-
 sound/pci/rme9652/hdspm.c                          |    2 +-
 sound/soc/codecs/wm8915.c                          |    8 ++--
 sound/soc/codecs/wm8974.c                          |    8 ++--
 sound/soc/codecs/wm8978.c                          |    6 +-
 sound/soc/codecs/wm8985.c                          |    6 +-
 sound/soc/codecs/wm8994.h                          |   12 ++--
 130 files changed, 228 insertions(+), 228 deletions(-)
