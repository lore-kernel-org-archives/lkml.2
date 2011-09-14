Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051Ab1INTxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 15:53:18 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35333 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932918Ab1INTxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 15:53:16 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Fix various typos in the kernel.
Date: Wed, 14 Sep 2011 12:52:45 -0700
Message-Id: <1316029968-11277-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The patch's below fix various typos that I have found in the kernel. 
Note: I am not sure if trivial will receive this or any other list for that matter due to 
kernel.org being down.


---
 arch/arm/mach-omap2/smartreflex.c                  |    2 +-
 arch/arm/plat-omap/include/plat/serial.h           |    4 ++--
 arch/powerpc/include/asm/io.h                      |    2 +-
 arch/powerpc/include/asm/keylargo.h                |    2 +-
 arch/powerpc/mm/numa.c                             |    2 +-
 arch/powerpc/platforms/embedded6xx/storcenter.c    |    2 +-
 arch/sparc/kernel/smp_64.c                         |    4 ++--
 drivers/acpi/acpica/hwxface.c                      |    2 +-
 drivers/base/regmap/regmap.c                       |    2 +-
 drivers/block/xen-blkback/xenbus.c                 |    2 +-
 drivers/char/ipmi/ipmi_bt_sm.c                     |    2 +-
 drivers/edac/ppc4xx_edac.c                         |    2 +-
 drivers/media/video/zoran/zoran_driver.c           |    2 +-
 drivers/message/fusion/lsi/mpi_ioc.h               |    2 +-
 drivers/net/arm/ks8695net.c                        |    2 +-
 drivers/net/atlx/atl1.c                            |    2 +-
 drivers/net/cs89x0.c                               |    2 +-
 drivers/net/irda/nsc-ircc.c                        |    2 +-
 drivers/net/irda/via-ircc.c                        |    4 ++--
 drivers/net/irda/w83977af_ir.c                     |    2 +-
 drivers/net/qlge/qlge_main.c                       |    2 +-
 drivers/net/sky2.c                                 |    2 +-
 drivers/net/tile/tilepro.c                         |    2 +-
 drivers/net/wimax/i2400m/i2400m.h                  |    2 +-
 drivers/net/wireless/rtlwifi/pci.c                 |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c        |    4 ++--
 drivers/parport/parport_mfc3.c                     |    2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm.c               |    2 +-
 drivers/scsi/ips.c                                 |    2 +-
 drivers/scsi/qla4xxx/ql4_fw.h                      |    2 +-
 drivers/scsi/vmw_pvscsi.c                          |    2 +-
 drivers/staging/brcm80211/brcmfmac/sdio_host.h     |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |    2 +-
 drivers/staging/cxt1e1/libsbew.h                   |    2 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |    4 ++--
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |    2 +-
 drivers/staging/iio/industrialio-trigger.c         |    2 +-
 drivers/staging/sep/sep_driver.c                   |    2 +-
 drivers/staging/tidspbridge/Kconfig                |    2 +-
 drivers/staging/tidspbridge/rmgr/dbdcd.c           |    2 +-
 drivers/tty/serial/mrst_max3110.c                  |    2 +-
 drivers/usb/gadget/langwell_udc.c                  |    2 +-
 drivers/usb/host/hwa-hc.c                          |    2 +-
 drivers/usb/host/imx21-hcd.c                       |    2 +-
 drivers/usb/musb/musb_gadget.c                     |    2 +-
 drivers/usb/otg/fsl_otg.c                          |    2 +-
 drivers/uwb/i1480/dfu/usb.c                        |    2 +-
 fs/btrfs/inode.c                                   |    2 +-
 fs/ext3/inode.c                                    |    2 +-
 fs/ext4/inode.c                                    |    2 +-
 fs/nfsd/nfs4state.c                                |    2 +-
 fs/ocfs2/file.c                                    |    2 +-
 fs/xfs/xfs_file.c                                  |    6 +++---
 fs/xfs/xfs_log_cil.c                               |    2 +-
 include/drm/drmP.h                                 |    2 +-
 include/linux/wanrouter.h                          |    2 +-
 include/net/mac80211.h                             |    2 +-
 net/ipv4/ip_fragment.c                             |    2 +-
 net/mac80211/work.c                                |    2 +-
 net/sctp/endpointola.c                             |    2 +-
 tools/power/cpupower/debug/i386/intel_gsic.c       |    2 +-
 61 files changed, 68 insertions(+), 68 deletions(-)

